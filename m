From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-kvm-fix-memory-corruption-in-kvm-with-thp-enabled.patch removed from -mm tree
Date: Fri, 06 May 2016 14:17:30 -0700
Message-ID: <572d09ea.dEwwU0s4sp0/tfIi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54417 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514AbcEFVRb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 May 2016 17:17:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, amit.shah@redhat.com, dgilbert@redhat.com, kirill@shutemov.name, liang.z.li@intel.com, pbonzini@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: kvm: fix memory corruption in KVM with THP enabled
has been removed from the -mm tree.  Its filename was
     mm-thp-kvm-fix-memory-corruption-in-kvm-with-thp-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: thp: kvm: fix memory corruption in KVM with THP enabled

After the THP refcounting change, obtaining a compound pages from
get_user_pages() no longer allows us to assume the entire compound page is
immediately mappable from a secondary MMU.

A secondary MMU doesn't want to call get_user_pages() more than once for
each compound page, in order to know if it can map the whole compound
page.  So a secondary MMU needs to know from a single get_user_pages()
invocation when it can map immediately the entire compound page to avoid a
flood of unnecessary secondary MMU faults and spurious
atomic_inc()/atomic_dec() (pages don't have to be pinned by MMU notifier
users).

Ideally instead of the page->_mapcount < 1 check, get_user_pages() should
return the granularity of the "page" mapping in the "mm" passed to
get_user_pages().  However it's non trivial change to pass the "pmd"
status belonging to the "mm" walked by get_user_pages up the stack (up to
the caller of get_user_pages).  So the fix just checks if there is not a
single pte mapping on the page returned by get_user_pages, and in turn if
the caller can assume that the whole compound page is mapped in the
current "mm" (in a pmd_trans_huge()).  In such case the entire compound
page is safe to map into the secondary MMU without additional
get_user_pages() calls on the surrounding tail/head pages.  In addition of
being faster, not having to run other get_user_pages() calls also reduces
the memory footprint of the secondary MMU fault in case the pmd split
happened as result of memory pressure.

Without this fix after a MADV_DONTNEED (like invoked by QEMU during
postcopy live migration or balloning) or after generic swapping (with a
failure in split_huge_page() that would only result in pmd splitting and
not a physical page split), KVM would map the whole compound page into the
shadow pagetables, despite regular faults or userfaults (like UFFDIO_COPY)
may map regular pages into the primary MMU as result of the pte faults,
leading to the guest mode and userland mode going out of sync and not
working on the same memory at all times.

Any other secondary MMU notifier manager (KVM is just one of the many MMU
notifier users) will need the same information if it doesn't want to run a
flood of get_user_pages_fast and it can support multiple granularity in
the secondary MMU mappings, so I think it is justified to be exposed not
just to KVM.

The other option would be to move transparent_hugepage_adjust to
mm/huge_memory.c but that currently has all kind of KVM data structures in
it, so it's definitely not a cut-and-paste work, so I couldn't do a fix as
cleaner as this one for 4.6.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: "Li, Liang Z" <liang.z.li@intel.com>
Cc: Amit Shah <amit.shah@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kvm/mmu.c         |    2 +-
 arch/x86/kvm/mmu.c         |    4 ++--
 include/linux/page-flags.h |   22 ++++++++++++++++++++++
 3 files changed, 25 insertions(+), 3 deletions(-)

diff -puN arch/arm/kvm/mmu.c~mm-thp-kvm-fix-memory-corruption-in-kvm-with-thp-enabled arch/arm/kvm/mmu.c
--- a/arch/arm/kvm/mmu.c~mm-thp-kvm-fix-memory-corruption-in-kvm-with-thp-enabled
+++ a/arch/arm/kvm/mmu.c
@@ -1004,7 +1004,7 @@ static bool transparent_hugepage_adjust(
 	kvm_pfn_t pfn = *pfnp;
 	gfn_t gfn = *ipap >> PAGE_SHIFT;
 
-	if (PageTransCompound(pfn_to_page(pfn))) {
+	if (PageTransCompoundMap(pfn_to_page(pfn))) {
 		unsigned long mask;
 		/*
 		 * The address we faulted on is backed by a transparent huge
diff -puN arch/x86/kvm/mmu.c~mm-thp-kvm-fix-memory-corruption-in-kvm-with-thp-enabled arch/x86/kvm/mmu.c
--- a/arch/x86/kvm/mmu.c~mm-thp-kvm-fix-memory-corruption-in-kvm-with-thp-enabled
+++ a/arch/x86/kvm/mmu.c
@@ -2823,7 +2823,7 @@ static void transparent_hugepage_adjust(
 	 */
 	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
 	    level == PT_PAGE_TABLE_LEVEL &&
-	    PageTransCompound(pfn_to_page(pfn)) &&
+	    PageTransCompoundMap(pfn_to_page(pfn)) &&
 	    !mmu_gfn_lpage_is_disallowed(vcpu, gfn, PT_DIRECTORY_LEVEL)) {
 		unsigned long mask;
 		/*
@@ -4785,7 +4785,7 @@ restart:
 		 */
 		if (sp->role.direct &&
 			!kvm_is_reserved_pfn(pfn) &&
-			PageTransCompound(pfn_to_page(pfn))) {
+			PageTransCompoundMap(pfn_to_page(pfn))) {
 			drop_spte(kvm, sptep);
 			need_tlb_flush = 1;
 			goto restart;
diff -puN include/linux/page-flags.h~mm-thp-kvm-fix-memory-corruption-in-kvm-with-thp-enabled include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-thp-kvm-fix-memory-corruption-in-kvm-with-thp-enabled
+++ a/include/linux/page-flags.h
@@ -517,6 +517,27 @@ static inline int PageTransCompound(stru
 }
 
 /*
+ * PageTransCompoundMap is the same as PageTransCompound, but it also
+ * guarantees the primary MMU has the entire compound page mapped
+ * through pmd_trans_huge, which in turn guarantees the secondary MMUs
+ * can also map the entire compound page. This allows the secondary
+ * MMUs to call get_user_pages() only once for each compound page and
+ * to immediately map the entire compound page with a single secondary
+ * MMU fault. If there will be a pmd split later, the secondary MMUs
+ * will get an update through the MMU notifier invalidation through
+ * split_huge_pmd().
+ *
+ * Unlike PageTransCompound, this is safe to be called only while
+ * split_huge_pmd() cannot run from under us, like if protected by the
+ * MMU notifier, otherwise it may result in page->_mapcount < 0 false
+ * positives.
+ */
+static inline int PageTransCompoundMap(struct page *page)
+{
+	return PageTransCompound(page) && atomic_read(&page->_mapcount) < 0;
+}
+
+/*
  * PageTransTail returns true for both transparent huge pages
  * and hugetlbfs pages, so it should only be called when it's known
  * that hugetlbfs pages aren't involved.
@@ -559,6 +580,7 @@ static inline int TestClearPageDoubleMap
 #else
 TESTPAGEFLAG_FALSE(TransHuge)
 TESTPAGEFLAG_FALSE(TransCompound)
+TESTPAGEFLAG_FALSE(TransCompoundMap)
 TESTPAGEFLAG_FALSE(TransTail)
 TESTPAGEFLAG_FALSE(DoubleMap)
 	TESTSETFLAG_FALSE(DoubleMap)
_

Patches currently in -mm which might be from aarcange@redhat.com are



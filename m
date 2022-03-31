Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81920C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 04:34:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiCaEgR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 00:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiCaEfN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 00:35:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6BA5A584
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 21:33:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B2F061481
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 04:33:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3A0C340ED;
        Thu, 31 Mar 2022 04:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648701205;
        bh=cC8Qi5MXJ6V81qogR9ywjkZTyirSBrkN1W87p0t8yz0=;
        h=Date:To:From:Subject:From;
        b=YckOu2oWhLYMsTGUX54tUZ7ZMKaQumTIvfLCDtjcd8739Rm+KjhvTFiUEH+SWDamD
         fHmX1W0LAYq/75WE6UrTohyDQIn1GOfTwJzOQP46EsA2FDS5FqH7Tup0+KotFKw9iG
         GOvgKNKejcgi388cKeYWijETESgFsju6VJDNdyP0=
Date:   Wed, 30 Mar 2022 21:33:24 -0700
To:     mm-commits@vger.kernel.org, zhangliang5@huawei.com,
        willy@infradead.org, will@kernel.org, vbabka@suse.cz,
        tglx@linutronix.de, shakeelb@google.com, rppt@linux.ibm.com,
        riel@surriel.com, peterx@redhat.com, pedrodemargomes@gmail.com,
        paulus@samba.org, oleg@redhat.com, oded.gabbay@gmail.com,
        namit@vmware.com, mpe@ellerman.id.au, mingo@redhat.com,
        mike.kravetz@oracle.com, mhocko@kernel.org,
        kirill.shutemov@linux.intel.com, jhubbard@nvidia.com,
        jgg@nvidia.com, jannh@google.com, jack@suse.cz, hughd@google.com,
        hch@lst.de, hca@linux.ibm.com, guro@fb.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, ddutile@redhat.com,
        dave.hansen@linux.intel.com, catalin.marinas@arm.com, bp@alien8.de,
        benh@kernel.crashing.org, agordeev@linux.ibm.com,
        aarcange@redhat.com, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-remember-pg_anon_exclusive-via-a-swp-pte-bit.patch added to -mm tree
Message-Id: <20220331043324.DD3A0C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: remember PG_anon_exclusive via a swp pte bit
has been added to the -mm tree.  Its filename is
     mm-swap-remember-pg_anon_exclusive-via-a-swp-pte-bit.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-swap-remember-pg_anon_exclusive-via-a-swp-pte-bit.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-remember-pg_anon_exclusive-via-a-swp-pte-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/swap: remember PG_anon_exclusive via a swp pte bit

Patch series "mm: COW fixes part 3: reliable GUP R/W FOLL_GET of anonymous pages", v2.

This series fixes memory corruptions when a GUP R/W reference (FOLL_WRITE
| FOLL_GET) was taken on an anonymous page and COW logic fails to detect
exclusivity of the page to then replacing the anonymous page by a copy in
the page table: The GUP reference lost synchronicity with the pages mapped
into the page tables.  This series focuses on x86, arm64, s390x and
ppc64/book3s -- other architectures are fairly easy to support by
implementing __HAVE_ARCH_PTE_SWP_EXCLUSIVE.

This primarily fixes the O_DIRECT memory corruptions that can happen on
concurrent swapout, whereby we lose DMA reads to a page (modifying the
user page by writing to it).

O_DIRECT currently uses FOLL_GET for short-term (!FOLL_LONGTERM) DMA
from/to a user page.  In the long run, we want to convert it to properly
use FOLL_PIN, and John is working on it, but that might take a while and
might not be easy to backport.  In the meantime, let's restore what used
to work before we started modifying our COW logic: make R/W FOLL_GET
references reliable as long as there is no fork() after GUP involved.

This is just the natural follow-up of part 2, that will also further
reduce "wrong COW" on the swapin path, for example, when we cannot remove
a page from the swapcache due to concurrent writeback, or if we have two
threads faulting on the same swapped-out page.  Fixing O_DIRECT is just a
nice side-product

This issue, including other related COW issues, has been summarized in [3]
under 2):
"
  2. Intra Process Memory Corruptions due to Wrong COW (FOLL_GET)

  It was discovered that we can create a memory corruption by reading a
  file via O_DIRECT to a part (e.g., first 512 bytes) of a page,
  concurrently writing to an unrelated part (e.g., last byte) of the same
  page, and concurrently write-protecting the page via clear_refs
  SOFTDIRTY tracking [6].

  For the reproducer, the issue is that O_DIRECT grabs a reference of the
  target page (via FOLL_GET) and clear_refs write-protects the relevant
  page table entry. On successive write access to the page from the
  process itself, we wrongly COW the page when resolving the write fault,
  resulting in a loss of synchronicity and consequently a memory corruption.

  While some people might think that using clear_refs in this combination
  is a corner cases, it turns out to be a more generic problem unfortunately.

  For example, it was just recently discovered that we can similarly
  create a memory corruption without clear_refs, simply by concurrently
  swapping out the buffer pages [7]. Note that we nowadays even use the
  swap infrastructure in Linux without an actual swap disk/partition: the
  prime example is zram which is enabled as default under Fedora [10].

  The root issue is that a write-fault on a page that has additional
  references results in a COW and thereby a loss of synchronicity
  and consequently a memory corruption if two parties believe they are
  referencing the same page.
"

We don't particularly care about R/O FOLL_GET references: they were never
reliable and O_DIRECT doesn't expect to observe modifications from a page
after DMA was started.

Note that:
* this only fixes the issue on x86, arm64, s390x and ppc64/book3s
  ("enterprise architectures"). Other architectures have to implement
  __HAVE_ARCH_PTE_SWP_EXCLUSIVE to achieve the same.
* this does *not * consider any kind of fork() after taking the reference:
  fork() after GUP never worked reliably with FOLL_GET.
* Not losing PG_anon_exclusive during swapout was the last remaining
  piece. KSM already makes sure that there are no other references on
  a page before considering it for sharing. Page migration maintains
  PG_anon_exclusive and simply fails when there are additional references
  (freezing the refcount fails). Only swapout code dropped the
  PG_anon_exclusive flag because it requires more work to remember +
  restore it.

With this series in place, most COW issues of [3] are fixed on said
architectures. Other architectures can implement
__HAVE_ARCH_PTE_SWP_EXCLUSIVE fairly easily.

[1] https://lkml.kernel.org/r/20220329160440.193848-1-david@redhat.com
[2] https://lkml.kernel.org/r/20211217113049.23850-1-david@redhat.com
[3] https://lore.kernel.org/r/3ae33b08-d9ef-f846-56fb-645e3b9b4c66@redhat.com


This patch (of 8):

Currently, we clear PG_anon_exclusive in try_to_unmap() and forget about
it.  We do this, to keep fork() logic on swap entries easy and efficient:
for example, if we wouldn't clear it when unmapping, we'd have to lookup
the page in the swapcache for each and every swap entry during fork() and
clear PG_anon_exclusive if set.

Instead, we want to store that information directly in the swap pte,
protected by the page table lock, similarly to how we handle
SWP_MIGRATION_READ_EXCLUSIVE for migration entries.  However, for actual
swap entries, we don't want to mess with the swap type (e.g., still one
bit) because it overcomplicates swap code.

In try_to_unmap(), we already reject to unmap in case the page might be
pinned, because we must not lose PG_anon_exclusive on pinned pages ever. 
Checking if there are other unexpected references reliably *before*
completely unmapping a page is unfortunately not really possible: THP
heavily overcomplicate the situation.  Once fully unmapped it's easier --
we, for example, make sure that there are no unexpected references *after*
unmapping a page before starting writeback on that page.

So, we currently might end up unmapping a page and clearing
PG_anon_exclusive if that page has additional references, for example, due
to a FOLL_GET.

do_swap_page() has to re-determine if a page is exclusive, which will
easily fail if there are other references on a page, most prominently GUP
references via FOLL_GET.  This can currently result in memory corruptions
when taking a FOLL_GET | FOLL_WRITE reference on a page even when fork()
is never involved: try_to_unmap() will succeed, and when refaulting the
page, it cannot be marked exclusive and will get replaced by a copy in the
page tables on the next write access, resulting in writes via the GUP
reference to the page being lost.

In an ideal world, everybody that uses GUP and wants to modify page
content, such as O_DIRECT, would properly use FOLL_PIN.  However, that
conversion will take a while.  It's easier to fix what used to work in the
past (FOLL_GET | FOLL_WRITE) remembering PG_anon_exclusive.  In addition,
by remembering PG_anon_exclusive we can further reduce unnecessary COW in
some cases, so it's the natural thing to do.

So let's transfer the PG_anon_exclusive information to the swap pte and
store it via an architecture-dependant pte bit; use that information when
restoring the swap pte in do_swap_page() and unuse_pte().  During fork(),
we simply have to clear the pte bit and are done.

Of course, there is one corner case to handle: swap backends that don't
support concurrent page modifications while the page is under writeback. 
Special case these, and drop the exclusive marker.  Add a comment why that
is just fine (also, reuse_swap_page() would have done the same in the
past).

In the future, we'll hopefully have all architectures support
__HAVE_ARCH_PTE_SWP_EXCLUSIVE, such that we can get rid of the empty stubs
and the define completely.  Then, we can also convert
SWP_MIGRATION_READ_EXCLUSIVE.  For architectures it's fairly easy to
support: either simply use a yet unused pte bit that can be used for swap
entries, steal one from the arch type bits if they exceed 5, or steal one
from the offset bits.

Note: R/O FOLL_GET references were never really reliable, especially when
taking one on a shared page and then writing to the page (e.g., GUP after
fork()).  FOLL_GET, including R/W references, were never really reliable
once fork was involved (e.g., GUP before fork(), GUP during fork()).  KSM
steps back in case it stumbles over unexpected references and is,
therefore, fine.

Link: https://lkml.kernel.org/r/20220329164329.208407-1-david@redhat.com
Link: https://lkml.kernel.org/r/20220329164329.208407-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nadav Amit <namit@vmware.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liang Zhang <zhangliang5@huawei.com>
Cc: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: Oded Gabbay <oded.gabbay@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |   29 ++++++++++++++++++++
 include/linux/swapops.h |    2 +
 mm/memory.c             |   55 +++++++++++++++++++++++++++++++++++---
 mm/rmap.c               |   19 +++++++------
 mm/swapfile.c           |   13 ++++++++
 5 files changed, 105 insertions(+), 13 deletions(-)

--- a/include/linux/pgtable.h~mm-swap-remember-pg_anon_exclusive-via-a-swp-pte-bit
+++ a/include/linux/pgtable.h
@@ -1003,6 +1003,35 @@ static inline pgprot_t pgprot_modify(pgp
 #define arch_start_context_switch(prev)	do {} while (0)
 #endif
 
+/*
+ * When replacing an anonymous page by a real (!non) swap entry, we clear
+ * PG_anon_exclusive from the page and instead remember whether the flag was
+ * set in the swp pte. During fork(), we have to mark the entry as !exclusive
+ * (possibly shared). On swapin, we use that information to restore
+ * PG_anon_exclusive, which is very helpful in cases where we might have
+ * additional (e.g., FOLL_GET) references on a page and wouldn't be able to
+ * detect exclusivity.
+ *
+ * These functions don't apply to non-swap entries (e.g., migration, hwpoison,
+ * ...).
+ */
+#ifndef __HAVE_ARCH_PTE_SWP_EXCLUSIVE
+static inline pte_t pte_swp_mkexclusive(pte_t pte)
+{
+	return pte;
+}
+
+static inline int pte_swp_exclusive(pte_t pte)
+{
+	return false;
+}
+
+static inline pte_t pte_swp_clear_exclusive(pte_t pte)
+{
+	return pte;
+}
+#endif
+
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
 #ifndef CONFIG_ARCH_ENABLE_THP_MIGRATION
 static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
--- a/include/linux/swapops.h~mm-swap-remember-pg_anon_exclusive-via-a-swp-pte-bit
+++ a/include/linux/swapops.h
@@ -26,6 +26,8 @@
 /* Clear all flags but only keep swp_entry_t related information */
 static inline pte_t pte_swp_clear_flags(pte_t pte)
 {
+	if (pte_swp_exclusive(pte))
+		pte = pte_swp_clear_exclusive(pte);
 	if (pte_swp_soft_dirty(pte))
 		pte = pte_swp_clear_soft_dirty(pte);
 	if (pte_swp_uffd_wp(pte))
--- a/mm/memory.c~mm-swap-remember-pg_anon_exclusive-via-a-swp-pte-bit
+++ a/mm/memory.c
@@ -792,6 +792,11 @@ copy_nonpresent_pte(struct mm_struct *ds
 						&src_mm->mmlist);
 			spin_unlock(&mmlist_lock);
 		}
+		/* Mark the swap entry as shared. */
+		if (pte_swp_exclusive(*src_pte)) {
+			pte = pte_swp_clear_exclusive(*src_pte);
+			set_pte_at(src_mm, addr, src_pte, pte);
+		}
 		rss[MM_SWAPENTS]++;
 	} else if (is_migration_entry(entry)) {
 		page = pfn_swap_entry_to_page(entry);
@@ -3559,6 +3564,7 @@ vm_fault_t do_swap_page(struct vm_fault
 	struct page *page = NULL, *swapcache;
 	struct swap_info_struct *si = NULL;
 	rmap_t rmap_flags = RMAP_NONE;
+	bool exclusive = false;
 	swp_entry_t entry;
 	pte_t pte;
 	int locked;
@@ -3725,6 +3731,46 @@ vm_fault_t do_swap_page(struct vm_fault
 	BUG_ON(PageAnon(page) && PageAnonExclusive(page));
 
 	/*
+	 * Check under PT lock (to protect against concurrent fork() sharing
+	 * the swap entry concurrently) for certainly exclusive pages.
+	 */
+	if (!PageKsm(page)) {
+		/*
+		 * Note that pte_swp_exclusive() == false for architectures
+		 * without __HAVE_ARCH_PTE_SWP_EXCLUSIVE.
+		 */
+		exclusive = pte_swp_exclusive(vmf->orig_pte);
+		if (page != swapcache) {
+			/*
+			 * We have a fresh page that is not exposed to the
+			 * swapcache -> certainly exclusive.
+			 */
+			exclusive = true;
+		} else if (exclusive && PageWriteback(page) &&
+			   !(swp_swap_info(entry)->flags & SWP_STABLE_WRITES)) {
+			/*
+			 * This is tricky: not all swap backends support
+			 * concurrent page modifications while under writeback.
+			 *
+			 * So if we stumble over such a page in the swapcache
+			 * we must not set the page exclusive, otherwise we can
+			 * map it writable without further checks and modify it
+			 * while still under writeback.
+			 *
+			 * For these problematic swap backends, simply drop the
+			 * exclusive marker: this is perfectly fine as we start
+			 * writeback only if we fully unmapped the page and
+			 * there are no unexpected references on the page after
+			 * unmapping succeeded. After fully unmapped, no
+			 * further GUP references (FOLL_GET and FOLL_PIN) can
+			 * appear, so dropping the exclusive marker and mapping
+			 * it only R/O is fine.
+			 */
+			exclusive = false;
+		}
+	}
+
+	/*
 	 * Remove the swap entry and conditionally try to free up the swapcache.
 	 * We're already holding a reference on the page but haven't mapped it
 	 * yet.
@@ -3738,11 +3784,12 @@ vm_fault_t do_swap_page(struct vm_fault
 	pte = mk_pte(page, vma->vm_page_prot);
 
 	/*
-	 * Same logic as in do_wp_page(); however, optimize for fresh pages
-	 * that are certainly not shared because we just allocated them without
-	 * exposing them to the swapcache.
+	 * Same logic as in do_wp_page(); however, optimize for pages that are
+	 * certainly not shared either because we just allocated them without
+	 * exposing them to the swapcache or because the swap entry indicates
+	 * exclusivity.
 	 */
-	if (!PageKsm(page) && (page != swapcache || page_count(page) == 1)) {
+	if (!PageKsm(page) && (exclusive || page_count(page) == 1)) {
 		if (vmf->flags & FAULT_FLAG_WRITE) {
 			pte = maybe_mkwrite(pte_mkdirty(pte), vma);
 			vmf->flags &= ~FAULT_FLAG_WRITE;
--- a/mm/rmap.c~mm-swap-remember-pg_anon_exclusive-via-a-swp-pte-bit
+++ a/mm/rmap.c
@@ -1656,14 +1656,15 @@ static bool try_to_unmap_one(struct foli
 				break;
 			}
 			/*
-			 * Note: We *don't* remember yet if the page was mapped
-			 * exclusively in the swap entry, so swapin code has
-			 * to re-determine that manually and might detect the
-			 * page as possibly shared, for example, if there are
-			 * other references on the page or if the page is under
-			 * writeback. We made sure that there are no GUP pins
-			 * on the page that would rely on it, so for GUP pins
-			 * this is fine.
+			 * Note: We *don't* remember if the page was mapped
+			 * exclusively in the swap pte if the architecture
+			 * doesn't support __HAVE_ARCH_PTE_SWP_EXCLUSIVE. In
+			 * that case, swapin code has to re-determine that
+			 * manually and might detect the page as possibly
+			 * shared, for example, if there are other references on
+			 * the page or if the page is under writeback. We made
+			 * sure that there are no GUP pins on the page that
+			 * would rely on it, so for GUP pins this is fine.
 			 */
 			if (list_empty(&mm->mmlist)) {
 				spin_lock(&mmlist_lock);
@@ -1674,6 +1675,8 @@ static bool try_to_unmap_one(struct foli
 			dec_mm_counter(mm, MM_ANONPAGES);
 			inc_mm_counter(mm, MM_SWAPENTS);
 			swp_pte = swp_entry_to_pte(entry);
+			if (anon_exclusive)
+				swp_pte = pte_swp_mkexclusive(swp_pte);
 			if (pte_soft_dirty(pteval))
 				swp_pte = pte_swp_mksoft_dirty(swp_pte);
 			if (pte_uffd_wp(pteval))
--- a/mm/swapfile.c~mm-swap-remember-pg_anon_exclusive-via-a-swp-pte-bit
+++ a/mm/swapfile.c
@@ -1804,7 +1804,18 @@ static int unuse_pte(struct vm_area_stru
 	inc_mm_counter(vma->vm_mm, MM_ANONPAGES);
 	get_page(page);
 	if (page == swapcache) {
-		page_add_anon_rmap(page, vma, addr, RMAP_NONE);
+		rmap_t rmap_flags = RMAP_NONE;
+
+		/*
+		 * See do_swap_page(): PageWriteback() would be problematic.
+		 * However, we do a wait_on_page_writeback() just before this
+		 * call and have the page locked.
+		 */
+		VM_BUG_ON_PAGE(PageWriteback(page), page);
+		if (pte_swp_exclusive(*pte))
+			rmap_flags |= RMAP_EXCLUSIVE;
+
+		page_add_anon_rmap(page, vma, addr, rmap_flags);
 	} else { /* ksm created a completely new copy */
 		page_add_new_anon_rmap(page, vma, addr);
 		lru_cache_add_inactive_or_unevictable(page, vma);
_

Patches currently in -mm which might be from david@redhat.com are

mm-rmap-fix-missing-swap_free-in-try_to_unmap-after-arch_unmap_one-failed.patch
mm-hugetlb-take-src_mm-write_protect_seq-in-copy_hugetlb_page_range.patch
mm-memory-slightly-simplify-copy_present_pte.patch
mm-rmap-split-page_dup_rmap-into-page_dup_file_rmap-and-page_try_dup_anon_rmap.patch
mm-rmap-convert-rmap-flags-to-a-proper-distinct-rmap_t-type.patch
mm-rmap-remove-do_page_add_anon_rmap.patch
mm-rmap-pass-rmap-flags-to-hugepage_add_anon_rmap.patch
mm-rmap-drop-compound-parameter-from-page_add_new_anon_rmap.patch
mm-rmap-use-page_move_anon_rmap-when-reusing-a-mapped-pageanon-page-exclusively.patch
mm-huge_memory-remove-outdated-vm_warn_on_once_page-from-unmap_page.patch
mm-page-flags-reuse-pg_mappedtodisk-as-pg_anon_exclusive-for-pageanon-pages.patch
mm-remember-exclusively-mapped-anonymous-pages-with-pg_anon_exclusive.patch
mm-gup-disallow-follow_pagefoll_pin.patch
mm-support-gup-triggered-unsharing-of-anonymous-pages.patch
mm-gup-trigger-fault_flag_unshare-when-r-o-pinning-a-possibly-shared-anonymous-page.patch
mm-gup-sanity-check-with-config_debug_vm-that-anonymous-pages-are-exclusive-when-unpinning.patch
mm-swap-remember-pg_anon_exclusive-via-a-swp-pte-bit.patch
mm-debug_vm_pgtable-add-tests-for-__have_arch_pte_swp_exclusive.patch
x86-pgtable-support-__have_arch_pte_swp_exclusive.patch
arm64-pgtable-support-__have_arch_pte_swp_exclusive.patch
s390-pgtable-cleanup-description-of-swp-pte-layout.patch
s390-pgtable-support-__have_arch_pte_swp_exclusive.patch
powerpc-pgtable-remove-_page_bit_swap_type-for-book3s.patch
powerpc-pgtable-support-__have_arch_pte_swp_exclusive-for-book3s.patch


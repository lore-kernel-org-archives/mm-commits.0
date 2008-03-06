From: akpm@linux-foundation.org
Subject: + pageflags-use-proper-page-flag-functions-in-xen.patch added to -mm tree
Date: Wed, 05 Mar 2008 17:31:19 -0800
Message-ID: <200803060131.m261VJi2002232@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756930AbYCFBcl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 20:32:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, ak@suse.de, apw@shadowen.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     pageflags: use proper page flag functions in Xen
has been added to the -mm tree.  Its filename is
     pageflags-use-proper-page-flag-functions-in-xen.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pageflags: use proper page flag functions in Xen
From: Christoph Lameter <clameter@sgi.com>

Xen uses bitops to manipulate page flags.  Make it use proper page flag
functions.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andi Kleen <ak@suse.de>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/mmu.c         |    4 ++--
 include/linux/page-flags.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/xen/mmu.c~pageflags-use-proper-page-flag-functions-in-xen arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c~pageflags-use-proper-page-flag-functions-in-xen
+++ a/arch/x86/xen/mmu.c
@@ -425,7 +425,7 @@ static void xen_do_pin(unsigned level, u
 
 static int pin_page(struct page *page, enum pt_level level)
 {
-	unsigned pgfl = test_and_set_bit(PG_pinned, &page->flags);
+	unsigned pgfl = TestSetPagePinned(page);
 	int flush;
 
 	if (pgfl)
@@ -506,7 +506,7 @@ void __init xen_mark_init_mm_pinned(void
 
 static int unpin_page(struct page *page, enum pt_level level)
 {
-	unsigned pgfl = test_and_clear_bit(PG_pinned, &page->flags);
+	unsigned pgfl = TestClearPagePinned(page);
 
 	if (pgfl && !PageHighMem(page)) {
 		void *pt = lowmem_page_address(page);
diff -puN include/linux/page-flags.h~pageflags-use-proper-page-flag-functions-in-xen include/linux/page-flags.h
--- a/include/linux/page-flags.h~pageflags-use-proper-page-flag-functions-in-xen
+++ a/include/linux/page-flags.h
@@ -155,7 +155,7 @@ PAGEFLAG(LRU, lru) __CLEARPAGEFLAG(LRU, 
 PAGEFLAG(Active, active) __CLEARPAGEFLAG(Active, active)
 __PAGEFLAG(Slab, slab)
 PAGEFLAG(Checked, checked)		/* Used by some filesystems */
-PAGEFLAG(Pinned, pinned)		/* Xen pinned pagetable */
+PAGEFLAG(Pinned, pinned) TESTSCFLAG(Pinned, pinned) /* Xen pagetable */
 PAGEFLAG(Reserved, reserved) __CLEARPAGEFLAG(Reserved, reserved)
 PAGEFLAG(Private, private) __CLEARPAGEFLAG(Private, private)
 	__SETPAGEFLAG(Private, private)
_

Patches currently in -mm which might be from clameter@sgi.com are

fix-mempolicy-reference-counting-bugs.patch
git-unionfs.patch
git-slub.patch
slab-pass-correct-flags-to-kmem_getpages.patch
ntfs-fix-nommu-build.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
remove-set_migrateflags.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch
mm-move-cache_line_size-to-linux-cacheh.patch
mempolicy-convert-mpol-constants-to-enum.patch
mempolicy-support-optional-mode-flags.patch
mempolicy-add-mpol_f_static_nodes-flag.patch
mempolicy-add-bitmap_onto-and-bitmap_fold-operations.patch
mempolicy-add-mpol_f_relative_nodes-flag.patch
mempolicy-update-numa-memory-policy-documentation.patch
sparsemem-vmemmap-does-not-need-section-bits.patch
kbuild-create-a-way-to-create-preprocessor-constants-from-c-expressions.patch
pageflags-use-an-enum-for-the-flags.patch
pageflags-get-rid-of-flags_reserved.patch
pageflags-introduce-macros-to-generate-page-flag-functions.patch
pageflags-convert-to-the-use-of-new-macros.patch
pageflags-use-proper-page-flag-functions-in-xen.patch
pageflags-eliminate-pg_xxx-aliases.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch


From: akpm@linux-foundation.org
Subject: + pageflags-eliminate-pg_xxx-aliases.patch added to -mm tree
Date: Wed, 05 Mar 2008 17:31:21 -0800
Message-ID: <200803060131.m261VMxx002236@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760344AbYCFBjH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 20:39:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, ak@suse.de, apw@shadowen.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     pageflags: eliminate PG_xxx aliases
has been added to the -mm tree.  Its filename is
     pageflags-eliminate-pg_xxx-aliases.patch

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
Subject: pageflags: eliminate PG_xxx aliases
From: Christoph Lameter <clameter@sgi.com>

Remove aliases of PG_xxx.  We can easily drop those now and alias by
specifying the PG_xxx flag in the macro that generates the functions.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andi Kleen <ak@suse.de>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   10 +++-------
 mm/page_alloc.c            |    2 +-
 2 files changed, 4 insertions(+), 8 deletions(-)

diff -puN include/linux/page-flags.h~pageflags-eliminate-pg_xxx-aliases include/linux/page-flags.h
--- a/include/linux/page-flags.h~pageflags-eliminate-pg_xxx-aliases
+++ a/include/linux/page-flags.h
@@ -77,8 +77,6 @@ enum pageflags {
 	PG_active,
 	PG_slab,
 	PG_owner_priv_1,	/* Owner use. If pagecache, fs may use*/
-	PG_checked = PG_owner_priv_1, /* Used by some filesystems */
-	PG_pinned = PG_owner_priv_1, /* Xen pinned pagetable */
 	PG_arch_1,
 	PG_reserved,
 	PG_private,		/* If pagecache, has fs-private data */
@@ -87,8 +85,6 @@ enum pageflags {
 	PG_swapcache,		/* Swap page: swp_entry_t in private */
 	PG_mappedtodisk,	/* Has blocks allocated on-disk */
 	PG_reclaim,		/* To be reclaimed asap */
-	/* PG_readahead is only used for file reads; PG_reclaim is only for writes */
-	PG_readahead = PG_reclaim, /* Reminder to do async read-ahead */
 	PG_buddy,		/* Page is free, on buddy lists */
 
 #if (BITS_PER_LONG > 32)
@@ -154,8 +150,8 @@ PAGEFLAG(Dirty, dirty) TESTSCFLAG(Dirty,
 PAGEFLAG(LRU, lru) __CLEARPAGEFLAG(LRU, lru)
 PAGEFLAG(Active, active) __CLEARPAGEFLAG(Active, active)
 __PAGEFLAG(Slab, slab)
-PAGEFLAG(Checked, checked)		/* Used by some filesystems */
-PAGEFLAG(Pinned, pinned) TESTSCFLAG(Pinned, pinned) /* Xen pagetable */
+PAGEFLAG(Checked, owner_priv_1)		/* Used by some filesystems */
+PAGEFLAG(Pinned, owner_priv_1) TESTSCFLAG(Pinned, owner_priv_1) /* Xen */
 PAGEFLAG(Reserved, reserved) __CLEARPAGEFLAG(Reserved, reserved)
 PAGEFLAG(Private, private) __CLEARPAGEFLAG(Private, private)
 	__SETPAGEFLAG(Private, private)
@@ -170,7 +166,7 @@ PAGEFLAG(MappedToDisk, mappedtodisk)
 
 /* PG_readahead is only used for file reads; PG_reclaim is only for writes */
 PAGEFLAG(Reclaim, reclaim) TESTCLEARFLAG(Reclaim, reclaim)
-PAGEFLAG(Readahead, readahead)		/* Reminder to do async read-ahead */
+PAGEFLAG(Readahead, reclaim)		/* Reminder to do async read-ahead */
 
 static inline int PageHighMem(struct page *page)
 {
diff -puN mm/page_alloc.c~pageflags-eliminate-pg_xxx-aliases mm/page_alloc.c
--- a/mm/page_alloc.c~pageflags-eliminate-pg_xxx-aliases
+++ a/mm/page_alloc.c
@@ -632,7 +632,7 @@ static int prep_new_page(struct page *pa
 	if (PageReserved(page))
 		return 1;
 
-	page->flags &= ~(1 << PG_uptodate | 1 << PG_error | 1 << PG_readahead |
+	page->flags &= ~(1 << PG_uptodate | 1 << PG_error | 1 << PG_reclaim |
 			1 << PG_referenced | 1 << PG_arch_1 |
 			1 << PG_owner_priv_1 | 1 << PG_mappedtodisk);
 	set_page_private(page, 0);
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


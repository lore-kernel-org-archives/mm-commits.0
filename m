From: akpm@linux-foundation.org
Subject: + pageflags-use-an-enum-for-the-flags.patch added to -mm tree
Date: Wed, 05 Mar 2008 17:31:11 -0800
Message-ID: <200803060131.m261VBqw002192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753837AbYCFBcf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 20:32:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, ak@suse.de, apw@shadowen.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     pageflags: use an enum for the flags
has been added to the -mm tree.  Its filename is
     pageflags-use-an-enum-for-the-flags.patch

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
Subject: pageflags: use an enum for the flags
From: Christoph Lameter <clameter@sgi.com>

Use an enum to ease the maintenance of page flags.  This is going to change
the numbering from 0 to 18.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andi Kleen <ak@suse.de>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   56 ++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 30 deletions(-)

diff -puN include/linux/page-flags.h~pageflags-use-an-enum-for-the-flags include/linux/page-flags.h
--- a/include/linux/page-flags.h~pageflags-use-an-enum-for-the-flags
+++ a/include/linux/page-flags.h
@@ -67,35 +67,29 @@
  * FLAGS_RESERVED which defines the width of the fields section
  * (see linux/mmzone.h).  New flags must _not_ overlap with this area.
  */
-#define PG_locked	 	 0	/* Page is locked. Don't touch. */
-#define PG_error		 1
-#define PG_referenced		 2
-#define PG_uptodate		 3
-
-#define PG_dirty	 	 4
-#define PG_lru			 5
-#define PG_active		 6
-#define PG_slab			 7	/* slab debug (Suparna wants this) */
-
-#define PG_owner_priv_1		 8	/* Owner use. If pagecache, fs may use*/
-#define PG_arch_1		 9
-#define PG_reserved		10
-#define PG_private		11	/* If pagecache, has fs-private data */
-
-#define PG_writeback		12	/* Page is under writeback */
-#define PG_compound		14	/* Part of a compound page */
-#define PG_swapcache		15	/* Swap page: swp_entry_t in private */
-
-#define PG_mappedtodisk		16	/* Has blocks allocated on-disk */
-#define PG_reclaim		17	/* To be reclaimed asap */
-#define PG_buddy		19	/* Page is free, on buddy lists */
-
-/* PG_readahead is only used for file reads; PG_reclaim is only for writes */
-#define PG_readahead		PG_reclaim /* Reminder to do async read-ahead */
-
-/* PG_owner_priv_1 users should have descriptive aliases */
-#define PG_checked		PG_owner_priv_1 /* Used by some filesystems */
-#define PG_pinned		PG_owner_priv_1	/* Xen pinned pagetable */
+enum pageflags {
+	PG_locked,		/* Page is locked. Don't touch. */
+	PG_error,
+	PG_referenced,
+	PG_uptodate,
+	PG_dirty,
+	PG_lru,
+	PG_active,
+	PG_slab,
+	PG_owner_priv_1,	/* Owner use. If pagecache, fs may use*/
+	PG_checked = PG_owner_priv_1, /* Used by some filesystems */
+	PG_pinned = PG_owner_priv_1, /* Xen pinned pagetable */
+	PG_arch_1,
+	PG_reserved,
+	PG_private,		/* If pagecache, has fs-private data */
+	PG_writeback,		/* Page is under writeback */
+	PG_compound,		/* A compound page */
+	PG_swapcache,		/* Swap page: swp_entry_t in private */
+	PG_mappedtodisk,	/* Has blocks allocated on-disk */
+	PG_reclaim,		/* To be reclaimed asap */
+	/* PG_readahead is only used for file reads; PG_reclaim is only for writes */
+	PG_readahead = PG_reclaim, /* Reminder to do async read-ahead */
+	PG_buddy,		/* Page is free, on buddy lists */
 
 #if (BITS_PER_LONG > 32)
 /*
@@ -105,8 +99,10 @@
  * 64 bit  |           FIELDS             | ??????         FLAGS         |
  *         63                            32                              0
  */
-#define PG_uncached		31	/* Page has been mapped as uncached */
+	PG_uncached = 31,		/* Page has been mapped as uncached */
 #endif
+	NR_PAGEFLAGS
+};
 
 /*
  * Manipulation of page state flags
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


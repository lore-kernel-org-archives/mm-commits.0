From: akpm@linux-foundation.org
Subject: - pageflags-use-an-enum-for-the-flags.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:52:17 -0700
Message-ID: <200804282152.m3SLqHWm017755@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933655AbYD1Vwt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:52:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, apw@shadowen.org, jeremy@goop.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pageflags: use an enum for the flags
has been removed from the -mm tree.  Its filename was
     pageflags-use-an-enum-for-the-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pageflags: use an enum for the flags
From: Christoph Lameter <clameter@sgi.com>

Use an enum to ease the maintenance of page flags.  This is going to change
the numbering from 0 to 18.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
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

origin.patch
git-unionfs.patch
git-pekka.patch
page-allcoator-smarter-retry-of-costly-order-allocations.patch
page-allocator-explicitly-retry-hugepage-allocations.patch
ipc-add-definitions-of-ushort_max-and-others.patch
mm-add-nr_writeback_temp-counter.patch
remove-div_long_long_rem.patch
slab-add-a-flag-to-prevent-debug_free-checks-on-a-kmem_cache.patch
add-kbuildh-that-contains-common-definitions-for-kbuild-users.patch
x86-use-kbuildh.patch
mips-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch
alpha-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch
ia64-use-kbuildh-macros-instead-of-defining-macros-in-asm-offsetsc.patch
arm-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch
xtensa-use-kbuildh-macros-instead-of-defining-them-in-asm-offsetsc.patch
sparc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
avr32-use-kbuildh-macros-instead-of-defining-macros-in-asm-offsetsc.patch
blackfin-use-kbuildh-instead-of-defining-macros-in-asm-macrosc.patch
frv-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
h8300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
m68k-m68kmmu-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
mn10300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
parisc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
ppc-powerpc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc-update.patch
sh-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
v850-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch


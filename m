From: akpm@linux-foundation.org
Subject: - pageflags-eliminate-pg_xxx-aliases.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:52:26 -0700
Message-ID: <200804282152.m3SLqQs3017773@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52581 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934860AbYD1Vw6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:52:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, apw@shadowen.org, jeremy@goop.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pageflags: eliminate PG_xxx aliases
has been removed from the -mm tree.  Its filename was
     pageflags-eliminate-pg_xxx-aliases.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pageflags: eliminate PG_xxx aliases
From: Christoph Lameter <clameter@sgi.com>

Remove aliases of PG_xxx.  We can easily drop those now and alias by
specifying the PG_xxx flag in the macro that generates the functions.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   12 ++++--------
 mm/page_alloc.c            |    2 +-
 2 files changed, 5 insertions(+), 9 deletions(-)

diff -puN include/linux/page-flags.h~pageflags-eliminate-pg_xxx-aliases include/linux/page-flags.h
--- a/include/linux/page-flags.h~pageflags-eliminate-pg_xxx-aliases
+++ a/include/linux/page-flags.h
@@ -79,8 +79,6 @@ enum pageflags {
 	PG_active,
 	PG_slab,
 	PG_owner_priv_1,	/* Owner use. If pagecache, fs may use*/
-	PG_checked = PG_owner_priv_1, /* Used by some filesystems */
-	PG_pinned = PG_owner_priv_1, /* Xen pinned pagetable */
 	PG_arch_1,
 	PG_reserved,
 	PG_private,		/* If pagecache, has fs-private data */
@@ -89,8 +87,6 @@ enum pageflags {
 	PG_swapcache,		/* Swap page: swp_entry_t in private */
 	PG_mappedtodisk,	/* Has blocks allocated on-disk */
 	PG_reclaim,		/* To be reclaimed asap */
-	/* PG_readahead is only used for file reads; PG_reclaim is only for writes */
-	PG_readahead = PG_reclaim, /* Reminder to do async read-ahead */
 	PG_buddy,		/* Page is free, on buddy lists */
 
 #if (BITS_PER_LONG > 32)
@@ -158,8 +154,8 @@ PAGEFLAG(Dirty, dirty) TESTSCFLAG(Dirty,
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
@@ -174,14 +170,14 @@ PAGEFLAG(MappedToDisk, mappedtodisk)
 
 /* PG_readahead is only used for file reads; PG_reclaim is only for writes */
 PAGEFLAG(Reclaim, reclaim) TESTCLEARFLAG(Reclaim, reclaim)
-PAGEFLAG(Readahead, readahead)		/* Reminder to do async read-ahead */
+PAGEFLAG(Readahead, reclaim)		/* Reminder to do async read-ahead */
 
 #ifdef CONFIG_HIGHMEM
 /*
  * Must use a macro here due to header dependency issues. page_zone() is not
  * available at this point.
  */
-#define PageHighMem(__p) is_highmem(page_zone(page))
+#define PageHighMem(__p) is_highmem(page_zone(__p))
 #else
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


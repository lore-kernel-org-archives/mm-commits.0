From: akpm@linux-foundation.org
Subject: - pageflags-use-proper-page-flag-functions-in-xen.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:52:24 -0700
Message-ID: <200804282152.m3SLqO77017770@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934836AbYD1Vw4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:52:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, apw@shadowen.org, jeremy@goop.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pageflags: use proper page flag functions in Xen
has been removed from the -mm tree.  Its filename was
     pageflags-use-proper-page-flag-functions-in-xen.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pageflags: use proper page flag functions in Xen
From: Christoph Lameter <clameter@sgi.com>

Xen uses bitops to manipulate page flags.  Make it use proper page flag
functions.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/mmu.c         |    4 ++--
 include/linux/page-flags.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/xen/mmu.c~pageflags-use-proper-page-flag-functions-in-xen arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c~pageflags-use-proper-page-flag-functions-in-xen
+++ a/arch/x86/xen/mmu.c
@@ -387,7 +387,7 @@ static void xen_do_pin(unsigned level, u
 
 static int pin_page(struct page *page, enum pt_level level)
 {
-	unsigned pgfl = test_and_set_bit(PG_pinned, &page->flags);
+	unsigned pgfl = TestSetPagePinned(page);
 	int flush;
 
 	if (pgfl)
@@ -468,7 +468,7 @@ void __init xen_mark_init_mm_pinned(void
 
 static int unpin_page(struct page *page, enum pt_level level)
 {
-	unsigned pgfl = test_and_clear_bit(PG_pinned, &page->flags);
+	unsigned pgfl = TestClearPagePinned(page);
 
 	if (pgfl && !PageHighMem(page)) {
 		void *pt = lowmem_page_address(page);
diff -puN include/linux/page-flags.h~pageflags-use-proper-page-flag-functions-in-xen include/linux/page-flags.h
--- a/include/linux/page-flags.h~pageflags-use-proper-page-flag-functions-in-xen
+++ a/include/linux/page-flags.h
@@ -159,7 +159,7 @@ PAGEFLAG(LRU, lru) __CLEARPAGEFLAG(LRU, 
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


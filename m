From: akpm@linux-foundation.org
Subject: [merged] mm-stop-ptlock-enlarging-struct-page.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:52:33 -0800
Message-ID: <200912152152.nBFLqXxn015201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761228AbZLOVxa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:53:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, Lee.Schermerhorn@hp.com, aarcange@redhat.com, andi@firstfloor.org, fengguang.wu@intel.com, ieidus@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohi


The patch titled
     mm: stop ptlock enlarging struct page
has been removed from the -mm tree.  Its filename was
     mm-stop-ptlock-enlarging-struct-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: stop ptlock enlarging struct page
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

CONFIG_DEBUG_SPINLOCK adds 12 or 16 bytes to a 32- or 64-bit spinlock_t,
and CONFIG_DEBUG_LOCK_ALLOC adds another 12 or 24 bytes to it: lockdep
enables both of those, and CONFIG_LOCK_STAT adds 8 or 16 bytes to that.

When 2.6.15 placed the split page table lock inside struct page (usually
sized 32 or 56 bytes), only CONFIG_DEBUG_SPINLOCK was a possibility, and
we ignored the enlargement (but fitted in CONFIG_GENERIC_LOCKBREAK's 4 by
letting the spinlock_t occupy both page->private and page->mapping).

Should these debugging options be allowed to double the size of a struct
page, when only one minority use of the page (as a page table) needs to
fit a spinlock in there?  Perhaps not.

Take the easy way out: switch off SPLIT_PTLOCK_CPUS when DEBUG_SPINLOCK or
DEBUG_LOCK_ALLOC is in force.  I've sometimes tried to be cleverer,
kmallocing a cacheline for the spinlock when it doesn't fit, but given up
each time.  Falling back to mm->page_table_lock (as we do when ptlock is
not split) lets lockdep check out the strictest path anyway.

And now that some arches allow 8192 cpus, use 999999 for infinity.

(What has this got to do with KSM swapping?  It doesn't care about the
size of struct page, but may care about random junk in page->mapping - to
be explained separately later.)

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/Kconfig~mm-stop-ptlock-enlarging-struct-page mm/Kconfig
--- a/mm/Kconfig~mm-stop-ptlock-enlarging-struct-page
+++ a/mm/Kconfig
@@ -158,11 +158,13 @@ config PAGEFLAGS_EXTENDED
 # Default to 4 for wider testing, though 8 might be more appropriate.
 # ARM's adjust_pte (unused if VIPT) depends on mm-wide page_table_lock.
 # PA-RISC 7xxx's spinlock_t would enlarge struct page from 32 to 44 bytes.
+# DEBUG_SPINLOCK and DEBUG_LOCK_ALLOC spinlock_t also enlarge struct page.
 #
 config SPLIT_PTLOCK_CPUS
 	int
-	default "4096" if ARM && !CPU_CACHE_VIPT
-	default "4096" if PARISC && !PA20
+	default "999999" if ARM && !CPU_CACHE_VIPT
+	default "999999" if PARISC && !PA20
+	default "999999" if DEBUG_SPINLOCK || DEBUG_LOCK_ALLOC
 	default "4"
 
 #
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
linux-next.patch
vfs-fsstack-handle-32-bit-smp-preempt-large-files-in-fsstack_copy_inode_size.patch
ksm-memory-hotremove-migration-only-fix.patch
elf-kill-use_elf_core_dump.patch
prio_tree-debugging-patch.patch


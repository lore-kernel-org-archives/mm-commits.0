From: akpm@linux-foundation.org
Subject: + paride-drivers-initialize-spinlocks.patch added to -mm tree
Date: Fri, 20 Apr 2007 15:31:46 -0700
Message-ID: <200704202231.l3KMVuMP025372@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751615AbXDTWcG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 18:32:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, jens.axboe@oracle.com


The patch titled
     paride drivers: initialize spinlocks
has been added to the -mm tree.  Its filename is
     paride-drivers-initialize-spinlocks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: paride drivers: initialize spinlocks
From: Alexey Dobriyan <adobriyan@sw.ru>

pcd_lock and pf_spin_lock are passed to blk_init_queue() which, seeing them
as valid lock pointer, sets it as ->queue_lock.

The problem is that pcd_lock and pf_spin_lock aren't initialized anywhere.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/paride/pcd.c |    2 +-
 drivers/block/paride/pf.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/block/paride/pcd.c~paride-drivers-initialize-spinlocks drivers/block/paride/pcd.c
--- a/drivers/block/paride/pcd.c~paride-drivers-initialize-spinlocks
+++ a/drivers/block/paride/pcd.c
@@ -140,7 +140,7 @@ enum {D_PRT, D_PRO, D_UNI, D_MOD, D_SLV,
 #include <linux/blkdev.h>
 #include <asm/uaccess.h>
 
-static spinlock_t pcd_lock;
+static DEFINE_SPINLOCK(pcd_lock);
 
 module_param(verbose, bool, 0644);
 module_param(major, int, 0);
diff -puN drivers/block/paride/pf.c~paride-drivers-initialize-spinlocks drivers/block/paride/pf.c
--- a/drivers/block/paride/pf.c~paride-drivers-initialize-spinlocks
+++ a/drivers/block/paride/pf.c
@@ -154,7 +154,7 @@ enum {D_PRT, D_PRO, D_UNI, D_MOD, D_SLV,
 #include <linux/blkpg.h>
 #include <asm/uaccess.h>
 
-static spinlock_t pf_spin_lock;
+static DEFINE_SPINLOCK(pf_spin_lock);
 
 module_param(verbose, bool, 0644);
 module_param(major, int, 0);
_

Patches currently in -mm which might be from adobriyan@sw.ru are

paride-drivers-initialize-spinlocks.patch
git-cpufreq.patch
2621-rc5-mm3-fix-e1000-compilation.patch
maps2-add-proc-pid-pagemap-interface-fix.patch
fix-race-between-proc_readdir-and-remove_proc_entry.patch
proc-remove-pathetic-deleted-warn_on.patch
add-file-position-info-to-proc.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
proc-oom_score-oops-re-badness.patch
protect-tty-drivers-list-with-tty_mutex.patch
simplify-module_get_kallsym-by-dropping-length-arg.patch
fix-race-between-rmmod-and-cat-proc-kallsyms.patch
fix-race-between-rmmod-and-cat-proc-kallsyms-fix.patch
simplify-kallsyms_lookup.patch
fix-race-between-cat-proc-wchan-and-rmmod-et-al.patch
fix-race-between-cat-proc-slab_allocators-and-rmmod.patch

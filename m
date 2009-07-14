From: akpm@linux-foundation.org
Subject: [merged] sys_sync-fix-16%-performance-regression-in-ffsb-create_4k-test.patch removed from -mm tree
Date: Tue, 14 Jul 2009 13:32:42 -0700
Message-ID: <200907142032.n6EKWgrX012367@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756411AbZGNUcw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jul 2009 16:32:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yanmin_zhang@linux.intel.com, jack@suse.cz, jens.axboe@oracle.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     sys_sync(): fix 16% performance regression in ffsb create_4k test
has been removed from the -mm tree.  Its filename was
     sys_sync-fix-16%-performance-regression-in-ffsb-create_4k-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_sync(): fix 16% performance regression in ffsb create_4k test
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>

I run many ffsb test cases on JBODs (typically 13/12 disks).  Comparing
with kernel 2.6.30, 2.6.31-rc1 has about 16% regression with
ffsb_create_4k.  The sub test case creates files continuously for 10
minitues and every file is 1MB.

Bisect located below patch.

5cee5815d1564bbbd505fea86f4550f1efdb5cd0 is first bad commit
commit 5cee5815d1564bbbd505fea86f4550f1efdb5cd0
Author: Jan Kara <jack@suse.cz>
Date:   Mon Apr 27 16:43:51 2009 +0200

    vfs: Make sys_sync() use fsync_super() (version 4)

    It is unnecessarily fragile to have two places (fsync_super() and do_sync())
    doing data integrity sync of the filesystem. Alter __fsync_super() to
    accommodate needs of both callers and use it. So after this patch
    __fsync_super() is the only place where we gather all the calls needed to
    properly send all data on a filesystem to disk.

As a matter of fact, ffsb calls sys_sync in the end to make sure all data
is flushed to disks and the flushing is counted into the result.  vmstat
shows ffsb is blocked when syncing for a long time.  With 2.6.30, ffsb is
blocked for a short time.

I checked the patch and did experiments to recover the original methods. 
Eventually, the root cause is the patch deletes the calling to
wakeup_pdflush when syncing, so only ffsb is blocked on disk I/O. 
wakeup_pdflush could ask pdflush to write back pages with ffsb at the
same time.

[akpm@linux-foundation.org: restore comment too]
Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sync.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/sync.c~sys_sync-fix-16%-performance-regression-in-ffsb-create_4k-test fs/sync.c
--- a/fs/sync.c~sys_sync-fix-16%-performance-regression-in-ffsb-create_4k-test
+++ a/fs/sync.c
@@ -112,8 +112,13 @@ restart:
 	mutex_unlock(&mutex);
 }
 
+/*
+ * sync everything.  Start out by waking pdflush, because that writes back
+ * all queues in parallel.
+ */
 SYSCALL_DEFINE0(sync)
 {
+	wakeup_pdflush(0);
 	sync_filesystems(0);
 	sync_filesystems(1);
 	if (unlikely(laptop_mode))
_

Patches currently in -mm which might be from yanmin_zhang@linux.intel.com are

kernel-core-add-smp_call_function_any.patch
kernel-core-add-smp_call_function_any-update.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch


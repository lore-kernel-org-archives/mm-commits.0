From: akpm@osdl.org
Subject: - avoid-lockdep-warning-in-md.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:00:37 -0800
Message-ID: <200612082000.kB8K0bMC001766@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56640 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426212AbWLHUAt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:00:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, a.p.zijlstra@chello.nl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     lockdep: avoid lockdep warning in md
has been removed from the -mm tree.  Its filename was
     avoid-lockdep-warning-in-md.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockdep: avoid lockdep warning in md
From: NeilBrown <neilb@suse.de>

md_open takes ->reconfig_mutex which causes lockdep to complain.  This
(normally) doesn't have deadlock potential as the possible conflict is with a
reconfig_mutex in a different device.

I say "normally" because if a loop were created in the array->member hierarchy
a deadlock could happen.  However that causes bigger problems than a deadlock
and should be fixed independently.

So we flag the lock in md_open as a nested lock.  This requires defining
mutex_lock_interruptible_nested.

Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/md.c       |    2 +-
 include/linux/mutex.h |    2 ++
 kernel/mutex.c        |    9 +++++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff -puN drivers/md/md.c~avoid-lockdep-warning-in-md drivers/md/md.c
--- a/drivers/md/md.c~avoid-lockdep-warning-in-md
+++ a/drivers/md/md.c
@@ -4423,7 +4423,7 @@ static int md_open(struct inode *inode, 
 	mddev_t *mddev = inode->i_bdev->bd_disk->private_data;
 	int err;
 
-	if ((err = mddev_lock(mddev)))
+	if ((err = mutex_lock_interruptible_nested(&mddev->reconfig_mutex, 1)))
 		goto out;
 
 	err = 0;
diff -puN include/linux/mutex.h~avoid-lockdep-warning-in-md include/linux/mutex.h
--- a/include/linux/mutex.h~avoid-lockdep-warning-in-md
+++ a/include/linux/mutex.h
@@ -125,8 +125,10 @@ extern int fastcall mutex_lock_interrupt
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 extern void mutex_lock_nested(struct mutex *lock, unsigned int subclass);
+extern int mutex_lock_interruptible_nested(struct mutex *lock, unsigned int subclass);
 #else
 # define mutex_lock_nested(lock, subclass) mutex_lock(lock)
+# define mutex_lock_interruptible_nested(lock, subclass) mutex_lock_interruptible(lock)
 #endif
 
 /*
diff -puN kernel/mutex.c~avoid-lockdep-warning-in-md kernel/mutex.c
--- a/kernel/mutex.c~avoid-lockdep-warning-in-md
+++ a/kernel/mutex.c
@@ -206,6 +206,15 @@ mutex_lock_nested(struct mutex *lock, un
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_nested);
+
+int __sched
+mutex_lock_interruptible_nested(struct mutex *lock, unsigned int subclass)
+{
+	might_sleep();
+	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, subclass);
+}
+
+EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
 #endif
 
 /*
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
avoid-lockdep-warning-in-md.patch
bdev-fix-bd_part_count-leak.patch
lockdep-annotate-nfsd4-recover-code.patch
nfs2-calculate-w-a-bit-later-in-nfsaclsvc_encode_getaclres.patch
nfs3-calculate-w-a-bit-later-in-nfs3svc_encode_getaclres.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
md-tidy-up-device-change-notification-when-an-md-array-is-stopped.patch
md-define-raid5_mergeable_bvec.patch
md-handle-bypassing-the-read-cache-assuming-nothing-fails.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-fix.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-misc-fixes-for-aligned-read-handling-including-raid6-read-corruption.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-misc-fixes-for-error-handling-of-aligned-reads.patch
md-enable-bypassing-cache-for-reads.patch
md-fix-innocuous-bug-in-raid6-stripe_to_pdidx.patch
md-conditionalize-some-code.patch
md-change-lifetime-rules-for-md-devices.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch


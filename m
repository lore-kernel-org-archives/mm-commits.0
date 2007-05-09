From: akpm@linux-foundation.org
Subject: - nbd-check-the-return-value-of-sysfs_create_file-fix.patch removed from -mm tree
Date: Wed, 09 May 2007 01:50:26 -0700
Message-ID: <200705090850.l498oQEE018443@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754532AbXEIIud (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 04:50:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, paul.clements@steeleye.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     nbd-check-the-return-value-of-sysfs_create_file-fix
has been removed from the -mm tree.  Its filename was
     nbd-check-the-return-value-of-sysfs_create_file-fix.patch

This patch was dropped because it was folded into nbd-check-the-return-value-of-sysfs_create_file.patch

------------------------------------------------------
Subject: nbd-check-the-return-value-of-sysfs_create_file-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN drivers/block/nbd.c~nbd-check-the-return-value-of-sysfs_create_file-fix drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-check-the-return-value-of-sysfs_create_file-fix
+++ a/drivers/block/nbd.c
@@ -366,23 +366,25 @@ static struct disk_attribute pid_attr = 
 	.show = pid_show,
 };
 
-static void nbd_do_it(struct nbd_device *lo)
+static int nbd_do_it(struct nbd_device *lo)
 {
 	struct request *req;
+	int ret;
 
 	BUG_ON(lo->magic != LO_MAGIC);
 
 	lo->pid = current->pid;
-	if (sysfs_create_file(&lo->disk->kobj, &pid_attr.attr)) {
+	ret = sysfs_create_file(&lo->disk->kobj, &pid_attr.attr);
+	if (ret) {
 		printk(KERN_ERR "nbd: sysfs_create_file failed!");
-		return;
+		return ret;
 	}
 
 	while ((req = nbd_read_stat(lo)) != NULL)
 		nbd_end_request(req);
 
 	sysfs_remove_file(&lo->disk->kobj, &pid_attr.attr);
-	return;
+	return 0;
 }
 
 static void nbd_clear_que(struct nbd_device *lo)
@@ -572,7 +574,9 @@ static int nbd_ioctl(struct inode *inode
 	case NBD_DO_IT:
 		if (!lo->file)
 			return -EINVAL;
-		nbd_do_it(lo);
+		error = nbd_do_it(lo);
+		if (error)
+			return error;
 		/* on return tidy up in case we have a signal */
 		/* Forcibly shutdown the socket causing all listeners
 		 * to error
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slub-add-support-for-dynamic-cacheline-size-determination.patch
swsusp-clean-up-print.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch
nbd-check-the-return-value-of-sysfs_create_file.patch
nbd-check-the-return-value-of-sysfs_create_file-fix.patch
mutex_lock_interruptible-add-__must_check.patch
mutex_lock_interruptible-add-__must_check-must-fix.patch
afs-implement-basic-file-write-support-fix.patch
tty-add-compat_ioctl-fix.patch
blacklist-dell-optiplex-320-from-using-the-hpet-fix.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
kthread-dont-depend-on-work-queues-take-2.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
make-cancel_rearming_delayed_work-reliable-spelling.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
linux-kernel-markers-i386-optimization.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
fs-convert-core-functions-to-zero_user_page-fix-2.patch
ntfs-use-zero_user_page-fix.patch
make-vm-statistics-update-interval-configurable-fix.patch
rename-thread_info-to-stack-fix.patch
reiser4-slab-allocators-remove-slab_debug_initial-flag.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
w1-build-fix.patch

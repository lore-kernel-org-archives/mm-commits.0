From: akpm@linux-foundation.org
Subject: - devscgroup-check-for-device-permissions-at-mount-time.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:48:12 -0700
Message-ID: <200806081948.m58JmCg0017484@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753745AbYFHTsT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:48:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     devscgroup: check for device permissions at mount time
has been removed from the -mm tree.  Its filename was
     devscgroup-check-for-device-permissions-at-mount-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devscgroup: check for device permissions at mount time
From: Pavel Emelyanov <xemul@openvz.org>

Currently even if a task sits in an all-denied cgroup it can still mount
any block device in any mode it wants.

Put a proper check in do_open for block device to prevent this.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Tested-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN fs/block_dev.c~devscgroup-check-for-device-permissions-at-mount-time fs/block_dev.c
--- a/fs/block_dev.c~devscgroup-check-for-device-permissions-at-mount-time
+++ a/fs/block_dev.c
@@ -12,6 +12,7 @@
 #include <linux/kmod.h>
 #include <linux/major.h>
 #include <linux/smp_lock.h>
+#include <linux/device_cgroup.h>
 #include <linux/highmem.h>
 #include <linux/blkdev.h>
 #include <linux/module.h>
@@ -928,9 +929,14 @@ static int do_open(struct block_device *
 {
 	struct module *owner = NULL;
 	struct gendisk *disk;
-	int ret = -ENXIO;
+	int ret;
 	int part;
 
+	ret = devcgroup_inode_permission(bdev->bd_inode, file->f_mode);
+	if (ret != 0)
+		return ret;
+
+	ret = -ENXIO;
 	file->f_mapping = bdev->bd_inode->i_mapping;
 	lock_kernel();
 	disk = get_gendisk(bdev->bd_dev, &part);
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
linux-next.patch
mark-res_counter_charge_locked-with-__must_check.patch
memcg-make-global-var-read_mostly.patch
memcg-avoid-unnecessary-initialization.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-handle-swap-cache.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch
bsdacct-rename-acct_blbls-to-bsd_acct_struct.patch
pidns-use-kzalloc-when-allocating-new-pid_namespace-struct.patch
pidns-add-the-struct-bsd_acct_struct-pointer-on-pid_namespace-struct.patch
bsdacct-truthify-a-comment-near-acct_process.patch
bsdacct-make-check-timer-accept-a-bsd_acct_struct-argument.patch
bsdacct-turn-the-acct_lock-from-on-the-struct-to-global.patch
bsdacct-make-internal-code-work-with-passed-bsd_acct_struct-not-global.patch
bsdacct-switch-from-global-bsd_acct_struct-instance-to-per-pidns-one.patch
bsdacct-turn-acct-off-for-all-pidns-s-on-umount-time.patch
bsdacct-account-dying-tasks-in-all-relevant-namespaces.patch
bsdacct-stir-up-comments-around-acct_process.patch
reiser4.patch


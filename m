From: akpm@linux-foundation.org
Subject: + devscgroup-check-for-device-permissions-at-mount-time.patch added to -mm tree
Date: Thu, 05 Jun 2008 11:47:49 -0700
Message-ID: <200806051847.m55IlnQH024365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754622AbYFES6N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 14:58:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, serue@us.ibm.com


The patch titled
     devscgroup: check for device permissions at mount time
has been added to the -mm tree.  Its filename is
     devscgroup-check-for-device-permissions-at-mount-time.patch

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

devcgroup-make-a-helper-to-convert-cgroup_subsys_state-to-devs_cgroup.patch
devscgroup-relax-task-to-dev_cgroup-conversion.patch
devscgroup-check-for-device-permissions-at-mount-time.patch
devscgroup-make-white-list-more-compact-in-some-cases.patch
linux-next.patch
proc-calculate-the-correct-proc-pid-link-count.patch
proc-calculate-the-correct-proc-pid-link-count-cleanup.patch
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


From: akpm@linux-foundation.org
Subject: - net-ignore-sysfs-network-device-rename-bugs.patch removed from -mm tree
Date: Wed, 04 Apr 2007 19:00:44 -0700
Message-ID: <200704050200.l3520i6R004846@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38067 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932469AbXDECAv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 4 Apr 2007 22:00:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, davem@davemloft.net, greg@kroah.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     net: ignore sysfs network device rename bugs.
has been removed from the -mm tree.  Its filename was
     net-ignore-sysfs-network-device-rename-bugs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: net: ignore sysfs network device rename bugs.
From: Eric W. Biederman <ebiederm@xmission.com>

The generic networking code ensures that no two networking devices have the
same name, so there is no time except when sysfs has implementation bugs
that device_rename when called from dev_change_name will fail.

The current error handling for errors from device_rename in dev_change_name
is wrong and results in an unusable and unrecoverable network device if
device_rename is happens to return an error.

This patch removes the buggy error handling.  Which confines the mess when
device_rename hits a problem to sysfs, instead of propagating it the rest
of the network stack.  Making linux a little more robust.

Without this patch you can observe what happens when sysfs has a bug when
CONFIG_SYSFS_DEPRECATED is not set and you attempt to rename a real network
device to a name like (broken_parity_status, device, modalias, power,
resource2, subsystem_vendor, class, driver, irq, msi_bus, resource,
subsystem, uevent, config, enable, local_cpus, numa_node, resource0,
subsystem_device, vendor)

Greg has a patch that fixes the sysfs bugs but he doesn't trust it for a
2.6.21 timeframe.  This patch which just ignores errors should be safe and
it keeps the system from going completely wacky.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/dev.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff -puN net/core/dev.c~net-ignore-sysfs-network-device-rename-bugs net/core/dev.c
--- a/net/core/dev.c~net-ignore-sysfs-network-device-rename-bugs
+++ a/net/core/dev.c
@@ -752,13 +752,10 @@ int dev_change_name(struct net_device *d
 	else
 		strlcpy(dev->name, newname, IFNAMSIZ);
 
-	err = device_rename(&dev->dev, dev->name);
-	if (!err) {
-		hlist_del(&dev->name_hlist);
-		hlist_add_head(&dev->name_hlist, dev_name_hash(dev->name));
-		raw_notifier_call_chain(&netdev_chain,
-				NETDEV_CHANGENAME, dev);
-	}
+	device_rename(&dev->dev, dev->name);
+	hlist_del(&dev->name_hlist);
+	hlist_add_head(&dev->name_hlist, dev_name_hash(dev->name));
+	raw_notifier_call_chain(&netdev_chain, NETDEV_CHANGENAME, dev);
 
 	return err;
 }
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
powerpc-rtas-msi-support.patch
fix-i-oat-for-kexec.patch
fix-x86_64-mm-relocatable-kernel-support.patch
i386-irq-kill-irq-compression.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
allow-access-to-proc-pid-fd-after-setuid.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
fix-race-between-proc_get_inode-and-remove_proc_entry.patch
fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-reorder-struct-pid_dentry-to-save-space-on-64bit-archs-and-constify-them.patch
tty-remove-unnecessary-export-of-proc_clear_tty.patch
tty-simplify-calling-of-put_pid.patch
tty-introduce-no_tty-and-use-it-in-selinux.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix.patch
clean-up-elf-note-generation.patch
edac-k8-driver-coding-tidy.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-and-sid-of-init-process.patch
use-struct-pid-parameter-in-copy_process.patch
use-task_pgrp-task_session-in-copy_process.patch
kill-unused-sesssion-and-group-values-in-rocket-driver.patch
fix-some-coding-style-errors-in-autofs.patch
replace-pid_t-in-autofs-with-struct-pid-reference.patch
dont-init-pgrp-and-__session-in-init_signals.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

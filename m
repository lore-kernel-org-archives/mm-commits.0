From: akpm@osdl.org
Subject: - ipc-procfs-sysctl-mixups.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:53:03 -0800
Message-ID: <200612130653.kBD6r38T030479@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57511 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965002AbWLMGxe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:53:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     ipc-procfs-sysctl mixups
has been removed from the -mm tree.  Its filename was
     ipc-procfs-sysctl-mixups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ipc-procfs-sysctl mixups
From: Randy Dunlap <randy.dunlap@oracle.com>

When CONFIG_PROC_FS=n and CONFIG_PROC_SYSCTL=n but CONFIG_SYSVIPC=y, we get
this build error:

kernel/built-in.o:(.data+0xc38): undefined reference to `proc_ipc_doulongvec_minmax'
kernel/built-in.o:(.data+0xc88): undefined reference to `proc_ipc_doulongvec_minmax'
kernel/built-in.o:(.data+0xcd8): undefined reference to `proc_ipc_dointvec'
kernel/built-in.o:(.data+0xd28): undefined reference to `proc_ipc_dointvec'
kernel/built-in.o:(.data+0xd78): undefined reference to `proc_ipc_dointvec'
kernel/built-in.o:(.data+0xdc8): undefined reference to `proc_ipc_dointvec'
kernel/built-in.o:(.data+0xe18): undefined reference to `proc_ipc_dointvec'
make: *** [vmlinux] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sysctl.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN kernel/sysctl.c~ipc-procfs-sysctl-mixups kernel/sysctl.c
--- a/kernel/sysctl.c~ipc-procfs-sysctl-mixups
+++ a/kernel/sysctl.c
@@ -2408,6 +2408,17 @@ static int proc_do_ipc_string(ctl_table 
 {
 	return -ENOSYS;
 }
+static int proc_ipc_dointvec(ctl_table *table, int write, struct file *filp,
+		void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return -ENOSYS;
+}
+static int proc_ipc_doulongvec_minmax(ctl_table *table, int write,
+		struct file *filp, void __user *buffer,
+		size_t *lenp, loff_t *ppos)
+{
+	return -ENOSYS;
+}
 #endif
 
 int proc_dointvec(ctl_table *table, int write, struct file *filp,
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
fix-section-mismatch-in-parainstructions.patch
kconfig-new-function-bool-conf_get_changedvoid.patch
kconfig-make-sym_change_count-static-let-it-be-altered-by-2-functions-only.patch
kconfig-add-void-conf_set_changed_callbackvoid-fnvoid-use-it-in-qconfcc.patch
kconfig-set-gconfs-save-widgets-sensitivity-according-to-configs-changed-state.patch
isicom-fix-build-with-pci-disabled.patch
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-mtd.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
kbuild-make-fusion-mpt-selectable-from-device-drivers.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
profile_likely-export-do_check_likely.patch


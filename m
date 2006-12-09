From: akpm@osdl.org
Subject: + ipc-procfs-sysctl-mixups.patch added to -mm tree
Date: Sat, 09 Dec 2006 00:51:22 -0800
Message-ID: <200612090851.kB98pMeD021601@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57259 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936476AbWLIIv1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 9 Dec 2006 03:51:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     ipc-procfs-sysctl mixups
has been added to the -mm tree.  Its filename is
     ipc-procfs-sysctl-mixups.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
x86-smp-export-smp_num_siblings-for-oprofile.patch
ucb1400_ts-depends-snd_ac97_bus.patch
ipc-procfs-sysctl-mixups.patch
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-mtd.patch
mtd-esb2rom-uses-pci.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
codingstyle-updates.patch
freezerh-uses-task_struct-fields.patch
geode-crypto-is-pci-device.patch
ipmi-remove-zero-inits.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
profile_likely-export-do_check_likely.patch


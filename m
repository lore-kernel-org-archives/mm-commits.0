From: akpm@osdl.org
Subject: + sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables.patch added to -mm tree
Date: Tue, 23 Jan 2007 19:13:57 -0800
Message-ID: <200701240313.l0O3DvT5007000@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49264 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030214AbXAXDN7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 22:13:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com


The patch titled
     sysctl: remove the proc_dir_entry member for the sysctl tables
has been added to the -mm tree.  Its filename is
     sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl: remove the proc_dir_entry member for the sysctl tables
From: Eric W. Biederman <ebiederm@xmission.com>

It isn't needed anymore, all of the users are gone, and all of the ctl_table
initializers have been converted to use explicit names of the fields they are
initializing.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/sysctl.h |    1 -
 net/decnet/dn_dev.c    |    5 -----
 net/ipv4/devinet.c     |    5 -----
 net/ipv6/addrconf.c    |    5 -----
 4 files changed, 16 deletions(-)

diff -puN include/linux/sysctl.h~sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables
+++ a/include/linux/sysctl.h
@@ -1025,7 +1025,6 @@ struct ctl_table 
 	ctl_table *child;
 	proc_handler *proc_handler;	/* Callback for text formatting */
 	ctl_handler *strategy;		/* Callback function for all r/w */
-	struct proc_dir_entry *de;	/* /proc control block */
 	void *extra1;
 	void *extra2;
 };
diff -puN net/decnet/dn_dev.c~sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables net/decnet/dn_dev.c
--- a/net/decnet/dn_dev.c~sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables
+++ a/net/decnet/dn_dev.c
@@ -261,7 +261,6 @@ static void dn_dev_sysctl_register(struc
 	for(i = 0; i < ARRAY_SIZE(t->dn_dev_vars) - 1; i++) {
 		long offset = (long)t->dn_dev_vars[i].data;
 		t->dn_dev_vars[i].data = ((char *)parms) + offset;
-		t->dn_dev_vars[i].de = NULL;
 	}
 
 	if (dev) {
@@ -273,13 +272,9 @@ static void dn_dev_sysctl_register(struc
 	}
 
 	t->dn_dev_dev[0].child = t->dn_dev_vars;
-	t->dn_dev_dev[0].de = NULL;
 	t->dn_dev_conf_dir[0].child = t->dn_dev_dev;
-	t->dn_dev_conf_dir[0].de = NULL;
 	t->dn_dev_proto_dir[0].child = t->dn_dev_conf_dir;
-	t->dn_dev_proto_dir[0].de = NULL;
 	t->dn_dev_root_dir[0].child = t->dn_dev_proto_dir;
-	t->dn_dev_root_dir[0].de = NULL;
 	t->dn_dev_vars[0].extra1 = (void *)dev;
 
 	t->sysctl_header = register_sysctl_table(t->dn_dev_root_dir);
diff -puN net/ipv4/devinet.c~sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables net/ipv4/devinet.c
--- a/net/ipv4/devinet.c~sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables
+++ a/net/ipv4/devinet.c
@@ -1572,7 +1572,6 @@ static void devinet_sysctl_register(stru
 		return;
 	for (i = 0; i < ARRAY_SIZE(t->devinet_vars) - 1; i++) {
 		t->devinet_vars[i].data += (char *)p - (char *)&ipv4_devconf;
-		t->devinet_vars[i].de = NULL;
 	}
 
 	if (dev) {
@@ -1594,13 +1593,9 @@ static void devinet_sysctl_register(stru
 
 	t->devinet_dev[0].procname    = dev_name;
 	t->devinet_dev[0].child	      = t->devinet_vars;
-	t->devinet_dev[0].de	      = NULL;
 	t->devinet_conf_dir[0].child  = t->devinet_dev;
-	t->devinet_conf_dir[0].de     = NULL;
 	t->devinet_proto_dir[0].child = t->devinet_conf_dir;
-	t->devinet_proto_dir[0].de    = NULL;
 	t->devinet_root_dir[0].child  = t->devinet_proto_dir;
-	t->devinet_root_dir[0].de     = NULL;
 
 	t->sysctl_header = register_sysctl_table(t->devinet_root_dir);
 	if (!t->sysctl_header)
diff -puN net/ipv6/addrconf.c~sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables net/ipv6/addrconf.c
--- a/net/ipv6/addrconf.c~sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables
+++ a/net/ipv6/addrconf.c
@@ -3978,7 +3978,6 @@ static void addrconf_sysctl_register(str
 		return;
 	for (i=0; t->addrconf_vars[i].data; i++) {
 		t->addrconf_vars[i].data += (char*)p - (char*)&ipv6_devconf;
-		t->addrconf_vars[i].de = NULL;
 		t->addrconf_vars[i].extra1 = idev; /* embedded; no ref */
 	}
 	if (dev) {
@@ -4001,13 +4000,9 @@ static void addrconf_sysctl_register(str
 	t->addrconf_dev[0].procname = dev_name;
 
 	t->addrconf_dev[0].child = t->addrconf_vars;
-	t->addrconf_dev[0].de = NULL;
 	t->addrconf_conf_dir[0].child = t->addrconf_dev;
-	t->addrconf_conf_dir[0].de = NULL;
 	t->addrconf_proto_dir[0].child = t->addrconf_conf_dir;
-	t->addrconf_proto_dir[0].de = NULL;
 	t->addrconf_root_dir[0].child = t->addrconf_proto_dir;
-	t->addrconf_root_dir[0].de = NULL;
 
 	t->sysctl_header = register_sysctl_table(t->addrconf_root_dir);
 	if (t->sysctl_header == NULL)
_

Patches currently in -mm which might be from ebiederm@xmission.com are

kthread-api-conversion-for-dvb_frontend-and-av7110.patch
vt-refactor-console-sak-processing.patch
sysctl_ms_jiffies-fix-oldlen-semantics.patch
9p-use-kthread_stop-instead-of-sending-a-sigkill.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
kill_pid_info-kill-acquired_tasklist_lock.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
fix-rmmod-read-write-races-in-proc-entries.patch
tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch
i386-apic-clean-up-the-apic-code.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
dynticks-i386-prepare-nmi-watchdog.patch
edac-e752x-bit-mask-fix.patch
edac-e752x-byte-access-fix.patch
edac-k8-driver-coding-tidy.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
nsproxy-externalizes-exit_task_namespaces.patch
user-namespace-add-the-framework.patch
user-namespace-add-the-framework-fix.patch
user-ns-add-user_namespace-ptr-to-vfsmount.patch
user-ns-hook-permission.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix.patch
user-ns-implement-shared-mounts.patch
user_ns-handle-file-sigio.patch
user_ns-handle-file-sigio-fix.patch
user-ns-implement-user-ns-unshare.patch
user-ns-implement-user-ns-unshare-tidy.patch
user-ns-implement-user-ns-unshare-remove-config_user_ns.patch
remove-find_attach_pid.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
sysctl-x25-remove-unnecessary-insert_at_head-from-register_sysctl_table.patch
sysctl-move-ctl_sunrpc-to-sysctlh-where-it-belongs.patch
sysctl-sunrpc-remove-unnecessary-insert_at_head-flag.patch
sysctl-sunrpc-dont-unnecessarily-set-ctl_table-de.patch
sysctl-rose-remove-unnecessary-insert_at_head-flag.patch
sysctl-netrom-remove-unnecessary-insert_at_head-flag.patch
sysctl-llc-remove-unnecessary-insert_at_head-flag.patch
sysctl-ipx-remove-unnecessary-insert_at_head-flag.patch
sysctl-decnet-remove-unnecessary-insert_at_head-flag.patch
sysctl-dccp-remove-unnecessary-insert_at_head-flag.patch
sysctl-ax25-remove-unnecessary-insert_at_head-flag.patch
sysctl-atalk-remove-unnecessary-insert_at_head-flag.patch
sysctl-xfs-remove-unnecessary-insert_at_head-flag.patch
sysctl-c99-convert-xfs-ctl_tables.patch
sysctl-c99-convert-xfs-ctl_tables-fixes.patch
sysctl-scsi-remove-unnecessary-insert_at_head-flag.patch
sysctl-md-remove-unnecessary-insert_at_head-flag.patch
sysctl-mac_hid-remove-unnecessary-insert_at_head-flag.patch
sysctl-ipmi-remove-unnecessary-insert_at_head-flag.patch
sysctl-cdrom-remove-unnecessary-insert_at_head-flag.patch
sysctl-cdrom-dont-set-de-owner.patch
sysctl-move-ctl_pm-into-sysctlh-where-it-belongs.patch
sysctl-frv-pm-remove-unnecessary-insert_at_head-flag.patch
sysctl-move-ctl_frv-into-sysctlh-where-it-belongs.patch
sysctl-frv-remove-unnecessary-insert_at_head-flag.patch
sysctl-c99-convert-arch-frv-kernel-pmc.patch
sysctl-c99-convert-arch-frv-kernel-sysctlc.patch
sysctl-sn-remove-sysctl-abi-breakage.patch
sysctl-c99-convert-arch-ia64-sn-kernel-xpc_mainc.patch
sysctl-c99-convert-arch-ia64-kernel-perfmon-and-remove-abi-breakage.patch
sysctl-mips-au1000-remove-sys_sysctl-support.patch
sysctl-c99-convert-the-ctl_tables-in-arch-mips-au1000-common-powerc.patch
sysctl-c99-convert-arch-mips-lasat-sysctlc-and-remove-abi-breakage.patch
sysctl-s390-move-sysctl-definitions-to-sysctlh.patch
sysctl-s390-remove-unnecessary-use-of-insert_at_head.patch
sysctl-c99-convert-ctl_tables-in-arch-powerpc-kernel-idlec.patch
sysctl-c99-convert-ctl_tables-entries-in-arch-ppc-kernel-ppc_htabc.patch
sysctl-c99-convert-arch-sh64-kernel-trapsc-and-remove-abi-breakage.patch
sysctl-x86_64-remove-unnecessary-use-of-insert_at_head.patch
sysctl-c99-convert-ctl_tables-in-arch-x86_64-ia32-ia32_binfmtc.patch
sysctl-c99-convert-ctl_tables-in-arch-x86_64-kernel-vsyscallc.patch
sysctl-c99-convert-ctl_tables-in-arch-x86_64-mm-initc.patch
sysctl-remove-sys_sysctl-support-from-the-hpet-timer-driver.patch
sysctl-remove-sys_sysctl-support-from-drivers-char-rtcc.patch
sysctl-register-the-sysctl-number-used-by-the-arlan-driver.patch
sysctl-c99-convert-ctl_tables-in-drivers-parport-procfsc.patch
sysctl-c99-convert-coda-ctl_tables-and-remove-binary-sysctls.patch
sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support.patch
sysctl-register-the-ocfs2-sysctl-numbers.patch
sysctl-move-init_irq_proc-into-init-main-where-it-belongs.patch
sysctl-move-utsname-sysctls-to-their-own-file.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file.patch
sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry.patch
sysctl-remove-support-for-ctl_any.patch
sysctl-remove-support-for-directory-strategy-routines.patch
sysctl-remove-insert_at_head-from-register_sysctl.patch
sysctl-factor-out-sysctl_head_next-from-do_sysctl.patch
sysctl-allow-sysctl_perm-to-be-called-from-outside-of-sysctlc.patch
sysctl-reimplement-the-sysctl-proc-support.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

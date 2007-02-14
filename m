From: akpm@linux-foundation.org
Subject: - sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix.patch removed from -mm tree
Date: Tue, 13 Feb 2007 23:02:22 -0800
Message-ID: <200702140702.l1E72NvN023947@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44024 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932166AbXBNHC2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 02:02:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, jmorris@namei.org, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     sysctl selinux: Don't look at table->de
has been removed from the -mm tree.  Its filename was
     sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix.patch

This patch was dropped because it was folded into sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables.patch

------------------------------------------------------
Subject: sysctl selinux: Don't look at table->de
From: Eric W. Biederman <ebiederm@xmission.com>

With the sysctl cleanups sysctl is not really a part of proc it just shows
up there, and any path based approach will not adequately describe the data
as sysctl is essentially a union mount underneath the covers.  As designed
this mechanism is viewer dependent so trying to be path based gets even
worse.

However the permissions in sys_sysctl are currently immutable and going
through proc does not change the permission checks when accessing sysctl. 
So we might as well stick with the well defined sysctl sid, as that is what
selinux uses when proc is not compiled in.

I.e.  I see no hope for salvaging the selinux_proc_get_sid call in
selinux_sysctl so I'm removing it.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/selinux/hooks.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN security/selinux/hooks.c~sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix security/selinux/hooks.c
--- a/security/selinux/hooks.c~sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix
+++ a/security/selinux/hooks.c
@@ -1431,12 +1431,8 @@ static int selinux_sysctl(ctl_table *tab
 
 	tsec = current->security;
 
-	rc = selinux_proc_get_sid(table->de, (op == 001) ?
-	                          SECCLASS_DIR : SECCLASS_FILE, &tsid);
-	if (rc) {
-		/* Default to the well-defined sysctl SID. */
-		tsid = SECINITSID_SYSCTL;
-	}
+	/* Use the well-defined sysctl SID. */
+	tsid = SECINITSID_SYSCTL;
 
 	/* The op values are "defined" in sysctl.c, thereby creating
 	 * a bad coupling between this module and sysctl.c */
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
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
sysctl-move-utsname-sysctls-to-their-own-file-fix-2.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file.patch
sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry.patch
sysctl-remove-support-for-ctl_any.patch
sysctl-remove-support-for-directory-strategy-routines.patch
sysctl-remove-insert_at_head-from-register_sysctl.patch
sysctl-factor-out-sysctl_head_next-from-do_sysctl.patch
sysctl-allow-sysctl_perm-to-be-called-from-outside-of-sysctlc.patch
sysctl-reimplement-the-sysctl-proc-support.patch
sysctl-add-a-parent-entry-to-ctl_table-and-set-the-parent-entry.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix-2.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-ntfs-fix.patch
sysctl-fix-the-selinux_sysctl_get_sid.patch
selinux-enhance-selinux-to-always-ignore-private-inodes.patch
sysctl-hide-the-sysctl-proc-inodes-from-selinux.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

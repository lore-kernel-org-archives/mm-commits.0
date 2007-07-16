From: akpm@linux-foundation.org
Subject: - diskquota-32bit-quota-tools-on-64bit-architectures.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:57:14 -0700
Message-ID: <200707162057.l6GKvEJ7002168@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48655 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763754AbXGPVes (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:34:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vtaras@openvz.org, ak@suse.de, jack@ucw.cz, linux-arch@vger.kernel.org, michal.k.k.piotrowski@gmail.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     diskquota: 32bit quota tools on 64bit architectures
has been removed from the -mm tree.  Its filename was
     diskquota-32bit-quota-tools-on-64bit-architectures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: diskquota: 32bit quota tools on 64bit architectures
From: Vasily Tarasov <vtaras@openvz.org>

OpenVZ Linux kernel team has discovered the problem with 32bit quota tools
working on 64bit architectures.  In 2.6.10 kernel sys32_quotactl() function
was replaced by sys_quotactl() with the comment "sys_quotactl seems to be
32/64bit clean, enable it for 32bit" However this isn't right.  Look at
if_dqblk structure:

struct if_dqblk {
        __u64 dqb_bhardlimit;
        __u64 dqb_bsoftlimit;
        __u64 dqb_curspace;
        __u64 dqb_ihardlimit;
        __u64 dqb_isoftlimit;
        __u64 dqb_curinodes;
        __u64 dqb_btime;
        __u64 dqb_itime;
        __u32 dqb_valid;
};

For 32 bit quota tools sizeof(if_dqblk) == 0x44.
But for 64 bit kernel its size is 0x48, 'cause of alignment!
Thus we got a problem. Attached patch reintroduce sys32_quotactl() function,
that handles this and related situations.

[michal.k.k.piotrowski@gmail.com: build fix]
[akpm@linux-foundation.org: Make it link with CONFIG_QUOTA=n]
Signed-off-by: Vasily Tarasov <vtaras@openvz.org>
Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Jan Kara <jack@ucw.cz>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/ia32/ia32_entry.S  |    2 
 arch/x86_64/ia32/ia32entry.S |    2 
 fs/quota.c                   |  118 +++++++++++++++++++++++++++++++++
 kernel/sys_ni.c              |    1 
 4 files changed, 121 insertions(+), 2 deletions(-)

diff -puN arch/ia64/ia32/ia32_entry.S~diskquota-32bit-quota-tools-on-64bit-architectures arch/ia64/ia32/ia32_entry.S
--- a/arch/ia64/ia32/ia32_entry.S~diskquota-32bit-quota-tools-on-64bit-architectures
+++ a/arch/ia64/ia32/ia32_entry.S
@@ -304,7 +304,7 @@ ia32_syscall_table:
 	data8 sys_ni_syscall	/* init_module */
 	data8 sys_ni_syscall	/* delete_module */
 	data8 sys_ni_syscall	/* get_kernel_syms */  /* 130 */
-	data8 sys_quotactl
+	data8 sys32_quotactl
 	data8 sys_getpgid
 	data8 sys_fchdir
 	data8 sys_ni_syscall	/* sys_bdflush */
diff -puN arch/x86_64/ia32/ia32entry.S~diskquota-32bit-quota-tools-on-64bit-architectures arch/x86_64/ia32/ia32entry.S
--- a/arch/x86_64/ia32/ia32entry.S~diskquota-32bit-quota-tools-on-64bit-architectures
+++ a/arch/x86_64/ia32/ia32entry.S
@@ -526,7 +526,7 @@ ia32_sys_call_table:
 	.quad sys_init_module
 	.quad sys_delete_module
 	.quad quiet_ni_syscall		/* 130  get_kernel_syms */
-	.quad sys_quotactl
+	.quad sys32_quotactl
 	.quad sys_getpgid
 	.quad sys_fchdir
 	.quad quiet_ni_syscall	/* bdflush */
diff -puN fs/quota.c~diskquota-32bit-quota-tools-on-64bit-architectures fs/quota.c
--- a/fs/quota.c~diskquota-32bit-quota-tools-on-64bit-architectures
+++ a/fs/quota.c
@@ -10,12 +10,14 @@
 #include <linux/slab.h>
 #include <asm/current.h>
 #include <asm/uaccess.h>
+#include <linux/compat.h>
 #include <linux/kernel.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/buffer_head.h>
 #include <linux/capability.h>
 #include <linux/quotaops.h>
+#include <linux/types.h>
 
 /* Check validity of generic quotactl commands */
 static int generic_quotactl_valid(struct super_block *sb, int type, int cmd, qid_t id)
@@ -384,3 +386,119 @@ asmlinkage long sys_quotactl(unsigned in
 
 	return ret;
 }
+
+#if defined(CONFIG_X86_64) || defined(CONFIG_IA64)
+/*
+ * This code works only for 32 bit quota tools over 64 bit OS (x86_64, ia64)
+ * and is necessary due to alignment problems.
+ */
+struct compat_if_dqblk {
+	compat_u64 dqb_bhardlimit;
+	compat_u64 dqb_bsoftlimit;
+	compat_u64 dqb_curspace;
+	compat_u64 dqb_ihardlimit;
+	compat_u64 dqb_isoftlimit;
+	compat_u64 dqb_curinodes;
+	compat_u64 dqb_btime;
+	compat_u64 dqb_itime;
+	compat_uint_t dqb_valid;
+};
+
+/* XFS structures */
+struct compat_fs_qfilestat {
+	compat_u64 dqb_bhardlimit;
+	compat_u64 qfs_nblks;
+	compat_uint_t qfs_nextents;
+};
+
+struct compat_fs_quota_stat {
+	__s8		qs_version;
+	__u16		qs_flags;
+	__s8		qs_pad;
+	struct compat_fs_qfilestat	qs_uquota;
+	struct compat_fs_qfilestat	qs_gquota;
+	compat_uint_t	qs_incoredqs;
+	compat_int_t	qs_btimelimit;
+	compat_int_t	qs_itimelimit;
+	compat_int_t	qs_rtbtimelimit;
+	__u16		qs_bwarnlimit;
+	__u16		qs_iwarnlimit;
+};
+
+asmlinkage long sys32_quotactl(unsigned int cmd, const char __user *special,
+						qid_t id, void __user *addr)
+{
+	unsigned int cmds;
+	struct if_dqblk __user *dqblk;
+	struct compat_if_dqblk __user *compat_dqblk;
+	struct fs_quota_stat __user *fsqstat;
+	struct compat_fs_quota_stat __user *compat_fsqstat;
+	compat_uint_t data;
+	u16 xdata;
+	long ret;
+
+	cmds = cmd >> SUBCMDSHIFT;
+
+	switch (cmds) {
+	case Q_GETQUOTA:
+		dqblk = compat_alloc_user_space(sizeof(struct if_dqblk));
+		compat_dqblk = addr;
+		ret = sys_quotactl(cmd, special, id, dqblk);
+		if (ret)
+			break;
+		if (copy_in_user(compat_dqblk, dqblk, sizeof(*compat_dqblk)) ||
+			get_user(data, &dqblk->dqb_valid) ||
+			put_user(data, &compat_dqblk->dqb_valid))
+			ret = -EFAULT;
+		break;
+	case Q_SETQUOTA:
+		dqblk = compat_alloc_user_space(sizeof(struct if_dqblk));
+		compat_dqblk = addr;
+		ret = -EFAULT;
+		if (copy_in_user(dqblk, compat_dqblk, sizeof(*compat_dqblk)) ||
+			get_user(data, &compat_dqblk->dqb_valid) ||
+			put_user(data, &dqblk->dqb_valid))
+			break;
+		ret = sys_quotactl(cmd, special, id, dqblk);
+		break;
+	case Q_XGETQSTAT:
+		fsqstat = compat_alloc_user_space(sizeof(struct fs_quota_stat));
+		compat_fsqstat = addr;
+		ret = sys_quotactl(cmd, special, id, fsqstat);
+		if (ret)
+			break;
+		ret = -EFAULT;
+		/* Copying qs_version, qs_flags, qs_pad */
+		if (copy_in_user(compat_fsqstat, fsqstat,
+			offsetof(struct compat_fs_quota_stat, qs_uquota)))
+			break;
+		/* Copying qs_uquota */
+		if (copy_in_user(&compat_fsqstat->qs_uquota,
+			&fsqstat->qs_uquota,
+			sizeof(compat_fsqstat->qs_uquota)) ||
+			get_user(data, &fsqstat->qs_uquota.qfs_nextents) ||
+			put_user(data, &compat_fsqstat->qs_uquota.qfs_nextents))
+			break;
+		/* Copying qs_gquota */
+		if (copy_in_user(&compat_fsqstat->qs_gquota,
+			&fsqstat->qs_gquota,
+			sizeof(compat_fsqstat->qs_gquota)) ||
+			get_user(data, &fsqstat->qs_gquota.qfs_nextents) ||
+			put_user(data, &compat_fsqstat->qs_gquota.qfs_nextents))
+			break;
+		/* Copying the rest */
+		if (copy_in_user(&compat_fsqstat->qs_incoredqs,
+			&fsqstat->qs_incoredqs,
+			sizeof(struct compat_fs_quota_stat) -
+			offsetof(struct compat_fs_quota_stat, qs_incoredqs)) ||
+			get_user(xdata, &fsqstat->qs_iwarnlimit) ||
+			put_user(xdata, &compat_fsqstat->qs_iwarnlimit))
+			break;
+		ret = 0;
+		break;
+	default:
+		ret = sys_quotactl(cmd, special, id, addr);
+	}
+	return ret;
+}
+#endif
diff -puN kernel/sys_ni.c~diskquota-32bit-quota-tools-on-64bit-architectures kernel/sys_ni.c
--- a/kernel/sys_ni.c~diskquota-32bit-quota-tools-on-64bit-architectures
+++ a/kernel/sys_ni.c
@@ -14,6 +14,7 @@ asmlinkage long sys_ni_syscall(void)
 
 cond_syscall(sys_nfsservctl);
 cond_syscall(sys_quotactl);
+cond_syscall(sys32_quotactl);
 cond_syscall(sys_acct);
 cond_syscall(sys_lookup_dcookie);
 cond_syscall(sys_swapon);
_

Patches currently in -mm which might be from vtaras@openvz.org are

origin.patch

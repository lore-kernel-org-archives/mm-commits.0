Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AD99C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 29 Nov 2021 22:58:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235992AbhK2XBt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Nov 2021 18:01:49 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:40842 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236467AbhK2XA7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Nov 2021 18:00:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 80CA5CE16C5
        for <mm-commits@vger.kernel.org>; Mon, 29 Nov 2021 22:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E614C53FAD;
        Mon, 29 Nov 2021 22:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638226657;
        bh=DMYGWYvgep+4KewiZjOQsXhhjb+wT6NotLfoltihfJs=;
        h=Date:From:To:Subject:From;
        b=e6GuLpoxyh4NgOwyTCZEOU8ZchOHIyCjxmlBuXP44U6a5JciZ6IxGMeDAI614yY2b
         fS8ZfiFqtoDEkI/Y1SC8EyhaQUhqGZtd2kMXc7vRSDlzuHZaAUsD2QMGKIv11BDNLu
         dNDtC7cNKQUqjntTc2YfvEykb/4Rt1QBDf+jPGCI=
Date:   Mon, 29 Nov 2021 14:57:36 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, bfields@fieldses.org,
        crope@iki.fi, ebiederm@xmission.com, jlayton@kernel.org,
        keescook@chromium.org, kernel@tuxforce.de, mcgrof@kernel.org,
        mchehab@kernel.org, mm-commits@vger.kernel.org,
        nixiaoming@huawei.com, steve@sk2.org, viro@zeniv.linux.org.uk,
        yzaikin@google.com
Subject:  + fs-move-fs-execc-sysctls-into-its-own-file.patch added
 to -mm tree
Message-ID: <20211129225736.psQsaqnEK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: move fs/exec.c sysctls into its own file
has been added to the -mm tree.  Its filename is
     fs-move-fs-execc-sysctls-into-its-own-file.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-move-fs-execc-sysctls-into-its-own-file.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-move-fs-execc-sysctls-into-its-own-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: fs: move fs/exec.c sysctls into its own file

kernel/sysctl.c is a kitchen sink where everyone leaves their dirty
dishes, this makes it very difficult to maintain.

To help with this maintenance let's start by moving sysctls to places
where they actually belong.  The proc sysctl maintainers do not want to
know what sysctl knobs you wish to add for your own piece of code, we just
care about the core logic.

So move the fs/exec.c respective sysctls to its own file.

Since checkpatch complains about style issues with the old code, this move
also fixes a few of those minor style issues:

  * Use pr_warn() instead of prink(WARNING
  * New empty lines are wanted at the beginning of routines

Link: https://lkml.kernel.org/r/20211129205548.605569-9-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Lukas Middendorf <kernel@tuxforce.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Stephen Kitt <steve@sk2.org>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c       |   90 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sysctl.c |   66 ---------------------------------
 2 files changed, 90 insertions(+), 66 deletions(-)

--- a/fs/exec.c~fs-move-fs-execc-sysctls-into-its-own-file
+++ a/fs/exec.c
@@ -65,6 +65,7 @@
 #include <linux/vmalloc.h>
 #include <linux/io_uring.h>
 #include <linux/syscall_user_dispatch.h>
+#include <linux/coredump.h>
 
 #include <linux/uaccess.h>
 #include <asm/mmu_context.h>
@@ -2097,3 +2098,92 @@ COMPAT_SYSCALL_DEFINE5(execveat, int, fd
 				  argv, envp, flags);
 }
 #endif
+
+#ifdef CONFIG_SYSCTL
+
+static void validate_coredump_safety(void)
+{
+#ifdef CONFIG_COREDUMP
+	if (suid_dumpable == SUID_DUMP_ROOT &&
+	    core_pattern[0] != '/' && core_pattern[0] != '|') {
+		pr_warn(
+"Unsafe core_pattern used with fs.suid_dumpable=2.\n"
+"Pipe handler or fully qualified core dump path required.\n"
+"Set kernel.core_pattern before fs.suid_dumpable.\n"
+		);
+	}
+#endif
+}
+
+static int proc_dointvec_minmax_coredump(struct ctl_table *table, int write,
+		void *buffer, size_t *lenp, loff_t *ppos)
+{
+	int error = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+
+	if (!error)
+		validate_coredump_safety();
+	return error;
+}
+
+static struct ctl_table fs_exec_sysctls[] = {
+	{
+		.procname	= "suid_dumpable",
+		.data		= &suid_dumpable,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax_coredump,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_TWO,
+	},
+	{ }
+};
+
+#ifdef CONFIG_COREDUMP
+
+static int proc_dostring_coredump(struct ctl_table *table, int write,
+		  void *buffer, size_t *lenp, loff_t *ppos)
+{
+	int error = proc_dostring(table, write, buffer, lenp, ppos);
+
+	if (!error)
+		validate_coredump_safety();
+	return error;
+}
+
+static struct ctl_table kernel_exec_sysctls[] = {
+	{
+		.procname	= "core_uses_pid",
+		.data		= &core_uses_pid,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "core_pattern",
+		.data		= core_pattern,
+		.maxlen		= CORENAME_MAX_SIZE,
+		.mode		= 0644,
+		.proc_handler	= proc_dostring_coredump,
+	},
+	{
+		.procname	= "core_pipe_limit",
+		.data		= &core_pipe_limit,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{ }
+};
+#endif
+
+static int __init init_fs_exec_sysctls(void)
+{
+	register_sysctl_init("fs", fs_exec_sysctls);
+#ifdef CONFIG_COREDUMP
+	register_sysctl_init("kernel", kernel_exec_sysctls);
+#endif
+	return 0;
+}
+
+fs_initcall(init_fs_exec_sysctls);
+#endif /* CONFIG_SYSCTL */
--- a/kernel/sysctl.c~fs-move-fs-execc-sysctls-into-its-own-file
+++ a/kernel/sysctl.c
@@ -1116,40 +1116,6 @@ static int proc_dopipe_max_size(struct c
 				 do_proc_dopipe_max_size_conv, NULL);
 }
 
-static void validate_coredump_safety(void)
-{
-#ifdef CONFIG_COREDUMP
-	if (suid_dumpable == SUID_DUMP_ROOT &&
-	    core_pattern[0] != '/' && core_pattern[0] != '|') {
-		printk(KERN_WARNING
-"Unsafe core_pattern used with fs.suid_dumpable=2.\n"
-"Pipe handler or fully qualified core dump path required.\n"
-"Set kernel.core_pattern before fs.suid_dumpable.\n"
-		);
-	}
-#endif
-}
-
-static int proc_dointvec_minmax_coredump(struct ctl_table *table, int write,
-		void *buffer, size_t *lenp, loff_t *ppos)
-{
-	int error = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
-	if (!error)
-		validate_coredump_safety();
-	return error;
-}
-
-#ifdef CONFIG_COREDUMP
-static int proc_dostring_coredump(struct ctl_table *table, int write,
-		  void *buffer, size_t *lenp, loff_t *ppos)
-{
-	int error = proc_dostring(table, write, buffer, lenp, ppos);
-	if (!error)
-		validate_coredump_safety();
-	return error;
-}
-#endif
-
 #ifdef CONFIG_MAGIC_SYSRQ
 static int sysrq_sysctl_handler(struct ctl_table *table, int write,
 				void *buffer, size_t *lenp, loff_t *ppos)
@@ -1873,29 +1839,6 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
-#ifdef CONFIG_COREDUMP
-	{
-		.procname	= "core_uses_pid",
-		.data		= &core_uses_pid,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{
-		.procname	= "core_pattern",
-		.data		= core_pattern,
-		.maxlen		= CORENAME_MAX_SIZE,
-		.mode		= 0644,
-		.proc_handler	= proc_dostring_coredump,
-	},
-	{
-		.procname	= "core_pipe_limit",
-		.data		= &core_pipe_limit,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#endif
 #ifdef CONFIG_PROC_SYSCTL
 	{
 		.procname	= "tainted",
@@ -2897,15 +2840,6 @@ static struct ctl_table vm_table[] = {
 
 static struct ctl_table fs_table[] = {
 	{
-		.procname	= "suid_dumpable",
-		.data		= &suid_dumpable,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax_coredump,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_TWO,
-	},
-	{
 		.procname	= "pipe-max-size",
 		.data		= &pipe_max_size,
 		.maxlen		= sizeof(pipe_max_size),
_

Patches currently in -mm which might be from mcgrof@kernel.org are

zram-use-attribute_groups.patch
hpet-simplify-subdirectory-registration-with-register_sysctl.patch
i915-simplify-subdirectory-registration-with-register_sysctl.patch
macintosh-mac_hidc-simplify-subdirectory-registration-with-register_sysctl.patch
ocfs2-simplify-subdirectory-registration-with-register_sysctl.patch
test_sysctl-simplify-subdirectory-registration-with-register_sysctl.patch
inotify-simplify-subdirectory-registration-with-register_sysctl-fix.patch
cdrom-simplify-subdirectory-registration-with-register_sysctl.patch
sysctl-add-helper-to-register-a-sysctl-mount-point.patch
fs-move-binfmt_misc-sysctl-to-its-own-file.patch
sysctl-share-unsigned-long-const-values.patch
fs-move-inode-sysctls-to-its-own-file.patch
fs-move-fs-stat-sysctls-to-file_tablec.patch
fs-move-dcache-sysctls-to-its-own-file.patch
sysctl-move-maxolduid-as-a-sysctl-specific-const.patch
fs-move-shared-sysctls-to-fs-sysctlsc.patch
fs-move-locking-sysctls-where-they-are-used.patch
fs-move-namei-sysctls-to-its-own-file.patch
fs-move-fs-execc-sysctls-into-its-own-file.patch
fs-move-pipe-sysctls-to-is-own-file.patch
sysctl-add-and-use-base-directory-declarer-and-registration-helper.patch
fs-move-namespace-sysctls-and-declare-fs-base-directory.patch
kernel-sysctlc-rename-sysctl_init-to-sysctl_init_bases.patch


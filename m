Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03300C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbiAVGNU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:13:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54542 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbiAVGNU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:13:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 535D3B82100
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5ACC004E1;
        Sat, 22 Jan 2022 06:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642831998;
        bh=ycMa5mjB+o9zgGI18BGTWadO4aveXSHak/4HKltHygI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BkLyTq90m6Jf7TyZGNcCR1AEG/DD/qrPuBmJldmt8x7Q7aRTdG7uRYA4oqo2gxtVp
         tKsVDDglQsN8h3/ubqjbLsYHmG5YlvmEiMp88b6CFQZEnyzWpOz28qmbvdNtrGdG19
         dww8+v06aT4/ckyfQYs7rEVq3LmSCptw5mzJJt3I=
Date:   Fri, 21 Jan 2022 22:13:17 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        bfields@fieldses.org, crope@iki.fi, ebiederm@xmission.com,
        jlayton@kernel.org, keescook@chromium.org, kernel@tuxforce.de,
        linux-mm@kvack.org, mcgrof@kernel.org, mm-commits@vger.kernel.org,
        nixiaoming@huawei.com, steve@sk2.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        yzaikin@google.com
Subject:  [patch 34/69] fs: move fs/exec.c sysctls into its own
 file
Message-ID: <20220122061317.hs5eXJyH-%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -2099,3 +2100,92 @@ COMPAT_SYSCALL_DEFINE5(execveat, int, fd
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
@@ -1117,40 +1117,6 @@ static int proc_dopipe_max_size(struct c
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
@@ -1874,29 +1840,6 @@ static struct ctl_table kern_table[] = {
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
@@ -2898,15 +2841,6 @@ static struct ctl_table vm_table[] = {
 
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

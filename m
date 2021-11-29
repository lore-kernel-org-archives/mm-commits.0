Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34F4AC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 29 Nov 2021 23:13:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbhK2XQy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Nov 2021 18:16:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232260AbhK2XQj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Nov 2021 18:16:39 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66001C043AF3
        for <mm-commits@vger.kernel.org>; Mon, 29 Nov 2021 14:58:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7CCD4CE13DE
        for <mm-commits@vger.kernel.org>; Mon, 29 Nov 2021 22:57:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278D5C8D101;
        Mon, 29 Nov 2021 22:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638226677;
        bh=rkMlWLxzGQUTFa8rp2sq2DNSwDAh9Gw6c6EbWu911cU=;
        h=Date:From:To:Subject:From;
        b=l9SiW0fCC6N4HtQLI7RJ1hBBMqYy9yQSnBz2XlAZUjNWHYtFn/8E6Z8Ogu2+LElkc
         cfN45jKYRoGpWRTZE3xm2T0RG7LM6kME7bzk9iXif37m2qsvgDdCAP82+mweXMMfKQ
         MwdnSynNSuSCBx5J96dM/Ibq2bOK3JrMshvx2+LE=
Date:   Mon, 29 Nov 2021 14:57:56 -0800
From:   akpm@linux-foundation.org
To:     anil.s.keshavamurthy@intel.com, christian.brauner@ubuntu.com,
        crope@iki.fi, davem@davemloft.net, ebiederm@xmission.com,
        ebiggers@google.com, keescook@chromium.org, kernel@tuxforce.de,
        mcgrof@kernel.org, mchehab@kernel.org, mhiramat@kernel.org,
        mm-commits@vger.kernel.org, naveen.n.rao@linux.ibm.com,
        nixiaoming@huawei.com, steve@sk2.org, viro@zeniv.linux.org.uk,
        yzaikin@google.com
Subject:  +
 fs-coredump-move-coredump-sysctls-into-its-own-file.patch added to -mm tree
Message-ID: <20211129225756.weoMVjYno%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/coredump: move coredump sysctls into its own file
has been added to the -mm tree.  Its filename is
     fs-coredump-move-coredump-sysctls-into-its-own-file.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-coredump-move-coredump-sysctls-into-its-own-file.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-coredump-move-coredump-sysctls-into-its-own-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xiaoming Ni <nixiaoming@huawei.com>
Subject: fs/coredump: move coredump sysctls into its own file

This moves the fs/coredump.c respective sysctls to its own file.

Link: https://lkml.kernel.org/r/20211129211943.640266-6-mcgrof@kernel.org
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Lukas Middendorf <kernel@tuxforce.de>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Stephen Kitt <steve@sk2.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c            |   66 ++++++++++++++++++++++++++++++++++---
 fs/exec.c                |   55 ------------------------------
 include/linux/coredump.h |   10 +++--
 kernel/sysctl.c          |    2 -
 4 files changed, 67 insertions(+), 66 deletions(-)

--- a/fs/coredump.c~fs-coredump-move-coredump-sysctls-into-its-own-file
+++ a/fs/coredump.c
@@ -41,6 +41,7 @@
 #include <linux/fs.h>
 #include <linux/path.h>
 #include <linux/timekeeping.h>
+#include <linux/sysctl.h>
 
 #include <linux/uaccess.h>
 #include <asm/mmu_context.h>
@@ -52,9 +53,9 @@
 
 #include <trace/events/sched.h>
 
-int core_uses_pid;
-unsigned int core_pipe_limit;
-char core_pattern[CORENAME_MAX_SIZE] = "core";
+static int core_uses_pid;
+static unsigned int core_pipe_limit;
+static char core_pattern[CORENAME_MAX_SIZE] = "core";
 static int core_name_size = CORENAME_MAX_SIZE;
 
 struct core_name {
@@ -62,8 +63,6 @@ struct core_name {
 	int used, size;
 };
 
-/* The maximal length of core_pattern is also specified in sysctl.c */
-
 static int expand_corename(struct core_name *cn, int size)
 {
 	char *corename = krealloc(cn->corename, size, GFP_KERNEL);
@@ -895,6 +894,63 @@ int dump_align(struct coredump_params *c
 }
 EXPORT_SYMBOL(dump_align);
 
+#ifdef CONFIG_SYSCTL
+
+void validate_coredump_safety(void)
+{
+	if (suid_dumpable == SUID_DUMP_ROOT &&
+	    core_pattern[0] != '/' && core_pattern[0] != '|') {
+		pr_warn(
+"Unsafe core_pattern used with fs.suid_dumpable=2.\n"
+"Pipe handler or fully qualified core dump path required.\n"
+"Set kernel.core_pattern before fs.suid_dumpable.\n"
+		);
+	}
+}
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
+static struct ctl_table coredump_sysctls[] = {
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
+
+static int __init init_fs_coredump_sysctls(void)
+{
+	register_sysctl_init("kernel", coredump_sysctls);
+	return 0;
+}
+fs_initcall(init_fs_coredump_sysctls);
+#endif /* CONFIG_SYSCTL */
+
 /*
  * The purpose of always_dump_vma() is to make sure that special kernel mappings
  * that are useful for post-mortem analysis are included in every core dump.
--- a/fs/exec.c~fs-coredump-move-coredump-sysctls-into-its-own-file
+++ a/fs/exec.c
@@ -2101,20 +2101,6 @@ COMPAT_SYSCALL_DEFINE5(execveat, int, fd
 
 #ifdef CONFIG_SYSCTL
 
-static void validate_coredump_safety(void)
-{
-#ifdef CONFIG_COREDUMP
-	if (suid_dumpable == SUID_DUMP_ROOT &&
-	    core_pattern[0] != '/' && core_pattern[0] != '|') {
-		pr_warn(
-"Unsafe core_pattern used with fs.suid_dumpable=2.\n"
-"Pipe handler or fully qualified core dump path required.\n"
-"Set kernel.core_pattern before fs.suid_dumpable.\n"
-		);
-	}
-#endif
-}
-
 static int proc_dointvec_minmax_coredump(struct ctl_table *table, int write,
 		void *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -2138,50 +2124,9 @@ static struct ctl_table fs_exec_sysctls[
 	{ }
 };
 
-#ifdef CONFIG_COREDUMP
-
-static int proc_dostring_coredump(struct ctl_table *table, int write,
-		  void *buffer, size_t *lenp, loff_t *ppos)
-{
-	int error = proc_dostring(table, write, buffer, lenp, ppos);
-
-	if (!error)
-		validate_coredump_safety();
-	return error;
-}
-
-static struct ctl_table kernel_exec_sysctls[] = {
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
-	{ }
-};
-#endif
-
 static int __init init_fs_exec_sysctls(void)
 {
 	register_sysctl_init("fs", fs_exec_sysctls);
-#ifdef CONFIG_COREDUMP
-	register_sysctl_init("kernel", kernel_exec_sysctls);
-#endif
 	return 0;
 }
 
--- a/include/linux/coredump.h~fs-coredump-move-coredump-sysctls-into-its-own-file
+++ a/include/linux/coredump.h
@@ -14,10 +14,6 @@ struct core_vma_metadata {
 	unsigned long dump_size;
 };
 
-extern int core_uses_pid;
-extern char core_pattern[];
-extern unsigned int core_pipe_limit;
-
 /*
  * These are the only things you should do on a core-file: use only these
  * functions to write out all the necessary info.
@@ -37,4 +33,10 @@ extern void do_coredump(const kernel_sig
 static inline void do_coredump(const kernel_siginfo_t *siginfo) {}
 #endif
 
+#if defined(CONFIG_COREDUMP) && defined(CONFIG_SYSCTL)
+extern void validate_coredump_safety(void);
+#else
+static inline void validate_coredump_safety(void) {}
+#endif
+
 #endif /* _LINUX_COREDUMP_H */
--- a/kernel/sysctl.c~fs-coredump-move-coredump-sysctls-into-its-own-file
+++ a/kernel/sysctl.c
@@ -61,12 +61,10 @@
 #include <linux/capability.h>
 #include <linux/binfmts.h>
 #include <linux/sched/sysctl.h>
-#include <linux/sched/coredump.h>
 #include <linux/kexec.h>
 #include <linux/bpf.h>
 #include <linux/mount.h>
 #include <linux/userfaultfd_k.h>
-#include <linux/coredump.h>
 #include <linux/latencytop.h>
 #include <linux/pid.h>
 #include <linux/delayacct.h>
_

Patches currently in -mm which might be from nixiaoming@huawei.com are

sysctl-add-a-new-register_sysctl_init-interface.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals.patch
hung_task-move-hung_task-sysctl-interface-to-hung_taskc.patch
watchdog-move-watchdog-sysctl-interface-to-watchdogc.patch
sysctl-use-const-for-typically-used-max-min-proc-sysctls.patch
sysctl-use-sysctl_zero-to-replace-some-static-int-zero-uses.patch
aio-move-aio-sysctl-to-aioc.patch
dnotify-move-dnotify-sysctl-to-dnotifyc.patch
inotify-simplify-subdirectory-registration-with-register_sysctl.patch
eventpoll-simplify-sysctl-declaration-with-register_sysctl.patch
firmware_loader-move-firmware-sysctl-to-its-own-files.patch
random-move-the-random-sysctl-declarations-to-its-own-file.patch
printk-move-printk-sysctl-to-printk-sysctlc.patch
scsi-sg-move-sg-big-buff-sysctl-to-scsi-sgc.patch
stackleak-move-stack_erasing-sysctl-to-stackleakc.patch
printk-fix-build-warning-when-config_printk=n.patch
fs-coredump-move-coredump-sysctls-into-its-own-file.patch
kprobe-move-sysctl_kprobes_optimization-to-kprobesc.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61542C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbiAVGNq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:13:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54816 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiAVGNp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:13:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57FB4B8216D
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9B2C340E0;
        Sat, 22 Jan 2022 06:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642832023;
        bh=fuMXDSZZZ5FaNt+W+kUJF0YSQVGfph0MsO0V4LlCf3M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=d8VmMVNyHVATjU0m+rQqaEBSoYi4pn6TKwBdni+vccsTlajCWf7lIxBBBCnhfE3v1
         o32RYK7zetnvsyJ91ZP5/vmnujduDdBBgFyIAC+tfv21bJpnG9ZNfSNjkdHjlt6c8H
         Ud5bUdaRk/ZVTBlm4dnf1TQn9le4rFkqofLBbLq0=
Date:   Fri, 21 Jan 2022 22:13:41 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anil.s.keshavamurthy@intel.com,
        christian.brauner@ubuntu.com, crope@iki.fi, davem@davemloft.net,
        ebiederm@xmission.com, ebiggers@google.com, keescook@chromium.org,
        kernel@tuxforce.de, linux-mm@kvack.org, mcgrof@kernel.org,
        mhiramat@kernel.org, mm-commits@vger.kernel.org,
        naveen.n.rao@linux.ibm.com, nixiaoming@huawei.com, steve@sk2.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        yzaikin@google.com
Subject:  [patch 41/69] kprobe: move sysctl_kprobes_optimization to
 kprobes.c
Message-ID: <20220122061341.vCxA2m6Q2%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Xiaoming Ni <nixiaoming@huawei.com>
Subject: kprobe: move sysctl_kprobes_optimization to kprobes.c

kernel/sysctl.c is a kitchen sink where everyone leaves their dirty
dishes, this makes it very difficult to maintain.

To help with this maintenance let's start by moving sysctls to places
where they actually belong.  The proc sysctl maintainers do not want to
know what sysctl knobs you wish to add for your own piece of code, we just
care about the core logic.

Move sysctl_kprobes_optimization from kernel/sysctl.c to kernel/kprobes.c.
Use register_sysctl() to register the sysctl interface.

[mcgrof@kernel.org: fix compile issue when CONFIG_OPTPROBES is disabled]
Link: https://lkml.kernel.org/r/20211129211943.640266-7-mcgrof@kernel.org
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
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Stephen Kitt <steve@sk2.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kprobes.h |    6 ------
 kernel/kprobes.c        |   30 ++++++++++++++++++++++++++----
 kernel/sysctl.c         |   12 ------------
 3 files changed, 26 insertions(+), 22 deletions(-)

--- a/include/linux/kprobes.h~kprobe-move-sysctl_kprobes_optimization-to-kprobesc
+++ a/include/linux/kprobes.h
@@ -348,12 +348,6 @@ extern void opt_pre_handler(struct kprob
 
 DEFINE_INSN_CACHE_OPS(optinsn);
 
-#ifdef CONFIG_SYSCTL
-extern int sysctl_kprobes_optimization;
-extern int proc_kprobes_optimization_handler(struct ctl_table *table,
-					     int write, void *buffer,
-					     size_t *length, loff_t *ppos);
-#endif /* CONFIG_SYSCTL */
 extern void wait_for_kprobe_optimizer(void);
 #else /* !CONFIG_OPTPROBES */
 static inline void wait_for_kprobe_optimizer(void) { }
--- a/kernel/kprobes.c~kprobe-move-sysctl_kprobes_optimization-to-kprobesc
+++ a/kernel/kprobes.c
@@ -48,6 +48,9 @@
 #define KPROBE_HASH_BITS 6
 #define KPROBE_TABLE_SIZE (1 << KPROBE_HASH_BITS)
 
+#if !defined(CONFIG_OPTPROBES) || !defined(CONFIG_SYSCTL)
+#define kprobe_sysctls_init() do { } while (0)
+#endif
 
 static int kprobes_initialized;
 /* kprobe_table can be accessed by
@@ -938,10 +941,10 @@ static void unoptimize_all_kprobes(void)
 }
 
 static DEFINE_MUTEX(kprobe_sysctl_mutex);
-int sysctl_kprobes_optimization;
-int proc_kprobes_optimization_handler(struct ctl_table *table, int write,
-				      void *buffer, size_t *length,
-				      loff_t *ppos)
+static int sysctl_kprobes_optimization;
+static int proc_kprobes_optimization_handler(struct ctl_table *table,
+					     int write, void *buffer,
+					     size_t *length, loff_t *ppos)
 {
 	int ret;
 
@@ -957,6 +960,24 @@ int proc_kprobes_optimization_handler(st
 
 	return ret;
 }
+
+static struct ctl_table kprobe_sysctls[] = {
+	{
+		.procname	= "kprobes-optimization",
+		.data		= &sysctl_kprobes_optimization,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_kprobes_optimization_handler,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+	{}
+};
+
+static void __init kprobe_sysctls_init(void)
+{
+	register_sysctl_init("debug", kprobe_sysctls);
+}
 #endif /* CONFIG_SYSCTL */
 
 /* Put a breakpoint for a probe. */
@@ -2584,6 +2605,7 @@ static int __init init_kprobes(void)
 		err = register_module_notifier(&kprobe_module_nb);
 
 	kprobes_initialized = (err == 0);
+	kprobe_sysctls_init();
 	return err;
 }
 early_initcall(init_kprobes);
--- a/kernel/sysctl.c~kprobe-move-sysctl_kprobes_optimization-to-kprobesc
+++ a/kernel/sysctl.c
@@ -56,7 +56,6 @@
 #include <linux/reboot.h>
 #include <linux/ftrace.h>
 #include <linux/perf_event.h>
-#include <linux/kprobes.h>
 #include <linux/oom.h>
 #include <linux/kmod.h>
 #include <linux/capability.h>
@@ -2819,17 +2818,6 @@ static struct ctl_table debug_table[] =
 		.proc_handler	= proc_dointvec
 	},
 #endif
-#if defined(CONFIG_OPTPROBES)
-	{
-		.procname	= "kprobes-optimization",
-		.data		= &sysctl_kprobes_optimization,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_kprobes_optimization_handler,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-#endif
 	{ }
 };
 
_

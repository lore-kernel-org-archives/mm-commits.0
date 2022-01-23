Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 308D2C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 23 Jan 2022 23:56:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240498AbiAWX4n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 23 Jan 2022 18:56:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51674 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240496AbiAWX4n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 23 Jan 2022 18:56:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2F2A611F4
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 23:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73F5C340E3;
        Sun, 23 Jan 2022 23:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642982202;
        bh=wTNU1mrV/Jf7X+WM09MuXjoA7GElJcGIoxLvsRCTtKI=;
        h=Date:From:To:Subject:From;
        b=IgWhJXDYEhG8D7R1+rUqXAkEWyZILtszSrGiepgFXhjLNP/ZLH9aG+6R76vLte3m1
         wx2z3LUNxxgWyL4ysPPYez5SPViR8LD1uU/RpB/jIIczg6lkojBqK6jQ/uLFS1Sho8
         XQEZpUHexMjVvLYbgeNXADBlOClfwD8kbESvhxQU=
Date:   Sun, 23 Jan 2022 15:56:40 -0800
From:   akpm@linux-foundation.org
To:     airlied@linux.ie, amir73il@gmail.com,
        andriy.shevchenko@linux.intel.com, arnd@arndb.de, bcrl@kvack.org,
        benh@kernel.crashing.org, clemens@ladisch.de, crope@iki.fi,
        dgilbert@interlog.com, ebiederm@xmission.com,
        gregkh@linuxfoundation.org, jack@suse.cz, jani.nikula@intel.com,
        jani.nikula@linux.intel.com, jejb@linux.ibm.com,
        jlbec@evilplan.org, john.ogness@linutronix.de,
        joonas.lahtinen@linux.intel.com, joseph.qi@linux.alibaba.com,
        julia.lawall@inria.fr, keescook@chromium.org, kernel@tuxforce.de,
        mark@fasheh.com, martin.petersen@oracle.com, mcgrof@kernel.org,
        mm-commits@vger.kernel.org, nixiaoming@huawei.com,
        penguin-kernel@I-love.SAKURA.ne.jp, peterz@infradead.org,
        phil@philpotter.co.uk, pjt@google.com, pmladek@suse.com,
        rafael@kernel.org, rodrigo.vivi@intel.com, rostedt@goodmis.org,
        senozhatsky@chromium.org, sre@kernel.org, steve@sk2.org,
        surenb@google.com, tytso@mit.edu, viro@zeniv.linux.org.uk,
        wangqing@vivo.com, yzaikin@google.com
Subject:  [merged]
 printk-move-printk-sysctl-to-printk-sysctlc.patch removed from -mm tree
Message-ID: <20220123235640.FQUqe5R1t%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: printk: move printk sysctl to printk/sysctl.c
has been removed from the -mm tree.  Its filename was
     printk-move-printk-sysctl-to-printk-sysctlc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xiaoming Ni <nixiaoming@huawei.com>
Subject: printk: move printk sysctl to printk/sysctl.c

kernel/sysctl.c is a kitchen sink where everyone leaves their dirty
dishes, this makes it very difficult to maintain.

To help with this maintenance let's start by moving sysctls to places
where they actually belong.  The proc sysctl maintainers do not want to
know what sysctl knobs you wish to add for your own piece of code, we just
care about the core logic.

So move printk sysctl from kernel/sysctl.c to kernel/printk/sysctl.c.  Use
register_sysctl() to register the sysctl interface.

[mcgrof@kernel.org: fixed compile issues when PRINTK is not set, commit log update]
Link: https://lkml.kernel.org/r/20211124231435.1445213-6-mcgrof@kernel.org
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Kees Cook <keescook@chromium.org>
Cc: Lukas Middendorf <kernel@tuxforce.de>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Phillip Potter <phil@philpotter.co.uk>
Cc: Qing Wang <wangqing@vivo.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Stephen Kitt <steve@sk2.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/Makefile   |    5 +-
 kernel/printk/internal.h |    6 ++
 kernel/printk/printk.c   |    1 
 kernel/printk/sysctl.c   |   85 +++++++++++++++++++++++++++++++++++++
 kernel/sysctl.c          |   68 -----------------------------
 5 files changed, 96 insertions(+), 69 deletions(-)

--- a/kernel/printk/internal.h~printk-move-printk-sysctl-to-printk-sysctlc
+++ a/kernel/printk/internal.h
@@ -4,6 +4,12 @@
  */
 #include <linux/percpu.h>
 
+#if defined(CONFIG_PRINTK) && defined(CONFIG_SYSCTL)
+void __init printk_sysctl_init(void);
+#else
+#define printk_sysctl_init() do { } while (0)
+#endif
+
 #ifdef CONFIG_PRINTK
 
 /* Flags for a single printk record. */
--- a/kernel/printk/Makefile~printk-move-printk-sysctl-to-printk-sysctlc
+++ a/kernel/printk/Makefile
@@ -2,5 +2,8 @@
 obj-y	= printk.o
 obj-$(CONFIG_PRINTK)	+= printk_safe.o
 obj-$(CONFIG_A11Y_BRAILLE_CONSOLE)	+= braille.o
-obj-$(CONFIG_PRINTK)	+= printk_ringbuffer.o
 obj-$(CONFIG_PRINTK_INDEX)	+= index.o
+
+obj-$(CONFIG_PRINTK)                 += printk_support.o
+printk_support-y	             := printk_ringbuffer.o
+printk_support-$(CONFIG_SYSCTL)	     += sysctl.o
--- a/kernel/printk/printk.c~printk-move-printk-sysctl-to-printk-sysctlc
+++ a/kernel/printk/printk.c
@@ -3211,6 +3211,7 @@ static int __init printk_late_init(void)
 	ret = cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN, "printk:online",
 					console_cpu_notify, NULL);
 	WARN_ON(ret < 0);
+	printk_sysctl_init();
 	return 0;
 }
 late_initcall(printk_late_init);
--- /dev/null
+++ a/kernel/printk/sysctl.c
@@ -0,0 +1,85 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * sysctl.c: General linux system control interface
+ */
+
+#include <linux/sysctl.h>
+#include <linux/printk.h>
+#include <linux/capability.h>
+#include <linux/ratelimit.h>
+#include "internal.h"
+
+static const int ten_thousand = 10000;
+
+static int proc_dointvec_minmax_sysadmin(struct ctl_table *table, int write,
+				void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	if (write && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+}
+
+static struct ctl_table printk_sysctls[] = {
+	{
+		.procname	= "printk",
+		.data		= &console_loglevel,
+		.maxlen		= 4*sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "printk_ratelimit",
+		.data		= &printk_ratelimit_state.interval,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	{
+		.procname	= "printk_ratelimit_burst",
+		.data		= &printk_ratelimit_state.burst,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "printk_delay",
+		.data		= &printk_delay_msec,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= (void *)&ten_thousand,
+	},
+	{
+		.procname	= "printk_devkmsg",
+		.data		= devkmsg_log_str,
+		.maxlen		= DEVKMSG_STR_MAX_SIZE,
+		.mode		= 0644,
+		.proc_handler	= devkmsg_sysctl_set_loglvl,
+	},
+	{
+		.procname	= "dmesg_restrict",
+		.data		= &dmesg_restrict,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax_sysadmin,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+	{
+		.procname	= "kptr_restrict",
+		.data		= &kptr_restrict,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax_sysadmin,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_TWO,
+	},
+	{}
+};
+
+void __init printk_sysctl_init(void)
+{
+	register_sysctl_init("kernel", printk_sysctls);
+}
--- a/kernel/sysctl.c~printk-move-printk-sysctl-to-printk-sysctlc
+++ a/kernel/sysctl.c
@@ -908,17 +908,6 @@ static int proc_taint(struct ctl_table *
 	return err;
 }
 
-#ifdef CONFIG_PRINTK
-static int proc_dointvec_minmax_sysadmin(struct ctl_table *table, int write,
-				void *buffer, size_t *lenp, loff_t *ppos)
-{
-	if (write && !capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
-}
-#endif
-
 /**
  * struct do_proc_dointvec_minmax_conv_param - proc_dointvec_minmax() range checking structure
  * @min: pointer to minimum allowable value
@@ -2210,63 +2199,6 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
 	},
-#if defined CONFIG_PRINTK
-	{
-		.procname	= "printk",
-		.data		= &console_loglevel,
-		.maxlen		= 4*sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{
-		.procname	= "printk_ratelimit",
-		.data		= &printk_ratelimit_state.interval,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "printk_ratelimit_burst",
-		.data		= &printk_ratelimit_state.burst,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{
-		.procname	= "printk_delay",
-		.data		= &printk_delay_msec,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= (void *)&ten_thousand,
-	},
-	{
-		.procname	= "printk_devkmsg",
-		.data		= devkmsg_log_str,
-		.maxlen		= DEVKMSG_STR_MAX_SIZE,
-		.mode		= 0644,
-		.proc_handler	= devkmsg_sysctl_set_loglvl,
-	},
-	{
-		.procname	= "dmesg_restrict",
-		.data		= &dmesg_restrict,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax_sysadmin,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-	{
-		.procname	= "kptr_restrict",
-		.data		= &kptr_restrict,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax_sysadmin,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_TWO,
-	},
-#endif
 	{
 		.procname	= "ngroups_max",
 		.data		= (void *)&ngroups_max,
_

Patches currently in -mm which might be from nixiaoming@huawei.com are



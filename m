Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0C5BC433F5
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:12:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbiAVGMq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:12:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43332 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiAVGMq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:12:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3B6260FBA
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:12:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE34C340E0;
        Sat, 22 Jan 2022 06:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642831965;
        bh=OYN1Wgb8kNCN+RcY/yro1xDNk5h0kk6fmGQgyU10ahA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=RiiqtFUABIh3BWy+locPB44Nwq8DiMN/e61SlRkiavRErqf9Gi37yPYkA+BVPlIZ0
         BDNzuaY/J8p6fVV3zmhdnTOzqfEuorED1PctkL49STcZLO7BrHSUHtDddUDYZnptcb
         GxnumCyVgrp6USWUP6nyj2OLBhnA8oJ2pvyyBpOc=
Date:   Fri, 21 Jan 2022 22:12:43 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     airlied@linux.ie, akpm@linux-foundation.org, amir73il@gmail.com,
        andriy.shevchenko@linux.intel.com, arnd@arndb.de, bcrl@kvack.org,
        benh@kernel.crashing.org, clemens@ladisch.de, crope@iki.fi,
        dgilbert@interlog.com, ebiederm@xmission.com,
        gregkh@linuxfoundation.org, jack@suse.cz, jani.nikula@intel.com,
        jani.nikula@linux.intel.com, jejb@linux.ibm.com,
        jlbec@evilplan.org, john.ogness@linutronix.de,
        joonas.lahtinen@linux.intel.com, joseph.qi@linux.alibaba.com,
        julia.lawall@inria.fr, keescook@chromium.org, kernel@tuxforce.de,
        linux-mm@kvack.org, mark@fasheh.com, martin.petersen@oracle.com,
        mcgrof@kernel.org, mm-commits@vger.kernel.org,
        nixiaoming@huawei.com, penguin-kernel@I-love.SAKURA.ne.jp,
        peterz@infradead.org, phil@philpotter.co.uk, pjt@google.com,
        pmladek@suse.com, rafael@kernel.org, rodrigo.vivi@intel.com,
        rostedt@goodmis.org, senozhatsky@chromium.org, sre@kernel.org,
        steve@sk2.org, surenb@google.com, torvalds@linux-foundation.org,
        tytso@mit.edu, viro@zeniv.linux.org.uk, wangqing@vivo.com,
        yzaikin@google.com
Subject:  [patch 25/69] stackleak: move stack_erasing sysctl to
 stackleak.c
Message-ID: <20220122061243.4gktiIpir%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Xiaoming Ni <nixiaoming@huawei.com>
Subject: stackleak: move stack_erasing sysctl to stackleak.c

kernel/sysctl.c is a kitchen sink where everyone leaves their dirty
dishes, this makes it very difficult to maintain.

To help with this maintenance let's start by moving sysctls to places
where they actually belong.  The proc sysctl maintainers do not want to
know what sysctl knobs you wish to add for your own piece of code, we just
care about the core logic.

So move the stack_erasing sysctl from kernel/sysctl.c to
kernel/stackleak.c and use register_sysctl() to register the sysctl
interface.

[mcgrof@kernel.org: commit log update]
Link: https://lkml.kernel.org/r/20211124231435.1445213-8-mcgrof@kernel.org
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

 include/linux/stackleak.h |    5 -----
 kernel/stackleak.c        |   26 ++++++++++++++++++++++++--
 kernel/sysctl.c           |   14 --------------
 3 files changed, 24 insertions(+), 21 deletions(-)

--- a/include/linux/stackleak.h~stackleak-move-stack_erasing-sysctl-to-stackleakc
+++ a/include/linux/stackleak.h
@@ -23,11 +23,6 @@ static inline void stackleak_task_init(s
 # endif
 }
 
-#ifdef CONFIG_STACKLEAK_RUNTIME_DISABLE
-int stack_erasing_sysctl(struct ctl_table *table, int write,
-			void *buffer, size_t *lenp, loff_t *ppos);
-#endif
-
 #else /* !CONFIG_GCC_PLUGIN_STACKLEAK */
 static inline void stackleak_task_init(struct task_struct *t) { }
 #endif
--- a/kernel/stackleak.c~stackleak-move-stack_erasing-sysctl-to-stackleakc
+++ a/kernel/stackleak.c
@@ -16,11 +16,13 @@
 #ifdef CONFIG_STACKLEAK_RUNTIME_DISABLE
 #include <linux/jump_label.h>
 #include <linux/sysctl.h>
+#include <linux/init.h>
 
 static DEFINE_STATIC_KEY_FALSE(stack_erasing_bypass);
 
-int stack_erasing_sysctl(struct ctl_table *table, int write,
-			void *buffer, size_t *lenp, loff_t *ppos)
+#ifdef CONFIG_SYSCTL
+static int stack_erasing_sysctl(struct ctl_table *table, int write,
+			void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int ret = 0;
 	int state = !static_branch_unlikely(&stack_erasing_bypass);
@@ -42,6 +44,26 @@ int stack_erasing_sysctl(struct ctl_tabl
 					state ? "enabled" : "disabled");
 	return ret;
 }
+static struct ctl_table stackleak_sysctls[] = {
+	{
+		.procname	= "stack_erasing",
+		.data		= NULL,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= stack_erasing_sysctl,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+	{}
+};
+
+static int __init stackleak_sysctls_init(void)
+{
+	register_sysctl_init("kernel", stackleak_sysctls);
+	return 0;
+}
+late_initcall(stackleak_sysctls_init);
+#endif /* CONFIG_SYSCTL */
 
 #define skip_erasing()	static_branch_unlikely(&stack_erasing_bypass)
 #else
--- a/kernel/sysctl.c~stackleak-move-stack_erasing-sysctl-to-stackleakc
+++ a/kernel/sysctl.c
@@ -95,9 +95,6 @@
 #if defined(CONFIG_PROVE_LOCKING) || defined(CONFIG_LOCK_STAT)
 #include <linux/lockdep.h>
 #endif
-#ifdef CONFIG_STACKLEAK_RUNTIME_DISABLE
-#include <linux/stackleak.h>
-#endif
 
 #if defined(CONFIG_SYSCTL)
 
@@ -2443,17 +2440,6 @@ static struct ctl_table kern_table[] = {
 		.extra2		= SYSCTL_INT_MAX,
 	},
 #endif
-#ifdef CONFIG_STACKLEAK_RUNTIME_DISABLE
-	{
-		.procname	= "stack_erasing",
-		.data		= NULL,
-		.maxlen		= sizeof(int),
-		.mode		= 0600,
-		.proc_handler	= stack_erasing_sysctl,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-#endif
 	{ }
 };
 
_

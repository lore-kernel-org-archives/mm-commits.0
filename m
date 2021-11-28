Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E1C2C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 28 Nov 2021 01:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344682AbhK1BKS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Nov 2021 20:10:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346836AbhK1BIS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Nov 2021 20:08:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4853FC061748
        for <mm-commits@vger.kernel.org>; Sat, 27 Nov 2021 17:05:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1E3E60F57
        for <mm-commits@vger.kernel.org>; Sun, 28 Nov 2021 01:05:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9321C53FAD;
        Sun, 28 Nov 2021 01:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638061502;
        bh=vq/npTlGz0qC9+WTfdJDRnqAig+U+U3yi4XFlK3q+c0=;
        h=Date:From:To:Subject:From;
        b=yVJ6O4YcnMYMAWi6DTW7B7fEJa3wJ1PNn5ltsIb2i3Y+klJXf5hVyoYFIdU8BCQ7t
         hHsE4lGXbr9VnL4NwyEPZniahmsz98W81G8Y7gMj2i2RK66xZVtb61YEmbN9f5hGeU
         DfH1IzIGwhKvI5A+pBQ+4gkij9rie0+AyFRbeLi4=
Date:   Sat, 27 Nov 2021 17:05:00 -0800
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
        mchehab@kernel.org, mm-commits@vger.kernel.org,
        nixiaoming@huawei.com, penguin-kernel@I-love.SAKURA.ne.jp,
        peterz@infradead.org, phil@philpotter.co.uk, pjt@google.com,
        pmladek@suse.com, rafael@kernel.org, rodrigo.vivi@intel.com,
        rostedt@goodmis.org, senozhatsky@chromium.org, sre@kernel.org,
        steve@sk2.org, surenb@google.com, tytso@mit.edu,
        viro@zeniv.linux.org.uk, wangqing@vivo.com, yzaikin@google.com
Subject:  + stackleak-move-stack_erasing-sysctl-to-stackleakc.patch
 added to -mm tree
Message-ID: <20211128010500.cXBEzgxcr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: stackleak: move stack_erasing sysctl to stackleak.c
has been added to the -mm tree.  Its filename is
     stackleak-move-stack_erasing-sysctl-to-stackleakc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/stackleak-move-stack_erasing-sysctl-to-stackleakc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/stackleak-move-stack_erasing-sysctl-to-stackleakc.patch

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
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
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
@@ -94,9 +94,6 @@
 #if defined(CONFIG_PROVE_LOCKING) || defined(CONFIG_LOCK_STAT)
 #include <linux/lockdep.h>
 #endif
-#ifdef CONFIG_STACKLEAK_RUNTIME_DISABLE
-#include <linux/stackleak.h>
-#endif
 
 #if defined(CONFIG_SYSCTL)
 
@@ -2442,17 +2439,6 @@ static struct ctl_table kern_table[] = {
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


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5A6FC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 23 Jan 2022 23:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240466AbiAWXzd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 23 Jan 2022 18:55:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44642 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbiAWXzd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 23 Jan 2022 18:55:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD882B80E48
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 23:55:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37ADCC340E3;
        Sun, 23 Jan 2022 23:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642982130;
        bh=Py1gxviOVyaonXYvpYJ7sgnm6NPKci3XYKZqJlo+RCw=;
        h=Date:From:To:Subject:From;
        b=ZQIZ6PaxrPOmLWWzBMiB3cN/kZ5os2NoMuY0MXf6oiWqz0mx0uWTsraWYeD3GHd2p
         jlcsCISvfQAiR/qZG4glhTMdnuXZqptM3vU4Zirkc92qsZASFgFhXpKzjfqr/xSAFS
         w0Zf4WUWTbZsDPod8i5s1eDxVIDtzayXp4T8ngL0=
Date:   Sun, 23 Jan 2022 15:55:28 -0800
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
 watchdog-move-watchdog-sysctl-interface-to-watchdogc.patch removed from -mm
 tree
Message-ID: <20220123235528.1A-jio69-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: move watchdog sysctl interface to watchdog.c
has been removed from the -mm tree.  Its filename was
     watchdog-move-watchdog-sysctl-interface-to-watchdogc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xiaoming Ni <nixiaoming@huawei.com>
Subject: watchdog: move watchdog sysctl interface to watchdog.c

The kernel/sysctl.c is a kitchen sink where everyone leaves their dirty
dishes, this makes it very difficult to maintain.

To help with this maintenance let's start by moving sysctls to places
where they actually belong.  The proc sysctl maintainers do not want to
know what sysctl knobs you wish to add for your own piece of code, we just
care about the core logic of proc sysctl.

So, move the watchdog syscl interface to watchdog.c.  Use
register_sysctl() to register the sysctl interface to avoid merge
conflicts when different features modify sysctl.c at the same time.

[mcgrof@kernel.org: justify the move on the commit log]
Link: https://lkml.kernel.org/r/20211123202347.818157-5-mcgrof@kernel.org
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qing Wang <wangqing@vivo.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Stephen Kitt <steve@sk2.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Lukas Middendorf <kernel@tuxforce.de>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Phillip Potter <phil@philpotter.co.uk>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c   |   96 -----------------------------------------
 kernel/watchdog.c |  101 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 101 insertions(+), 96 deletions(-)

--- a/kernel/sysctl.c~watchdog-move-watchdog-sysctl-interface-to-watchdogc
+++ a/kernel/sysctl.c
@@ -103,16 +103,10 @@
 #ifdef CONFIG_STACKLEAK_RUNTIME_DISABLE
 #include <linux/stackleak.h>
 #endif
-#ifdef CONFIG_LOCKUP_DETECTOR
-#include <linux/nmi.h>
-#endif
 
 #if defined(CONFIG_SYSCTL)
 
 /* Constants used for minimum and  maximum */
-#ifdef CONFIG_LOCKUP_DETECTOR
-static int sixty = 60;
-#endif
 
 static unsigned long zero_ul;
 static unsigned long one_ul = 1;
@@ -2309,96 +2303,6 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0444,
 		.proc_handler	= proc_dointvec,
 	},
-#if defined(CONFIG_LOCKUP_DETECTOR)
-	{
-		.procname       = "watchdog",
-		.data		= &watchdog_user_enabled,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler   = proc_watchdog,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-	{
-		.procname	= "watchdog_thresh",
-		.data		= &watchdog_thresh,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_watchdog_thresh,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= &sixty,
-	},
-	{
-		.procname       = "nmi_watchdog",
-		.data		= &nmi_watchdog_user_enabled,
-		.maxlen		= sizeof(int),
-		.mode		= NMI_WATCHDOG_SYSCTL_PERM,
-		.proc_handler   = proc_nmi_watchdog,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-	{
-		.procname	= "watchdog_cpumask",
-		.data		= &watchdog_cpumask_bits,
-		.maxlen		= NR_CPUS,
-		.mode		= 0644,
-		.proc_handler	= proc_watchdog_cpumask,
-	},
-#ifdef CONFIG_SOFTLOCKUP_DETECTOR
-	{
-		.procname       = "soft_watchdog",
-		.data		= &soft_watchdog_user_enabled,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler   = proc_soft_watchdog,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-	{
-		.procname	= "softlockup_panic",
-		.data		= &softlockup_panic,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-#ifdef CONFIG_SMP
-	{
-		.procname	= "softlockup_all_cpu_backtrace",
-		.data		= &sysctl_softlockup_all_cpu_backtrace,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-#endif /* CONFIG_SMP */
-#endif
-#ifdef CONFIG_HARDLOCKUP_DETECTOR
-	{
-		.procname	= "hardlockup_panic",
-		.data		= &hardlockup_panic,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-#ifdef CONFIG_SMP
-	{
-		.procname	= "hardlockup_all_cpu_backtrace",
-		.data		= &sysctl_hardlockup_all_cpu_backtrace,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-#endif /* CONFIG_SMP */
-#endif
-#endif
-
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)
 	{
 		.procname       = "unknown_nmi_panic",
--- a/kernel/watchdog.c~watchdog-move-watchdog-sysctl-interface-to-watchdogc
+++ a/kernel/watchdog.c
@@ -740,6 +740,106 @@ int proc_watchdog_cpumask(struct ctl_tab
 	mutex_unlock(&watchdog_mutex);
 	return err;
 }
+
+static const int sixty = 60;
+
+static struct ctl_table watchdog_sysctls[] = {
+	{
+		.procname       = "watchdog",
+		.data		= &watchdog_user_enabled,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler   = proc_watchdog,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+	{
+		.procname	= "watchdog_thresh",
+		.data		= &watchdog_thresh,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_watchdog_thresh,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= (void *)&sixty,
+	},
+	{
+		.procname       = "nmi_watchdog",
+		.data		= &nmi_watchdog_user_enabled,
+		.maxlen		= sizeof(int),
+		.mode		= NMI_WATCHDOG_SYSCTL_PERM,
+		.proc_handler   = proc_nmi_watchdog,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+	{
+		.procname	= "watchdog_cpumask",
+		.data		= &watchdog_cpumask_bits,
+		.maxlen		= NR_CPUS,
+		.mode		= 0644,
+		.proc_handler	= proc_watchdog_cpumask,
+	},
+#ifdef CONFIG_SOFTLOCKUP_DETECTOR
+	{
+		.procname       = "soft_watchdog",
+		.data		= &soft_watchdog_user_enabled,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler   = proc_soft_watchdog,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+	{
+		.procname	= "softlockup_panic",
+		.data		= &softlockup_panic,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#ifdef CONFIG_SMP
+	{
+		.procname	= "softlockup_all_cpu_backtrace",
+		.data		= &sysctl_softlockup_all_cpu_backtrace,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#endif /* CONFIG_SMP */
+#endif
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
+	{
+		.procname	= "hardlockup_panic",
+		.data		= &hardlockup_panic,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#ifdef CONFIG_SMP
+	{
+		.procname	= "hardlockup_all_cpu_backtrace",
+		.data		= &sysctl_hardlockup_all_cpu_backtrace,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#endif /* CONFIG_SMP */
+#endif
+	{}
+};
+
+static void __init watchdog_sysctl_init(void)
+{
+	register_sysctl_init("kernel", watchdog_sysctls);
+}
+#else
+#define watchdog_sysctl_init() do { } while (0)
 #endif /* CONFIG_SYSCTL */
 
 void __init lockup_detector_init(void)
@@ -753,4 +853,5 @@ void __init lockup_detector_init(void)
 	if (!watchdog_nmi_probe())
 		nmi_watchdog_available = true;
 	lockup_detector_setup();
+	watchdog_sysctl_init();
 }
_

Patches currently in -mm which might be from nixiaoming@huawei.com are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 151B4C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 15 Feb 2022 22:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243613AbiBOWEs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Feb 2022 17:04:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240547AbiBOWEp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Feb 2022 17:04:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38531EEC0
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 14:04:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FF956194B
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 22:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84A5C340EB;
        Tue, 15 Feb 2022 22:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644962673;
        bh=6IOjjIBxGR+WADKl8A86qsx6CxTVlBL1gNRIfTt45c0=;
        h=Date:To:From:Subject:From;
        b=PUPeU8Evco/xJa9Um6ZwX6zDlUFmh/08KLaBN99xgVVreBF4xKNxVz476N3KoQ0P9
         Gdyd3daWtpQHxNrezVwkzb/KuwJvstvCuAsRXudw1y//UR/5AW7DyE9tiO9Q4sMoD5
         i//P/LwK0n+KUwI4H2Zpapa8klIQy1tZ2/3qPUxc=
Date:   Tue, 15 Feb 2022 14:04:33 -0800
To:     mm-commits@vger.kernel.org, yzaikin@google.com, mhocko@suse.com,
        keescook@chromium.org, sujiaxun@uniontech.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-oom_kill-sysctls-to-their-own-file.patch added to -mm tree
Message-Id: <20220215220433.A84A5C340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move oom_kill sysctls to their own file
has been added to the -mm tree.  Its filename is
     mm-move-oom_kill-sysctls-to-their-own-file.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-move-oom_kill-sysctls-to-their-own-file.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-move-oom_kill-sysctls-to-their-own-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: sujiaxun <sujiaxun@uniontech.com>
Subject: mm: move oom_kill sysctls to their own file

kernel/sysctl.c is a kitchen sink where everyone leaves their dirty
dishes, this makes it very difficult to maintain.

To help with this maintenance let's start by moving sysctls to places
where they actually belong.  The proc sysctl maintainers do not want to
know what sysctl knobs you wish to add for your own piece of code, we just
care about the core logic.

So move the oom_kill sysctls to their own file, mm/oom_kill.c

Link: https://lkml.kernel.org/r/20220215093203.31032-1-sujiaxun@uniontech.com
Signed-off-by: sujiaxun <sujiaxun@uniontech.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |    4 ----
 kernel/sysctl.c     |   23 -----------------------
 mm/oom_kill.c       |   37 ++++++++++++++++++++++++++++++++++---
 3 files changed, 34 insertions(+), 30 deletions(-)

--- a/include/linux/oom.h~mm-move-oom_kill-sysctls-to-their-own-file
+++ a/include/linux/oom.h
@@ -123,8 +123,4 @@ extern void oom_killer_enable(void);
 
 extern struct task_struct *find_lock_task_mm(struct task_struct *p);
 
-/* sysctls */
-extern int sysctl_oom_dump_tasks;
-extern int sysctl_oom_kill_allocating_task;
-extern int sysctl_panic_on_oom;
 #endif /* _INCLUDE_LINUX_OOM_H */
--- a/kernel/sysctl.c~mm-move-oom_kill-sysctls-to-their-own-file
+++ a/kernel/sysctl.c
@@ -2355,29 +2355,6 @@ static struct ctl_table vm_table[] = {
 		.extra2		= SYSCTL_TWO,
 	},
 	{
-		.procname	= "panic_on_oom",
-		.data		= &sysctl_panic_on_oom,
-		.maxlen		= sizeof(sysctl_panic_on_oom),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_TWO,
-	},
-	{
-		.procname	= "oom_kill_allocating_task",
-		.data		= &sysctl_oom_kill_allocating_task,
-		.maxlen		= sizeof(sysctl_oom_kill_allocating_task),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{
-		.procname	= "oom_dump_tasks",
-		.data		= &sysctl_oom_dump_tasks,
-		.maxlen		= sizeof(sysctl_oom_dump_tasks),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{
 		.procname	= "overcommit_ratio",
 		.data		= &sysctl_overcommit_ratio,
 		.maxlen		= sizeof(sysctl_overcommit_ratio),
--- a/mm/oom_kill.c~mm-move-oom_kill-sysctls-to-their-own-file
+++ a/mm/oom_kill.c
@@ -52,9 +52,37 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/oom.h>
 
-int sysctl_panic_on_oom;
-int sysctl_oom_kill_allocating_task;
-int sysctl_oom_dump_tasks = 1;
+static int sysctl_panic_on_oom;
+static int sysctl_oom_kill_allocating_task;
+static int sysctl_oom_dump_tasks = 1;
+
+#ifdef CONFIG_SYSCTL
+static struct ctl_table vm_oom_kill_table[] = {
+	{
+		.procname	= "panic_on_oom",
+		.data		= &sysctl_panic_on_oom,
+		.maxlen		= sizeof(sysctl_panic_on_oom),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_TWO,
+	},
+	{
+		.procname	= "oom_kill_allocating_task",
+		.data		= &sysctl_oom_kill_allocating_task,
+		.maxlen		= sizeof(sysctl_oom_kill_allocating_task),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "oom_dump_tasks",
+		.data		= &sysctl_oom_dump_tasks,
+		.maxlen		= sizeof(sysctl_oom_dump_tasks),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	}
+};
+#endif
 
 /*
  * Serializes oom killer invocations (out_of_memory()) from all contexts to
@@ -680,6 +708,9 @@ static void wake_oom_reaper(struct task_
 static int __init oom_init(void)
 {
 	oom_reaper_th = kthread_run(oom_reaper, NULL, "oom_reaper");
+#ifdef CONFIG_SYSCTL
+	register_sysctl_init("vm", vm_oom_kill_table);
+#endif
 	return 0;
 }
 subsys_initcall(oom_init)
_

Patches currently in -mm which might be from sujiaxun@uniontech.com are

mm-move-oom_kill-sysctls-to-their-own-file.patch


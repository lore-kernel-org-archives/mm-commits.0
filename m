Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66179C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 22:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbiB1WSB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 17:18:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbiB1WR7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 17:17:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4E012F425
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 14:17:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D414A61309
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 22:17:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3210DC340F1;
        Mon, 28 Feb 2022 22:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646086638;
        bh=qkWnfG0+6XfFt5D/apcnd45EIb86G0FTMbl5BhbEdEI=;
        h=Date:To:From:Subject:From;
        b=g8Q1xIaeP+u4wz6Uz/ud4AeS057JByMpDEQ5CFfV+5p8saqsI/KghARmHKEuKWV0U
         QtmBCIx4ZUZmjjAGuEuTN3UCUeBxd1BjmmLSkTQSjdQi6IRM7a7qK1pb9wP5Czo7Iz
         Jl24IbStDdBfbx6R35eqx+//6dKaiADYaXh14eL0=
Date:   Mon, 28 Feb 2022 14:17:17 -0800
To:     mm-commits@vger.kernel.org, mcgrof@kernel.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch added to -mm tree
Message-Id: <20220228221718.3210DC340F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill.c: fix vm_oom_kill_table[] ifdeffery
has been added to the -mm tree.  Its filename is
     mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/oom_kill.c: fix vm_oom_kill_table[] ifdeffery

arm allnoconfig:

mm/oom_kill.c:60:25: warning: 'vm_oom_kill_table' defined but not used [-Wunused-variable]
   60 | static struct ctl_table vm_oom_kill_table[] = {
      |                         ^~~~~~~~~~~~~~~~~

Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   58 ++++++++++++++++++++++++------------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

--- a/mm/oom_kill.c~mm-oom_killc-fix-vm_oom_kill_table-ifdeffery
+++ a/mm/oom_kill.c
@@ -56,35 +56,6 @@ static int sysctl_panic_on_oom;
 static int sysctl_oom_kill_allocating_task;
 static int sysctl_oom_dump_tasks = 1;
 
-#ifdef CONFIG_SYSCTL
-static struct ctl_table vm_oom_kill_table[] = {
-	{
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
-	{}
-};
-#endif
-
 /*
  * Serializes oom killer invocations (out_of_memory()) from all contexts to
  * prevent from over eager oom killing (e.g. when the oom killer is invoked
@@ -703,6 +674,35 @@ static void wake_oom_reaper(struct task_
 	wake_up(&oom_reaper_wait);
 }
 
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
+	},
+	{}
+};
+#endif
+
 static int __init oom_init(void)
 {
 	oom_reaper_th = kthread_run(oom_reaper, NULL, "oom_reaper");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-list_lru-replace-linear-array-with-xarray-fix.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
mm-export-pageheadhuge-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-next-rejects.patch
drivers-gpu-drm-dp-drm_dpc-fix-build.patch
arch-x86-kernel-resourcec-needs-spinlockh.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch


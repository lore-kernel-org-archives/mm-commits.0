Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 738B3C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  7 Mar 2022 23:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233796AbiCHAAr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Mar 2022 19:00:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243949AbiCHAAp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2022 19:00:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A1F33EB3
        for <mm-commits@vger.kernel.org>; Mon,  7 Mar 2022 15:59:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B76EE61280
        for <mm-commits@vger.kernel.org>; Mon,  7 Mar 2022 23:59:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB5DC340E9;
        Mon,  7 Mar 2022 23:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646697589;
        bh=L6Co0XO847rHNEtYyMICGP+mMsiWRst0NOIbBXR3NOs=;
        h=Date:To:From:Subject:From;
        b=HkVLPeLyhKg7Hc23iRxlcRCLJfY3r+OREmbH5r6oTRTSiw/F2kjFEzT+k8rH+k3vE
         yYi6obHQgMSmzrEqDtXLef8qfbJqt/BSQ3AiNvgBqapSg78WryrzAtuD8ivY0lmcXu
         koD62IVv1CAUSbDno7FhbPvRt2TOqhU8dwRRcwQE=
Date:   Mon, 07 Mar 2022 15:59:48 -0800
To:     mm-commits@vger.kernel.org, mcgrof@kernel.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch added to -mm tree
Message-Id: <20220307235949.1AB5DC340E9@smtp.kernel.org>
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

memcg-sync-flush-only-if-periodic-flush-is-delayed-fix.patch
remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-list_lru-replace-linear-array-with-xarray-fix.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
mm-export-pageheadhuge-fix.patch
userfaultfd-provide-unmasked-address-on-page-fault-v3-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
taskstats-remove-unneeded-dead-assignment-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
arch-x86-kernel-resourcec-needs-spinlockh.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch


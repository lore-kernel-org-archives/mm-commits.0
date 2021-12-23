Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBBD8C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 23 Dec 2021 02:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbhLWCPL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Dec 2021 21:15:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbhLWCPK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Dec 2021 21:15:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E8BC061574
        for <mm-commits@vger.kernel.org>; Wed, 22 Dec 2021 18:15:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25DD861D1B
        for <mm-commits@vger.kernel.org>; Thu, 23 Dec 2021 02:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48397C36AE8;
        Thu, 23 Dec 2021 02:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640225709;
        bh=sBsDllqQLrBRo7iwV+zDLgBG3btyl7cL3NJ3xZP8AbQ=;
        h=Date:From:To:Subject:From;
        b=kVivw9vRWorB3t1pcHng1hw1B6Coc4U1FQSZRhVsluXXm/9TR2DTDf4OQpzyLUU2Y
         39L6Oq2ntTuWMM4mbwWtz2HHyFmwI2IRPsA4shuOIMoTPVpMt/gIPt3te4BOIJWG5U
         nWYkmnx6b+UziQj5WuyRYkGrfReCZ1yotuigGcq8=
Date:   Wed, 22 Dec 2021 18:15:08 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, bunk@stusta.de, dhowells@redhat.com,
        mingo@elte.hu, mm-commits@vger.kernel.org, rdunlap@xenotime.net,
        walken@google.com
Subject:  + mutex-subsystem-synchro-test-module-fix.patch added to
 -mm tree
Message-ID: <20211223021508.bVwG2TEIk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mutex-subsystem-synchro-test-module-fix
has been added to the -mm tree.  Its filename is
     mutex-subsystem-synchro-test-module-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mutex-subsystem-synchro-test-module-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mutex-subsystem-synchro-test-module-fix.patch

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
Subject: mutex-subsystem-synchro-test-module-fix

Cc: Adrian Bunk <bunk@stusta.de>
Cc: David Howells <dhowells@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Michel Lespinasse <walken@google.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/synchro-test.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/kernel/synchro-test.c~mutex-subsystem-synchro-test-module-fix
+++ a/kernel/synchro-test.c
@@ -264,7 +264,7 @@ static int spinlocker(void *arg)
 
 	if (verbose >= 2)
 		printk("%s: done\n", current->comm);
-	complete_and_exit(&sp_comp[N], 0);
+	kthread_complete_and_exit(&sp_comp[N], 0);
 }
 
 static int mutexer(void *arg)
@@ -285,7 +285,7 @@ static int mutexer(void *arg)
 
 	if (verbose >= 2)
 		printk("%s: done\n", current->comm);
-	complete_and_exit(&mx_comp[N], 0);
+	kthread_complete_and_exit(&mx_comp[N], 0);
 }
 
 static int semaphorer(void *arg)
@@ -306,7 +306,7 @@ static int semaphorer(void *arg)
 
 	if (verbose >= 2)
 		printk("%s: done\n", current->comm);
-	complete_and_exit(&sm_comp[N], 0);
+	kthread_complete_and_exit(&sm_comp[N], 0);
 }
 
 static int reader(void *arg)
@@ -329,7 +329,7 @@ static int reader(void *arg)
 
 	if (verbose >= 2)
 		printk("%s: done\n", current->comm);
-	complete_and_exit(&rd_comp[N], 0);
+	kthread_complete_and_exit(&rd_comp[N], 0);
 }
 
 static int writer(void *arg)
@@ -352,7 +352,7 @@ static int writer(void *arg)
 
 	if (verbose >= 2)
 		printk("%s: done\n", current->comm);
-	complete_and_exit(&wr_comp[N], 0);
+	kthread_complete_and_exit(&wr_comp[N], 0);
 }
 
 static int downgrader(void *arg)
@@ -380,7 +380,7 @@ static int downgrader(void *arg)
 
 	if (verbose >= 2)
 		printk("%s: done\n", current->comm);
-	complete_and_exit(&dg_comp[N], 0);
+	kthread_complete_and_exit(&dg_comp[N], 0);
 }
 
 static void stop_test(struct timer_list *t)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch
kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
mm.patch
kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch
device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes.patch
memcg-add-per-memcg-vmalloc-stat-v2-fix.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-vmalloc-allocate-small-pages-for-area-pages-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch
mm-rmap-fix-potential-batched-tlb-flush-race-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix2.patch
proc-make-the-proc_create-stubs-static-inlines-fix2-fix.patch
kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp-checkpatch-fixes.patch
hashh-remove-unused-define-directive-fix.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
proc-remove-pde_data-completely-fix.patch
proc-remove-pde_data-completely-fix-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch


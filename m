Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BBF4C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  7 Dec 2021 00:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378847AbhLGA6M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Dec 2021 19:58:12 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:47486 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378849AbhLGA6L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Dec 2021 19:58:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9752CCE1952
        for <mm-commits@vger.kernel.org>; Tue,  7 Dec 2021 00:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63F6C004DD;
        Tue,  7 Dec 2021 00:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638838478;
        bh=0X8il6ZdnxDCtBG2YqLI7L8ckAHc72wlAyjjz1yS7Wg=;
        h=Date:From:To:Subject:From;
        b=xmAzUcF/J2QhXF0X2YUL0ioKzHDavDYr9SCujBdxXNM6KdkMjgqK8FT2zD73P53TB
         AWjCmGFwGXeOT16h3hz9KRKb+lGSJmDxakYhuOJlNBFIp74u5j4uoi+6CQn/BANCav
         CmqbXwM80s/5wlefva3liyMNkt4VeFLJ1z5ynjiI=
Date:   Mon, 06 Dec 2021 16:54:38 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hdegoede@redhat.com, lkp@intel.com,
        mm-commits@vger.kernel.org
Subject:  +
 proc-make-the-proc_create-stubs-static-inlines-fix2-fix.patch added to -mm
 tree
Message-ID: <20211207005438.ucvuj6M6O%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc-make-the-proc_create-stubs-static-inlines-fix2-fix
has been added to the -mm tree.  Its filename is
     proc-make-the-proc_create-stubs-static-inlines-fix2-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-make-the-proc_create-stubs-static-inlines-fix2-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-make-the-proc_create-stubs-static-inlines-fix2-fix.patch

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
Subject: proc-make-the-proc_create-stubs-static-inlines-fix2-fix

fix build

Cc: Hans de Goede <hdegoede@redhat.com>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/led.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/sparc/kernel/led.c~proc-make-the-proc_create-stubs-static-inlines-fix2-fix
+++ a/arch/sparc/kernel/led.c
@@ -114,8 +114,6 @@ static const struct proc_ops led_proc_op
 };
 #endif
 
-static struct proc_dir_entry *led;
-
 #define LED_VERSION	"0.1"
 
 static int __init led_init(void)
@@ -123,8 +121,7 @@ static int __init led_init(void)
 	timer_setup(&led_blink_timer, led_blink, 0);
 
 #ifdef CONFIG_PROC_FS
-	led = proc_create("led", 0, NULL, &led_proc_ops);
-	if (!led)
+	if (!proc_create("led", 0, NULL, &led_proc_ops))
 		return -ENOMEM;
 #endif
 	printk(KERN_INFO
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch
kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
mm.patch
kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch
device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-page-table-check-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch
mm-rmap-fix-potential-batched-tlb-flush-race-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix2.patch
proc-make-the-proc_create-stubs-static-inlines-fix2-fix.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
linux-next-rejects.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
proc-remove-pde_data-completely-fix.patch
proc-remove-pde_data-completely-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch


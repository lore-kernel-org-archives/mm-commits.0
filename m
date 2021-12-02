Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B77C6C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Dec 2021 23:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349336AbhLBXKx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Dec 2021 18:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240957AbhLBXKw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Dec 2021 18:10:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F37FC06174A
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 15:07:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E5E26287A
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 23:07:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2941C00446;
        Thu,  2 Dec 2021 23:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638486447;
        bh=dtohLVsUufViwxMKoOmsRqL8lE2cqGh2ToCbSV/rN+w=;
        h=Date:From:To:Subject:From;
        b=wA4B7vLQEOB1r+/iCHwIoZjw7Y+QejjInZdiF6Ybz3nN3F64ou714jPpOCdsFsHmH
         IeahLIJnK65VIH+SaRZRFerGCCCiorwDPacm8TYCyEa84laerkljQCuEj4yceMjpMd
         Nn1uS9Iwn6u2QFSHAw1HzVBO2PglPmnlr2s4hQ6g=
Date:   Thu, 02 Dec 2021 15:07:27 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hdegoede@redhat.com, lkp@intel.com,
        mm-commits@vger.kernel.org
Subject:  +
 proc-make-the-proc_create-stubs-static-inlines-fix2.patch added to -mm tree
Message-ID: <20211202230727.vr8ic7s1J%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc-make-the-proc_create-stubs-static-inlines-fix2
has been added to the -mm tree.  Its filename is
     proc-make-the-proc_create-stubs-static-inlines-fix2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-make-the-proc_create-stubs-static-inlines-fix2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-make-the-proc_create-stubs-static-inlines-fix2.patch

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
Subject: proc-make-the-proc_create-stubs-static-inlines-fix2

fix arch/sparc/kernel/led.c

Reported-by: kernel test robot <lkp@intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/led.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/sparc/kernel/led.c~proc-make-the-proc_create-stubs-static-inlines-fix2
+++ a/arch/sparc/kernel/led.c
@@ -122,10 +122,11 @@ static int __init led_init(void)
 {
 	timer_setup(&led_blink_timer, led_blink, 0);
 
+#ifdef CONFIG_PROC_FS
 	led = proc_create("led", 0, NULL, &led_proc_ops);
 	if (!led)
 		return -ENOMEM;
-
+#endif
 	printk(KERN_INFO
 	       "led: version %s, Lars Kotthoff <metalhead@metalhead.ws>\n",
 	       LED_VERSION);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch
kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
mm.patch
kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-page-table-check-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch
mm-rmap-fix-potential-batched-tlb-flush-race-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix2.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
proc-remove-pde_data-completely-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch


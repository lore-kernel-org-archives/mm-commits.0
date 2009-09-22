From: akpm@linux-foundation.org
Subject: [folded] generic-ipi-make-struct-call_function_data-lockless-cleanup.patch removed from -mm tree
Date: Tue, 22 Sep 2009 14:37:32 -0700
Message-ID: <200909222137.n8MLbWct021399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752592AbZIVVht (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 17:37:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jens.axboe@oracle.com, mingo@elte.hu, nickpiggin@yahoo.com.au, peterz@infradead.org, rusty@rustcorp.com.au, xiaoguangrong@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     generic-ipi-make-struct-call_function_data-lockless-cleanup
has been removed from the -mm tree.  Its filename was
     generic-ipi-make-struct-call_function_data-lockless-cleanup.patch

This patch was dropped because it was folded into generic-ipi-make-struct-call_function_data-lockless.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: generic-ipi-make-struct-call_function_data-lockless-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

Use atomic_dec_return().

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/smp.c~generic-ipi-make-struct-call_function_data-lockless-cleanup kernel/smp.c
--- a/kernel/smp.c~generic-ipi-make-struct-call_function_data-lockless-cleanup
+++ a/kernel/smp.c
@@ -193,7 +193,7 @@ void generic_smp_call_function_interrupt
 
 		data->csd.func(data->csd.info);
 
-		refs = atomic_sub_return(1, &data->refs);
+		refs = atomic_dec_return(&data->refs);
 		WARN_ON(refs < 0);
 		if (!refs) {
 			spin_lock(&call_function.lock);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch
generic-ipi-make-struct-call_function_data-lockless.patch
generic-ipi-make-struct-call_function_data-lockless-cleanup.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it-fix.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
sdio-add-cd-disable-support-cleanup.patch
sdio-add-mmc_quirk_lenient_fn0-fix.patch
at91-atmel-mci-platform-configuration-to-the-the-atmel-mci-driver-checkpatch-fixes.patch
mmc-core-sdio-suspend-resume-support-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
walk-system-ram-range-fix-2.patch
kcore-register-vmemmap-range-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup.patch
drivers-video-add-kmalloc-null-tests-fix.patch
drivers-video-tmiofbc-fix-uninitialised-return-value.patch
v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch


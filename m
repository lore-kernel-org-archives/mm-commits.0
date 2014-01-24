From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 11:02:52 -0800
Message-ID: <52e2b8dc.nUMFgGlr577RzN+h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43766 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbaAXTCx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:02:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, robh+dt@kernel.org, julia.lawall@lip6.fr, john.stultz@linaro.org, grant.likely@linaro.org, akpm@linux-foundation.org

Subject: [merged] drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch removed from -mm tree
To: akpm@linux-foundation.org,grant.likely@linaro.org,john.stultz@linaro.org,julia.lawall@lip6.fr,robh+dt@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:02:52 -0800


The patch titled
     Subject: drivers/rtc/rtc-cmos.c: propagate hpet_register_irq_handler() failure
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/rtc/rtc-cmos.c: propagate hpet_register_irq_handler() failure

If hpet_register_irq_handler() fails, cmos_do_probe() will incorrectly
return 0.

Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure
+++ a/drivers/rtc/rtc-cmos.c
@@ -756,11 +756,9 @@ cmos_do_probe(struct device *dev, struct
 		irq_handler_t rtc_cmos_int_handler;
 
 		if (is_hpet_enabled()) {
-			int err;
-
 			rtc_cmos_int_handler = hpet_rtc_interrupt;
-			err = hpet_register_irq_handler(cmos_interrupt);
-			if (err != 0) {
+			retval = hpet_register_irq_handler(cmos_interrupt);
+			if (retval) {
 				dev_warn(dev, "hpet_register_irq_handler "
 						" failed in rtc_init().");
 				goto cleanup1;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
mm.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
ipcmsg-document-barriers-fix.patch
ipcmsg-document-barriers-fix-fix.patch
linux-next.patch
linux-next-git-rejects.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


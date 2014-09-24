From: akpm@linux-foundation.org
Subject: + rtc-pcf8563-fix-uninitialized-use-warning.patch added to -mm
 tree
Date: Wed, 24 Sep 2014 15:39:06 -0700
Message-ID: <5423480a.ho4+GKpxi2rHWqYy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaIXWjH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Sep 2014 18:39:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, a.zummo@towertech.it, sergei.shtylyov@cogentembedded.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pcf8563.c: fix uninitialized use warning
has been added to the -mm tree.  Its filename is
     rtc-pcf8563-fix-uninitialized-use-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-pcf8563-fix-uninitialized-use-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-pcf8563-fix-uninitialized-use-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: drivers/rtc/rtc-pcf8563.c: fix uninitialized use warning

gcc-4.9 found a potential condition under which the 'pending' variable may
be used uninitialized:

drivers/rtc/rtc-pcf8563.c: In function 'pcf8563_irq':
drivers/rtc/rtc-pcf8563.c:173:5: warning: 'pending' may be used uninitialized in this function [-Wmaybe-uninitialized]

This is because in the pcf8563_get_alarm_mode() function, we check any
nonzero return of pcf8563_read_block_data, but in the irq function we only
check for negative values, so a possible positive value does not get
detected if the compiler chooses not to inline the entire call chain.

Checking for any non-zero value in the interrupt handler as well is just
as correct and lets the compiler know what we are doing, without needing a
bogus initialization.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8563.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-fix-uninitialized-use-warning drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-fix-uninitialized-use-warning
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -167,7 +167,7 @@ static irqreturn_t pcf8563_irq(int irq,
 	char pending;
 
 	err = pcf8563_get_alarm_mode(pcf8563->client, NULL, &pending);
-	if (err < 0)
+	if (err)
 		return err;
 
 	if (pending) {
_

Patches currently in -mm which might be from arnd@arndb.de are

origin.patch
lib-genallocc-add-power-aligned-algorithm.patch
lib-genallocc-add-genpool-range-check-function.patch
common-dma-mapping-introduce-common-remapping-functions.patch
arm-use-genalloc-for-the-atomic-pool.patch
arm64-add-atomic-pool-for-non-coherent-and-cma-allocations.patch
mm-compaction-fix-warning-of-flags-may-be-used-uninitialized.patch
drivers-of-add-return-value-to-of_reserved_mem_device_init.patch
drivers-dma-coherent-add-initialization-from-device-tree.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes.patch
drivers-dma-contiguous-add-initialization-from-device-tree.patch
drivers-dma-contiguous-add-initialization-from-device-tree-checkpatch-fixes.patch
binfmt_misc-work-around-gcc-49-warning.patch
rtc-pcf8563-fix-uninitialized-use-warning.patch
rtc-pcf8563-fix-pcf8563_irq-error-return-value.patch
linux-next.patch
kernel-add-support-for-kernel-restart-handler-call-chain.patch
power-restart-call-machine_restart-instead-of-arm_pm_restart.patch
arm64-support-restart-through-restart-handler-call-chain.patch
arm-support-restart-through-restart-handler-call-chain.patch
watchdog-moxart-register-restart-handler-with-kernel-restart-handler.patch
watchdog-alim7101-register-restart-handler-with-kernel-restart-handler.patch
watchdog-sunxi-register-restart-handler-with-kernel-restart-handler.patch
arm-arm64-unexport-restart-handlers.patch
watchdog-s3c2410-add-restart-handler.patch
clk-samsung-register-restart-handlers-for-s3c2412-and-s3c2443.patch
clk-rockchip-add-restart-handler.patch


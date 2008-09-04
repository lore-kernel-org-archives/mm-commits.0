From: akpm@linux-foundation.org
Subject: - rtc-m48t59-reduce-structure-m48t59_private.patch removed from -mm tree
Date: Thu, 04 Sep 2008 12:56:23 -0700
Message-ID: <200809041956.m84JuNlv027875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754113AbYIDT4j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2008 15:56:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc-m48t59: reduce structure m48t59_private
has been removed from the -mm tree.  Its filename was
     rtc-m48t59-reduce-structure-m48t59_private.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-m48t59: reduce structure m48t59_private
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Remove element size from the structure m48t59_private as it is used as
local variable for storing temporary value.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m48t59.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-m48t59.c~rtc-m48t59-reduce-structure-m48t59_private drivers/rtc/rtc-m48t59.c
--- a/drivers/rtc/rtc-m48t59.c~rtc-m48t59-reduce-structure-m48t59_private
+++ a/drivers/rtc/rtc-m48t59.c
@@ -34,7 +34,6 @@
 
 struct m48t59_private {
 	void __iomem *ioaddr;
-	unsigned int size; /* iomem size */
 	int irq;
 	struct rtc_device *rtc;
 	spinlock_t lock; /* serialize the NVRAM and RTC access */
@@ -403,8 +402,7 @@ static int __devinit m48t59_rtc_probe(st
 	if (!m48t59)
 		return -ENOMEM;
 
-	m48t59->size = res->end - res->start + 1;
-	m48t59->ioaddr = ioremap(res->start, m48t59->size);
+	m48t59->ioaddr = ioremap(res->start, res->end - res->start + 1);
 	if (!m48t59->ioaddr)
 		goto out;
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
linux-next.patch
fb-metronome-printk-format-warning.patch
x86-delay-early-cpu-initialization-until-cpuid-is-done.patch
x86-move-mtrr-cpu-cap-setting-early-in-early_init_xxxx.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch
neofb-reduce-panning-function.patch
viafb-accelc-accelh-update.patch
viafb-viafbdevc-update.patch
fbdev-kconfig-update.patch
fbdev-kconfig-update-fix.patch
neofb-kill-some-redundant-code.patch
vga16fb-remove-open_lock-mutex.patch
neofb-remove-open_lock-mutex.patch
cirrusfb-remove-information-about-memory-size-during-mode-change.patch
cirrusfb-simplify-clock-calculation.patch
cirrusfb-remove-24-bpp-mode.patch
cirrusfb-drop-device-pointers-from-cirrusfb_info.patch
tdfxfb-do-not-make-changes-to-default-tdfx_fix.patch
intelfb-support-945gme-as-used-in-asus-eee-901.patch
cirrusfb-use-modedb-and-add-mode_option-parameter-2nd-rev.patch


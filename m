From: akpm@linux-foundation.org
Subject: [folded] cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix.patch removed from -mm tree
Date: Thu, 09 Apr 2009 14:41:58 -0700
Message-ID: <200904092141.n39Lfwop008782@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47274 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752258AbZDIVqv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 17:46:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, david-b@pacbell.net, dilinger@debian.org, jordan@cosmicpenguin.net, katzj@redhat.com, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     gpio: fix cs553x printk format
has been removed from the -mm tree.  Its filename was
     cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix.patch

This patch was dropped because it was folded into cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: fix cs553x printk format
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning:

drivers/gpio/cs553x-gpio.c:193: warning: format '%x' expects type 'unsigned int', but argument 5 has type 'resource_size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andres Salomon <dilinger@debian.org>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jeremy Katz <katzj@redhat.com>
Cc: Jordan Crouse <jordan@cosmicpenguin.net>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/cs553x-gpio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/gpio/cs553x-gpio.c~cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix drivers/gpio/cs553x-gpio.c
--- a/drivers/gpio/cs553x-gpio.c~cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix
+++ a/drivers/gpio/cs553x-gpio.c
@@ -190,8 +190,8 @@ static int __init cs553x_gpio_probe(stru
 	cs553x_gpio_chip.pdev = pdev;
 	spin_lock_init(&cs553x_gpio_chip.lock);
 
-	dev_info(&pdev->dev, "allocated PCI BAR #%d: base 0x%x\n", GPIO_BAR,
-			cs553x_gpio_chip.base);
+	dev_info(&pdev->dev, "allocated PCI BAR #%d: base 0x%llx\n", GPIO_BAR,
+			(unsigned long long)cs553x_gpio_chip.base);
 
 	/* finally, register with the generic GPIO API */
 	err = gpiochip_add(&cs553x_gpio_chip.chip);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
maintainers-fix-email-address.patch
linux-next.patch
timers-add-missing-kernel-doc.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
sysctl-lockdep-support-for-sysctl-reference-counting-fix.patch
qla2x-fix-printk-format-warnings.patch
filemap-fix-kernel-doc-warnings.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization-fix.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch


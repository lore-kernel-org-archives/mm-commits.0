From: akpm@linux-foundation.org
Subject: + mtd-maps-gpio-addr-flash-fix-warnings-and-make-more-portable.patch added to -mm tree
Date: Thu, 21 Oct 2010 14:53:46 -0700
Message-ID: <201010212153.o9LLrk4C005870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756070Ab0JUVyL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Oct 2010 17:54:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, alan@linux.intel.com, cbouatmailru@gmail.com, dwmw2@infradead.org


The patch titled
     mtd/maps: gpio-addr-flash: fix warnings and make more portable
has been added to the -mm tree.  Its filename is
     mtd-maps-gpio-addr-flash-fix-warnings-and-make-more-portable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd/maps: gpio-addr-flash: fix warnings and make more portable
From: Mike Frysinger <vapier@gentoo.org>

As reported on lkml, building this module for HIGHMEM systems spews
warnings about mismatch in pointer types.  Further, we need to use
ioremap() in order to properly access the flash memory on most systems
rather than just doing it directly.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Reported-by: Alan Cox <alan@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/gpio-addr-flash.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN drivers/mtd/maps/gpio-addr-flash.c~mtd-maps-gpio-addr-flash-fix-warnings-and-make-more-portable drivers/mtd/maps/gpio-addr-flash.c
--- a/drivers/mtd/maps/gpio-addr-flash.c~mtd-maps-gpio-addr-flash-fix-warnings-and-make-more-portable
+++ a/drivers/mtd/maps/gpio-addr-flash.c
@@ -208,10 +208,14 @@ static int __devinit gpio_flash_probe(st
 	if (!state)
 		return -ENOMEM;
 
+	/*
+	 * We cast start/end to known types in the boards file, so cast
+	 * away their pointer types here to the known types (gpios->xxx).
+	 */
 	state->gpio_count     = gpios->end;
-	state->gpio_addrs     = (void *)gpios->start;
+	state->gpio_addrs     = (void *)(unsigned long)gpios->start;
 	state->gpio_values    = (void *)(state + 1);
-	state->win_size       = memory->end - memory->start + 1;
+	state->win_size       = resource_size(memory);
 	memset(state->gpio_values, 0xff, arr_size);
 
 	state->map.name       = DRIVER_NAME;
@@ -221,7 +225,7 @@ static int __devinit gpio_flash_probe(st
 	state->map.copy_to    = gf_copy_to;
 	state->map.bankwidth  = pdata->width;
 	state->map.size       = state->win_size * (1 << state->gpio_count);
-	state->map.virt       = (void __iomem *)memory->start;
+	state->map.virt       = ioremap_nocache(memory->start, state->map.size);
 	state->map.phys       = NO_XIP;
 	state->map.map_priv_1 = (unsigned long)state;
 
_

Patches currently in -mm which might be from vapier@gentoo.org are

drivers-misc-ad525x_dpot-fix-typo-in-spi-write16-and-write24-transfer-counts.patch
linux-next.patch
mtd-maps-gpio-addr-flash-fix-warnings-and-make-more-portable.patch
video-backlight-adp8860-fix-ambient-light-zone-overwrite-handling.patch
m68knommu-blackfin-remove-old-assembler-only-flags-bit-definitions.patch
vmlinuxldsh-gather-datashared_aligned-sections-in-data_data.patch
vmlinuxldsh-lower-init-ramfs-alignment-to-4.patch
drivers-misc-ad525x_dpot-fix-part-name-typos-in-defines.patch
drivers-misc-ad525x_dpot-new-features.patch
ad525x_dpot-use-correct-rdac-channel-for-ad5251-ad5252.patch
misc-devices-do-not-enable-by-default.patch
rtc-bfin-shrink-optimize-interrupt-handler-a-bit.patch
rtc-bfin-add-debug-markers-to-suspend-resume-paths.patch
gpio-adp5588-gpio-support-interrupt-controller.patch
gpio-adp5588-gpio-support-interrupt-controller-update.patch
gpio-adp5588-gpio-gpio_start-must-be-signed.patch
gpio-adp5588-gpio-add-i2c-forward-declaration.patch
ptrace-cleanup-arch_ptrace-and-friends-on-blackfin.patch


From: akpm@linux-foundation.org
Subject: [obsolete] drivers-usb-serial-usb_wwanc-unbork.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:16:32 -0700
Message-ID: <201103250716.p2P7GQrr025446@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933415Ab1CYHQe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:16:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gregkh@suse.de, oneukum@suse.de, mm-commits@vger.kernel.org


The patch titled
     drivers/usb/serial/usb_wwan.c: unbork
has been removed from the -mm tree.  Its filename was
     drivers-usb-serial-usb_wwanc-unbork.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/usb/serial/usb_wwan.c: unbork
From: Andrew Morton <akpm@linux-foundation.org>

linux-next x86_64 allmodconfig:

drivers/usb/serial/usb_wwan.c: In function 'play_delayed':
drivers/usb/serial/usb_wwan.c:702: error: 'struct dev_pm_info' has no member named 'usage_count'

Cc: Oliver Neukum <oneukum@suse.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/usb_wwan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/serial/usb_wwan.c~drivers-usb-serial-usb_wwanc-unbork drivers/usb/serial/usb_wwan.c
--- a/drivers/usb/serial/usb_wwan.c~drivers-usb-serial-usb_wwanc-unbork
+++ a/drivers/usb/serial/usb_wwan.c
@@ -699,7 +699,7 @@ static void play_delayed(struct usb_seri
 			do {
 				unbusy_queued_urb(urb, portdata);
 				//extremely dirty
-				atomic_dec(&port->serial->interface->dev.power.usage_count);
+//				atomic_dec(&port->serial->interface->dev.power.usage_count);
 			} while ((urb = usb_get_from_anchor(&portdata->delayed)));
 			break;
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix-fix.patch
mm-add-vm-counters-for-transparent-hugepages-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch


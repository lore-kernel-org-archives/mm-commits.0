From: akpm@linux-foundation.org
Subject: + drivers-usb-serial-usb_wwanc-unbork.patch added to -mm tree
Date: Wed, 02 Mar 2011 13:18:29 -0800
Message-ID: <201103022153.p22LrEPM003034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757405Ab1CBVxV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Mar 2011 16:53:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, gregkh@suse.de, oneukum@suse.de


The patch titled
     drivers/usb/serial/usb_wwan.c: unbork
has been added to the -mm tree.  Its filename is
     drivers-usb-serial-usb_wwanc-unbork.patch

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

cpuset-add-a-missing-unlock-in-cpuset_write_resmask-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch
mm-batch-free-pcp-list-if-possible-fix.patch
pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
kernel-cpuc-fix-many-errors-related-to-style-fix.patch
lib-vsprintf-optimised-put_dec-function-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes.patch
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks-checkpatch-fixes.patch
scatterlist-new-helper-functions.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch
drivers-usb-serial-usb_wwanc-unbork.patch


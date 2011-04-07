From: akpm@linux-foundation.org
Subject: + drivers-tty-vt-vt_ioctlc-repair-insane-expression.patch added to -mm tree
Date: Thu, 07 Apr 2011 16:13:01 -0700
Message-ID: <201104072313.p37ND1nP006142@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757114Ab1DGXNd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Apr 2011 19:13:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, art@ified.ca, gregkh@suse.de


The patch titled
     drivers/tty/vt/vt_ioctl.c: repair insane ?: expression
has been added to the -mm tree.  Its filename is
     drivers-tty-vt-vt_ioctlc-repair-insane-expression.patch

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
Subject: drivers/tty/vt/vt_ioctl.c: repair insane ?: expression
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Arthur Taylor <art@ified.ca>
Cc: Greg KH <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/vt/vt_ioctl.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff -puN drivers/tty/vt/vt_ioctl.c~drivers-tty-vt-vt_ioctlc-repair-insane-expression drivers/tty/vt/vt_ioctl.c
--- a/drivers/tty/vt/vt_ioctl.c~drivers-tty-vt-vt_ioctlc-repair-insane-expression
+++ a/drivers/tty/vt/vt_ioctl.c
@@ -698,11 +698,23 @@ int vt_ioctl(struct tty_struct *tty,
 		break;
 
 	case KDGKBMODE:
-		uival = ((kbd->kbdmode == VC_RAW) ? K_RAW :
-				 (kbd->kbdmode == VC_MEDIUMRAW) ? K_MEDIUMRAW :
-				 (kbd->kbdmode == VC_UNICODE) ? K_UNICODE :
-				 (kbd->kbdmode == VC_OFF) ? K_OFF :
-				 K_XLATE);
+		switch (kbd->kbdmode) {
+		case VC_RAW:
+			uival = K_RAW;
+			break;
+		case VC_MEDIUMRAW:
+			uival = K_MEDIUMRAW;
+			break;
+		case VC_UNICODE:
+			uival = K_UNICODE;
+			break;
+		case VC_OFF:
+			uival = K_OFF;
+			break;
+		default:
+			uival = K_XLATE;
+			break;
+		}
 		goto setint;
 
 	/* this could be folded into KDSKBMODE, but for compatibility
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-i2c-busses-i2c-designware-corec-needs-delayh.patch
fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table-checkpatch-fixes.patch
mm-add-vm-counters-for-transparent-hugepages.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
mm-nommu-sort-mm-mmap-list-properly-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix.patch
lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
drivers-tty-vt-vt_ioctlc-repair-insane-expression.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch


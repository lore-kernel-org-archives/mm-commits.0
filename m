From: akpm@linux-foundation.org
Subject: + rtc-add-platform-driver-for-efi-fix.patch added to -mm tree
Date: Wed, 14 Jan 2009 13:26:04 -0800
Message-ID: <200901142126.n0ELQ4Xf014144@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760318AbZANV0y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Jan 2009 16:26:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alessandro.zummo@towertech.it, dannf@dannf.org, dannf@hp.com, david-b@pacbell.net, eranian@googlemail.com, tony.luck@intel.com


The patch titled
     rtc-add-platform-driver-for-efi-fix
has been added to the -mm tree.  Its filename is
     rtc-add-platform-driver-for-efi-fix.patch

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
Subject: rtc-add-platform-driver-for-efi-fix
From: Andrew Morton <akpm@linux-foundation.org>

Use is_leap_year()

Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: dann frazier <dannf@dannf.org>
Cc: dann frazier <dannf@hp.com>
Cc: stephane eranian <eranian@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-efi.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-efi.c~rtc-add-platform-driver-for-efi-fix drivers/rtc/rtc-efi.c
--- a/drivers/rtc/rtc-efi.c~rtc-add-platform-driver-for-efi-fix
+++ a/drivers/rtc/rtc-efi.c
@@ -26,8 +26,6 @@
  */
 #define EFI_RTC_EPOCH		1998
 
-#define LEAP_YEAR(year) ((!(year % 4) && (year % 100)) || !(year % 400))
-
 /*
  * returns day of the year [0-365]
  */
@@ -54,7 +52,7 @@ compute_wday(efi_time_t *eft)
 	}
 
 	for (y = EFI_RTC_EPOCH; y < eft->year; y++)
-		ndays += 365 + (LEAP_YEAR(y) ? 1 : 0);
+		ndays += 365 + (is_leap_year(y) ? 1 : 0);
 
 	ndays += compute_yday(eft);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kernel-upc-omit-it-if-smp=y-use_generic_smp_helpers=n.patch
alpha-fix-vmalloc-breakage-fix.patch
revert-mm-vmalloc-use-mutex-for-purge.patch
kprobes-fix-module-compilation-error-with-config_kprobes=n-fix.patch
lib-idrc-use-kmem_cache_zalloc-for-the-idr_layer-cache.patch
hp_accel-do-not-call-acpi-from-invalid-context-fix.patch
i-need-old-gcc.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
kernel-trace-ring_bufferc-reduce-inlining.patch
kernel-trace-ring_bufferc-use-div_round_up.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
ext2-update-also-inode-on-disk-when-dir-is-is_dirsync-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix-3-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
rtc-cumulative-style-fixes-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch


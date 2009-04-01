From: akpm@linux-foundation.org
Subject: [merged] rtc-convert-leap_year-into-an-inline.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:41:47 -0700
Message-ID: <200904011841.n31IflRU009465@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761033AbZDAThd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:37:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alessandro.zummo@towertech.it, dannf@hp.com, david-b@pacbell.net, eranian@googlemail.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     rtc: convert LEAP_YEAR into an inline
has been removed from the -mm tree.  Its filename was
     rtc-convert-leap_year-into-an-inline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: convert LEAP_YEAR into an inline
From: Andrew Morton <akpm@linux-foundation.org>

- the LEAP_YEAR macro is buggy - it references its arg multiple times. 
  Fix this by turning it into a C function.

- give it a more approriate name

- Move it to rtc.h so that other .c files can use it, instead of copying it.

Cc: dann frazier <dannf@hp.com>
Acked-by: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: stephane eranian <eranian@googlemail.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-lib.c |    7 +++----
 include/linux/rtc.h   |    6 ++++++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-lib.c~rtc-convert-leap_year-into-an-inline drivers/rtc/rtc-lib.c
--- a/drivers/rtc/rtc-lib.c~rtc-convert-leap_year-into-an-inline
+++ a/drivers/rtc/rtc-lib.c
@@ -26,14 +26,13 @@ static const unsigned short rtc_ydays[2]
 };
 
 #define LEAPS_THRU_END_OF(y) ((y)/4 - (y)/100 + (y)/400)
-#define LEAP_YEAR(year) ((!(year % 4) && (year % 100)) || !(year % 400))
 
 /*
  * The number of days in the month.
  */
 int rtc_month_days(unsigned int month, unsigned int year)
 {
-	return rtc_days_in_month[month] + (LEAP_YEAR(year) && month == 1);
+	return rtc_days_in_month[month] + (is_leap_year(year) && month == 1);
 }
 EXPORT_SYMBOL(rtc_month_days);
 
@@ -42,7 +41,7 @@ EXPORT_SYMBOL(rtc_month_days);
  */
 int rtc_year_days(unsigned int day, unsigned int month, unsigned int year)
 {
-	return rtc_ydays[LEAP_YEAR(year)][month] + day-1;
+	return rtc_ydays[is_leap_year(year)][month] + day-1;
 }
 EXPORT_SYMBOL(rtc_year_days);
 
@@ -66,7 +65,7 @@ void rtc_time_to_tm(unsigned long time, 
 		- LEAPS_THRU_END_OF(1970 - 1);
 	if (days < 0) {
 		year -= 1;
-		days += 365 + LEAP_YEAR(year);
+		days += 365 + is_leap_year(year);
 	}
 	tm->tm_year = year - 1900;
 	tm->tm_yday = days + 1;
diff -puN include/linux/rtc.h~rtc-convert-leap_year-into-an-inline include/linux/rtc.h
--- a/include/linux/rtc.h~rtc-convert-leap_year-into-an-inline
+++ a/include/linux/rtc.h
@@ -99,6 +99,7 @@ struct rtc_pll_info {
 
 #ifdef __KERNEL__
 
+#include <linux/types.h>
 #include <linux/interrupt.h>
 
 extern int rtc_month_days(unsigned int month, unsigned int year);
@@ -232,6 +233,11 @@ int rtc_register(rtc_task_t *task);
 int rtc_unregister(rtc_task_t *task);
 int rtc_control(rtc_task_t *t, unsigned int cmd, unsigned long arg);
 
+static inline bool is_leap_year(unsigned int year)
+{
+	return (!(year % 4) && (year % 100)) || !(year % 400);
+}
+
 #endif /* __KERNEL__ */
 
 #endif /* _LINUX_RTC_H_ */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
toshiba_acpi-add-full-hotkey-support-fix.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
arch-x86-mm-iomap_32c-fix-warning.patch
early-platform-driver-v3.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
leds-add-bd2802gu-led-driver.patch
flex-onenand-support-v2-fix.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2-checkpatch-fixes.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional-fix.patch
xtensa-add-flat-support-checkpatch-fixes.patch
__tty_open-use-the-correct-type-for-saved_flags.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
simplify-copy_thread-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
rtc-v3020-add-ability-to-access-v3020-chip-with-gpios.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix-checkpatch-fixes.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
forget_original_parent-do-not-abuse-child-ptrace_entry-fix.patch
hpet-fix-the-possibility-of-insane-return-value-of-hpet_calibrate-against-smi-fix.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
nbd-add-locking-to-nbd_ioctl-fix.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-checkpatch-fixes-cleanup.patch
kernel-auditscc-fix-warning.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
vfs-simple_set_mnt-should-return-void-fix-nilfs.patch
nilfs2-segment-buffer-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
page-owner-tracking.patch
page-owner-tracking-checkpatch-fixes.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch


From: akpm@linux-foundation.org
Subject: + rtc-convert-leap_year-into-an-inline.patch added to -mm tree
Date: Wed, 14 Jan 2009 13:26:00 -0800
Message-ID: <200901142126.n0ELQ0Sp014003@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760289AbZANV0v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Jan 2009 16:26:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alessandro.zummo@towertech.it, dannf@hp.com, david-b@pacbell.net, eranian@googlemail.com, tony.luck@intel.com


The patch titled
     rtc: convert LEAP_YEAR into an inline
has been added to the -mm tree.  Its filename is
     rtc-convert-leap_year-into-an-inline.patch

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
Subject: rtc: convert LEAP_YEAR into an inline
From: Andrew Morton <akpm@linux-foundation.org>

- the LEAP_YEAR macro is buggy - it references its arg multiple times. 
  Fix this by turning it into a C function.

- give it a more approriate name

- Move it to rtc.h so that other .c files can use it, instead of copying it.

Cc: dann frazier <dannf@hp.com>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>
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


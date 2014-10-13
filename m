From: akpm@linux-foundation.org
Subject: [folded-merged]
 rtc-max77686-use-ffs-to-calculate-tm_wday-fix.patch removed from -mm tree
Date: Mon, 13 Oct 2014 15:38:42 -0700
Message-ID: <543c5472.TtXx6nebvwJ6BcnN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34670 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbaJMWim (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 18:38:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, javier.martinez@collabora.co.uk, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-max77686-use-ffs-to-calculate-tm_wday-fix
has been removed from the -mm tree.  Its filename was
     rtc-max77686-use-ffs-to-calculate-tm_wday-fix.patch

This patch was dropped because it was folded into rtc-max77686-use-ffs-to-calculate-tm_wday.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-max77686-use-ffs-to-calculate-tm_wday-fix

add comment clarifying ffs() use

Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max77686.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/rtc-max77686.c~rtc-max77686-use-ffs-to-calculate-tm_wday-fix drivers/rtc/rtc-max77686.c
--- a/drivers/rtc/rtc-max77686.c~rtc-max77686-use-ffs-to-calculate-tm_wday-fix
+++ a/drivers/rtc/rtc-max77686.c
@@ -83,6 +83,7 @@ static void max77686_rtc_data_to_tm(u8 *
 			tm->tm_hour += 12;
 	}
 
+	/* Only a single bit is set in data[], so fls() would be equivalent */
 	tm->tm_wday = ffs(data[RTC_WEEKDAY] & 0x7f) - 1;
 	tm->tm_mday = data[RTC_DATE] & 0x1f;
 	tm->tm_mon = (data[RTC_MONTH] & 0x0f) - 1;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cma-fix-cma-bitmap-aligned-mask-computing.patch
drivers-dma-coherent-add-initialization-from-device-tree.patch
checkpatch-fix-spello.patch
checkpatch-warn-on-logging-functions-with-kern_level.patch
rtc-rk808-add-rtc-driver-for-rk808.patch
rtc-bq32000-add-trickle-charger-option-with-device-tree-binding.patch
rtc-max77686-use-ffs-to-calculate-tm_wday.patch
rtc-add-driver-for-maxim-77802-pmic-real-time-clock-v10-fix.patch
x86-optimize-resource-lookups-for-ioremap-fix.patch
init-resolve-shadow-warnings-checkpatch-fixes.patch
arch-x86-kernel-cpu-commonc-fix-unused-symbol-warning.patch
mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable-checkpatch-fixes.patch
lib-string_helpers-introduce-string_escape_mem-fix.patch
lib-vsprintf-add-%pe-format-specifier-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix-2.patch
watchdog-control-hard-lockup-detection-default-fix.patch


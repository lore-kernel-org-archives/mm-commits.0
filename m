From: akpm@linux-foundation.org
Subject: + drivers-acpi-use-kasprintf-fix.patch added to -mm tree
Date: Thu, 18 Mar 2010 16:25:53 -0700
Message-ID: <201003182325.o2INPrjY021788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752172Ab0CRXZ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 19:25:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, julia@diku.dk, lenb@kernel.org


The patch titled
     drivers-acpi-use-kasprintf-fix
has been added to the -mm tree.  Its filename is
     drivers-acpi-use-kasprintf-fix.patch

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
Subject: drivers-acpi-use-kasprintf-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Julia Lawall <julia@diku.dk>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/video.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/video.c~drivers-acpi-use-kasprintf-fix drivers/acpi/video.c
--- a/drivers/acpi/video.c~drivers-acpi-use-kasprintf-fix
+++ a/drivers/acpi/video.c
@@ -1006,9 +1006,10 @@ static void acpi_video_device_find_cap(s
 		result = acpi_video_init_brightness(device);
 		if (result)
 			return;
-		name = kasprintf(GFP_KERNEL, "acpi_video%d", count++);
+		name = kasprintf(GFP_KERNEL, "acpi_video%d", count);
 		if (!name)
 			return;
+		count++;
 
 		memset(&props, 0, sizeof(struct backlight_properties));
 		props.max_brightness = device->brightness->count - 3;
@@ -1058,9 +1059,10 @@ static void acpi_video_device_find_cap(s
 		if (device->cap._DCS && device->cap._DSS) {
 			static int count;
 			char *name;
-			name = kasprintf(GFP_KERNEL, "acpi_video%d", count++);
+			name = kasprintf(GFP_KERNEL, "acpi_video%d", count);
 			if (!name)
 				return;
+			count++;
 			device->output_dev = video_output_register(name,
 					NULL, device, &acpi_output_properties);
 			kfree(name);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-i2c-busses-i2c-xiicc-is-borked.patch
rtc-davinci-rtc-driver-checkpatch-fixes.patch
c2port-fix-device_create-return-value-check-fix.patch
drivers-acpi-use-kasprintf-fix.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
3x59x-fix-pci-resource-management.patch
kernel-schedc-suppress-unused-var-warning.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch
memcg-oom-notifier-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
bitops-remove-temporary-for_each_bit.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch


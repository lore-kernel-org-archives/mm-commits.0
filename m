From: akpm@linux-foundation.org
Subject: + hpet-factor-timer-allocate-from-open-fix.patch added to -mm tree
Date: Mon, 22 Mar 2010 15:22:04 -0700
Message-ID: <201003222222.o2MMM4DS030893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755655Ab0CVWWq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 18:22:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, clemens@ladisch.de, johnstul@us.ibm.com, maglyx@gmail.com, tglx@linutronix.de


The patch titled
     hpet-factor-timer-allocate-from-open-fix
has been added to the -mm tree.  Its filename is
     hpet-factor-timer-allocate-from-open-fix.patch

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
Subject: hpet-factor-timer-allocate-from-open-fix
From: Andrew Morton <akpm@linux-foundation.org>

coding-style tweaks

Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Magnus Lynch <maglyx@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hpet.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/char/hpet.c~hpet-factor-timer-allocate-from-open-fix drivers/char/hpet.c
--- a/drivers/char/hpet.c~hpet-factor-timer-allocate-from-open-fix
+++ a/drivers/char/hpet.c
@@ -405,8 +405,9 @@ static int hpet_mmap(struct file *file, 
 static int hpet_fasync(int fd, struct file *file, int on)
 {
 	struct hpet_dev *devp;
+	int r;
 
-	int r = hpet_alloc_timer(file);
+	r = hpet_alloc_timer(file);
 	if (r < 0)
 		return r;
 
@@ -466,8 +467,9 @@ hpet_ioctl(struct inode *inode, struct f
 	   unsigned long arg)
 {
 	struct hpet_dev *devp;
+	int r;
 
-	int r = hpet_alloc_timer(file);
+	r = hpet_alloc_timer(file);
 	if (r < 0)
 		return r;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-i2c-busses-i2c-xiicc-is-borked.patch
rtc-davinci-rtc-driver-checkpatch-fixes.patch
c2port-fix-device_create-return-value-check-fix.patch
ratelimit-annotate-___ratelimit-fix.patch
drivers-acpi-use-kasprintf-fix.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
hpet-factor-timer-allocate-from-open-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
3x59x-fix-pci-resource-management.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
fault-injection-add-cpu-notifier-error-injection-module-fix.patch
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


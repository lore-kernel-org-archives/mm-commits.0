From: akpm@linux-foundation.org
Subject: [merged] drivers-char-tty_bufferc-fix-min-warnings.patch removed from -mm tree
Date: Thu, 18 Mar 2010 11:09:17 -0400
Message-ID: <201003181809.o2II9wns007614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753210Ab0CRSK2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 14:10:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/char/tty_buffer.c: fix min() warnings
has been removed from the -mm tree.  Its filename was
     drivers-char-tty_bufferc-fix-min-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/tty_buffer.c: fix min() warnings
From: Andrew Morton <akpm@linux-foundation.org>

i386 allnoconfig:

drivers/char/tty_buffer.c: In function 'tty_insert_flip_string_fixed_flag':
drivers/char/tty_buffer.c:251: warning: comparison of distinct pointer types lacks a cast
drivers/char/tty_buffer.c: In function 'tty_insert_flip_string_flags':
drivers/char/tty_buffer.c:288: warning: comparison of distinct pointer types lacks a cast

Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_buffer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/tty_buffer.c~drivers-char-tty_bufferc-fix-min-warnings drivers/char/tty_buffer.c
--- a/drivers/char/tty_buffer.c~drivers-char-tty_bufferc-fix-min-warnings
+++ a/drivers/char/tty_buffer.c
@@ -248,7 +248,7 @@ int tty_insert_flip_string_fixed_flag(st
 {
 	int copied = 0;
 	do {
-		int goal = min(size - copied, TTY_BUFFER_PAGE);
+		int goal = min_t(size_t, size - copied, TTY_BUFFER_PAGE);
 		int space = tty_buffer_request_room(tty, goal);
 		struct tty_buffer *tb = tty->buf.tail;
 		/* If there is no space then tb may be NULL */
@@ -285,7 +285,7 @@ int tty_insert_flip_string_flags(struct 
 {
 	int copied = 0;
 	do {
-		int goal = min(size - copied, TTY_BUFFER_PAGE);
+		int goal = min_t(size_t, size - copied, TTY_BUFFER_PAGE);
 		int space = tty_buffer_request_room(tty, goal);
 		struct tty_buffer *tb = tty->buf.tail;
 		/* If there is no space then tb may be NULL */
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


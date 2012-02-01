From: akpm@linux-foundation.org
Subject: + backlight-add-driver-for-bachmanns-ot200-fix.patch added to -mm tree
Date: Wed, 01 Feb 2012 12:35:04 -0800
Message-ID: <20120201203504.C34E8A00EA@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:60244 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044Ab2BAUfF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Feb 2012 15:35:05 -0500
Received: by ggnp1 with SMTP id p1so173591ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Feb 2012 12:35:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, christian.gmeiner@gmail.com, dilinger@queued.net, lars@metafoo.de


The patch titled
     Subject: backlight-add-driver-for-bachmanns-ot200-fix
has been added to the -mm tree.  Its filename is
     backlight-add-driver-for-bachmanns-ot200-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: backlight-add-driver-for-bachmanns-ot200-fix

Cc: Andres Salomon <dilinger@queued.net>
Cc: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ot200_bl.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/video/backlight/ot200_bl.c~backlight-add-driver-for-bachmanns-ot200-fix drivers/video/backlight/ot200_bl.c
--- a/drivers/video/backlight/ot200_bl.c~backlight-add-driver-for-bachmanns-ot200-fix
+++ a/drivers/video/backlight/ot200_bl.c
@@ -19,15 +19,15 @@
 static struct cs5535_mfgpt_timer *pwm_timer;
 
 /* this array defines the mapping of brightness in % to pwm frequency */
-static const  u8 dim_table[101] = {0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2,
-				   2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4,
-				   4, 5, 5, 5, 5, 6, 6, 6, 7, 7, 7, 8, 8, 9, 9,
-				   10, 10, 11, 11, 12, 12, 13, 14, 15, 15, 16,
-				   17, 18, 19, 20, 21, 22, 23, 24, 26, 27, 28,
-				   30, 31, 33, 35, 37, 39, 41, 43, 45, 47, 50,
-				   53, 55, 58, 61, 65, 68, 72, 75, 79, 84, 88,
-				   93, 97, 103, 108, 114, 120, 126, 133, 140,
-				   147, 155, 163};
+static const u8 dim_table[101] = {0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2,
+				  2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4,
+				  4, 5, 5, 5, 5, 6, 6, 6, 7, 7, 7, 8, 8, 9, 9,
+				  10, 10, 11, 11, 12, 12, 13, 14, 15, 15, 16,
+				  17, 18, 19, 20, 21, 22, 23, 24, 26, 27, 28,
+				  30, 31, 33, 35, 37, 39, 41, 43, 45, 47, 50,
+				  53, 55, 58, 61, 65, 68, 72, 75, 79, 84, 88,
+				  93, 97, 103, 108, 114, 120, 126, 133, 140,
+				  147, 155, 163};
 
 struct ot200_backlight_data {
 	int current_brightness;
@@ -51,7 +51,7 @@ static int ot200_backlight_update_status
 	/* enable or disable PWM timer */
 	if (brightness == 0)
 		cs5535_mfgpt_write(pwm_timer, MFGPT_REG_SETUP, 0);
-	else if (brightness != 0 && data->current_brightness == 0) {
+	else if (data->current_brightness == 0) {
 		cs5535_mfgpt_write(pwm_timer, MFGPT_REG_COUNTER, 0);
 		cs5535_mfgpt_write(pwm_timer, MFGPT_REG_SETUP,
 			MFGPT_SETUP_CNTEN);
_
Subject: Subject: backlight-add-driver-for-bachmanns-ot200-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-cpufreq-gx-suspmodc-fix-build.patch
mm-memcontrolc-fix-warning-with-config_numa=n.patch
mm-filemap_xipc-fix-race-condition-in-xip_file_fault-fix.patch
kprobes-fix-a-memory-leak-in-function-pre_handler_kretprobe-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
alix2-supplement-driver-to-include-gpio-button-support-fix.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer-fix.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
fs-btrfs-inode-mapc-fix-warnings.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
hpet-factor-timer-allocate-from-open.patch
thermal-thermal_sys-fix-build-warning-fix.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
mm.patch
make-swapin-readahead-skip-over-holes-fix.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-fix.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-checkpatch-fixes.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


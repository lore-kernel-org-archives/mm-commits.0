From: akpm@linux-foundation.org
Subject: + drivers-leds-leds-lp5523c-constify-some-data.patch added to -mm tree
Date: Tue, 31 Jan 2012 14:06:04 -0800
Message-ID: <20120131224847.13E2A20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:62149 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab2AaWst (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2012 17:48:49 -0500
Received: by eaaf1 with SMTP id f1so23808eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2012 14:48:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, rpurdie@rpsys.net


The patch titled
     Subject: drivers/leds/leds-lp5523.c: constify some data
has been added to the -mm tree.  Its filename is
     drivers-leds-leds-lp5523c-constify-some-data.patch

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
Subject: drivers/leds/leds-lp5523.c: constify some data

Saves ~50 bytes text and speeds things up.

Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp5523.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/leds/leds-lp5523.c~drivers-leds-leds-lp5523c-constify-some-data drivers/leds/leds-lp5523.c
--- a/drivers/leds/leds-lp5523.c~drivers-leds-leds-lp5523c-constify-some-data
+++ a/drivers/leds/leds-lp5523.c
@@ -152,7 +152,7 @@ static inline struct lp5523_chip *led_to
 
 static int lp5523_set_mode(struct lp5523_engine *engine, u8 mode);
 static int lp5523_set_engine_mode(struct lp5523_engine *engine, u8 mode);
-static int lp5523_load_program(struct lp5523_engine *engine, u8 *pattern);
+static int lp5523_load_program(struct lp5523_engine *engine, const u8 *pattern);
 
 static void lp5523_led_brightness_work(struct work_struct *work);
 
@@ -196,7 +196,7 @@ static int lp5523_configure(struct i2c_c
 	u8 status;
 
 	/* one pattern per engine setting led mux start and stop addresses */
-	u8 pattern[][LP5523_PROGRAM_LENGTH] =  {
+	static const u8 pattern[][LP5523_PROGRAM_LENGTH] =  {
 		{ 0x9c, 0x30, 0x9c, 0xb0, 0x9d, 0x80, 0xd8, 0x00, 0},
 		{ 0x9c, 0x40, 0x9c, 0xc0, 0x9d, 0x80, 0xd8, 0x00, 0},
 		{ 0x9c, 0x50, 0x9c, 0xd0, 0x9d, 0x80, 0xd8, 0x00, 0},
@@ -301,7 +301,7 @@ static int lp5523_load_mux(struct lp5523
 	return ret;
 }
 
-static int lp5523_load_program(struct lp5523_engine *engine, u8 *pattern)
+static int lp5523_load_program(struct lp5523_engine *engine, const u8 *pattern)
 {
 	struct lp5523_chip *chip = engine_to_lp5523(engine);
 	struct i2c_client *client = chip->client;
_
Subject: Subject: drivers/leds/leds-lp5523.c: constify some data

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
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
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
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
drivers-leds-leds-lp5523c-constify-some-data.patch


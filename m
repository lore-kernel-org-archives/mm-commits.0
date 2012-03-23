From: akpm@linux-foundation.org
Subject: [folded] prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch removed from -mm tree
Date: Fri, 23 Mar 2012 14:20:03 -0700
Message-ID: <20120323212003.AC6D9A00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:58607 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754431Ab2CWVUG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 Mar 2012 17:20:06 -0400
Received: by laai8 with SMTP id i8so187804laa.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:20:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Valdis.Kletnieks@vt.edu, kay.sievers@vrfy.org, lennart@poettering.net, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix
has been removed from the -mm tree.  Its filename was
     prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch

This patch was dropped because it was folded into prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix

add lengthy code comment from Oleg

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN kernel/exit.c~prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix kernel/exit.c
--- a/kernel/exit.c~prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix
+++ a/kernel/exit.c
@@ -725,7 +725,13 @@ static struct task_struct *find_new_reap
 	} else if (father->signal->has_child_subreaper) {
 		struct task_struct *reaper;
 
-		/* find the first ancestor marked as child_subreaper */
+		/*
+		 * Find the first ancestor marked as child_subreaper.
+		 * Note that the code below checks same_thread_group(reaper,
+		 * pid_ns->child_reaper).  This is what we need to DTRT in a
+		 * PID namespace. However we still need the check above, see
+		 * http://marc.info/?l=linux-kernel&m=131385460420380
+		 */
 		for (reaper = father->real_parent;
 		     reaper != &init_task;
 		     reaper = reaper->real_parent) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
kernel-watchdogc-convert-to-pr_foo.patch
kernel-watchdogc-add-comment-to-watchdog-exit-path.patch
backlight-use-id-driver_data-to-differentiate-lp855x-chips-fix.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch
leds-lm3530-replace-i2c_client-with-led_classdev-fix.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch


From: akpm@linux-foundation.org
Subject: [folded] procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 23 Mar 2012 14:33:03 -0700
Message-ID: <20120323213303.85F85A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:57671 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588Ab2CWVdJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 17:33:09 -0400
Received: by ggnd2 with SMTP id d2so566031ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:33:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch

This patch was dropped because it was folded into procfs-speed-up-proc-pid-stat-statm.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes

ERROR: space required after that ',' (ctx:VxV)
#116: FILE: fs/proc/array.c:465:
+	seq_printf(m,"%d (%s) %c", pid_nr_ns(pid, ns), tcomm, state);
 	            ^

ERROR: code indent should use tabs where possible
#145: FILE: fs/proc/array.c:494:
+ ^I * It must be decimal for Linux 2.0 compatibility.$

WARNING: please, no space before tabs
#145: FILE: fs/proc/array.c:494:
+ ^I * It must be decimal for Linux 2.0 compatibility.$

total: 2 errors, 1 warnings, 172 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/procfs-speed-up-proc-pid-stat-statm.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/array.c~procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes fs/proc/array.c
--- a/fs/proc/array.c~procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes
+++ a/fs/proc/array.c
@@ -462,7 +462,7 @@ static int do_task_stat(struct seq_file 
 	/* convert nsec -> ticks */
 	start_time = nsec_to_clock_t(start_time);
 
-	seq_printf(m,"%d (%s) %c", pid_nr_ns(pid, ns), tcomm, state);
+	seq_printf(m, "%d (%s) %c", pid_nr_ns(pid, ns), tcomm, state);
 	seq_put_decimal_ll(m, ' ', ppid);
 	seq_put_decimal_ll(m, ' ', pgid);
 	seq_put_decimal_ll(m, ' ', sid);
@@ -491,7 +491,7 @@ static int do_task_stat(struct seq_file 
 	seq_put_decimal_ull(m, ' ', esp);
 	seq_put_decimal_ull(m, ' ', eip);
 	/* The signal information here is obsolete.
- 	 * It must be decimal for Linux 2.0 compatibility.
+	 * It must be decimal for Linux 2.0 compatibility.
 	 * Use /proc/#/status for real-time signals.
 	 */
 	seq_put_decimal_ull(m, ' ', task->pending.signal.sig[0] & 0x7fffffffUL);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any.patch
kernel-watchdogc-convert-to-pr_foo.patch
kernel-watchdogc-add-comment-to-watchdog-exit-path.patch
backlight-use-id-driver_data-to-differentiate-lp855x-chips.patch
backlight-add-driver-for-bachmanns-ot200.patch
leds-lp5521-support-led-pattern-data.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip.patch
leds-lm3530-replace-i2c_client-with-led_classdev.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation.patch
rtc-rtc-driver-for-da9052-53-pmic-v1.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump.patch
procfs-add-num_to_str-to-speed-up-proc-stat.patch
procfs-speed-up-proc-pid-stat-statm.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch


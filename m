From: akpm@linux-foundation.org
Subject: + procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch added to -mm tree
Date: Tue, 31 Jan 2012 12:34:39 -0800
Message-ID: <20120131203440.4A997A016E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:45603 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab2AaUel (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2012 15:34:41 -0500
Received: by yhgm50 with SMTP id m50so54729yhg.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2012 12:34:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     Subject: procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch

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
Subject: Subject: procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-memcontrolc-fix-warning-with-config_numa=n.patch
mm-filemap_xipc-fix-race-condition-in-xip_file_fault-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
alix2-supplement-driver-to-include-gpio-button-support-fix.patch
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


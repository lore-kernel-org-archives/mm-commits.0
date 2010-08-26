From: akpm@linux-foundation.org
Subject: + select-rename-estimate_accuracy-to-select_estimate_accuracy.patch added to -mm tree
Date: Thu, 26 Aug 2010 15:32:10 -0700
Message-ID: <201008262232.o7QMWAlj018542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754447Ab0HZWcR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Aug 2010 18:32:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, davidel@xmailserver.org, shawn.bohrer@gmail.com, tglx@linutronix.de, viro@zeniv.linux.org.uk


The patch titled
     select: rename estimate_accuracy() to select_estimate_accuracy()
has been added to the -mm tree.  Its filename is
     select-rename-estimate_accuracy-to-select_estimate_accuracy.patch

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
Subject: select: rename estimate_accuracy() to select_estimate_accuracy()
From: Andrew Morton <akpm@linux-foundation.org>

Make it a subsystem-specific identifier because we wish to amke it
non-static in the next patch ("epoll: make epoll_wait() use the hrtimer
range feature").  

Cc: Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/select.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/select.c~select-rename-estimate_accuracy-to-select_estimate_accuracy fs/select.c
--- a/fs/select.c~select-rename-estimate_accuracy-to-select_estimate_accuracy
+++ a/fs/select.c
@@ -67,7 +67,7 @@ static long __estimate_accuracy(struct t
 	return slack;
 }
 
-static long estimate_accuracy(struct timespec *tv)
+static long select_estimate_accuracy(struct timespec *tv)
 {
 	unsigned long ret;
 	struct timespec now;
@@ -417,7 +417,7 @@ int do_select(int n, fd_set_bits *fds, s
 	}
 
 	if (end_time && !timed_out)
-		slack = estimate_accuracy(end_time);
+		slack = select_estimate_accuracy(end_time);
 
 	retval = 0;
 	for (;;) {
@@ -769,7 +769,7 @@ static int do_poll(unsigned int nfds,  s
 	}
 
 	if (end_time && !timed_out)
-		slack = estimate_accuracy(end_time);
+		slack = select_estimate_accuracy(end_time);
 
 	for (;;) {
 		struct poll_list *walk;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
cgroups-fix-api-thinko-fix.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-i915-intel_overlayc-needs-seq_fileh.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
usb-storage-add-new-no_read_disc_info-quirk-fix.patch
mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled-cleanup.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
sdhci-support-10-bit-divided-clock-mode-for-spec-30-checkpatch-fixes.patch
sdhci-get-rid-of-card-detect-work-fix.patch
checkpatch-returning-errno-typically-should-be-negative.patch
select-rename-estimate_accuracy-to-select_estimate_accuracy.patch
cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2-checkpatch-fixes.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-cleanups.patch
kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch


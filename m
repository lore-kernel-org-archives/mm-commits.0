From: akpm@linux-foundation.org
Subject: + ratelimit-add-comment-warning-people-off-printk_ratelimit.patch added to -mm tree
Date: Tue, 26 Oct 2010 12:07:24 -0700
Message-ID: <201010261907.o9QJ7Ole009956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753766Ab0JZTIL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Oct 2010 15:08:11 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id o9QJ7OJu020160
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 26 Oct 2010 12:07:24 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     ratelimit: add comment warning people off printk_ratelimit()
has been added to the -mm tree.  Its filename is
     ratelimit-add-comment-warning-people-off-printk_ratelimit.patch

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
Subject: ratelimit: add comment warning people off printk_ratelimit()
From: Andrew Morton <akpm@linux-foundation.org>

printk_ratelimit() was a bad idea - we don't want subsytem A causing
ratelimiting of subsystem B's messages.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN include/linux/kernel.h~ratelimit-add-comment-warning-people-off-printk_ratelimit include/linux/kernel.h
--- a/include/linux/kernel.h~ratelimit-add-comment-warning-people-off-printk_ratelimit
+++ a/include/linux/kernel.h
@@ -277,6 +277,11 @@ asmlinkage int vprintk(const char *fmt, 
 asmlinkage int printk(const char * fmt, ...)
 	__attribute__ ((format (printf, 1, 2))) __cold;
 
+/*
+ * Please don't use printk_ratelimit(), because it shares ratelimiting state
+ * with all other unrelated printk_ratelimit() callsites.  Instead use
+ * printk_ratelimited() or plain old __ratelimit().
+ */
 extern int __printk_ratelimit(const char *func);
 #define printk_ratelimit() __printk_ratelimit(__func__)
 extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
typesh-move-misplaced-comment.patch
kfifo-disable-__kfifo_must_check_helper.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled.patch
memory-hotplug-unify-is_removable-and-offline-detection-code.patch
mm-stack-based-kmap_atomic.patch
mm-retry-page-fault-when-blocking-on-disk-transfer.patch
vmstat-include-compactionh-when-config_compaction.patch
fs-fs-writebackc-restore-lost-comment.patch
mm-memory_hotplugc-make-scan_lru_pages-static.patch
proc-swaps-support-polling.patch
drivers-char-hpetc-fix-information-leak-to-userland.patch
kernelh-add-minmax3-macros.patch
include-linux-kernelh-add-__must_check-to-strict_strto.patch
workqueues-s-on_stack-onstack.patch
isl29020-ambient-light-sensor.patch
drivers-misc-apds9802alsc-add-runtime-pm-support.patch
printk-declare-printk_ratelimit_state-in-ratelimith.patch
vsprintfc-use-default-pointer-field-size-for-null-strings-fix.patch
scripts-get_maintainerpl-add-git-blame-rolestats-authored-lines-information.patch
idr-fix-idr_pre_get-locking-description-fix.patch
percpu_counter-rename-__percpu_counter_add-to-percpu_counter_add_batch.patch
percpu_counters-inline-the-percpu_counter_add_batch-fastpath.patch
percpu_counters-inline-the-percpu_counter_add_batch-fastpath-fix.patch
checkpatch-returning-errno-typically-should-be-negative.patch
select-rename-estimate_accuracy-to-select_estimate_accuracy.patch
vcs-add-poll-fasync-support-fix-fix.patch
rtc-rtc-s3c-fix-access-unit-from-byte-to-word-on-rtccon-checkpatch-fixes.patch
drivers-rtc-rtc-jz4740c-add-alarm-function-checkpatch-fixes.patch
gpio-add-support-for-74x164-serial-in-parallel-out-8-bit-shift-register-fix.patch
gpio-add-topcliff-pch-gpio-driver-fix.patch
drivers-gpio-langwell_gpioc-remove-semicolons-after-function-definitions.patch
cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes.patch
memcg-cpu-hotplug-aware-quick-acount_move-detection-checkpatch-fixes.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2-checkpatch-fixes.patch
proc-stat-fix-scalability-of-irq-sum-of-all-cpu-fix.patch
drivers-char-hvc_consolec-remove-unneeded-__set_current_statetask_running.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
fuse-use-release_pages.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-fix.patch
kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource.patch
ramoops-use-the-platform-data-structure-instead-of-module-params-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch
ratelimit-add-comment-warning-people-off-printk_ratelimit.patch


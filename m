From: akpm@linux-foundation.org
Subject: + proc-stat-fix-scalability-of-irq-sum-of-all-cpu-fix-2.patch added to -mm tree
Date: Wed, 27 Oct 2010 13:34:25 -0700
Message-ID: <201010272106.o9RL6FCt018140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932194Ab0J0VHD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Oct 2010 17:07:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, mingo@elte.hu, steiner@sgi.com, tglx@linutronix.de, yinghai@kernel.org


The patch titled
     proc-stat-fix-scalability-of-irq-sum-of-all-cpu-fix-2
has been added to the -mm tree.  Its filename is
     proc-stat-fix-scalability-of-irq-sum-of-all-cpu-fix-2.patch

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
Subject: proc-stat-fix-scalability-of-irq-sum-of-all-cpu-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

fs/proc/stat.c: In function 'show_stat':
fs/proc/stat.c:34: warning: unused variable 'per_irq_sum'

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jack Steiner <steiner@sgi.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/stat.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/proc/stat.c~proc-stat-fix-scalability-of-irq-sum-of-all-cpu-fix-2 fs/proc/stat.c
--- a/fs/proc/stat.c~proc-stat-fix-scalability-of-irq-sum-of-all-cpu-fix-2
+++ a/fs/proc/stat.c
@@ -31,7 +31,6 @@ static int show_stat(struct seq_file *p,
 	u64 sum_softirq = 0;
 	unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
 	struct timespec boottime;
-	unsigned int per_irq_sum;
 
 	user = nice = system = idle = iowait =
 		irq = softirq = steal = cputime64_zero;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
vcs-add-poll-fasync-support-fix-fix.patch
rtc-rtc-s3c-fix-access-unit-from-byte-to-word-on-rtccon-checkpatch-fixes.patch
drivers-rtc-rtc-jz4740c-add-alarm-function-checkpatch-fixes.patch
gpio-add-support-for-74x164-serial-in-parallel-out-8-bit-shift-register-fix.patch
gpio-add-topcliff-pch-gpio-driver-fix.patch
drivers-gpio-langwell_gpioc-remove-semicolons-after-function-definitions.patch
cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes.patch
memcg-cpu-hotplug-aware-quick-acount_move-detection-checkpatch-fixes.patch
ptrace-cleanup-arch_ptrace-on-x86-fix.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2-checkpatch-fixes.patch
proc-stat-fix-scalability-of-irq-sum-of-all-cpu-fix.patch
proc-stat-fix-scalability-of-irq-sum-of-all-cpu-fix-2.patch
drivers-char-hvc_consolec-remove-unneeded-__set_current_statetask_running.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
fuse-use-release_pages.patch
kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource.patch
ramoops-use-the-platform-data-structure-instead-of-module-params-fix.patch
select-rename-estimate_accuracy-to-select_estimate_accuracy.patch


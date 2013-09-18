From: akpm@linux-foundation.org
Subject: + kernel-time-tick-commonc-document-tick_do_timer_cpu.patch added to -mm tree
Date: Wed, 18 Sep 2013 16:06:37 -0700
Message-ID: <523a31fd.cMe6u7Rn39UHkq6m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47857 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab3IRXGi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Sep 2013 19:06:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, akpm@linux-foundation.org

Subject: + kernel-time-tick-commonc-document-tick_do_timer_cpu.patch added to -mm tree
To: akpm@linux-foundation.org,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Wed, 18 Sep 2013 16:06:37 -0700


The patch titled
     Subject: kernel/time/tick-common.c: document tick_do_timer_cpu
has been added to the -mm tree.  Its filename is
     kernel-time-tick-commonc-document-tick_do_timer_cpu.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-time-tick-commonc-document-tick_do_timer_cpu.patch

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
Subject: kernel/time/tick-common.c: document tick_do_timer_cpu

Taken straight from a tglx email ;)

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-common.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN kernel/time/tick-common.c~kernel-time-tick-commonc-document-tick_do_timer_cpu kernel/time/tick-common.c
--- a/kernel/time/tick-common.c~kernel-time-tick-commonc-document-tick_do_timer_cpu
+++ a/kernel/time/tick-common.c
@@ -33,6 +33,21 @@ DEFINE_PER_CPU(struct tick_device, tick_
  */
 ktime_t tick_next_period;
 ktime_t tick_period;
+
+/*
+ * tick_do_timer_cpu is a timer core internal variable which holds the CPU NR
+ * which is responsible for calling do_timer(), i.e. the timekeeping stuff. This
+ * variable has two functions:
+ *
+ * 1) Prevent a thundering herd issue of a gazillion of CPUs trying to grab the
+ *    timekeeping lock all at once. Only the CPU which is assigned to do the
+ *    update is handling it.
+ *
+ * 2) Hand off the duty in the NOHZ idle case by setting the value to
+ *    TICK_DO_TIMER_NONE, i.e. a non existing CPU. So the next cpu which looks
+ *    at it will take over and keep the time keeping alive.  The handover
+ *    procedure also covers cpu hotplug.
+ */
 int tick_do_timer_cpu __read_mostly = TICK_DO_TIMER_BOOT;
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
revert-memcg-track-all-children-over-limit-in-the-root.patch
revert-memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
revert-memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
revert-memcg-enhance-memcg-iterator-to-support-predicates.patch
revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
revert-memcg-get-rid-of-soft-limit-tree-infrastructure.patch
revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
mm-vmalloc-revert-mm-vmallocc-emit-the-failure-message-before-return-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
fat-additions-to-support-fat_fallocate-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-gcov-fsc-use-pr_warn.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


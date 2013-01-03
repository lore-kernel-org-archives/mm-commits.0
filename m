From: akpm@linux-foundation.org
Subject: + kernel-auditc-avoid-negative-sleep-durations.patch added to -mm tree
Date: Thu, 03 Jan 2013 14:20:35 -0800
Message-ID: <20130103222036.2B110200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:64468 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab3ACWUj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jan 2013 17:20:39 -0500
Received: by mail-we0-f202.google.com with SMTP id t57so982827wey.3
        for <mm-commits@vger.kernel.org>; Thu, 03 Jan 2013 14:20:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, davej@redhat.com, eparis@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: kernel/audit.c: avoid negative sleep durations
has been added to the -mm tree.  Its filename is
     kernel-auditc-avoid-negative-sleep-durations.patch

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
Subject: kernel/audit.c: avoid negative sleep durations

audit_log_start() performs the same jiffies comparison in two places.  If
sufficient time has elapsed between the two comparisons, the second one
produces a negative sleep duration:

schedule_timeout: wrong timeout value fffffffffffffff0
Pid: 6606, comm: trinity-child1 Not tainted 3.8.0-rc1+ #43
Call Trace:
 [<ffffffff81698415>] schedule_timeout+0x305/0x340
 [<ffffffff8169ae82>] ? preempt_schedule+0x42/0x60
 [<ffffffff8169cb65>] ? _raw_spin_unlock_irqrestore+0x75/0x80
 [<ffffffff810dc461>] audit_log_start+0x311/0x470
 [<ffffffff8106c62c>] ? __rcu_read_unlock+0x5c/0xa0
 [<ffffffff81086120>] ? try_to_wake_up+0x320/0x320
 [<ffffffff810e0d0b>] audit_log_exit+0x4b/0xfb0
 [<ffffffff81156e1b>] ? vm_mmap_pgoff+0x8b/0xb0
 [<ffffffff810b2342>] ? get_lock_stats+0x22/0x70
 [<ffffffff810b27ae>] ? put_lock_stats.isra.23+0xe/0x40
 [<ffffffff810b2ecb>] ? lock_release_holdtime.part.24+0xcb/0x130
 [<ffffffff81075f93>] ? up_write+0x23/0x40
 [<ffffffff81156e1b>] ? vm_mmap_pgoff+0x8b/0xb0
 [<ffffffff816a4afc>] ? sysret_signal+0x5/0x47
 [<ffffffff810e3d3f>] __audit_syscall_exit+0x25f/0x2c0
 [<ffffffff816a4bad>] sysret_audit+0x17/0x21

Fix it by performing the comparison a single time.

Reported-by: Dave Jones <davej@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit.c |   36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff -puN kernel/audit.c~kernel-auditc-avoid-negative-sleep-durations kernel/audit.c
--- a/kernel/audit.c~kernel-auditc-avoid-negative-sleep-durations
+++ a/kernel/audit.c
@@ -1101,6 +1101,23 @@ static inline void audit_get_stamp(struc
 	}
 }
 
+/*
+ * Wait for auditd to drain the queue a little
+ */
+static void wait_for_auditd(unsigned long sleep_time)
+{
+	DECLARE_WAITQUEUE(wait, current);
+	set_current_state(TASK_INTERRUPTIBLE);
+	add_wait_queue(&audit_backlog_wait, &wait);
+
+	if (audit_backlog_limit &&
+	    skb_queue_len(&audit_skb_queue) > audit_backlog_limit)
+		schedule_timeout(sleep_time);
+
+	__set_current_state(TASK_RUNNING);
+	remove_wait_queue(&audit_backlog_wait, &wait);
+}
+
 /* Obtain an audit buffer.  This routine does locking to obtain the
  * audit buffer, but then no locking is required for calls to
  * audit_log_*format.  If the tsk is a task that is currently in a
@@ -1146,20 +1163,13 @@ struct audit_buffer *audit_log_start(str
 
 	while (audit_backlog_limit
 	       && skb_queue_len(&audit_skb_queue) > audit_backlog_limit + reserve) {
-		if (gfp_mask & __GFP_WAIT && audit_backlog_wait_time
-		    && time_before(jiffies, timeout_start + audit_backlog_wait_time)) {
-
-			/* Wait for auditd to drain the queue a little */
-			DECLARE_WAITQUEUE(wait, current);
-			set_current_state(TASK_INTERRUPTIBLE);
-			add_wait_queue(&audit_backlog_wait, &wait);
-
-			if (audit_backlog_limit &&
-			    skb_queue_len(&audit_skb_queue) > audit_backlog_limit)
-				schedule_timeout(timeout_start + audit_backlog_wait_time - jiffies);
+		if (gfp_mask & __GFP_WAIT && audit_backlog_wait_time) {
+			unsigned long sleep_time;
 
-			__set_current_state(TASK_RUNNING);
-			remove_wait_queue(&audit_backlog_wait, &wait);
+			sleep_time = timeout_start + audit_backlog_wait_time -
+					jiffies;
+			if ((long)sleep_time > 0)
+				wait_for_auditd(sleep_time);
 			continue;
 		}
 		if (audit_rate_check() && printk_ratelimit())
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-message-queue-receive-cleanup.patch
ipc-convert-prepare_copy-from-macro-to-function.patch
rtc-add-rtc-driver-for-tps6586x-fix.patch
rtc-add-rtc-driver-for-tps6586x-fix2.patch
linux-next.patch
make-my-i386-build-work.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
i-need-old-gcc.patch
lib-cpu_rmap-avoid-flushing-all-workqueues-fix.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
kernel-auditc-avoid-negative-sleep-durations.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


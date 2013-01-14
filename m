From: akpm@linux-foundation.org
Subject: [merged] kernel-auditc-avoid-negative-sleep-durations.patch removed from -mm tree
Date: Mon, 14 Jan 2013 12:39:12 -0800
Message-ID: <20130114203912.C21C282004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:44716 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757312Ab3ANUjN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jan 2013 15:39:13 -0500
Received: by mail-ye0-f202.google.com with SMTP id r9so537397yen.5
        for <mm-commits@vger.kernel.org>; Mon, 14 Jan 2013 12:39:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davej@redhat.com, eparis@redhat.com, keescook@chromium.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/audit.c: avoid negative sleep durations
has been removed from the -mm tree.  Its filename was
     kernel-auditc-avoid-negative-sleep-durations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reviewed-by: Kees Cook <keescook@chromium.org>
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

origin.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
i-need-old-gcc.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-remove-flags-argument-to-mmap_region-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
kernel-smpc-cleanups.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-lms501kf03-lcd-driver-fix-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix.patch
rtc-add-support-for-spi-rtc-rx4581-checkpatch-fixes.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
aio-smoosh-struct-kiocb-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


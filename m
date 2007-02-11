From: akpm@linux-foundation.org
Subject: - _proc_do_string-fix-short-reads.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:55:26 -0800
Message-ID: <200702112255.l1BMtQav016320@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60642 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932888AbXBKWzx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:55:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ebiederm@xmission.com, mjt@tls.msk.ru, mm-commits@vger.kernel.org


The patch titled
     _proc_do_string(): fix short reads
has been removed from the -mm tree.  Its filename was
     _proc_do_string-fix-short-reads.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: _proc_do_string(): fix short reads
From: Oleg Nesterov <oleg@tv-sign.ru>

If you try to read things like /proc/sys/kernel/osrelease with single-byte
reads, you get just one byte and then EOF.  This is because _proc_do_string()
assumes that the caller is read()ing into a buffer which is large enough to
fit the whole string in a single hit.

Fix.

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN kernel/sysctl.c~_proc_do_string-fix-short-reads kernel/sysctl.c
--- a/kernel/sysctl.c~_proc_do_string-fix-short-reads
+++ a/kernel/sysctl.c
@@ -1686,13 +1686,12 @@ static int _proc_do_string(void* data, i
 	size_t len;
 	char __user *p;
 	char c;
-	
-	if (!data || !maxlen || !*lenp ||
-	    (*ppos && !write)) {
+
+	if (!data || !maxlen || !*lenp) {
 		*lenp = 0;
 		return 0;
 	}
-	
+
 	if (write) {
 		len = 0;
 		p = buffer;
@@ -1713,6 +1712,15 @@ static int _proc_do_string(void* data, i
 		len = strlen(data);
 		if (len > maxlen)
 			len = maxlen;
+
+		if (*ppos > len) {
+			*lenp = 0;
+			return 0;
+		}
+
+		data += *ppos;
+		len  -= *ppos;
+
 		if (len > *lenp)
 			len = *lenp;
 		if (len)
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
git-block.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch
posix-timers-rcu-optimization-for-clock_gettime.patch
posix-timers-rcu-optimization-for-clock_gettime-fix.patch
reimplement-flush_workqueue.patch
implement-flush_work.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
flush_cpu_workqueue-dont-flush-an-empty-worklist.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
slab-use-cpu_lock_.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
workqueue-kill-run_scheduled_work.patch
workqueue-dont-save-interrupts-in-run_workqueue.patch
workqueue-dont-save-interrupts-in-run_workqueue-update-2.patch
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
rework-compat_sys_io_submit.patch
fix-aioh-includes.patch
fix-access_ok-checks.patch
make-good_sigevent-non-static.patch
make-good_sigevent-non-static-fix.patch
make-__sigqueue_free-and.patch
aio-completion-signal-notification.patch
aio-completion-signal-notification-fix.patch
aio-completion-signal-notification-fixes-and-cleanups.patch
aio-completion-signal-notification-small-cleanup.patch
add-listio-syscall-support.patch
hotplug-allow-modules-to-use-the-cpu-hotplug-notifiers.patch

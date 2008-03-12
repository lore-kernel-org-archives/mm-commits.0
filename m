From: akpm@linux-foundation.org
Subject: - genhd-must_check-warning-fix.patch removed from -mm tree
Date: Tue, 11 Mar 2008 22:39:11 -0700
Message-ID: <200803120539.m2C5dBov012407@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751763AbYCLFkj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Mar 2008 01:40:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, greg@kroah.com, jeff@garzik.org, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     genhd must_check warning fix
has been removed from the -mm tree.  Its filename was
     genhd-must_check-warning-fix.patch

This patch was dropped because I already had it

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: genhd must_check warning fix
From: Roland McGrath <roland@redhat.com>

block/genhd.c:361: warning: ignoring return value of `class_register', declared with attribute warn_unused_result

Signed-off-by: Roland McGrath <roland@redhat.com>
Acked-by: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN block/genhd.c~genhd-must_check-warning-fix block/genhd.c
--- a/block/genhd.c~genhd-must_check-warning-fix
+++ a/block/genhd.c
@@ -360,7 +360,9 @@ static struct kobject *base_probe(dev_t 
 
 static int __init genhd_device_init(void)
 {
-	class_register(&block_class);
+	int error = class_register(&block_class);
+	if (unlikely(error))
+		return error;
 	bdev_map = kobj_map_init(base_probe, &block_class_lock);
 	blk_dev_init();
 
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
git-x86.patch
arch-x86-kernel-ptracec-fix-defined-but-unused-warnings.patch
genhd-must_check-warning-fix.patch
add-rusage_thread.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-do_signal_stop-use-signal_group_exit.patch
signals-do_group_exit-use-signal_group_exit-more-consistently.patch
lock_task_sighand-add-rcu-lock-unlock.patch
k_getrusage-dont-take-rcu_read_lock.patch
do_task_stat-dont-take-rcu_read_lock.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
signals-re-assign-cld_continued-notification-from-the-sender-to-reciever.patch
kill_pid_info-dont-take-now-unneeded-tasklist_lock.patch
handle_stop_signal-unify-partial-full-stop-handling.patch
handle_stop_signal-use-the-cached-p-signal-value.patch
get_signal_to_deliver-use-the-cached-signal-sighand-values.patch
signals-send_sigqueue-dont-take-rcu-lock.patch
signals-send_sigqueue-dont-forget-about-handle_stop_signal.patch
signals-__group_complete_signal-cache-the-value-of-p-signal.patch
signals-send_group_sigqueue-dont-take-tasklist_lock.patch
signals-move-handle_stop_signal-into-send_signal.patch
signals-do_tkill-dont-use-tasklist_lock.patch
signals-do_tkill-dont-use-tasklist_lock-comment.patch
signals-send_sig_info-dont-take-tasklist_lock.patch
signals-microoptimize-the-usage-of-curr_target.patch
signals-move-the-definition-of-__group_complete_signal-up.patch
signals-change-send_signal-do_send_sigqueue-to-take-boolean-group-parameter.patch
signals-use-__group_complete_signal-for-the-specific-signals-too.patch
signals-fold-complete_signal-into-send_signal-do_send_sigqueue.patch
signals-unify-send_sigqueue-send_group_sigqueue-completely.patch
signals-join-send_sigqueue-with-send_group_sigqueue.patch
signals-handle_stop_signal-dont-worry-about-sigkill.patch
signals-send_signal-factor-out-signal_group_exit-checks.patch
signals-fold-sig_ignored-into-prepare_signal.patch
signals-document-cld_continued-notification-mechanics.patch
signals-cleanup-the-usage-of-print_fatal_signal.patch
ptrace-introduce-task_detached-helper.patch
reparent_thread-use-same_thread_group.patch
document-de_thread-with-exit_notify-connection.patch
ptrace-introduce-ptrace_reparented-helper.patch
ptrace-__ptrace_unlink-use-the-ptrace_reparented-helper.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch


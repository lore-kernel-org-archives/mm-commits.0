From: akpm@osdl.org
Subject: + videobuf_qbuf-fix-possible-videobuf_queue-stream-corruption-and-lockup.patch added to -mm tree
Date: Wed, 24 Jan 2007 21:58:19 -0800
Message-ID: <200701250558.l0P5wJgi007448@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48701 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965365AbXAYF7w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 00:59:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, mchehab@infradead.org, stable@kernel.org


The patch titled
     videobuf_qbuf: fix videobuf_queue->stream corruption and lockup
has been added to the -mm tree.  Its filename is
     videobuf_qbuf-fix-possible-videobuf_queue-stream-corruption-and-lockup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: videobuf_qbuf: fix videobuf_queue->stream corruption and lockup
From: Oleg Nesterov <oleg@tv-sign.ru>

We are doing ->buf_prepare(buf) before adding buf to q->stream list. This
means that videobuf_qbuf() should not try to re-add a STATE_PREPARED buffer.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/media/video/video-buf.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/media/video/video-buf.c~videobuf_qbuf-fix-possible-videobuf_queue-stream-corruption-and-lockup drivers/media/video/video-buf.c
--- a/drivers/media/video/video-buf.c~videobuf_qbuf-fix-possible-videobuf_queue-stream-corruption-and-lockup
+++ a/drivers/media/video/video-buf.c
@@ -700,6 +700,7 @@ videobuf_qbuf(struct videobuf_queue *q,
 		goto done;
 	}
 	if (buf->state == STATE_QUEUED ||
+	    buf->state == STATE_PREPARED ||
 	    buf->state == STATE_ACTIVE) {
 		dprintk(1,"qbuf: buffer is already queued or active.\n");
 		goto done;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

videobuf_qbuf-fix-possible-videobuf_queue-stream-corruption-and-lockup.patch
git-block.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
vt-refactor-console-sak-processing.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
kill_pid_info-kill-acquired_tasklist_lock.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
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

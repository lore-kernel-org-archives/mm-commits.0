From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-use-spinlock-irqsave-for-downconvert-lock-in-ocfs2_osb_dump.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:53:02 -0700
Message-ID: <56e9b99e.YBcXdoB5+4v51TLe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38355 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933996AbcCPTxD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:53:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiangyiwen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: use spinlock_irqsave() to downconvert lock in ocfs2_osb_dump()
has been removed from the -mm tree.  Its filename was
     ocfs2-use-spinlock-irqsave-for-downconvert-lock-in-ocfs2_osb_dump.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: jiangyiwen <jiangyiwen@huawei.com>
Subject: ocfs2: use spinlock_irqsave() to downconvert lock in ocfs2_osb_dump()

commit a75e9ccabd92 ("ocfs2: use spinlock irqsave for downconvert lock")
missed an unmodified place in ocfs2_osb_dump(), so it still exists a
deadlock scenario.

    ocfs2_wake_downconvert_thread
    ocfs2_rw_unlock
    ocfs2_dio_end_io
    dio_complete
    .....
    bio_endio
    req_bio_endio
    ....
    scsi_io_completion
    blk_done_softirq
    __do_softirq
    do_softirq
    irq_exit
    do_IRQ
    ocfs2_osb_dump
    cat /sys/kernel/debug/ocfs2/${uuid}/fs_state

This patch still uses spin_lock_irqsave() - replace spin_lock() to solve
this situation.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/super.c~ocfs2-use-spinlock-irqsave-for-downconvert-lock-in-ocfs2_osb_dump fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-use-spinlock-irqsave-for-downconvert-lock-in-ocfs2_osb_dump
+++ a/fs/ocfs2/super.c
@@ -236,6 +236,7 @@ static int ocfs2_osb_dump(struct ocfs2_s
 	struct ocfs2_recovery_map *rm = osb->recovery_map;
 	struct ocfs2_orphan_scan *os = &osb->osb_orphan_scan;
 	int i, out = 0;
+	unsigned long flags;
 
 	out += snprintf(buf + out, len - out,
 			"%10s => Id: %-s  Uuid: %-s  Gen: 0x%X  Label: %-s\n",
@@ -271,14 +272,14 @@ static int ocfs2_osb_dump(struct ocfs2_s
 				cconn->cc_version.pv_minor);
 	}
 
-	spin_lock(&osb->dc_task_lock);
+	spin_lock_irqsave(&osb->dc_task_lock, flags);
 	out += snprintf(buf + out, len - out,
 			"%10s => Pid: %d  Count: %lu  WakeSeq: %lu  "
 			"WorkSeq: %lu\n", "DownCnvt",
 			(osb->dc_task ?  task_pid_nr(osb->dc_task) : -1),
 			osb->blocked_lock_count, osb->dc_wake_sequence,
 			osb->dc_work_sequence);
-	spin_unlock(&osb->dc_task_lock);
+	spin_unlock_irqrestore(&osb->dc_task_lock, flags);
 
 	spin_lock(&osb->osb_lock);
 	out += snprintf(buf + out, len - out, "%10s => Pid: %d  Nodes:",
_

Patches currently in -mm which might be from jiangyiwen@huawei.com are

ocfs2-avoid-occurring-deadlock-by-changing-ocfs2_wq-from-global-to-local.patch
ocfs2-solve-a-problem-of-crossing-the-boundary-in-updating-backups.patch


From: akpm@linux-foundation.org
Subject: [merged]
 exit-release_task-fix-the-comment-about-group-leader-accounting.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 11:08:17 -0800
Message-ID: <5489eba1.52YC/SsVBlMTl4c5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46072 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbaLKTIS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:08:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, atomlin@redhat.com, ebiederm@xmission.com, riel@redhat.com, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: release_task: fix the comment about group leader accounting
has been removed from the -mm tree.  Its filename was
     exit-release_task-fix-the-comment-about-group-leader-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exit: release_task: fix the comment about group leader accounting

Contrary to what the comment in __exit_signal() says we do account the
group leader. Fix this and explain why.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sterling Alexander <stalexan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN kernel/exit.c~exit-release_task-fix-the-comment-about-group-leader-accounting kernel/exit.c
--- a/kernel/exit.c~exit-release_task-fix-the-comment-about-group-leader-accounting
+++ a/kernel/exit.c
@@ -118,13 +118,10 @@ static void __exit_signal(struct task_st
 	}
 
 	/*
-	 * Accumulate here the counters for all threads but the group leader
-	 * as they die, so they can be added into the process-wide totals
-	 * when those are taken.  The group leader stays around as a zombie as
-	 * long as there are other threads.  When it gets reaped, the exit.c
-	 * code will add its counts into these totals.  We won't ever get here
-	 * for the group leader, since it will have been the last reference on
-	 * the signal_struct.
+	 * Accumulate here the counters for all threads as they die. We could
+	 * skip the group leader because it is the last user of signal_struct,
+	 * but we want to avoid the race with thread_group_cputime() which can
+	 * see the empty ->thread_head list.
 	 */
 	task_cputime(tsk, &utime, &stime);
 	write_seqlock(&sig->stats_lock);
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
remove-unnecessary-is_valid_nodemask.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2-fix.patch
oom-kill-the-insufficient-and-no-longer-needed-pt_trace_exit-check.patch
linux-next.patch
all-arches-signal-move-restart_block-to-struct-task_struct.patch


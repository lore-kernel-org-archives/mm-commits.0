From: akpm@linux-foundation.org
Subject: - sched-reorder-signal_struct-to-remove-8-bytes-on-64-bit-builds.patch removed from -mm tree
Date: Tue, 26 Aug 2008 11:45:02 -0700
Message-ID: <200808261845.m7QIj2tO021367@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757210AbYHZSx5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 14:53:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@rsk.demon.co.uk, a.p.zijlstra@chello.nl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     sched: reorder signal_struct to remove 8 bytes on 64 bit builds
has been removed from the -mm tree.  Its filename was
     sched-reorder-signal_struct-to-remove-8-bytes-on-64-bit-builds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sched: reorder signal_struct to remove 8 bytes on 64 bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>

reorder structure to remove 8 bytes of padding on 64 bit builds

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/sched.h~sched-reorder-signal_struct-to-remove-8-bytes-on-64-bit-builds include/linux/sched.h
--- a/include/linux/sched.h~sched-reorder-signal_struct-to-remove-8-bytes-on-64-bit-builds
+++ a/include/linux/sched.h
@@ -451,8 +451,8 @@ struct signal_struct {
 	 * - everyone except group_exit_task is stopped during signal delivery
 	 *   of fatal signals, group_exit_task processes the signal.
 	 */
-	struct task_struct	*group_exit_task;
 	int			notify_count;
+	struct task_struct	*group_exit_task;
 
 	/* thread group stop support, overloads group_exit_code too */
 	int			group_stop_count;
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

linux-next.patch
hrtimer-reorder-struct-hrtimer-to-save-8-bytes-on-64-bit-builds.patch


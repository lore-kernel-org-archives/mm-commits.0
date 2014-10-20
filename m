From: akpm@linux-foundation.org
Subject: [to-be-updated]
 freezer-remove-obsolete-comments-in-__thaw_task.patch removed from -mm tree
Date: Mon, 20 Oct 2014 13:58:56 -0700
Message-ID: <54457790.kGtb8WSZgUFU2mnb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56744 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbaJTU64 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Oct 2014 16:58:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, mhocko@suse.cz, oleg@redhat.com, rientjes@google.com, rjw@rjwysocki.net, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: freezer: remove obsolete comments in __thaw_task()
has been removed from the -mm tree.  Its filename was
     freezer-remove-obsolete-comments-in-__thaw_task.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: freezer: remove obsolete comments in __thaw_task()

__thaw_task() no longer clears frozen flag since commit a3201227f803
("freezer: make freezing() test freeze conditions in effect instead of
TIF_FREEZE").

Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/freezer.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN kernel/freezer.c~freezer-remove-obsolete-comments-in-__thaw_task kernel/freezer.c
--- a/kernel/freezer.c~freezer-remove-obsolete-comments-in-__thaw_task
+++ a/kernel/freezer.c
@@ -161,12 +161,6 @@ void __thaw_task(struct task_struct *p)
 {
 	unsigned long flags;
 
-	/*
-	 * Clear freezing and kick @p if FROZEN.  Clearing is guaranteed to
-	 * be visible to @p as waking up implies wmb.  Waking up inside
-	 * freezer_lock also prevents wakeups from leaking outside
-	 * refrigerator.
-	 */
 	spin_lock_irqsave(&freezer_lock, flags);
 	if (frozen(p))
 		wake_up_process(p);
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

oom-pm-oom-killed-task-cannot-escape-pm-suspend.patch
oom-pm-oom-killed-task-cannot-escape-pm-suspend-v2.patch
linux-next.patch


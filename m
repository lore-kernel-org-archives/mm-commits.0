From: akpm@linux-foundation.org
Subject: - pid_ns-kill-the-now-unused-task_child_reaper.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:19:16 -0700
Message-ID: <200810182319.m9INJGJp029452@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322AbYJRXTX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:19:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, serue@us.ibm.com, sukadev@linux.vnet.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     pid_ns: kill the now unused task_child_reaper()
has been removed from the -mm tree.  Its filename was
     pid_ns-kill-the-now-unused-task_child_reaper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pid_ns: kill the now unused task_child_reaper()
From: Oleg Nesterov <oleg@tv-sign.ru>

task_child_reaper() has no callers anymore, kill it.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid_namespace.h |    6 ------
 1 file changed, 6 deletions(-)

diff -puN include/linux/pid_namespace.h~pid_ns-kill-the-now-unused-task_child_reaper include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~pid_ns-kill-the-now-unused-task_child_reaper
+++ a/include/linux/pid_namespace.h
@@ -84,12 +84,6 @@ static inline struct pid_namespace *task
 	return tsk->nsproxy->pid_ns;
 }
 
-static inline struct task_struct *task_child_reaper(struct task_struct *tsk)
-{
-	BUG_ON(tsk != current);
-	return tsk->nsproxy->pid_ns->child_reaper;
-}

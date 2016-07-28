From: akpm@linux-foundation.org
Subject: [patch 015/101] freezer, oom: check TIF_MEMDIE on the correct
 task
Date: Thu, 28 Jul 2016 15:45:16 -0700
Message-ID: <579a8afc.HymOGq5qjFxq6IxO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56636 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbcG1WpR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:45:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, miaox@cn.fujitsu.com, miaoxie@huawei.com, rientjes@google.com, rjw@rjwysocki.net

From: Michal Hocko <mhocko@suse.com>
Subject: freezer, oom: check TIF_MEMDIE on the correct task

freezing_slow_path() is checking TIF_MEMDIE to skip OOM killed tasks.  It
is, however, checking the flag on the current task rather than the given
one.  This is really confusing because freezing() can be called also on
!current tasks.  It would end up working correctly for its main purpose
because __refrigerator will be always called on the current task so the
oom victim will never get frozen.  But it could lead to surprising results
when a task which is freezing a cgroup got oom killed because only part of
the cgroup would get frozen.  This is highly unlikely but worth fixing as
the resulting code would be more clear anyway.

Link: http://lkml.kernel.org/r/1467029719-17602-2-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: Miao Xie <miaoxie@huawei.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/freezer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/freezer.c~freezer-oom-check-tif_memdie-on-the-correct-task kernel/freezer.c
--- a/kernel/freezer.c~freezer-oom-check-tif_memdie-on-the-correct-task
+++ a/kernel/freezer.c
@@ -42,7 +42,7 @@ bool freezing_slow_path(struct task_stru
 	if (p->flags & (PF_NOFREEZE | PF_SUSPEND_TASK))
 		return false;
 
-	if (test_thread_flag(TIF_MEMDIE))
+	if (test_tsk_thread_flag(p, TIF_MEMDIE))
 		return false;
 
 	if (pm_nosig_freezing || cgroup_freezing(p))
_

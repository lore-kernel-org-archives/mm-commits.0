From: akpm@linux-foundation.org
Subject: [patch 016/101] cpuset, mm: fix TIF_MEMDIE check in
 cpuset_change_task_nodemask
Date: Thu, 28 Jul 2016 15:45:19 -0700
Message-ID: <579a8aff.1CVvDoOWsED4VaIl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56643 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbcG1WpU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:45:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, miaox@cn.fujitsu.com, miaoxie@huawei.com, rientjes@google.com, rjw@rjwysocki.net

From: Michal Hocko <mhocko@suse.com>
Subject: cpuset, mm: fix TIF_MEMDIE check in cpuset_change_task_nodemask

c0ff7453bb5c ("cpuset,mm: fix no node to alloc memory when changing
cpuset's mems") has added TIF_MEMDIE and PF_EXITING check but it is
checking the flag on the current task rather than the given one.  This
doesn't make much sense and it is actually wrong.  If the current task
which updates the nodemask of a cpuset got killed by the OOM killer then a
part of the cpuset cgroup processes would have incompatible nodemask which
is surprising to say the least.

The comment suggests the intention was to skip oom victim or an exiting
task so we should be checking the given task.  But even then it would be
layering violation because it is the memory allocator to interpret the
TIF_MEMDIE meaning.  Simply drop both checks.  All tasks in the cpuset
should simply follow the same mask.

Link: http://lkml.kernel.org/r/1467029719-17602-3-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: Miao Xie <miaoxie@huawei.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN kernel/cpuset.c~cpuset-mm-fix-tif_memdie-check-in-cpuset_change_task_nodemask kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-mm-fix-tif_memdie-check-in-cpuset_change_task_nodemask
+++ a/kernel/cpuset.c
@@ -1034,15 +1034,6 @@ static void cpuset_change_task_nodemask(
 {
 	bool need_loop;
 
-	/*
-	 * Allow tasks that have access to memory reserves because they have
-	 * been OOM killed to get memory anywhere.
-	 */
-	if (unlikely(test_thread_flag(TIF_MEMDIE)))
-		return;
-	if (current->flags & PF_EXITING) /* Let dying task have memory */
-		return;

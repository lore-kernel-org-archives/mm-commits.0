From: akpm@linux-foundation.org
Subject: + oom-move-oom_adj-value-from-task_struct-to-mm_struct-fix.patch added to -mm tree
Date: Tue, 02 Jun 2009 21:57:19 -0700
Message-ID: <200906030457.n534vJ0X007555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751354AbZFCE5c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jun 2009 00:57:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com


The patch titled
     oom-move-oom_adj-value-from-task_struct-to-mm_struct fix
has been added to the -mm tree.  Its filename is
     oom-move-oom_adj-value-from-task_struct-to-mm_struct-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom-move-oom_adj-value-from-task_struct-to-mm_struct fix
From: David Rientjes <rientjes@google.com>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/android/lowmemorykiller.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/staging/android/lowmemorykiller.c~oom-move-oom_adj-value-from-task_struct-to-mm_struct-fix drivers/staging/android/lowmemorykiller.c
--- a/drivers/staging/android/lowmemorykiller.c~oom-move-oom_adj-value-from-task_struct-to-mm_struct-fix
+++ a/drivers/staging/android/lowmemorykiller.c
@@ -96,19 +96,21 @@ static int lowmem_shrink(int nr_to_scan,
 
 	read_lock(&tasklist_lock);
 	for_each_process(p) {
+		struct mm_struct *mm;
 		int oom_adj;
 
 		task_lock(p);
-		if (!p->mm) {
+		mm = p->mm;
+		if (!mm) {
 			task_unlock(p);
 			continue;
 		}
-		oom_adj = p->oomkilladj;
+		oom_adj = mm->oom_adj;
 		if (oom_adj < min_adj) {
 			task_unlock(p);
 			continue;
 		}
-		tasksize = get_mm_rss(p->mm);
+		tasksize = get_mm_rss(mm);
 		task_unlock(p);
 		if (tasksize <= 0)
 			continue;
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
cpusets-restructure-the-function-cpuset_update_task_memory_state.patch
cpusets-update-tasks-page-slab-spread-flags-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time-fix.patch
cpusetmm-update-tasks-mems_allowed-in-time-cleanup.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths-do-not-override-definition-of-node_set_online-with-macro.patch
mm-setup_per_zone_inactive_ratio-do-not-call-for-int_sqrt-if-not-needed.patch
mm-setup_per_zone_inactive_ratio-fix-comment-and-make-it-__init.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch
oom-move-oom_adj-value-from-task_struct-to-mm_struct-fix.patch
oom-avoid-unnecessary-mm-locking-and-scanning-for-oom_disable.patch
memcg-add-file-based-rss-accounting.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch


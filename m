From: akpm@linux-foundation.org
Subject: [merged] cls_cgroup-read-classid-atomically-in-classifier.patch removed from -mm tree
Date: Thu, 28 May 2009 12:27:03 -0700
Message-ID: <200905281927.n4SJR3mG002672@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763611AbZE1T1o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 15:27:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, lizf@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     cls_cgroup: read classid atomically in classifier
has been removed from the -mm tree.  Its filename was
     cls_cgroup-read-classid-atomically-in-classifier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cls_cgroup: read classid atomically in classifier
From: Paul Menage <menage@google.com>

Avoid reading the unsynchronized value cs->classid multiple times, since
it could change concurrently from non-zero to zero; this would result in
the classifier returning a positive result with a bogus (zero) classid.

Signed-off-by: Paul Menage <menage@google.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sched/cls_cgroup.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN net/sched/cls_cgroup.c~cls_cgroup-read-classid-atomically-in-classifier net/sched/cls_cgroup.c
--- a/net/sched/cls_cgroup.c~cls_cgroup-read-classid-atomically-in-classifier
+++ a/net/sched/cls_cgroup.c
@@ -98,8 +98,7 @@ static int cls_cgroup_classify(struct sk
 			       struct tcf_result *res)
 {
 	struct cls_cgroup_head *head = tp->root;
-	struct cgroup_cls_state *cs;
-	int ret = 0;
+	u32 classid;
 
 	/*
 	 * Due to the nature of the classifier it is required to ignore all
@@ -115,17 +114,18 @@ static int cls_cgroup_classify(struct sk
 		return -1;
 
 	rcu_read_lock();
-	cs = task_cls_state(current);
-	if (cs->classid && tcf_em_tree_match(skb, &head->ematches, NULL)) {
-		res->classid = cs->classid;
-		res->class = 0;
-		ret = tcf_exts_exec(skb, &head->exts, res);
-	} else
-		ret = -1;
-
+	classid = task_cls_state(current)->classid;
 	rcu_read_unlock();
 
-	return ret;
+	if (!classid)
+		return -1;
+
+	if (!tcf_em_tree_match(skb, &head->ematches, NULL))
+		return -1;
+
+	res->classid = classid;
+	res->class = 0;
+	return tcf_exts_exec(skb, &head->exts, res);
 }
 
 static unsigned long cls_cgroup_get(struct tcf_proto *tp, u32 handle)
_

Patches currently in -mm which might be from menage@google.com are

linux-next.patch
cpusets-restructure-the-function-cpuset_update_task_memory_state.patch
cpusets-update-tasks-page-slab-spread-flags-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time-fix.patch
cpusetmm-update-tasks-mems_allowed-in-time-cleanup.patch
cgroups-make-messages-more-readable.patch
memcg-add-file-based-rss-accounting.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch
add-a-refcount-check-in-dput.patch


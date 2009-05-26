From: akpm@linux-foundation.org
Subject: + cls_cgroup-read-classid-atomically-in-classifier.patch added to -mm tree
Date: Tue, 26 May 2009 14:02:22 -0700
Message-ID: <200905262102.n4QL2M8j002063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751857AbZEZVCe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 17:02:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, lizf@cn.fujitsu.com


The patch titled
     cls_cgroup: read classid atomically in classifier
has been added to the -mm tree.  Its filename is
     cls_cgroup-read-classid-atomically-in-classifier.patch

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
cls_cgroup-read-classid-atomically-in-classifier.patch
cpusets-restructure-the-function-cpuset_update_task_memory_state.patch
cpusets-update-tasks-page-slab-spread-flags-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time-fix.patch
cpusetmm-update-tasks-mems_allowed-in-time-cleanup.patch
cgroups-make-messages-more-readable.patch
memcg-add-file-based-rss-accounting.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch
add-a-refcount-check-in-dput.patch


From: akpm@linux-foundation.org
Subject: [merged]
 mm-add-a-helper-function-to-check-may-oom-condition.patch removed from -mm
 tree
Date: Wed, 13 Nov 2013 12:38:05 -0800
Message-ID: <5283e32d.GCVsYfZadSGXrtsS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42520 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3KMUiG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:38:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, h.huangqiang@huawei.com

Subject: [merged] mm-add-a-helper-function-to-check-may-oom-condition.patch removed from -mm tree
To: h.huangqiang@huawei.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:38:05 -0800


The patch titled
     Subject: mm: add a helper function to check may oom condition
has been removed from the -mm tree.  Its filename was
     mm-add-a-helper-function-to-check-may-oom-condition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qiang Huang <h.huangqiang@huawei.com>
Subject: mm: add a helper function to check may oom condition

Use helper function to check if we need to deal with oom condition.

Signed-off-by: Qiang Huang <h.huangqiang@huawei.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |    5 +++++
 mm/memcontrol.c     |    9 +--------
 mm/page_alloc.c     |    2 +-
 3 files changed, 7 insertions(+), 9 deletions(-)

diff -puN include/linux/oom.h~mm-add-a-helper-function-to-check-may-oom-condition include/linux/oom.h
--- a/include/linux/oom.h~mm-add-a-helper-function-to-check-may-oom-condition
+++ a/include/linux/oom.h
@@ -82,6 +82,11 @@ static inline void oom_killer_enable(voi
 	oom_killer_disabled = false;
 }
 
+static inline bool oom_gfp_allowed(gfp_t gfp_mask)
+{
+	return (gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY);
+}
+
 extern struct task_struct *find_lock_task_mm(struct task_struct *p);
 
 /* sysctls */
diff -puN mm/memcontrol.c~mm-add-a-helper-function-to-check-may-oom-condition mm/memcontrol.c
--- a/mm/memcontrol.c~mm-add-a-helper-function-to-check-may-oom-condition
+++ a/mm/memcontrol.c
@@ -2984,21 +2984,14 @@ static int memcg_charge_kmem(struct mem_
 	struct res_counter *fail_res;
 	struct mem_cgroup *_memcg;
 	int ret = 0;
-	bool may_oom;
 
 	ret = res_counter_charge(&memcg->kmem, size, &fail_res);
 	if (ret)
 		return ret;
 
-	/*
-	 * Conditions under which we can wait for the oom_killer. Those are
-	 * the same conditions tested by the core page allocator
-	 */
-	may_oom = (gfp & __GFP_FS) && !(gfp & __GFP_NORETRY);
-
 	_memcg = memcg;
 	ret = __mem_cgroup_try_charge(NULL, gfp, size >> PAGE_SHIFT,
-				      &_memcg, may_oom);
+				      &_memcg, oom_gfp_allowed(gfp));
 
 	if (ret == -EINTR)  {
 		/*
diff -puN mm/page_alloc.c~mm-add-a-helper-function-to-check-may-oom-condition mm/page_alloc.c
--- a/mm/page_alloc.c~mm-add-a-helper-function-to-check-may-oom-condition
+++ a/mm/page_alloc.c
@@ -2593,7 +2593,7 @@ rebalance:
 	 * running out of options and have to consider going OOM
 	 */
 	if (!did_some_progress) {
-		if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
+		if (oom_gfp_allowed(gfp_mask)) {
 			if (oom_killer_disabled)
 				goto nopage;
 			/* Coredumps can quickly deplete all memory reserves */
_

Patches currently in -mm which might be from h.huangqiang@huawei.com are

origin.patch


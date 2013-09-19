From: akpm@linux-foundation.org
Subject: + mm-add-a-helper-function-to-check-may-oom-condition.patch added to -mm tree
Date: Thu, 19 Sep 2013 16:10:18 -0700
Message-ID: <523b845a.+e9sgj95dMPUdTc7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58606 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab3ISXKT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Sep 2013 19:10:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, h.huangqiang@huawei.com

Subject: + mm-add-a-helper-function-to-check-may-oom-condition.patch added to -mm tree
To: h.huangqiang@huawei.com,rientjes@google.com
From: akpm@linux-foundation.org
Date: Thu, 19 Sep 2013 16:10:18 -0700


The patch titled
     Subject: mm: add a helper function to check may oom condition
has been added to the -mm tree.  Its filename is
     mm-add-a-helper-function-to-check-may-oom-condition.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-a-helper-function-to-check-may-oom-condition.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-a-helper-function-to-check-may-oom-condition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3008,21 +3008,14 @@ static int memcg_charge_kmem(struct mem_
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

mm-add-a-helper-function-to-check-may-oom-condition.patch


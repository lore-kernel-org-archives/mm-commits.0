From: akpm@linux-foundation.org
Subject: +
 mmoom-move-last-second-allocation-to-inside-the-oom-killer.patch added to
 -mm tree
Date: Mon, 27 Nov 2017 16:06:30 -0800
Message-ID: <5a1ca886.hFHFR/G09qaqu4ZF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48864 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752406AbdK1AGc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2017 19:06:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, aarcange@redhat.com, hannes@cmpxchg.org, mhocko@suse.com, mjaggi@caviumnetworks.com, oleg@redhat.com, rientjes@google.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,oom: move last second allocation to inside the OOM killer
has been added to the -mm tree.  Its filename is
     mmoom-move-last-second-allocation-to-inside-the-oom-killer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmoom-move-last-second-allocation-to-inside-the-oom-killer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmoom-move-last-second-allocation-to-inside-the-oom-killer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: mm,oom: move last second allocation to inside the OOM killer

Since selecting an OOM victim can take quite some time and the OOM
situation might be resolved meanwhile, sometimes doing last second
allocation attempt after selecting an OOM victim can succeed.

Therefore, this patch moves last second allocation attempt to after
selecting an OOM victim.  This patch is expected to reduce the time window
for potentially premature OOM killing considerably.

Link: http://lkml.kernel.org/r/1511607169-5084-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Suggested-by: Michal Hocko <mhocko@suse.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Manish Jaggi <mjaggi@caviumnetworks.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |   13 ++++++++++++
 mm/oom_kill.c       |   14 +++++++++++++
 mm/page_alloc.c     |   44 ++++++++++++++++++++++++------------------
 3 files changed, 53 insertions(+), 18 deletions(-)

diff -puN include/linux/oom.h~mmoom-move-last-second-allocation-to-inside-the-oom-killer include/linux/oom.h
--- a/include/linux/oom.h~mmoom-move-last-second-allocation-to-inside-the-oom-killer
+++ a/include/linux/oom.h
@@ -14,6 +14,8 @@ struct zonelist;
 struct notifier_block;
 struct mem_cgroup;
 struct task_struct;
+struct alloc_context;
+struct page;
 
 /*
  * Details of the page allocation that triggered the oom killer that are used to
@@ -38,6 +40,15 @@ struct oom_control {
 	 */
 	const int order;
 
+	/* Context for really last second allocation attempt. */
+	const struct alloc_context *ac;
+	/*
+	 * Set by the OOM killer if ac != NULL and last second allocation
+	 * attempt succeeded. If ac != NULL, the caller must check for
+	 * page != NULL.
+	 */
+	struct page *page;
+
 	/* Used by oom implementation, do not set */
 	unsigned long totalpages;
 	struct task_struct *chosen;
@@ -102,6 +113,8 @@ extern void oom_killer_enable(void);
 
 extern struct task_struct *find_lock_task_mm(struct task_struct *p);
 
+extern struct page *alloc_pages_before_oomkill(const struct oom_control *oc);
+
 /* sysctls */
 extern int sysctl_oom_dump_tasks;
 extern int sysctl_oom_kill_allocating_task;
diff -puN mm/oom_kill.c~mmoom-move-last-second-allocation-to-inside-the-oom-killer mm/oom_kill.c
--- a/mm/oom_kill.c~mmoom-move-last-second-allocation-to-inside-the-oom-killer
+++ a/mm/oom_kill.c
@@ -1061,6 +1061,9 @@ bool out_of_memory(struct oom_control *o
 	if (!is_memcg_oom(oc) && sysctl_oom_kill_allocating_task &&
 	    current->mm && !oom_unkillable_task(current, NULL, oc->nodemask) &&
 	    current->signal->oom_score_adj != OOM_SCORE_ADJ_MIN) {
+		oc->page = alloc_pages_before_oomkill(oc);
+		if (oc->page)
+			return true;
 		get_task_struct(current);
 		oc->chosen = current;
 		oom_kill_process(oc, "Out of memory (oom_kill_allocating_task)");
@@ -1068,6 +1071,17 @@ bool out_of_memory(struct oom_control *o
 	}
 
 	select_bad_process(oc);
+	/*
+	 * Try really last second allocation attempt after we selected an OOM
+	 * victim, for somebody might have managed to free memory while we were
+	 * selecting an OOM victim which can take quite some time.
+	 */
+	oc->page = alloc_pages_before_oomkill(oc);
+	if (oc->page) {
+		if (oc->chosen && oc->chosen != (void *)-1UL)
+			put_task_struct(oc->chosen);
+		return true;
+	}
 	/* Found nothing?!?! Either we hang forever, or we panic. */
 	if (!oc->chosen && !is_sysrq_oom(oc) && !is_memcg_oom(oc)) {
 		dump_header(oc, NULL);
diff -puN mm/page_alloc.c~mmoom-move-last-second-allocation-to-inside-the-oom-killer mm/page_alloc.c
--- a/mm/page_alloc.c~mmoom-move-last-second-allocation-to-inside-the-oom-killer
+++ a/mm/page_alloc.c
@@ -3325,8 +3325,9 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 		.memcg = NULL,
 		.gfp_mask = gfp_mask,
 		.order = order,
+		.ac = ac,
 	};
-	struct page *page;
+	struct page *page = NULL;
 
 	*did_some_progress = 0;
 
@@ -3340,19 +3341,6 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 		return NULL;
 	}
 
-	/*
-	 * Go through the zonelist yet one more time, keep very high watermark
-	 * here, this is only to catch a parallel oom killing, we must fail if
-	 * we're still under heavy pressure. But make sure that this reclaim
-	 * attempt shall not depend on __GFP_DIRECT_RECLAIM && !__GFP_NORETRY
-	 * allocation which will never fail due to oom_lock already held.
-	 */
-	page = get_page_from_freelist((gfp_mask | __GFP_HARDWALL) &
-				      ~__GFP_DIRECT_RECLAIM, order,
-				      ALLOC_WMARK_HIGH|ALLOC_CPUSET, ac);
-	if (page)
-		goto out;
-
 	/* Coredumps can quickly deplete all memory reserves */
 	if (current->flags & PF_DUMPCORE)
 		goto out;
@@ -3387,16 +3375,18 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 		goto out;
 
 	/* Exhausted what can be done so it's blamo time */
-	if (out_of_memory(&oc) || WARN_ON_ONCE(gfp_mask & __GFP_NOFAIL)) {
+	if (out_of_memory(&oc)) {
+		*did_some_progress = 1;
+		page = oc.page;
+	} else if (WARN_ON_ONCE(gfp_mask & __GFP_NOFAIL)) {
 		*did_some_progress = 1;
 
 		/*
 		 * Help non-failing allocations by giving them access to memory
 		 * reserves
 		 */
-		if (gfp_mask & __GFP_NOFAIL)
-			page = __alloc_pages_cpuset_fallback(gfp_mask, order,
-					ALLOC_NO_WATERMARKS, ac);
+		page = __alloc_pages_cpuset_fallback(gfp_mask, order,
+						     ALLOC_NO_WATERMARKS, ac);
 	}
 out:
 	mutex_unlock(&oom_lock);
@@ -4156,6 +4146,24 @@ got_pg:
 	return page;
 }
 
+struct page *alloc_pages_before_oomkill(const struct oom_control *oc)
+{
+	/*
+	 * Go through the zonelist yet one more time, keep very high watermark
+	 * here, this is only to catch a parallel oom killing, we must fail if
+	 * we're still under heavy pressure. But make sure that this reclaim
+	 * attempt shall not depend on __GFP_DIRECT_RECLAIM && !__GFP_NORETRY
+	 * allocation which will never fail due to oom_lock already held.
+	 */
+	int alloc_flags = ALLOC_CPUSET | ALLOC_WMARK_HIGH;
+	gfp_t gfp_mask = oc->gfp_mask | __GFP_HARDWALL;
+
+	if (!oc->ac)
+		return NULL;
+	gfp_mask &= ~__GFP_DIRECT_RECLAIM;
+	return get_page_from_freelist(gfp_mask, oc->order, alloc_flags, oc->ac);
+}
+
 static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 		int preferred_nid, nodemask_t *nodemask,
 		struct alloc_context *ac, gfp_t *alloc_mask,
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

dentry-fix-kmemcheck-splat-at-take_dentry_name_snapshot.patch
mmvmscan-mark-register_shrinker-as-__must_check.patch
mmoom-move-last-second-allocation-to-inside-the-oom-killer.patch
mmoom-use-alloc_oom-for-oom-victims-last-second-allocation.patch
mmoom-remove-oom_lock-serialization-from-the-oom-reaper.patch


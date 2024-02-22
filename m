Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9CB14B810
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 19:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708628936; cv=none; b=JxaaSmR3Yn9RB0Qf/P7sB72/IAwAVlpNhQZFSHsKc01ZUMV5bStmNWZ3Nh9OU20t8Ty4qAUdfQoOpsNJJyAdbWPgdwO41UPM3ogQ1Anq5xgt5eu+qDxTFa0llbm3wvGSyBIZgqU2g66/tfUi7R4xwuX2NwRGlpMR991fDV+qgLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708628936; c=relaxed/simple;
	bh=DTp4YvChDxpIvAiR/G59VaGmKK8oEgLqUcl257OqsJc=;
	h=Date:To:From:Subject:Message-Id; b=g5wSIah9bsSWxKtOTRtgnagG/STMBep+DqUSr/CdA3NDRcZQUx78gKM+wT6fmcY/kF+wZypljYUAWRs4f2v2zhDU0vI18HfWWvflssToV5+8tXW/PeNY6p1RXuP5BfaTJk8RpH3nDbaGmy4u5Z3B1Mke29TlFed0k2tp8J+c4pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IkcjzFgO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IkcjzFgO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89358C433F1;
	Thu, 22 Feb 2024 19:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708628935;
	bh=DTp4YvChDxpIvAiR/G59VaGmKK8oEgLqUcl257OqsJc=;
	h=Date:To:From:Subject:From;
	b=IkcjzFgOHFGW2PQ+2cK+SIuFrNu+fNmgfj3XkPybJ3kmg3oW+3CQhzBLV86Fe1k1C
	 rH2hsD1WwOplL+MUH1CUPR8HIOl6w6QsYKovoiq4FDtL5DWFWl+NGkIKK0ITsiAOb1
	 UUIcjIN5+UnsRcXNCe68py5iVSSkocu5pQjAaYZA=
Date: Thu, 22 Feb 2024 11:08:54 -0800
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,rientjes@google.com,muchun.song@linux.dev,ligang.bdlg@bytedance.com,gang.li@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + padata-dispatch-works-on-different-nodes.patch added to mm-unstable branch
Message-Id: <20240222190855.89358C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: padata: dispatch works on different nodes
has been added to the -mm mm-unstable branch.  Its filename is
     padata-dispatch-works-on-different-nodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/padata-dispatch-works-on-different-nodes.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Gang Li <gang.li@linux.dev>
Subject: padata: dispatch works on different nodes
Date: Thu, 22 Feb 2024 22:04:17 +0800

When a group of tasks that access different nodes are scheduled on the
same node, they may encounter bandwidth bottlenecks and access latency.

Thus, numa_aware flag is introduced here, allowing tasks to be distributed
across different nodes to fully utilize the advantage of multi-node
systems.

Link: https://lkml.kernel.org/r/20240222140422.393911-5-gang.li@linux.dev
Signed-off-by: Gang Li <ligang.bdlg@bytedance.com>
Tested-by: David Rientjes <rientjes@google.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/padata.h |    2 ++
 kernel/padata.c        |   14 ++++++++++++--
 mm/mm_init.c           |    1 +
 3 files changed, 15 insertions(+), 2 deletions(-)

--- a/include/linux/padata.h~padata-dispatch-works-on-different-nodes
+++ a/include/linux/padata.h
@@ -137,6 +137,7 @@ struct padata_shell {
  *             appropriate for one worker thread to do at once.
  * @max_threads: Max threads to use for the job, actual number may be less
  *               depending on task size and minimum chunk size.
+ * @numa_aware: Distribute jobs to different nodes with CPU in a round robin fashion.
  */
 struct padata_mt_job {
 	void (*thread_fn)(unsigned long start, unsigned long end, void *arg);
@@ -146,6 +147,7 @@ struct padata_mt_job {
 	unsigned long		align;
 	unsigned long		min_chunk;
 	int			max_threads;
+	bool			numa_aware;
 };
 
 /**
--- a/kernel/padata.c~padata-dispatch-works-on-different-nodes
+++ a/kernel/padata.c
@@ -485,7 +485,8 @@ void __init padata_do_multithreaded(stru
 	struct padata_work my_work, *pw;
 	struct padata_mt_job_state ps;
 	LIST_HEAD(works);
-	int nworks;
+	int nworks, nid;
+	static atomic_t last_used_nid __initdata;
 
 	if (job->size == 0)
 		return;
@@ -517,7 +518,16 @@ void __init padata_do_multithreaded(stru
 	ps.chunk_size = roundup(ps.chunk_size, job->align);
 
 	list_for_each_entry(pw, &works, pw_list)
-		queue_work(system_unbound_wq, &pw->pw_work);
+		if (job->numa_aware) {
+			int old_node = atomic_read(&last_used_nid);
+
+			do {
+				nid = next_node_in(old_node, node_states[N_CPU]);
+			} while (!atomic_try_cmpxchg(&last_used_nid, &old_node, nid));
+			queue_work_node(nid, system_unbound_wq, &pw->pw_work);
+		} else {
+			queue_work(system_unbound_wq, &pw->pw_work);
+		}
 
 	/* Use the current thread, which saves starting a workqueue worker. */
 	padata_work_init(&my_work, padata_mt_helper, &ps, PADATA_WORK_ONSTACK);
--- a/mm/mm_init.c~padata-dispatch-works-on-different-nodes
+++ a/mm/mm_init.c
@@ -2231,6 +2231,7 @@ static int __init deferred_init_memmap(v
 			.align       = PAGES_PER_SECTION,
 			.min_chunk   = PAGES_PER_SECTION,
 			.max_threads = max_threads,
+			.numa_aware  = false,
 		};
 
 		padata_do_multithreaded(&job);
_

Patches currently in -mm which might be from gang.li@linux.dev are

hugetlb-code-clean-for-hugetlb_hstate_alloc_pages.patch
hugetlb-split-hugetlb_hstate_alloc_pages.patch
hugetlb-pass-next_nid_to_alloc-directly-to-for_each_node_mask_to_alloc.patch
padata-dispatch-works-on-different-nodes.patch
padata-downgrade-padata_do_multithreaded-to-serial-execution-for-non-smp.patch
hugetlb-have-config_hugetlbfs-select-config_padata.patch
hugetlb-parallelize-2m-hugetlb-allocation-and-initialization.patch
hugetlb-parallelize-1g-hugetlb-initialization.patch


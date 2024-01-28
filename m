Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79307D527
	for <mm-commits@vger.kernel.org>; Sun, 28 Jan 2024 08:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706430487; cv=none; b=u60JEJJF8hMm53mDdPewURqbPg6RUtrVxxohHxHKqi02cUs2vzliY+877wyNFF9hGMYB1MFMRY4ngTwJOlIaPyppfu7DlrY2aVAM9PmZeOeg1qwL7k8XiSsn7PUcmQZbmF7M1/0+/mA87RMpSDbORxfxLVJISyMygWsNPpvvo3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706430487; c=relaxed/simple;
	bh=fGs01xFifC39aptNmoOrn7HljnJHMarxlZpyOIq8EsM=;
	h=Date:To:From:Subject:Message-Id; b=bG9ihPTiYnOhrnF4VU33BBpnYspj+0kNG1k2TMlT2iAuDfgBnYtsnSYPw/i80umzhetI6FHuOJORb/0CwZYHyZ9OHi9sV9UlJM9Hfg4qDTx5jTw+FbGCWoY+eetdBFiEOZwx9zhFRpOt2wJUT6k0fjVcda1xnvnSMhfPiX7NGfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wo5GLTUE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wo5GLTUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CDFC433C7;
	Sun, 28 Jan 2024 08:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706430486;
	bh=fGs01xFifC39aptNmoOrn7HljnJHMarxlZpyOIq8EsM=;
	h=Date:To:From:Subject:From;
	b=wo5GLTUEVpTV2286rbhjtxyUms6kump77twjbbBjtY0XPh0g4iab9QopHkSWvCUOs
	 PAsfSeCDvSpfGHiUzOFZTfwvCRpcKnySPSt9wysKwPIPwmOagfIeQ1AdQZ+iwForeN
	 upEQ+kdPuISa0RDsxHebI9h7jVu7RgYWze5KwMcw=
Date: Sun, 28 Jan 2024 00:28:03 -0800
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,rientjes@google.com,muchun.song@linux.dev,mike.kravetz@oracle.com,ligang.bdlg@bytedance.com,david@redhat.com,gang.li@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + padata-dispatch-works-on-different-nodes.patch added to mm-unstable branch
Message-Id: <20240128082806.71CDFC433C7@smtp.kernel.org>
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
Date: Fri, 26 Jan 2024 23:24:07 +0800

When a group of tasks that access different nodes are scheduled on the
same node, they may encounter bandwidth bottlenecks and access latency.

Thus, numa_aware flag is introduced here, allowing tasks to be distributed
across different nodes to fully utilize the advantage of multi-node
systems.

Link: https://lkml.kernel.org/r/20240126152411.1238072-4-gang.li@linux.dev
Signed-off-by: Gang Li <ligang.bdlg@bytedance.com>
Tested-by: David Rientjes <rientjes@google.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
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
padata-dispatch-works-on-different-nodes.patch
hugetlb-pass-next_nid_to_alloc-directly-to-for_each_node_mask_to_alloc.patch
hugetlb-have-config_hugetlbfs-select-config_padata.patch
hugetlb-parallelize-2m-hugetlb-allocation-and-initialization.patch
hugetlb-parallelize-1g-hugetlb-initialization.patch


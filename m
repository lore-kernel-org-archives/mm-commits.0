Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B462ABE4D
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759097; cv=none; b=R0oD7F9ZygMoKefVrlKMY0K5WwY42zcrY6YZmyvD3rscHjio8jbxPdZ+5Zs9SZ0aRwaUJVFI+TrshuMWzGUFSIw8gMaLId6mTc+3HeAI0l8DH95XRpOc1dfl7TqmjR75r6dnLtU4lOmLEasdIjjKMmYH7KnrlDNvBjJmc8z7X+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759097; c=relaxed/simple;
	bh=Aq14UJzzTS3EhBx8CWYpARcQ7I2Bxkgi45w9/t/Ujek=;
	h=Date:To:From:Subject:Message-Id; b=il8dPICuwNpIKc5qB4x+x7zGCdIzASlqixyVNJQa3SvB615oIKP4SdVsghj+cCpDhZjfC92JdSjjgn6v0yLhDDEgbz+0sMdNKtJzWjLaxHiWIHPyrE6lvl3EGvsQM28+CR/NvaGWd3/oQ2SgZlRMM91OUPpcyZncmXIPpNt3WDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UawOHkXA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UawOHkXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C743C433F1;
	Wed,  6 Mar 2024 21:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759097;
	bh=Aq14UJzzTS3EhBx8CWYpARcQ7I2Bxkgi45w9/t/Ujek=;
	h=Date:To:From:Subject:From;
	b=UawOHkXAs3XYY2Cm5TOfdbhoh8n8UF4N2zm+RR4UWiX7ViKIi9y/QolJ/DF31VHiM
	 AZtGqPmvDj6gaz6gBt9F5+wrAzHH0rQMObI3EHXG96H6c3du1y0mENdvqR/Y53g6/c
	 RuJJqH1z/pli3eEiIPDaPwCkgxI1fVq42ktXSOdI=
Date: Wed, 06 Mar 2024 13:04:56 -0800
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,steffen.klassert@secunet.com,rientjes@google.com,rdunlap@infradead.org,paulmck@kernel.org,muchun.song@linux.dev,mike.kravetz@oracle.com,ligang.bdlg@bytedance.com,jane.chu@oracle.com,david@redhat.com,daniel.m.jordan@oracle.com,adobriyan@gmail.com,gang.li@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] padata-dispatch-works-on-different-nodes.patch removed from -mm tree
Message-Id: <20240306210457.6C743C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     different nodes Date: Thu, 22 Feb 2024 22:04:17 +0800
has been removed from the -mm tree.  Its filename was
     padata-dispatch-works-on-different-nodes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gang Li <gang.li@linux.dev> Subject: padata: dispatch works on
different nodes Date: Thu, 22 Feb 2024 22:04:17 +0800

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
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
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



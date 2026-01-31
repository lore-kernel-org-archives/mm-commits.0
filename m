Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0291220CCDC
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898299; cv=none; b=s3yJvrYvqX0dingsO7hZY29G1UJT3QtrN5McR3D2LpAG00NNTBI7ginmXhoCEfW+OlxvYmV3PQTo12NrvdvGBJxYd9zLP0iZbVwb42GhQ0m6OX7OA4WRGhw43FJ1VeEOfWQI4z7jqEN1uCwpIJHKMlOJE9ZG2LYXjLzwU8SwgeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898299; c=relaxed/simple;
	bh=74m6HUOAahI5aDdI0kC/9P14kN9wGrlONbnoDGVgsIg=;
	h=Date:To:From:Subject:Message-Id; b=ZgSquF7+Wcz5vi3/LRnEPSg8DfxplmI27cmtJ7HvcHHnQIK2QtvKKJy6/AR7lDpyK70uEtAx6fgH8MSQQ+h18Fvju4jBRmrQbqwKiU3FON5oE5Qvpjh+kK3eMcgOSGFyvTDCX7JtT8OiOvGuA6+G+R8UBoddvQx52CRbjla/kqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tG0B4GdE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tG0B4GdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8B9C4CEF1;
	Sat, 31 Jan 2026 22:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898298;
	bh=74m6HUOAahI5aDdI0kC/9P14kN9wGrlONbnoDGVgsIg=;
	h=Date:To:From:Subject:From;
	b=tG0B4GdEGswUerJgp4ShXr6jAYJuC6aCy7CD705GpZjbUO0oIP7vaFzzyodc218Rs
	 3E8dqLL9z/jOypdV4WYiUdIjHkSBHPpZZ+nCH1PBK1lV0dbC+/dYbOGKIxfoVgGHYL
	 jYSHiCdyoxGc/UkSqGhwI/JLvxYIciKAVlzEWjas=
Date: Sat, 31 Jan 2026 14:24:58 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tj@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jiangshanlai@gmail.com,hannes@cmpxchg.org,glider@google.com,frederic@kernel.org,elver@google.com,dvyukov@google.com,david@kernel.org,bigeasy@linutronix.de,marco.crivellari@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-wq_percpu-to-alloc_workqueue-users.patch removed from -mm tree
Message-Id: <20260131222458.CD8B9C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add WQ_PERCPU to alloc_workqueue users
has been removed from the -mm tree.  Its filename was
     mm-add-wq_percpu-to-alloc_workqueue-users.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Marco Crivellari <marco.crivellari@suse.com>
Subject: mm: add WQ_PERCPU to alloc_workqueue users
Date: Tue, 13 Jan 2026 12:46:30 +0100

This continues the effort to refactor workqueue APIs, which began with the
introduction of new workqueues and a new alloc_workqueue flag in:

   commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
   commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

The refactoring is going to alter the default behavior of
alloc_workqueue() to be unbound by default.

With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
any alloc_workqueue() caller that doesn't explicitly specify WQ_UNBOUND
must now use WQ_PERCPU.  For more details see the Link tag below.

In order to keep alloc_workqueue() behavior identical, explicitly request
WQ_PERCPU.

[akpm@linux-foundation.org: fix mm/slub.c]
[akpm@linux-foundation.org: fix kmem_cache_init_late() properly, per Sebastian]
Link: https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/
Link: https://lkml.kernel.org/r/20260113114630.152942-4-marco.crivellari@suse.com
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
Suggested-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lai jiangshan <jiangshanlai@gmail.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    2 +-
 mm/slub.c        |    3 ++-
 mm/vmstat.c      |    3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)

--- a/mm/backing-dev.c~mm-add-wq_percpu-to-alloc_workqueue-users
+++ a/mm/backing-dev.c
@@ -974,7 +974,7 @@ static int __init cgwb_init(void)
 	 * system_percpu_wq.  Put them in a separate wq and limit concurrency.
 	 * There's no point in executing many of these in parallel.
 	 */
-	cgwb_release_wq = alloc_workqueue("cgwb_release", 0, 1);
+	cgwb_release_wq = alloc_workqueue("cgwb_release", WQ_PERCPU, 1);
 	if (!cgwb_release_wq)
 		return -ENOMEM;
 
--- a/mm/slub.c~mm-add-wq_percpu-to-alloc_workqueue-users
+++ a/mm/slub.c
@@ -8542,7 +8542,8 @@ void __init kmem_cache_init(void)
 
 void __init kmem_cache_init_late(void)
 {
-	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM, 0);
+	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM | WQ_PERCPU,
+				  0);
 	WARN_ON(!flushwq);
 }
 
--- a/mm/vmstat.c~mm-add-wq_percpu-to-alloc_workqueue-users
+++ a/mm/vmstat.c
@@ -2259,7 +2259,8 @@ void __init init_mm_internals(void)
 {
 	int ret __maybe_unused;
 
-	mm_percpu_wq = alloc_workqueue("mm_percpu_wq", WQ_MEM_RECLAIM, 0);
+	mm_percpu_wq = alloc_workqueue("mm_percpu_wq",
+				       WQ_MEM_RECLAIM | WQ_PERCPU, 0);
 
 #ifdef CONFIG_SMP
 	ret = cpuhp_setup_state_nocalls(CPUHP_MM_VMSTAT_DEAD, "mm/vmstat:dead",
_

Patches currently in -mm which might be from marco.crivellari@suse.com are



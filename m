Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE53D30F551
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 22:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768345008; cv=none; b=ABQdkusAizPHeW5nk/vI3kQuHOk51mzbKLihM6GpZx+tsfnWa6PBjx4jh8SfiyEFeC2c7cAdMBy+Xv1a3vUH08QWygV5YqVYFiyl34TbVcdatBUbhHFkwBNri9rupGKDYceJKycAntOa5rGPsRX/0EyEVJ+b9rJf7wbE3FoX8pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768345008; c=relaxed/simple;
	bh=r3zy2yWuuePc2yRomANDR6sPW6AfSgGB5o7O0ILVZtA=;
	h=Date:To:From:Subject:Message-Id; b=i5uxqsJc/uYZYj8ifnkMv9DqMskyVJwvfBMU76Wf3voS+UFJ9jJuNpCtZakwdjMg2YUfUNAfegOtMD1eUyAd8mm+L8foA06kF228iHIiJ2tFlAMw72LBR28dvs4GUhdGHV4anc4LSlH2ihxGj5ZyWKK8UGJCVuua0EFma2vyUa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TkocoC3M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TkocoC3M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68507C116C6;
	Tue, 13 Jan 2026 22:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768345008;
	bh=r3zy2yWuuePc2yRomANDR6sPW6AfSgGB5o7O0ILVZtA=;
	h=Date:To:From:Subject:From;
	b=TkocoC3MdRWRwqAheICJan2WHak1q1SzG1ft5EDp/t3c52rxESwZizyW8Y1fa8Swa
	 Fas308KVgqIjlTFXrrZl3nemGYd6H9H5aUrSXdrAj4wF0/aQjInh8ZLKMgDK8z7+si
	 wGThi+XseG8SseCcJcqzFCYz0ZgtBt6zrYA6DcnQ=
Date: Tue, 13 Jan 2026 14:56:47 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tj@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jiangshanlai@gmail.com,hannes@cmpxchg.org,glider@google.com,frederic@kernel.org,elver@google.com,dvyukov@google.com,david@kernel.org,bigeasy@linutronix.de,marco.crivellari@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-wq_percpu-to-alloc_workqueue-users.patch added to mm-new branch
Message-Id: <20260113225648.68507C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add WQ_PERCPU to alloc_workqueue users
has been added to the -mm mm-new branch.  Its filename is
     mm-add-wq_percpu-to-alloc_workqueue-users.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-wq_percpu-to-alloc_workqueue-users.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

Link: https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/
Link: https://lkml.kernel.org/r/20260113114630.152942-4-marco.crivellari@suse.com
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
Suggested-by: Tejun Heo <tj@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lai jiangshan <jiangshanlai@gmail.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    2 +-
 mm/slub.c        |    4 +++-
 mm/vmstat.c      |    3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

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
@@ -8542,7 +8542,9 @@ void __init kmem_cache_init(void)
 
 void __init kmem_cache_init_late(void)
 {
-	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM, 0);
+#ifndef CONFIG_SLUB_TINY
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

mm-replace-use-of-system_unbound_wq-with-system_dfl_wq.patch
mm-replace-use-of-system_wq-with-system_percpu_wq.patch
mm-add-wq_percpu-to-alloc_workqueue-users.patch


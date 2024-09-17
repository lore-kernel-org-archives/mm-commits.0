Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30C214A62E
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 07:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726558232; cv=none; b=c8TgnyRewjen4tMfks9iZVw5xALFfuZkTOPb/QvZeaBIPfl2GJlB6RcZqP8TQTGXwksYSVPAxa7IwAot9KnxGbggrb7Jnb3I+ALudY686t21qvTZKNejDbV83GhAvxtGf3Io3AeYqd5Bx1OYONBE6NjVCHjPzujRKyY1xsZdwgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726558232; c=relaxed/simple;
	bh=tLIbFWO+0r4EVA66gXqnQWJ2S+kgQyWGnG5FhliY5yE=;
	h=Date:To:From:Subject:Message-Id; b=dGdiKXw4x9pXxYl1G7YNZGnhithy43aKbZDiaGn++IFcVzdBaR713+Hls4Ozfrd+/Qk1+JWajJF4OvsGKq4yUWIsHGQ2mw/CDLRK6Un8VXf8DtycgepoywNPiLrDj0ES+Zl6lCNAFfTue0F08DoArzq68XmX5GmYhRQg+FkPf14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CMnL0H+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CMnL0H+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1492C4CEC6;
	Tue, 17 Sep 2024 07:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726558232;
	bh=tLIbFWO+0r4EVA66gXqnQWJ2S+kgQyWGnG5FhliY5yE=;
	h=Date:To:From:Subject:From;
	b=CMnL0H+0cMv/8XlIuoeL0FN2LQisB/19sP1PLYr/g6ENzpECetSGbsqO7c0gzHVNW
	 1TZI+GpovB6Zm3iuQHNyNjrPPJOGuE/75FlBK3iSnK0FTod5pif2VYO5VbAa83Obzl
	 jNa40FI4+kRZmBS2ZB5z4IT7BEUbW+1E09Hjjeo8=
Date: Tue, 17 Sep 2024 00:30:28 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,peterz@infradead.org,jiangshanlai@gmail.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kernel-workqueuec-fix-define_per_cpu_shared_aligned-expansion.patch removed from -mm tree
Message-Id: <20240917073031.C1492C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/workqueue.c: fix DEFINE_PER_CPU_SHARED_ALIGNED expansion
has been removed from the -mm tree.  Its filename was
     kernel-workqueuec-fix-define_per_cpu_shared_aligned-expansion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: kernel/workqueue.c: fix DEFINE_PER_CPU_SHARED_ALIGNED expansion
Date: Wed, 11 Sep 2024 13:07:28 +0800

Make tags always produces below annoying warnings:

ctags: Warning: kernel/workqueue.c:470: null expansion of name pattern "\1"
ctags: Warning: kernel/workqueue.c:474: null expansion of name pattern "\1"
ctags: Warning: kernel/workqueue.c:478: null expansion of name pattern "\1"

In commit 25528213fe9f ("tags: Fix DEFINE_PER_CPU expansions"), codes in
places have been adjusted including cpu_worker_pools definition. I noticed
in commit 4cb1ef64609f ("workqueue: Implement BH workqueues to eventually
replace tasklets"), cpu_worker_pools definition was unfolded back. Not
sure if it was intentionally done or ignored carelessly.

Makes change to mute them specifically.

Link: https://lkml.kernel.org/r/20240911050728.258817-1-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/kernel/workqueue.c~kernel-workqueuec-fix-define_per_cpu_shared_aligned-expansion
+++ a/kernel/workqueue.c
@@ -476,16 +476,13 @@ static bool wq_debug_force_rr_cpu = fals
 module_param_named(debug_force_rr_cpu, wq_debug_force_rr_cpu, bool, 0644);
 
 /* to raise softirq for the BH worker pools on other CPUs */
-static DEFINE_PER_CPU_SHARED_ALIGNED(struct irq_work [NR_STD_WORKER_POOLS],
-				     bh_pool_irq_works);
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct irq_work [NR_STD_WORKER_POOLS], bh_pool_irq_works);
 
 /* the BH worker pools */
-static DEFINE_PER_CPU_SHARED_ALIGNED(struct worker_pool [NR_STD_WORKER_POOLS],
-				     bh_worker_pools);
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct worker_pool [NR_STD_WORKER_POOLS], bh_worker_pools);
 
 /* the per-cpu worker pools */
-static DEFINE_PER_CPU_SHARED_ALIGNED(struct worker_pool [NR_STD_WORKER_POOLS],
-				     cpu_worker_pools);
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct worker_pool [NR_STD_WORKER_POOLS], cpu_worker_pools);
 
 static DEFINE_IDR(worker_pool_idr);	/* PR: idr of all pools */
 
_

Patches currently in -mm which might be from bhe@redhat.com are



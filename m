Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242D715575B
	for <mm-commits@vger.kernel.org>; Mon, 16 Sep 2024 14:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726497645; cv=none; b=jUdv4feXyYAQNiqBHiiCkwQ4S4sOkUeuTGdr36PeSSGz0esTcXH5GDHQ/iDRI5o4n9sq4gLY4VcnNmzeDGF5zw9czr3FjtAEOFhRBexOaA51MaqBYI05vZxZu5VfzBgKIaYu/qd/sN7t5Wh50a58Z2rNlYPTIEXb9XbolWsjesA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726497645; c=relaxed/simple;
	bh=Vj4Dlr7jcIGb+kxR4HpAJGb9eM+Gv9fmxwTyrykxs2o=;
	h=Date:To:From:Subject:Message-Id; b=hYg1BWamhGP+ik50gzM+vhd+6/cYs/dGREuh03cILBzRBms/2v79sH1g6QpZ4nZzxNgm5Yyf5lnRXuMGVkXcu6L13JZSm8L5NYjT/PATIoqwW75g1ll1pEfzwmrRMmDUJDRLFxtYQ0iR/d/qQoBwLzssRofVJjhlJYgToYBxDF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fg6gq++B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fg6gq++B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF48C4CEC5;
	Mon, 16 Sep 2024 14:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726497644;
	bh=Vj4Dlr7jcIGb+kxR4HpAJGb9eM+Gv9fmxwTyrykxs2o=;
	h=Date:To:From:Subject:From;
	b=Fg6gq++BW8kKW92LEQcIDnw/2wpIsmxlaiWdf14jDw0g1CGpfqaEKKPBOddUoy3DM
	 FeFzHJ0VareTvqIrqDTVepNqxhqIXnZRYPdEb8lFJRtuABReRzQY/6wReCsjuYmE0s
	 ERfXE0u1yXwqJK3q6j/9seEI/3nWR3zNId+Mt/mM=
Date: Mon, 16 Sep 2024 07:40:41 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,peterz@infradead.org,jiangshanlai@gmail.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-workqueuec-fix-define_per_cpu_shared_aligned-expansion.patch added to mm-nonmm-unstable branch
Message-Id: <20240916144044.3AF48C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/workqueue.c: fix DEFINE_PER_CPU_SHARED_ALIGNED expansion
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-workqueuec-fix-define_per_cpu_shared_aligned-expansion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-workqueuec-fix-define_per_cpu_shared_aligned-expansion.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

kernel-workqueuec-fix-define_per_cpu_shared_aligned-expansion.patch


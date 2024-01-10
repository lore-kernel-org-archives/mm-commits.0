Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA8C4C601
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 16:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e7tuYSbm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D77C43394;
	Wed, 10 Jan 2024 16:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704902877;
	bh=LU2pDfpSyR0BLu+xTN1kU/f8UkPWNGRfeXVy9X/qtXs=;
	h=Date:To:From:Subject:From;
	b=e7tuYSbmiXorCvcbDOetRN6jWpvGhXXrbI4iuBWN04IukcXd52ZFtr0zaANRSq1SF
	 uN4stHTbH0rMVQxXJJ5TzybqS5gjq+3DlB7vkmTb57nOeFpH+WUsOwsBaH8dvZ6rqQ
	 ZfU8wVg7BCyc77PF/gxEOIXmmfjvOHhk2xJsBlxo=
Date: Wed, 10 Jan 2024 08:07:56 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,ming.lei@redhat.com,linux@rasmusvillemoes.dk,andriy.shevchenko@linux.intel.com,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-group_cpus-simplify-group_cpus_evenly-for-more.patch added to mm-nonmm-unstable branch
Message-Id: <20240110160757.40D77C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/group_cpus: simplify group_cpus_evenly() for more
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-group_cpus-simplify-group_cpus_evenly-for-more.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-group_cpus-simplify-group_cpus_evenly-for-more.patch

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
From: Yury Norov <yury.norov@gmail.com>
Subject: lib/group_cpus: simplify group_cpus_evenly() for more
Date: Thu, 28 Dec 2023 12:09:36 -0800

The nmsk parameter is used only in helper function, so move it there.

Link: https://lkml.kernel.org/r/20231228200936.2475595-10-yury.norov@gmail.com
Suggested-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/group_cpus.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/lib/group_cpus.c~lib-group_cpus-simplify-group_cpus_evenly-for-more
+++ a/lib/group_cpus.c
@@ -253,13 +253,17 @@ static void alloc_nodes_groups(unsigned
 static int __group_cpus_evenly(unsigned int startgrp, unsigned int numgrps,
 			       cpumask_var_t *node_to_cpumask,
 			       const struct cpumask *cpu_mask,
-			       struct cpumask *nmsk, struct cpumask *masks)
+			       struct cpumask *masks)
 {
 	unsigned int i, n, nodes, cpus_per_grp, extra_grps, done = 0;
 	unsigned int last_grp = numgrps;
 	unsigned int curgrp = startgrp;
 	nodemask_t nodemsk = NODE_MASK_NONE;
 	struct node_groups *node_groups;
+	cpumask_var_t nmsk __free(free_cpumask_var);
+
+	if (!alloc_cpumask_var(&nmsk, GFP_KERNEL))
+		return -ENOMEM;
 
 	nodes = get_nodes_in_cpumask(node_to_cpumask, cpu_mask, &nodemsk);
 
@@ -350,11 +354,9 @@ struct cpumask *group_cpus_evenly(unsign
 	cpumask_var_t *node_to_cpumask __free(free_node_to_cpumask) = alloc_node_to_cpumask();
 	struct cpumask *masks __free(kfree) = kcalloc(numgrps, sizeof(*masks), GFP_KERNEL);
 	cpumask_var_t npresmsk __free(free_cpumask_var);
-	cpumask_var_t nmsk __free(free_cpumask_var);
 	unsigned int curgrp, nr_present, nr_others;
 
-	if (!masks || !node_to_cpumask || !alloc_cpumask_var(&nmsk, GFP_KERNEL)
-			|| !alloc_cpumask_var(&npresmsk, GFP_KERNEL))
+	if (!masks || !node_to_cpumask || !alloc_cpumask_var(&npresmsk, GFP_KERNEL))
 		return NULL;
 
 	build_node_to_cpumask(node_to_cpumask);
@@ -374,7 +376,7 @@ struct cpumask *group_cpus_evenly(unsign
 	cpumask_copy(npresmsk, data_race(cpu_present_mask));
 
 	/* grouping present CPUs first */
-	nr_present = __group_cpus_evenly(0, numgrps, node_to_cpumask, npresmsk, nmsk, masks);
+	nr_present = __group_cpus_evenly(0, numgrps, node_to_cpumask, npresmsk, masks);
 	if (nr_present < 0)
 		return NULL;
 
@@ -390,8 +392,7 @@ struct cpumask *group_cpus_evenly(unsign
 	 * group space, assign the non present CPUs to the already
 	 * allocated out groups.
 	 */
-	nr_others = __group_cpus_evenly(curgrp, numgrps, node_to_cpumask,
-					npresmsk, nmsk, masks);
+	nr_others = __group_cpus_evenly(curgrp, numgrps, node_to_cpumask, npresmsk, masks);
 	if (nr_others < 0)
 		return NULL;
 
_

Patches currently in -mm which might be from yury.norov@gmail.com are

cpumask-introduce-for_each_cpu_and_from.patch
lib-group_cpus-optimize-inner-loop-in-grp_spread_init_one.patch
lib-group_cpus-relax-atomicity-requirement-in-grp_spread_init_one.patch
lib-group_cpus-optimize-outer-loop-in-grp_spread_init_one.patch
lib-group_cpus-dont-zero-cpumasks-in-group_cpus_evenly-on-allocation.patch
lib-group_cpus-drop-unneeded-cpumask_empty-call-in-__group_cpus_evenly.patch
cpumask-define-cleanup-function-for-cpumasks.patch
lib-group_cpus-rework-group_cpus_evenly.patch
lib-group_cpus-simplify-group_cpus_evenly-for-more.patch


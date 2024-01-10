Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5744C61D
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 16:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NubrtpEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E20BC433C7;
	Wed, 10 Jan 2024 16:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704902875;
	bh=fC6cgf4FNVorAwCGJwdKJcivFY1Vu8iCpewaie/G9Vc=;
	h=Date:To:From:Subject:From;
	b=NubrtpEdOvhE09yoIcTch02txJFVbFHziSw3T2GfyI32vH9bAxv5dOulJ53IEAu6U
	 daOEcshU+EdOkXhdZWAkiE8dHafJvT0KfgWkljuPdfkft1eymMHT7w0rLArtcUrKDw
	 NNglpyVUKpz8Dmfr7JojHZC6PfBddASqIOUT9tPg=
Date: Wed, 10 Jan 2024 08:07:54 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,ming.lei@redhat.com,linux@rasmusvillemoes.dk,andriy.shevchenko@linux.intel.com,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-group_cpus-rework-group_cpus_evenly.patch added to mm-nonmm-unstable branch
Message-Id: <20240110160755.3E20BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/group_cpus: rework group_cpus_evenly()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-group_cpus-rework-group_cpus_evenly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-group_cpus-rework-group_cpus_evenly.patch

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
Subject: lib/group_cpus: rework group_cpus_evenly()
Date: Thu, 28 Dec 2023 12:09:35 -0800

Leverage cleanup machinery and drop most of housekeeping code. 
Particularly, drop unneeded and erroneously initialized with -ENOMEM
variable ret.

Link: https://lkml.kernel.org/r/20231228200936.2475595-9-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/group_cpus.c |   77 ++++++++++++++-------------------------------
 1 file changed, 24 insertions(+), 53 deletions(-)

--- a/lib/group_cpus.c~lib-group_cpus-rework-group_cpus_evenly
+++ a/lib/group_cpus.c
@@ -76,6 +76,8 @@ static void free_node_to_cpumask(cpumask
 	kfree(masks);
 }
 
+DEFINE_FREE(free_node_to_cpumask, cpumask_var_t *, if (_T) free_node_to_cpumask(_T));
+
 static void build_node_to_cpumask(cpumask_var_t *masks)
 {
 	int cpu;
@@ -345,26 +347,16 @@ static int __group_cpus_evenly(unsigned
  */
 struct cpumask *group_cpus_evenly(unsigned int numgrps)
 {
-	unsigned int curgrp = 0, nr_present = 0, nr_others = 0;
-	cpumask_var_t *node_to_cpumask;
-	cpumask_var_t nmsk, npresmsk;
-	int ret = -ENOMEM;
-	struct cpumask *masks = NULL;
+	cpumask_var_t *node_to_cpumask __free(free_node_to_cpumask) = alloc_node_to_cpumask();
+	struct cpumask *masks __free(kfree) = kcalloc(numgrps, sizeof(*masks), GFP_KERNEL);
+	cpumask_var_t npresmsk __free(free_cpumask_var);
+	cpumask_var_t nmsk __free(free_cpumask_var);
+	unsigned int curgrp, nr_present, nr_others;
 
-	if (!alloc_cpumask_var(&nmsk, GFP_KERNEL))
+	if (!masks || !node_to_cpumask || !alloc_cpumask_var(&nmsk, GFP_KERNEL)
+			|| !alloc_cpumask_var(&npresmsk, GFP_KERNEL))
 		return NULL;
 
-	if (!alloc_cpumask_var(&npresmsk, GFP_KERNEL))
-		goto fail_nmsk;
-
-	node_to_cpumask = alloc_node_to_cpumask();
-	if (!node_to_cpumask)
-		goto fail_npresmsk;
-
-	masks = kcalloc(numgrps, sizeof(*masks), GFP_KERNEL);
-	if (!masks)
-		goto fail_node_to_cpumask;
-
 	build_node_to_cpumask(node_to_cpumask);
 
 	/*
@@ -382,11 +374,15 @@ struct cpumask *group_cpus_evenly(unsign
 	cpumask_copy(npresmsk, data_race(cpu_present_mask));
 
 	/* grouping present CPUs first */
-	ret = __group_cpus_evenly(curgrp, numgrps, node_to_cpumask,
-				  npresmsk, nmsk, masks);
-	if (ret < 0)
-		goto fail_build_affinity;
-	nr_present = ret;
+	nr_present = __group_cpus_evenly(0, numgrps, node_to_cpumask, npresmsk, nmsk, masks);
+	if (nr_present < 0)
+		return NULL;
+
+	/* If npresmsk is empty */
+	if (!cpumask_andnot(npresmsk, cpu_possible_mask, npresmsk))
+		return_ptr(masks);
+
+	curgrp = nr_present < numgrps ? nr_present : 0;
 
 	/*
 	 * Allocate non present CPUs starting from the next group to be
@@ -394,38 +390,13 @@ struct cpumask *group_cpus_evenly(unsign
 	 * group space, assign the non present CPUs to the already
 	 * allocated out groups.
 	 */
-	if (nr_present >= numgrps)
-		curgrp = 0;
-	else
-		curgrp = nr_present;
-
-	if (cpumask_andnot(npresmsk, cpu_possible_mask, npresmsk))
-		/* If npresmsk is not empty */
-		ret = __group_cpus_evenly(curgrp, numgrps, node_to_cpumask,
-					  npresmsk, nmsk, masks);
-	else
-		ret = 0;
-
-	if (ret >= 0)
-		nr_others = ret;
-
- fail_build_affinity:
-	if (ret >= 0)
-		WARN_ON(nr_present + nr_others < numgrps);
-
- fail_node_to_cpumask:
-	free_node_to_cpumask(node_to_cpumask);
-
- fail_npresmsk:
-	free_cpumask_var(npresmsk);
-
- fail_nmsk:
-	free_cpumask_var(nmsk);
-	if (ret < 0) {
-		kfree(masks);
+	nr_others = __group_cpus_evenly(curgrp, numgrps, node_to_cpumask,
+					npresmsk, nmsk, masks);
+	if (nr_others < 0)
 		return NULL;
-	}
-	return masks;
+
+	WARN_ON(nr_present + nr_others < numgrps);
+	return_ptr(masks);
 }
 #else /* CONFIG_SMP */
 struct cpumask *group_cpus_evenly(unsigned int numgrps)
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536014C3C6
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 16:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qffLp/gp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA34BC433C7;
	Wed, 10 Jan 2024 16:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704902871;
	bh=0Fu7NqozumQdGBqxgyTLjUWBplA1YnuTU4amxsrXiyE=;
	h=Date:To:From:Subject:From;
	b=qffLp/gpIgVT/SokvUNb4K0WKR8ICGmK59RDenSFZ4IArs+oL5V7SCK/8bVBGMonZ
	 yl+ee5g4VmQI8dODbptjw3tnE6mJqOOjLTO1iJl4lPwuIf0h0fjaGuBpDB1IqZcNfQ
	 2AbvDkKif2A1+6b5ZWm/bjr0yMEvvsWsc/rZC65A=
Date: Wed, 10 Jan 2024 08:07:51 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,ming.lei@redhat.com,linux@rasmusvillemoes.dk,andriy.shevchenko@linux.intel.com,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-group_cpus-drop-unneeded-cpumask_empty-call-in-__group_cpus_evenly.patch added to mm-nonmm-unstable branch
Message-Id: <20240110160751.AA34BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/group_cpus: drop unneeded cpumask_empty() call in __group_cpus_evenly()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-group_cpus-drop-unneeded-cpumask_empty-call-in-__group_cpus_evenly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-group_cpus-drop-unneeded-cpumask_empty-call-in-__group_cpus_evenly.patch

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
Subject: lib/group_cpus: drop unneeded cpumask_empty() call in __group_cpus_evenly()
Date: Thu, 28 Dec 2023 12:09:33 -0800

The function is called twice.  First time it's called with cpumask_present
as a parameter, which can't be empty.  Second time it's called with a mask
created with cpumask_andnot(), which returns false if the result is an
empty mask.

We can safely drop redundant cpumask_empty() call from the
__group_cpus_evenly() and save few cycles.

Link: https://lkml.kernel.org/r/20231228200936.2475595-7-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/group_cpus.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/lib/group_cpus.c~lib-group_cpus-drop-unneeded-cpumask_empty-call-in-__group_cpus_evenly
+++ a/lib/group_cpus.c
@@ -259,9 +259,6 @@ static int __group_cpus_evenly(unsigned
 	nodemask_t nodemsk = NODE_MASK_NONE;
 	struct node_groups *node_groups;
 
-	if (cpumask_empty(cpu_mask))
-		return 0;
-
 	nodes = get_nodes_in_cpumask(node_to_cpumask, cpu_mask, &nodemsk);
 
 	/*
@@ -401,9 +398,14 @@ struct cpumask *group_cpus_evenly(unsign
 		curgrp = 0;
 	else
 		curgrp = nr_present;
-	cpumask_andnot(npresmsk, cpu_possible_mask, npresmsk);
-	ret = __group_cpus_evenly(curgrp, numgrps, node_to_cpumask,
-				  npresmsk, nmsk, masks);
+
+	if (cpumask_andnot(npresmsk, cpu_possible_mask, npresmsk))
+		/* If npresmsk is not empty */
+		ret = __group_cpus_evenly(curgrp, numgrps, node_to_cpumask,
+					  npresmsk, nmsk, masks);
+	else
+		ret = 0;
+
 	if (ret >= 0)
 		nr_others = ret;
 
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


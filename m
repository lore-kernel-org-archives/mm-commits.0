Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B53B4C3C6
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 16:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HTcfrVLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E973AC433C7;
	Wed, 10 Jan 2024 16:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704902868;
	bh=IzTnobkAdgUFlTNfjpp7N6nDr/52tQGThDdSXb4OaTs=;
	h=Date:To:From:Subject:From;
	b=HTcfrVLCzJXniAkGWXENlb9hQcy6NhuYghU/NlUehHTOMIYTcQgUKo/hlYlM95rBe
	 29b/MLq72+wWrsYpkcvvCP54wpsxygg4VgMDxFai+gbXz09l5q8KNkveOuynu/6d66
	 MZz1h3tZiNIHXKJE2dOkIFtvjVAbf5Wg4Zd+Xlos=
Date: Wed, 10 Jan 2024 08:07:47 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,ming.lei@redhat.com,linux@rasmusvillemoes.dk,andriy.shevchenko@linux.intel.com,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-group_cpus-optimize-outer-loop-in-grp_spread_init_one.patch added to mm-nonmm-unstable branch
Message-Id: <20240110160747.E973AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/group_cpus: optimize outer loop in grp_spread_init_one()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-group_cpus-optimize-outer-loop-in-grp_spread_init_one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-group_cpus-optimize-outer-loop-in-grp_spread_init_one.patch

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
Subject: lib/group_cpus: optimize outer loop in grp_spread_init_one()
Date: Thu, 28 Dec 2023 12:09:31 -0800

Similarly to the inner loop, in the outer loop we can use for_each_cpu()
macro, and skip CPUs that have been copied.

With this patch, the function becomes O(1), despite that it's a
double-loop.

While here, add a comment why we can't merge the inner and outer logic.

Link: https://lkml.kernel.org/r/20231228200936.2475595-5-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/group_cpus.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/lib/group_cpus.c~lib-group_cpus-optimize-outer-loop-in-grp_spread_init_one
+++ a/lib/group_cpus.c
@@ -17,16 +17,17 @@ static void grp_spread_init_one(struct c
 	const struct cpumask *siblmsk;
 	int cpu, sibl;
 
-	for ( ; cpus_per_grp > 0; ) {
-		cpu = cpumask_first(nmsk);
-
-		/* Should not happen, but I'm too lazy to think about it */
-		if (cpu >= nr_cpu_ids)
+	for_each_cpu(cpu, nmsk) {
+		if (cpus_per_grp-- == 0)
 			return;
 
+		/*
+		 * If a caller wants to spread IRQa on offline CPUs, we need to
+		 * take care of it explicitly because those offline CPUS are not
+		 * included in siblings cpumask.
+		 */
 		__cpumask_clear_cpu(cpu, nmsk);
 		__cpumask_set_cpu(cpu, irqmsk);
-		cpus_per_grp--;
 
 		/* If the cpu has siblings, use them first */
 		siblmsk = topology_sibling_cpumask(cpu);
@@ -38,6 +39,7 @@ static void grp_spread_init_one(struct c
 
 			__cpumask_clear_cpu(sibl, nmsk);
 			__cpumask_set_cpu(sibl, irqmsk);
+			cpu = sibl + 1;
 		}
 	}
 }
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


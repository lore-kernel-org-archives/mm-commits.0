Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6152B4C61D
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 16:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xzi5ucLg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D1DC433F1;
	Wed, 10 Jan 2024 16:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704902866;
	bh=hHYyWGoqfCvgwRVwmd87xh1knfZzME3KDxPpWS4sS+M=;
	h=Date:To:From:Subject:From;
	b=Xzi5ucLgo3hHSCEoWun9FiQ2xrQwEP+7CUWNTDvmsEYiS4m/plN7zZL69scqmlcUn
	 Px19Il5uDqas7noav5cVE7CbgoMOpk0IXrCRm2XirS2SorRtQ7N1izaOZZwHmQZWKN
	 hpeyOwXt5PIKGMQPjIGuMDsAPBl6MJodnv7CfKmQ=
Date: Wed, 10 Jan 2024 08:07:45 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,ming.lei@redhat.com,linux@rasmusvillemoes.dk,andriy.shevchenko@linux.intel.com,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-group_cpus-relax-atomicity-requirement-in-grp_spread_init_one.patch added to mm-nonmm-unstable branch
Message-Id: <20240110160746.22D1DC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/group_cpus: relax atomicity requirement in grp_spread_init_one()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-group_cpus-relax-atomicity-requirement-in-grp_spread_init_one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-group_cpus-relax-atomicity-requirement-in-grp_spread_init_one.patch

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
Subject: lib/group_cpus: relax atomicity requirement in grp_spread_init_one()
Date: Thu, 28 Dec 2023 12:09:30 -0800

Because nmsk and irqmsk are stable, extra atomicity is not required.

__cpumask_clear_cpu() and __cpumask_set_cpu() are added in commit
6c8557bdb28d ("smp, cpumask: Use non-atomic cpumask_{set,clear}_cpu()")
for fast code path( smp_call_function_many()).

We have ~670 users of cpumask_clear_cpu & cpumask_set_cpu, lots of them
fall into same category with group_cpus.c(doesn't care atomicity, not in
fast code path), and needn't change to __cpumask_clear_cpu() and
__cpumask_set_cpu().  Otherwise, this way may encourage to update others
into the __cpumask_* version.

Link: https://lkml.kernel.org/r/20231228200936.2475595-4-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
NAKed-by: Ming Lei <ming.lei@redhat.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/group_cpus.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/lib/group_cpus.c~lib-group_cpus-relax-atomicity-requirement-in-grp_spread_init_one
+++ a/lib/group_cpus.c
@@ -24,8 +24,8 @@ static void grp_spread_init_one(struct c
 		if (cpu >= nr_cpu_ids)
 			return;
 
-		cpumask_clear_cpu(cpu, nmsk);
-		cpumask_set_cpu(cpu, irqmsk);
+		__cpumask_clear_cpu(cpu, nmsk);
+		__cpumask_set_cpu(cpu, irqmsk);
 		cpus_per_grp--;
 
 		/* If the cpu has siblings, use them first */
@@ -36,8 +36,8 @@ static void grp_spread_init_one(struct c
 			if (cpus_per_grp-- == 0)
 				return;
 
-			cpumask_clear_cpu(sibl, nmsk);
-			cpumask_set_cpu(sibl, irqmsk);
+			__cpumask_clear_cpu(sibl, nmsk);
+			__cpumask_set_cpu(sibl, irqmsk);
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


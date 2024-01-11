Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AEB4B5AD
	for <mm-commits@vger.kernel.org>; Thu, 11 Jan 2024 21:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S1Ofn8tP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DD4C433C7;
	Thu, 11 Jan 2024 21:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705010322;
	bh=Qx7YztEHNe26nfKHMJ5x7eaUOu4G38jHGQUVvfvb8Uo=;
	h=Date:To:From:Subject:From;
	b=S1Ofn8tPk7OJbjj9ekEawVVKZihMMsq0DsP63XEjdV+SsRMLuAoV2hjlCOKlE1WUU
	 sv3QB/V1CEZEnDwECclveab31GcYgm1NEn3SFOe3fK6rZc2YV3mB+Z/9AuEqanzSvv
	 LD15yq5G2vWcLlhDbkI5z3uO2NLi1LeJbopVdCac=
Date: Thu, 11 Jan 2024 13:58:41 -0800
To: mm-commits@vger.kernel.org,lkp@intel.com,dan.carpenter@linaro.org,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-group_cpus-rework-group_cpus_evenly-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20240111215842.97DD4C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/group_cpus: fix initialization section in group_cpus_evenly()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-group_cpus-rework-group_cpus_evenly-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-group_cpus-rework-group_cpus_evenly-fix.patch

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
Subject: lib/group_cpus: fix initialization section in group_cpus_evenly()
Date: Wed, 10 Jan 2024 09:46:39 -0800

_free() parameters have to be initialized at declaration to avoid passing
uninitialized pointer to the destructor (unless such a parameter is
initialized before any possibility of return).

nr_present and nr_others are assigned by __group_cpus_evenly(), which may
return negative value in case of error.  So make it signed.

Link: https://lkml.kernel.org/r/ZZ7e3xbIKfVa3yqd@yury-ThinkPad
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202312310941.FXBRzn8C-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202401050452.IcgrcQON-lkp@intel.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/group_cpus.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/group_cpus.c~lib-group_cpus-rework-group_cpus_evenly-fix
+++ a/lib/group_cpus.c
@@ -349,9 +349,9 @@ struct cpumask *group_cpus_evenly(unsign
 {
 	cpumask_var_t *node_to_cpumask __free(free_node_to_cpumask) = alloc_node_to_cpumask();
 	struct cpumask *masks __free(kfree) = kcalloc(numgrps, sizeof(*masks), GFP_KERNEL);
-	cpumask_var_t npresmsk __free(free_cpumask_var);
+	cpumask_var_t npresmsk __free(free_cpumask_var) = NULL;
 	cpumask_var_t nmsk __free(free_cpumask_var);
-	unsigned int curgrp, nr_present, nr_others;
+	int curgrp, nr_present, nr_others;
 
 	if (!masks || !node_to_cpumask || !alloc_cpumask_var(&nmsk, GFP_KERNEL)
 			|| !alloc_cpumask_var(&npresmsk, GFP_KERNEL))
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
lib-group_cpus-rework-group_cpus_evenly-fix.patch
lib-group_cpus-simplify-group_cpus_evenly-for-more.patch


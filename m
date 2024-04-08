Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B3C8662A
	for <mm-commits@vger.kernel.org>; Mon,  8 Apr 2024 17:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712598860; cv=none; b=eETZr/QObPGk57I073quFfztv8SBktV4V1V22rATgV4yO7T5JVdN/80hqDqB6ITpD2VcvqAdAKvWZbgryg/67S9K883wcpXEhjri41QjckxfdGBB1QGuDgTT/H7AETDUIPdsLCQQOr/CtUeNO6hZD64e5kqaDXX7uaT7THD0fv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712598860; c=relaxed/simple;
	bh=uKcJE1rNFSxTaDhDaZPwDbeOIn7MjfNcxRnaBMF6zHM=;
	h=Date:To:From:Subject:Message-Id; b=MifsJL3Fhj/wmdVrMeRLjO7Oo38hUm0rfwSpCz7fpNCA3/FPnO1kG9kh+TDdJ/z1Jm6xS2BnIExYJT4TVix55Ii08QXx4EBK70pDt3NVXl3Cck/EKAO+gSEG8k8N8M7f4fa6kNPl0ex+tf84D3Kvk2Rx9PJzaWc7nMoWNYhf3vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q4EaWoUm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q4EaWoUm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAEF0C433C7;
	Mon,  8 Apr 2024 17:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712598860;
	bh=uKcJE1rNFSxTaDhDaZPwDbeOIn7MjfNcxRnaBMF6zHM=;
	h=Date:To:From:Subject:From;
	b=q4EaWoUmZfYHW8S0NCfDNVq3VTfpUkckHBCoMpdF3JeG9VM8j4qMLVYLgbeA0hajB
	 oZszDQKznJ6nUr/dvkL02/oM48y3MGHCa0tig76YwMmKMgas2qNpIKYoU1tGwwd0ew
	 h6H5+fBaCda0d/GTOpsg6TE18fU8qWd7sd3fvItM=
Date: Mon, 08 Apr 2024 10:54:19 -0700
To: mm-commits@vger.kernel.org,yujie.liu@intel.com,lkp@intel.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-per-order-mthp-anon_alloc-and-anon_alloc_fallback-counters-fix.patch added to mm-unstable branch
Message-Id: <20240408175419.EAEF0C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix powerpc build issue
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-per-order-mthp-anon_alloc-and-anon_alloc_fallback-counters-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-per-order-mthp-anon_alloc-and-anon_alloc_fallback-counters-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: fix powerpc build issue
Date: Sun, 7 Apr 2024 12:23:35 +1200

On powerpc, PMD_ORDER is not a constant variable. We should transition
to using alloc_percpu instead of a static percpu array.

Link: https://lkml.kernel.org/r/20240407042247.201412-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202404061754.n8jmZ6s3-lkp@intel.com/
Tested-by: Yujie Liu <yujie.liu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    9 ++++-----
 mm/huge_memory.c        |   12 ++++++++++--
 2 files changed, 14 insertions(+), 7 deletions(-)

--- a/include/linux/huge_mm.h~mm-add-per-order-mthp-anon_alloc-and-anon_alloc_fallback-counters-fix
+++ a/include/linux/huge_mm.h
@@ -271,16 +271,15 @@ enum mthp_stat_item {
 };
 
 struct mthp_stat {
-	unsigned long stats[PMD_ORDER + 1][__MTHP_STAT_COUNT];
+	unsigned long stats[0][__MTHP_STAT_COUNT];
 };
 
-DECLARE_PER_CPU(struct mthp_stat, mthp_stats);
+extern struct mthp_stat __percpu *mthp_stats;
 
 static inline void count_mthp_stat(int order, enum mthp_stat_item item)
 {
-	if (unlikely(order > PMD_ORDER))
-		return;
-	this_cpu_inc(mthp_stats.stats[order][item]);
+	if (likely(order <= PMD_ORDER))
+		raw_cpu_ptr(mthp_stats)->stats[order][item]++;
 }
 
 #define transparent_hugepage_use_zero_page()				\
--- a/mm/huge_memory.c~mm-add-per-order-mthp-anon_alloc-and-anon_alloc_fallback-counters-fix
+++ a/mm/huge_memory.c
@@ -526,7 +526,7 @@ static const struct kobj_type thpsize_kt
 	.sysfs_ops = &kobj_sysfs_ops,
 };
 
-DEFINE_PER_CPU(struct mthp_stat, mthp_stats) = {{{0}}};
+struct mthp_stat __percpu *mthp_stats;
 
 static unsigned long sum_mthp_stat(int order, enum mthp_stat_item item)
 {
@@ -534,7 +534,7 @@ static unsigned long sum_mthp_stat(int o
 	int cpu;
 
 	for_each_online_cpu(cpu) {
-		struct mthp_stat *this = &per_cpu(mthp_stats, cpu);
+		struct mthp_stat *this = per_cpu_ptr(mthp_stats, cpu);
 
 		sum += this->stats[order][item];
 	}
@@ -636,6 +636,13 @@ static int __init hugepage_init_sysfs(st
 		goto remove_hp_group;
 	}
 
+	mthp_stats = __alloc_percpu((PMD_ORDER + 1) * sizeof(mthp_stats->stats[0]),
+			sizeof(unsigned long));
+	if (!mthp_stats) {
+		err = -ENOMEM;
+		goto remove_hp_group;
+	}
+
 	orders = THP_ORDERS_ALL_ANON;
 	order = highest_order(orders);
 	while (orders) {
@@ -673,6 +680,7 @@ static void __init hugepage_exit_sysfs(s
 	sysfs_remove_group(hugepage_kobj, &khugepaged_attr_group);
 	sysfs_remove_group(hugepage_kobj, &hugepage_attr_group);
 	kobject_put(hugepage_kobj);
+	free_percpu(mthp_stats);
 }
 #else
 static inline int hugepage_init_sysfs(struct kobject **hugepage_kobj)
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

arm64-mm-swap-support-thp_swap-on-hardware-with-mte.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio.patch
mm-alloc_anon_folio-avoid-doing-vma_thp_gfp_mask-in-fallback-cases.patch
mm-add-per-order-mthp-anon_alloc-and-anon_alloc_fallback-counters.patch
mm-add-per-order-mthp-anon_alloc-and-anon_alloc_fallback-counters-fix.patch
mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters.patch


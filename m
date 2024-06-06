Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE798440C
	for <mm-commits@vger.kernel.org>; Thu,  6 Jun 2024 02:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717640406; cv=none; b=fTcuHW3JVCpyYOgm4LaX/Ct3iAz3STmTEJ+dEwPEvE9opa13/BhylOOYD9K+g1TZCsSDrqWv1kXL+sPac9QN3g/zYDFU4krq7a8+5z09hl1TjY6Wd+0g78F5667bGwUJHm0MAqL9H8UizzpqT7FUcA9mFal4O8Yx0GW2ojy28NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717640406; c=relaxed/simple;
	bh=5/RY/UxWsw/SLPES6Erup5cGW7ES1X4Q1osw7PpdT9I=;
	h=Date:To:From:Subject:Message-Id; b=N3oyA6oTfKuWIqW10je1eJNynqvsDzsw+iVq7oScINXaZBHn0lcJPWeSFyH93G1Rqxk2tpOzy4koWtw8/bLt+7rPzW0RXQ3aM5O8dDH68jxe3EHtWUWqTjBDqZvLCQY+pREcIEit6dQHHe0ZjopqvspPQF2yn1xyoK/Z+0nrJS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yIqhtx0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yIqhtx0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB815C4AF15;
	Thu,  6 Jun 2024 02:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717640405;
	bh=5/RY/UxWsw/SLPES6Erup5cGW7ES1X4Q1osw7PpdT9I=;
	h=Date:To:From:Subject:From;
	b=yIqhtx0UIcR5usrnmaVB0as/MyLVqCw/wuu8qROiRAyQ2F6veKpyfCD/rq1v6r9q3
	 FgqahM/O4NUHycp/7eVv35ZB2jc2Sce5IDoqmsQhaRaM0JvwD1Xyol2YJvp8ZMQWYv
	 y5s+iRUkehJ4ZILiP61zbPLNixRIaobU4SZAyg9k=
Date: Wed, 05 Jun 2024 19:20:05 -0700
To: mm-commits@vger.kernel.org,yujie.liu@intel.com,lkp@intel.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-huge_mm-fix-undefined-reference-to-mthp_stats-for-config_sysfs=n.patch removed from -mm tree
Message-Id: <20240606022005.AB815C4AF15@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: huge_mm: fix undefined reference to `mthp_stats' for CONFIG_SYSFS=n
has been removed from the -mm tree.  Its filename was
     mm-huge_mm-fix-undefined-reference-to-mthp_stats-for-config_sysfs=n.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: huge_mm: fix undefined reference to `mthp_stats' for CONFIG_SYSFS=n
Date: Fri, 24 May 2024 08:50:48 +1200

if CONFIG_SYSFS is not enabled in config, we get the below error,

All errors (new ones prefixed by >>):

   s390-linux-ld: mm/memory.o: in function `count_mthp_stat':
>> include/linux/huge_mm.h:285:(.text+0x191c): undefined reference to `mthp_stats'
   s390-linux-ld: mm/huge_memory.o:(.rodata+0x10): undefined reference to `mthp_stats'

vim +285 include/linux/huge_mm.h

   279
   280  static inline void count_mthp_stat(int order, enum mthp_stat_item item)
   281  {
   282          if (order <= 0 || order > PMD_ORDER)
   283                  return;
   284
 > 285          this_cpu_inc(mthp_stats.stats[order][item]);
   286  }
   287

Link: https://lkml.kernel.org/r/20240523210045.40444-1-21cnbao@gmail.com
Fixes: ec33687c6749 ("mm: add per-order mTHP anon_fault_alloc and anon_fault_fallback counters")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202405231728.tCAogiSI-lkp@intel.com/
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Tested-by: Yujie Liu <yujie.liu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/linux/huge_mm.h~mm-huge_mm-fix-undefined-reference-to-mthp_stats-for-config_sysfs=n
+++ a/include/linux/huge_mm.h
@@ -278,6 +278,7 @@ struct mthp_stat {
 	unsigned long stats[ilog2(MAX_PTRS_PER_PTE) + 1][__MTHP_STAT_COUNT];
 };
 
+#ifdef CONFIG_SYSFS
 DECLARE_PER_CPU(struct mthp_stat, mthp_stats);
 
 static inline void count_mthp_stat(int order, enum mthp_stat_item item)
@@ -287,6 +288,11 @@ static inline void count_mthp_stat(int o
 
 	this_cpu_inc(mthp_stats.stats[order][item]);
 }
+#else
+static inline void count_mthp_stat(int order, enum mthp_stat_item item)
+{
+}
+#endif
 
 #define transparent_hugepage_use_zero_page()				\
 	(transparent_hugepage_flags &					\
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-remove-the-implementation-of-swap_free-and-always-use-swap_free_nr.patch
mm-introduce-pte_move_swp_offset-helper-which-can-move-offset-bidirectionally.patch
mm-introduce-arch_do_swap_page_nr-which-allows-restore-metadata-for-nr-pages.patch
mm-swap-reuse-exclusive-folio-directly-instead-of-wp-page-faults.patch


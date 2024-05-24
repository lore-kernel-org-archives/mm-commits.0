Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC63023D2
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 02:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716518758; cv=none; b=FQV68n67lSSdjF/DVRoi36u0aBXCBoCnFvUzDLT62oL/h1fuPXKe9AHYLgwf1JOXKJ6qX87z+QD1w7NyosMe786iR1+9bj6fC4+wNsTpSD+6S/gYXCrRHBv3YdzHbvLiyH3/H8izV3B8M5efGu2VGuvvB1JI5fku3zHeKmD/2mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716518758; c=relaxed/simple;
	bh=XlnOodpGrQrA7tfbTVu1+vIG4/4CPi02SW7JiJfekCc=;
	h=Date:To:From:Subject:Message-Id; b=G8Ad7ftK38SqXsexbaVq4YVBtIGnDAP6XuDa6wzdz7JueaMaDeBH/LwdKJ3IJ/1bRgnogyQlbsNBCOnhorlUHO58KXwbzdMgwzoYjE3zjHyVTrnT/Zm5kBcE1EOJWiC1Qf04aHjGuPOkz4yP5T1OhwvcZ5M9WWG4MVlYgBlgU3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C/zz7HbY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C/zz7HbY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7368BC2BD10;
	Fri, 24 May 2024 02:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716518758;
	bh=XlnOodpGrQrA7tfbTVu1+vIG4/4CPi02SW7JiJfekCc=;
	h=Date:To:From:Subject:From;
	b=C/zz7HbYm5uSu9UvVPiOBRvTrbgfZXeSqHGnyoGq6Spcmhr8HTtVoZyjhNPwc/kMK
	 Adra78Vuho3y4hwsUKvVfSqGo6XiuiAEXpn95nfF0MdYIe+64Qd6UIUHe/6T+A4Tk5
	 wpDAEDxRo5Dl2JrrcX4puw/O5ZoeTlfgfpr62g5k=
Date: Thu, 23 May 2024 19:45:57 -0700
To: mm-commits@vger.kernel.org,yujie.liu@intel.com,lkp@intel.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_mm-fix-undefined-reference-to-mthp_stats-for-config_sysfs=n.patch added to mm-hotfixes-unstable branch
Message-Id: <20240524024558.7368BC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: huge_mm: fix undefined reference to `mthp_stats' for CONFIG_SYSFS=n
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_mm-fix-undefined-reference-to-mthp_stats-for-config_sysfs=n.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_mm-fix-undefined-reference-to-mthp_stats-for-config_sysfs=n.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-huge_mm-fix-undefined-reference-to-mthp_stats-for-config_sysfs=n.patch


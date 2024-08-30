Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA72917B4E9
	for <mm-commits@vger.kernel.org>; Fri, 30 Aug 2024 22:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725057051; cv=none; b=nl17QGyR7La9NkE69orXT7poDRuweZ5XE08m+TjPobwhIYgI+S4jyLzuQ1xDCaET/LULWzMG1c5rv5N5N7b9HTcLfWTAtbVxOysButdCx2DVvPwqzT2q7zNAq4JspyTNGVIkuA5EbMvDAohlYf1zyIMn5beSPUpqCzU55T76iOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725057051; c=relaxed/simple;
	bh=vsBX8kcibZbC9WB02jTW33Y+ta0Dlp0r7dMr+3TCQbE=;
	h=Date:To:From:Subject:Message-Id; b=SSrb9S3/MBb6/FgVLMOlADS2JshEmbKsAjo/VNxYbX2Wd/0eP2mQHTkupb4bZVXbsLDXaRMfmTSb1Ioy2cMwBdtgy8amv4Gdgk9/bbd3SsJfebscWqijN9Fp7rQ+SZejqzzx+AMT9KTJIKv7RBSVg3OwT9qwWMdgJy7FW4aSCbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uCZPawyZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uCZPawyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3205EC4CEC2;
	Fri, 30 Aug 2024 22:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725057051;
	bh=vsBX8kcibZbC9WB02jTW33Y+ta0Dlp0r7dMr+3TCQbE=;
	h=Date:To:From:Subject:From;
	b=uCZPawyZORwdR+SeGrioz5ZJ4Dhvr5nGmmMZtCiCF0k+rF3x2B6ik5xpUTrPsX/It
	 bm+dWYLtghKEnaW85W9H41zHn7ewVduwDE4fNw+OSLTXTWvBIsj7OHjsRUvNxXqtOa
	 Yz51pmpO/a7cc1ac/QyONuvrdSyxt1eS83zlC6HA=
Date: Fri, 30 Aug 2024 15:30:50 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,Jonathan.Cameron@huawei.com,horen.chuang@linux.dev,yanfei.xu@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-tier-fix-deadlock-warning-while-onlining-pages-v2.patch added to mm-unstable branch
Message-Id: <20240830223051.3205EC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memory tier: fix deadlock warning while onlining pages
has been added to the -mm mm-unstable branch.  Its filename is
     memory-tier-fix-deadlock-warning-while-onlining-pages-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memory-tier-fix-deadlock-warning-while-onlining-pages-v2.patch

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
From: Yanfei Xu <yanfei.xu@intel.com>
Subject: memory tier: fix deadlock warning while onlining pages
Date: Fri, 30 Aug 2024 18:24:47 +0800

Add the mutex_lock/unlock() pair back and exclude the
hotplug_memory_notifier() from the locked region, per Ying Huang.

Link: https://lkml.kernel.org/r/20240830102447.1445296-1-yanfei.xu@intel.com
Fixes: 823430c8e9d9 ("memory tier: consolidate the initialization of memory tiers")
Signed-off-by: Yanfei Xu <yanfei.xu@intel.com>
Cc: Ho-Ren (Jack) Chuang <horen.chuang@linux.dev>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-tiers.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memory-tiers.c~memory-tier-fix-deadlock-warning-while-onlining-pages-v2
+++ a/mm/memory-tiers.c
@@ -914,12 +914,14 @@ static int __init memory_tier_init(void)
 	WARN_ON(!node_demotion);
 #endif
 
+	mutex_lock(&memory_tier_lock);
 	/*
 	 * For now we can have 4 faster memory tiers with smaller adistance
 	 * than default DRAM tier.
 	 */
 	default_dram_type = mt_find_alloc_memory_type(MEMTIER_ADISTANCE_DRAM,
 						      &default_memory_types);
+	mutex_unlock(&memory_tier_lock);
 	if (IS_ERR(default_dram_type))
 		panic("%s() failed to allocate default DRAM tier\n", __func__);
 
_

Patches currently in -mm which might be from yanfei.xu@intel.com are

memory-tier-fix-deadlock-warning-while-onlining-pages.patch
memory-tier-fix-deadlock-warning-while-onlining-pages-v2.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7452F3D6B
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725422449; cv=none; b=ZzaYR5qd8RjTowJrjDCYm1rFcQL3yHsHOwjJRuvhSt14YpjGK142T00f/lWr4VmyQa5UYrJ6SAtQ+aC4EVZFOiWJEp3yJvQUIF8UpgYKjB/Kl0o7gyrrUZRnfpd3lijN25SG+/KuHd05kdQNIhxSPVXJqBEqGXp/O0mfA/oukqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725422449; c=relaxed/simple;
	bh=KGkxq6ZSjUxYcJdGIiwj+bxPt2Vt62T8d8fx9KMxYXY=;
	h=Date:To:From:Subject:Message-Id; b=WjRiaSmX57HRhhWfmadqG0BatTbeIPygvQ3DsbxNckWWgAwPTDO3HWafEGd46/a3iK3gHG2+kOkN1X0xlPyiQhBwFqGROum2xIizLbSbzLJSJP3xNVyahneoGjYPsDC+KuVshn4A0L8f16kv8D+A/aFKpRm7cPKHa8NG3TtY4iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jJ9r4ByB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jJ9r4ByB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A40C4CEC2;
	Wed,  4 Sep 2024 04:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725422449;
	bh=KGkxq6ZSjUxYcJdGIiwj+bxPt2Vt62T8d8fx9KMxYXY=;
	h=Date:To:From:Subject:From;
	b=jJ9r4ByB7i4diUzBh90tMCdS44CK4e1KLWtBsbxi3u1XiB+wMLJhnAFtmf6yGE17v
	 PYJaHz8E3fYrDPz57sE83JlU66IYS5F+kJqg2J4QU6SvDbA+RfrIL3hmw27hDgdFeX
	 I0RhZIPt5DfuMdvhIkcvrs83ND8DQkRo5gCegth0=
Date: Tue, 03 Sep 2024 21:00:48 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,Jonathan.Cameron@huawei.com,horen.chuang@linux.dev,yanfei.xu@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] memory-tier-fix-deadlock-warning-while-onlining-pages-v2.patch removed from -mm tree
Message-Id: <20240904040048.E5A40C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memory tier: fix deadlock warning while onlining pages
has been removed from the -mm tree.  Its filename was
     memory-tier-fix-deadlock-warning-while-onlining-pages-v2.patch

This patch was dropped because it was folded into memory-tier-fix-deadlock-warning-while-onlining-pages.patch

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


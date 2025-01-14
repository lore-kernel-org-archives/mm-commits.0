Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEB7230276
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736835793; cv=none; b=tyGR1OEvZ9WHtIifqmScPQlkf2MMpTxaM8tC1k1ZYAjAu0jhFT9sdQt2DIyj8vcY/DE7feRZo4q1EHIWnntgS1VJc654HtQvwvVwDZlGo2DfAYJye3nLkI+FX/wKYVVc1YUzOe6hkGL6N4KOW2aiXBL72cxmiVA6k8Hj3CvdbVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736835793; c=relaxed/simple;
	bh=OLOj9kE/wvcAR+4lUg1sh2SI16utyK3D1ReRh0gsVGw=;
	h=Date:To:From:Subject:Message-Id; b=cPhnWCpp4iWMvl52ah1YqoOo8GWI0zhif5ixzV31nbp5Er+XGd6HBvES4UfukuLX8C6yYQnh5yHS3+7pKQhRXSSXaRDt+NVpa29d+gLuWw2lIRgizpQYUteSP97vkYQWUSmIzhccfJgJBxx4vhCOL4JDCBqZ6HK0Z93pw2UXTQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bne16Kjf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bne16Kjf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F24CC4CEDD;
	Tue, 14 Jan 2025 06:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736835793;
	bh=OLOj9kE/wvcAR+4lUg1sh2SI16utyK3D1ReRh0gsVGw=;
	h=Date:To:From:Subject:From;
	b=bne16KjfOd0fPMubya7ovCS5JBpsLibQMTqUv6x2N94V+xpufhFvErHlBOemf7hyA
	 i8Vm16xk+Filtujd0Q8VWRbCmfwa96JZpgEEnN6aFa131iWNXQ4yocWd74u4xax1ur
	 3TA97OOxQJXHMptD7/gevBYtuSIWDd2DjYU1Fh3I=
Date: Mon, 13 Jan 2025 22:23:12 -0800
To: mm-commits@vger.kernel.org,gaoxiang17@xiaomi.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch removed from -mm tree
Message-Id: <20250114062313.3F24CC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch

This patch was dropped because it was folded into mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix
Date: Fri Nov 29 09:23:51 PM PST 2024

tweak grammer, fit to 80 cols

Cc: gaoxiang17 <gaoxiang17@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix
+++ a/mm/page_alloc.c
@@ -1856,11 +1856,12 @@ static bool can_steal_fallback(unsigned
 		return true;
 
 	/*
-	 * movable pages won't cause permanent fragmentation, so when you alloc small pages,
-	 * you just need to temporarily steal unmovable or reclaimable pages that are closest
-	 * to the request size. After a while, memory compact may occur to form large contiguous
-	 * pages, and the next movable allocation may not need to steal. Unmovable and reclaimable
-	 * allocation need to actually steal pages.
+	 * Movable pages won't cause permanent fragmentation, so when you alloc
+	 * small pages, you just need to temporarily steal unmovable or
+	 * reclaimable pages that are closest to the request size.  After a
+	 * while, memory compaction may occur to form large contiguous pages,
+	 * and the next movable allocation may not need to steal.  Unmovable and
+	 * reclaimable allocations need to actually steal pages.
 	 */
 	if (order >= pageblock_order / 2 ||
 		start_mt == MIGRATE_RECLAIMABLE ||
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback.patch
mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch
mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch
mm-huge_memoryc-rename-shadowed-local.patch
mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device-fix.patch
ksm-add-ksm-involvement-information-for-each-process-fix.patch
documentation-filesystems-procrst-fix-possessive-form-of-process.patch


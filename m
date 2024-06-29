Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3ABD8493
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719627871; cv=none; b=KslVr7Rd9aMBij5hUR1g+weslwdn35ryABCIXzxcxZ0K9P9+ywsKIlHOUEcW4yOXlvyiW4FMWpC0jzpBoOSbWUITcsNdKGovBIzNm4Gi2fjFja/BrWVXqwrvGH/6W8jIaWMYhH4GlMUWTbh9qguVkitcbzgud+LMu5WRqVRe6F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719627871; c=relaxed/simple;
	bh=e1ieZeQXNoOGI9qQ1WzpT0zN40q7IFy1sXxQswN7/Rg=;
	h=Date:To:From:Subject:Message-Id; b=FhYGo4SFYml0Esobj1zwAvj9qMPh054WV4+zqg8rz66DoXltw6aM+kiXF9tx8dF6RYwkFwmd12ircL62xeGpi12jZFUnOjYTxvFXT2zKcvFGEqTLyPyJWxHoAVe5fYOsb0A2aKOGBAJW6Iqwg/1UUiHdlhtqqr18yVdHPn570Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TKLOOvSW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TKLOOvSW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68791C32781;
	Sat, 29 Jun 2024 02:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719627870;
	bh=e1ieZeQXNoOGI9qQ1WzpT0zN40q7IFy1sXxQswN7/Rg=;
	h=Date:To:From:Subject:From;
	b=TKLOOvSWGjNtyZzYQkBgJdrGsOOoIXcFccIJUNa9XqDcohsN6WwfcUH2LAl4sE2Ok
	 2a7b/6JoRWI06mLHc5c88BJYFtFMOR8cdgKi5dX5tjacgnzDCfIIKhuRHzZ573m32h
	 N9xowf5awD5CLhe1oDglOY6MA5zUJdIFDgBooDzQ=
Date: Fri, 28 Jun 2024 19:24:29 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,donettom@linux.ibm.com,baolin.wang@linux.alibaba.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl-fix.patch removed from -mm tree
Message-Id: <20240629022430.68791C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl-fix
has been removed from the -mm tree.  Its filename was
     mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl-fix.patch

This patch was dropped because it was folded into mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl.patch

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl-fix
Date: Wed, 26 Jun 2024 18:14:44 +0200

Donet reports an issue during NUMA migration we haven't seen previously:

	[   71.422804] list_del corruption, c00c00000061b3c8->next is
	LIST_POISON1 (5deadbeef0000100)
	[   71.422839] ------------[ cut here ]------------
	[   71.422843] kernel BUG at lib/list_debug.c:56!
	[   71.422850] Oops: Exception in kernel mode, sig: 5 [#1]

We forgot to convert one "return 0;" to return an error instead from
migrate_misplaced_folio_prepare() in case the target node is nearly
full.

Link: https://lkml.kernel.org/r/8f85c31a-e603-4578-bf49-136dae0d4b69@redhat.com
Link: https://lkml.kernel.org/r/20240626191129.658CFC32782@smtp.kernel.org
Signed-off-by: David Hildenbrand <david@redhat.com>
Tested-by: Donet Tom <donettom@linux.ibm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl-fix
+++ a/mm/migrate.c
@@ -2556,7 +2556,7 @@ int migrate_misplaced_folio_prepare(stru
 		int z;
 
 		if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING))
-			return 0;
+			return -EAGAIN;
 		for (z = pgdat->nr_zones - 1; z >= 0; z--) {
 			if (managed_zone(pgdat->node_zones + z))
 				break;
_

Patches currently in -mm which might be from david@redhat.com are

mm-update-_mapcount-and-page_type-documentation.patch
mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type.patch
mm-zsmalloc-use-a-proper-page-type.patch
mm-page_alloc-clear-pagebuddy-using-__clearpagebuddy-for-bad-pages.patch
mm-filemap-reinitialize-folio-_mapcount-directly.patch
mm-mm_init-initialize-page-_mapcount-directly-in-__init_single_page.patch
mm-pass-meminit_context-to-__free_pages_core.patch
mm-memory_hotplug-initialize-memmap-of-zone_device-with-pageoffline-instead-of-pagereserved.patch
mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining.patch
mm-read-page_type-using-read_once.patch
mm-migrate-make-migrate_misplaced_folio-return-0-on-success.patch
mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl.patch


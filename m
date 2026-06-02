Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D7D3C13E9
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439151; cv=none; b=go+5U7uBX/Gbm7LcNR8VPmR9kFTEWpjXBtJxIxFCEio90PDk056BeaUZ38Y9ccyXLzWpNuZJN40ZfG/GQTyGtle3Feu+UF6uk6CC1FtqXn2PHXF+xvWRNmQW14RvwGHYMLDMht1RW6tSO3tQKNWVZcvdEJzsZWAleVraTwt3qaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439151; c=relaxed/simple;
	bh=21ECYqgmj0jEMx4ONtxwpItf1yTOFEBwe/8rmSLNnCU=;
	h=Date:To:From:Subject:Message-Id; b=fEqsp+KxHkhpY9M+wfVnX0RwMJCEQ1NyEAWoH0WnoyEgmb96UPfdYHXEBvDjxTm8zFY/ldldC9v4Dvfdkgxu35Kw4WYdGrx8W2LJSYocLIyLhJC6RW08YSVSszL5y4aXuiFVHI5kFYVHQTlNuF1zsx/zjl8nVMu0avk0ZY+gkg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dFqBjKxr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dFqBjKxr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D53C1F00898;
	Tue,  2 Jun 2026 22:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439150;
	bh=x+Wys7aicZKQp7uNueYxM4QIuLQpTPzX4LfSsr3QDbU=;
	h=Date:To:From:Subject;
	b=dFqBjKxrNtMlvT8D4ynYts7MXMB//8WU+aLafD99UhF5GnCqyY63C04ODy0/p9j5H
	 y/hAxfllhxwIU//6MneBkY85Mx/KjB9gslXfaVbNL67I7/9OS9RpNzVBRnaX1CabK6
	 5cAggUVLDLUAJbt4RGFf57g+8AMsOP0bUAwruVNo=
Date: Tue, 02 Jun 2026 15:25:50 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-hide-damon_add_region.patch removed from -mm tree
Message-Id: <20260602222550.9D53C1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: hide damon_add_region()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-hide-damon_add_region.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: hide damon_add_region()
Date: Fri, 22 May 2026 08:40:16 -0700

damon_add_region() is being used by only DAMON core, but exposed to DAMON
API callers.  Exposing something that is not really being used by others
will only increase the maintenance cost.  Hide it.

Link: https://lore.kernel.org/20260522154026.80546-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    1 -
 mm/damon/core.c       |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-hide-damon_add_region
+++ a/include/linux/damon.h
@@ -1024,7 +1024,6 @@ static inline void damon_insert_region(s
 	t->nr_regions++;
 }
 
-void damon_add_region(struct damon_region *r, struct damon_target *t);
 void damon_destroy_region(struct damon_region *r, struct damon_target *t);
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges, unsigned long min_region_sz);
--- a/mm/damon/core.c~mm-damon-core-hide-damon_add_region
+++ a/mm/damon/core.c
@@ -250,7 +250,7 @@ struct damon_region *damon_new_region(un
 	return region;
 }
 
-void damon_add_region(struct damon_region *r, struct damon_target *t)
+static void damon_add_region(struct damon_region *r, struct damon_target *t)
 {
 	list_add_tail(&r->list, &t->regions_list);
 	t->nr_regions++;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch


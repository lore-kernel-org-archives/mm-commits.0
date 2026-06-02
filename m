Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23C73BB10E
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439153; cv=none; b=p4p5M4OMFN6HM1pdhJYEfjs3G/yjWGUHRAKF2KBi5MRnuOhyId7GIWbmm0yYwMB5iEyaQw5AQ/WV365qjawlw3daCLOJDM1SMs9US1Ehv4+z+ygT2c/tK/9Up1HNQmoAyNxRmZnu6jOVJ+oxxiksrzxUS+U+syLKw2Isz6amVtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439153; c=relaxed/simple;
	bh=hACAKxwRBOXxZ8PfuMdE3X8ZUcLZH9IoRRK0Q28REVA=;
	h=Date:To:From:Subject:Message-Id; b=uFBpH9ShXDHloEA/hizDRerqPw6O3oZPpOox8jA1RWA5kI/LiQxTcimsSuxmvwG6TcRumOupTdnPCR1SxPJEO47kiSZWBJxizNSnY5kZ4TwELtIGdWjkSSg04JRknTGuQzGfz/j2HzXfLfYgsjlVdFzmACkERN6h0nF4pb1eRec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y8nAz2LA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y8nAz2LA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60A71F00893;
	Tue,  2 Jun 2026 22:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439151;
	bh=b6aKZYo/yRFatBaEW3n2MTJ6+cdRwlF7rRSKjEaJ0rA=;
	h=Date:To:From:Subject;
	b=y8nAz2LA2cdXc+kqILZAizcH6YdGAKwBvECstNr0WKRJVDwsBKMgJGEBCeu7BGDEQ
	 jejK7XowHrClQH8NIQsXjVsNXLwnT1zKYLB/egM7UR+vzEghqIv2eqB6hiAzEXNbQs
	 1kowHNEPhjHWZD5xqEwfMvry+zncyOoU/hxFK9rw=
Date: Tue, 02 Jun 2026 15:25:51 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-hide-damon_insert_region.patch removed from -mm tree
Message-Id: <20260602222551.C60A71F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: hide damon_insert_region()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-hide-damon_insert_region.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: hide damon_insert_region()
Date: Fri, 22 May 2026 08:40:17 -0700

damon_insert_region() is being used by only DAMON core, but exposed to
DAMON API callers.  Exposing something that is not really being used by
others will only increase the maintenance cost.  Hide it.

Link: https://lore.kernel.org/20260522154026.80546-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   11 -----------
 mm/damon/core.c       |   11 +++++++++++
 2 files changed, 11 insertions(+), 11 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-hide-damon_insert_region
+++ a/include/linux/damon.h
@@ -1013,17 +1013,6 @@ void damon_add_probe(struct damon_ctx *c
 
 struct damon_region *damon_new_region(unsigned long start, unsigned long end);
 
-/*
- * Add a region between two other regions
- */
-static inline void damon_insert_region(struct damon_region *r,
-		struct damon_region *prev, struct damon_region *next,
-		struct damon_target *t)
-{
-	__list_add(&r->list, &prev->list, &next->list);
-	t->nr_regions++;
-}
-
 void damon_destroy_region(struct damon_region *r, struct damon_target *t);
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges, unsigned long min_region_sz);
--- a/mm/damon/core.c~mm-damon-core-hide-damon_insert_region
+++ a/mm/damon/core.c
@@ -256,6 +256,17 @@ static void damon_add_region(struct damo
 	t->nr_regions++;
 }
 
+/*
+ * Add a region between two other regions
+ */
+static inline void damon_insert_region(struct damon_region *r,
+		struct damon_region *prev, struct damon_region *next,
+		struct damon_target *t)
+{
+	__list_add(&r->list, &prev->list, &next->list);
+	t->nr_regions++;
+}
+
 #ifdef CONFIG_DAMON_DEBUG_SANITY
 static void damon_verify_del_region(struct damon_target *t)
 {
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch


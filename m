Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0FC3090E0
	for <mm-commits@vger.kernel.org>; Fri,  6 Feb 2026 23:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770421685; cv=none; b=UjlkNraeWyzKNA9GdWIERXeiof39s8Du0/1a8yCfGa9DxXnaRqSbY3uxLC+7E8RICv2E/Dlg6La2DA6JlaPZKN1adgDBncnUq6MTwg2Y05u+gr1V5wDzzHFS5Vqn4wUHwNtH/tb7eCD3fIFU5EV9/p8zDID5AHPrUyQk0I4BgFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770421685; c=relaxed/simple;
	bh=fQIVuLrnyivL6PhmKKPSNZfgKxNTP7Deen/tBmXyhac=;
	h=Date:To:From:Subject:Message-Id; b=ton1+GOdbF3yL7C6DbeEygu5Xs9pO3L3+KikV/7B33jPJ40XQzs0gBOJix7cUifb4yBKQU8k3Rafbg7c9G6XG/+OvQLhWFwW/DqqWWSvKUExOQKdlyD3uD1ph4l4IVVg7buAOwcv3+1uKVo1k1qOHp4Wqda7w6UVOPZE0kBWjhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ib3C4QFm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ib3C4QFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF4BC116C6;
	Fri,  6 Feb 2026 23:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770421685;
	bh=fQIVuLrnyivL6PhmKKPSNZfgKxNTP7Deen/tBmXyhac=;
	h=Date:To:From:Subject:From;
	b=Ib3C4QFmFfSY0lbfMpG3kvFN991tRl9BwcVB0x6SKHI3Wo7yPRfjDl2n0bZr4lCGN
	 XIyTinWWRhFqHTBeiOr0H9LrBhr4eJs2DyhKvm9leQug2XmTO1/m/aFIWKrYNEyBr2
	 Gdn6g1OvwGt5zKPrOdq4n3JHFdimBmKlqhaPRRjE=
Date: Fri, 06 Feb 2026 15:48:04 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-unify-address-range-representation-with-damon_addr_range.patch removed from -mm tree
Message-Id: <20260206234805.4DF4BC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: unify address range representation with damon_addr_range
has been removed from the -mm tree.  Its filename was
     mm-damon-unify-address-range-representation-with-damon_addr_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Enze Li <lienze@kylinos.cn>
Subject: mm/damon: unify address range representation with damon_addr_range
Date: Thu, 29 Jan 2026 18:08:45 +0800

Currently, DAMON defines two identical structures for representing address
ranges: damon_system_ram_region and damon_addr_range.  Both structures
share the same semantic interpretation of a half-open interval [start,
end), where the start address is inclusive and the end address is
exclusive.

This duplication adds unnecessary redundancy and increases maintenance
overhead.  This patch replaces all uses of damon_system_ram_region with
the more generic damon_addr_range structure, ensuring a unified type
representation for address ranges within the DAMON subsystem.  The change
simplifies the codebase, improves readability, and avoids potential
inconsistencies in future modifications.

Link: https://lkml.kernel.org/r/20260129100845.281734-1-lienze@kylinos.cn
Signed-off-by: Enze Li <lienze@kylinos.cn>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

--- a/mm/damon/core.c~mm-damon-unify-address-range-representation-with-damon_addr_range
+++ a/mm/damon/core.c
@@ -2856,20 +2856,9 @@ done:
 	return 0;
 }
 
-/*
- * struct damon_system_ram_region - System RAM resource address region of
- *				    [@start, @end).
- * @start:	Start address of the region (inclusive).
- * @end:	End address of the region (exclusive).
- */
-struct damon_system_ram_region {
-	unsigned long start;
-	unsigned long end;
-};
-
 static int walk_system_ram(struct resource *res, void *arg)
 {
-	struct damon_system_ram_region *a = arg;
+	struct damon_addr_range *a = arg;
 
 	if (a->end - a->start < resource_size(res)) {
 		a->start = res->start;
@@ -2886,7 +2875,7 @@ static bool damon_find_biggest_system_ra
 						unsigned long *end)
 
 {
-	struct damon_system_ram_region arg = {};
+	struct damon_addr_range arg = {};
 
 	walk_system_ram_res(0, ULONG_MAX, &arg, walk_system_ram);
 	if (arg.end <= arg.start)
_

Patches currently in -mm which might be from lienze@kylinos.cn are



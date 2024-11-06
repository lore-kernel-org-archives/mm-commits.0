Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B852418858C
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855605; cv=none; b=fXw50Z1P1qBZhe1NwlB61kkcgD2nT6M0jZpN+PlOXLautTS/KMJEVu+rKZW3mN2PnfVrOCZGExkEPJpMtlc/3YNWvncy8W+nAJrnoWxrZDQUnSmwTh+8V0rrpuO1eqMtlbWIsKl7IFpmq7opRh/2gxE+aJNPt3DGSKo15rgvQLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855605; c=relaxed/simple;
	bh=teya///1qlTM7vVRUt4ytC27ifDhNhwa0qwj4MFQFq8=;
	h=Date:To:From:Subject:Message-Id; b=cs5LwoyclYM57UJLtztMUYsCB0YeZLPFIqKfObjdiPZ8eDrqaa8/D+TC+BJQd6G6b9JUbjIN58fDU04XefZrmD+UsqOdYcb/tfdOjuEekGsybcm0SHXIUTZs3ANguiprDeRSy9i/Vu6UoK9NGPONZplfk24si/Zfqy87hJe0XRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DjqbbHf+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DjqbbHf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21132C4CECF;
	Wed,  6 Nov 2024 01:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855605;
	bh=teya///1qlTM7vVRUt4ytC27ifDhNhwa0qwj4MFQFq8=;
	h=Date:To:From:Subject:From;
	b=DjqbbHf+zipsAH4llm8I/N4YIrM3Uz4YsWqWOpNIlX2+Hu9lB3EJOdZ2cfCV7+NuU
	 DN8cYfam9N98sWl/tkwXxY/qs13715i2KbW7UWsRAy+rtbdwK0UHLHj+KQfPMQO1wH
	 A+nt8YkwZVqMhtHW5es+XYIrvHN4cTQUj8sO4ke4=
Date: Tue, 05 Nov 2024 17:13:24 -0800
To: mm-commits@vger.kernel.org,linux@rasmusvillemoes.dk,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] resource-introduce-is_type_match-helper-and-use-it.patch removed from -mm tree
Message-Id: <20241106011325.21132C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: resource: introduce is_type_match() helper and use it
has been removed from the -mm tree.  Its filename was
     resource-introduce-is_type_match-helper-and-use-it.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: resource: introduce is_type_match() helper and use it
Date: Wed, 25 Sep 2024 18:43:35 +0300

There are already a couple of places where we may replace a few lines of
code by calling a helper, which increases readability while deduplicating
the code.

Introduce is_type_match() helper and use it.

Link: https://lkml.kernel.org/r/20240925154355.1170859-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

--- a/kernel/resource.c~resource-introduce-is_type_match-helper-and-use-it
+++ a/kernel/resource.c
@@ -297,6 +297,11 @@ int release_resource(struct resource *ol
 
 EXPORT_SYMBOL(release_resource);
 
+static bool is_type_match(struct resource *p, unsigned long flags, unsigned long desc)
+{
+	return (p->flags & flags) == flags && (desc == IORES_DESC_NONE || desc == p->desc);
+}
+
 /**
  * find_next_iomem_res - Finds the lowest iomem resource that covers part of
  *			 [@start..@end].
@@ -339,13 +344,9 @@ static int find_next_iomem_res(resource_
 		if (p->end < start)
 			continue;
 
-		if ((p->flags & flags) != flags)
-			continue;
-		if ((desc != IORES_DESC_NONE) && (desc != p->desc))
-			continue;
-
 		/* Found a match, break */
-		break;
+		if (is_type_match(p, flags, desc))
+			break;
 	}
 
 	if (p) {
@@ -540,7 +541,7 @@ static int __region_intersects(struct re
 	int type = 0; int other = 0;
 	struct resource *p, *dp;
 	struct resource res, o;
-	bool is_type, covered;
+	bool covered;
 
 	res.start = start;
 	res.end = start + size - 1;
@@ -548,9 +549,7 @@ static int __region_intersects(struct re
 	for (p = parent->child; p ; p = p->sibling) {
 		if (!resource_intersection(p, &res, &o))
 			continue;
-		is_type = (p->flags & flags) == flags &&
-			(desc == IORES_DESC_NONE || desc == p->desc);
-		if (is_type) {
+		if (is_type_match(p, flags, desc)) {
 			type++;
 			continue;
 		}
@@ -570,9 +569,7 @@ static int __region_intersects(struct re
 		for_each_resource(p, dp, false) {
 			if (!resource_overlaps(dp, &res))
 				continue;
-			is_type = (dp->flags & flags) == flags &&
-				(desc == IORES_DESC_NONE || desc == dp->desc);
-			if (is_type) {
+			if (is_type_match(dp, flags, desc)) {
 				type++;
 				/*
 				 * Range from 'o.start' to 'dp->start'
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are



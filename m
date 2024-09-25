Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D48F1BC2A
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 20:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727296619; cv=none; b=L908usLEhFiYekmBzrB06x8cdDicND8S/qnm8Seg5GRVSIaX7SOP1hiEbjI67Ys9m9RpVfLIJ6+wvfvwrM60b2ppIGkir2VmF/Mf6v2jTx8ssJKLlYDYNtz6Nt0Ojjo5sJsPYxG8lPl1PQdE6FDCnmxVrDdqCB68jPkpdpZUmr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727296619; c=relaxed/simple;
	bh=3HSgYwZrLiE+oUOOkpkKIET6n0hRskJThN2NWGiJnBA=;
	h=Date:To:From:Subject:Message-Id; b=V+FJ+qR6/ag/3PUPaFm6hRyTa+xBN825siwAFFmMK3mnIn4iRutgojSbdU4KW/ShqAcz/Rt6uAbScwQQrXmDs0zAyc738OzvMLRnFC/7vMKTS+HA8Sia+UeYj4qpkWa8gHFe8HloJi+7oBhUbqA0DiVp+0ZQx9aGPPiLOLoSh3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GrlqjmGD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GrlqjmGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF2DC4CEC3;
	Wed, 25 Sep 2024 20:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727296619;
	bh=3HSgYwZrLiE+oUOOkpkKIET6n0hRskJThN2NWGiJnBA=;
	h=Date:To:From:Subject:From;
	b=GrlqjmGD/FPYWfJ9ask+QvCNC5tfeZ3wehQgkvijY7HnRzDviJrFzJVZeCr551yCu
	 5dZBheItZ0ky0/t2IYFBQGRUlBoJ3pRGulR5MIrBjtrGhyvhrduri6R8z2r5an6Jqa
	 8MtnnLCD1RgmnCL8otFwDMuF5sSV42AFii6CZVyc=
Date: Wed, 25 Sep 2024 13:36:58 -0700
To: mm-commits@vger.kernel.org,linux@rasmusvillemoes.dk,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + resource-introduce-is_type_match-helper-and-use-it.patch added to mm-nonmm-unstable branch
Message-Id: <20240925203659.5CF2DC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: resource: introduce is_type_match() helper and use it
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     resource-introduce-is_type_match-helper-and-use-it.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/resource-introduce-is_type_match-helper-and-use-it.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
@@ -542,7 +543,7 @@ static int __region_intersects(struct re
 	int type = 0; int other = 0;
 	struct resource *p, *dp;
 	struct resource res, o;
-	bool is_type, covered;
+	bool covered;
 
 	res.start = start;
 	res.end = start + size - 1;
@@ -550,9 +551,7 @@ static int __region_intersects(struct re
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
@@ -572,9 +571,7 @@ static int __region_intersects(struct re
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

resource-replace-open-coded-resource_intersection.patch
resource-introduce-is_type_match-helper-and-use-it.patch


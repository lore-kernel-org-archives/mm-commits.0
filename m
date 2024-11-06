Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F5118858C
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855604; cv=none; b=jYkPsQDqhb+v9vsYmeoMfyZLfmVukpmN/JDe8uLVcZsXyenk4E94MVwKJpjRqtcDeE51tl/xRNz7G8bn6Z+/v6aBU0rmJ/IWDkZwnErEbkD5cutJ0hlgP041P6fIfvtyY6eV//pCJGSpraDDwYaMX8SLGvq2W4jB730siPXiK2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855604; c=relaxed/simple;
	bh=5gFwy7+0N1dJv7dDngikUOBJXjeEWV9zxpr2ii4Db0I=;
	h=Date:To:From:Subject:Message-Id; b=ofP53rWEua3MvaCUB6ILWYRFEkvuheaNw1h4dBCMUGNNeXcnlTtxi2Ng0UfrhV/C3VY8QkCCF8D8ttLqidMSInjs2V9uylXEpzTbF2fkntbAf0I65Rl9Bx1lGMGU9fNqehv13LR1h1CFVVkPEGwiSCNbg7qedgQaWWPTMIs4vUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kJghc8aK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kJghc8aK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE510C4CECF;
	Wed,  6 Nov 2024 01:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855604;
	bh=5gFwy7+0N1dJv7dDngikUOBJXjeEWV9zxpr2ii4Db0I=;
	h=Date:To:From:Subject:From;
	b=kJghc8aKQsmj0rHVz5Ny1KzDnJFoLJQBLTXkZbrqgrfKlAe8x0L9K8Pms0SvFgOir
	 507Uw7n9XvOoIDNeQl9FNV/NXvvKIEbfuvRl6J4Qg43yq6VdgSEqvjCxHVwtz7+2Zw
	 dRi+W3bZubFTf+TLU1vaJR0dL6IGO7byl7V+AzBw=
Date: Tue, 05 Nov 2024 17:13:23 -0800
To: mm-commits@vger.kernel.org,linux@rasmusvillemoes.dk,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] resource-replace-open-coded-resource_intersection.patch removed from -mm tree
Message-Id: <20241106011323.EE510C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: resource: replace open coded resource_intersection()
has been removed from the -mm tree.  Its filename was
     resource-replace-open-coded-resource_intersection.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: resource: replace open coded resource_intersection()
Date: Wed, 25 Sep 2024 18:43:34 +0300

Patch series "resource: A couple of cleanups".

A couple of ad-hoc cleanups since there was a recent development of
the code in question. No functional changes intended.


This patch (of 2):

__region_intersects() uses open coded resource_intersection().  Replace it
with existing API which also make more clear what we are checking.

Link: https://lkml.kernel.org/r/20240925154355.1170859-1-andriy.shevchenko@linux.intel.com
Link: https://lkml.kernel.org/r/20240925154355.1170859-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/kernel/resource.c~resource-replace-open-coded-resource_intersection
+++ a/kernel/resource.c
@@ -537,17 +537,16 @@ static int __region_intersects(struct re
 			       size_t size, unsigned long flags,
 			       unsigned long desc)
 {
-	resource_size_t ostart, oend;
 	int type = 0; int other = 0;
 	struct resource *p, *dp;
+	struct resource res, o;
 	bool is_type, covered;
-	struct resource res;
 
 	res.start = start;
 	res.end = start + size - 1;
 
 	for (p = parent->child; p ; p = p->sibling) {
-		if (!resource_overlaps(p, &res))
+		if (!resource_intersection(p, &res, &o))
 			continue;
 		is_type = (p->flags & flags) == flags &&
 			(desc == IORES_DESC_NONE || desc == p->desc);
@@ -568,8 +567,6 @@ static int __region_intersects(struct re
 		 * |-- "System RAM" --||-- "CXL Window 0a" --|
 		 */
 		covered = false;
-		ostart = max(res.start, p->start);
-		oend = min(res.end, p->end);
 		for_each_resource(p, dp, false) {
 			if (!resource_overlaps(dp, &res))
 				continue;
@@ -578,17 +575,17 @@ static int __region_intersects(struct re
 			if (is_type) {
 				type++;
 				/*
-				 * Range from 'ostart' to 'dp->start'
+				 * Range from 'o.start' to 'dp->start'
 				 * isn't covered by matched resource.
 				 */
-				if (dp->start > ostart)
+				if (dp->start > o.start)
 					break;
-				if (dp->end >= oend) {
+				if (dp->end >= o.end) {
 					covered = true;
 					break;
 				}
 				/* Remove covered range */
-				ostart = max(ostart, dp->end + 1);
+				o.start = max(o.start, dp->end + 1);
 			}
 		}
 		if (!covered)
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are



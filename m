Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5436D1BC2A
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 20:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727296618; cv=none; b=eo0efWrB6hoU+JCCG70n4LTYmtj/mqyq1paW9pVaOk5UxFdZavxPPxkdxRxirfsVzoj2QNun/Bf1nz1ndKl/hRjOpq/XqP381c18gW9BYvU6JTW2ABlsjBJ4/zrXJYMjsk1PDWMko3QAftfLXKsMZsWO2GNh8OFsDo3rG3wZ8uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727296618; c=relaxed/simple;
	bh=lHqk8ro9yIc96m4tFjq7s8U4ZybCuNiv4gDVGFphOKk=;
	h=Date:To:From:Subject:Message-Id; b=Ci6bp4R8/JQ8aryytDgO/8yjhE5+LIEfe0edc5Q189T+1s1I8j6rwTnVppU7JE1bn6mVvO0SA1a6pJlajNdjnlCFc3EwhEqHPvfrjtLAbybVPEa9InhtunyFCFbjRN6PM6coegp+2K1VzsYrlSW61/kBBwnrFkZmP1YXSrwSfFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M/lrqLf9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M/lrqLf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26494C4CEC3;
	Wed, 25 Sep 2024 20:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727296618;
	bh=lHqk8ro9yIc96m4tFjq7s8U4ZybCuNiv4gDVGFphOKk=;
	h=Date:To:From:Subject:From;
	b=M/lrqLf9YLNNInemWDnG6PxK/6p/Ghy+8nQ14G6KOy6zmvlNtN7c94GFe8VJWquoM
	 PeqLrgH8iXVYPVmvIpF30++m9H/Z+AB8iFSJIy2nGZyyXLK3qgfNuMA5c6nFuIel5r
	 FVgK9P6MZ5yjI/h66uiULr7zZdiO2GhqJqnVvpGQ=
Date: Wed, 25 Sep 2024 13:36:57 -0700
To: mm-commits@vger.kernel.org,linux@rasmusvillemoes.dk,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + resource-replace-open-coded-resource_intersection.patch added to mm-nonmm-unstable branch
Message-Id: <20240925203658.26494C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: resource: replace open coded resource_intersection()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     resource-replace-open-coded-resource_intersection.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/resource-replace-open-coded-resource_intersection.patch

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
@@ -539,17 +539,16 @@ static int __region_intersects(struct re
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
@@ -570,8 +569,6 @@ static int __region_intersects(struct re
 		 * |-- "System RAM" --||-- "CXL Window 0a" --|
 		 */
 		covered = false;
-		ostart = max(res.start, p->start);
-		oend = min(res.end, p->end);
 		for_each_resource(p, dp, false) {
 			if (!resource_overlaps(dp, &res))
 				continue;
@@ -580,17 +577,17 @@ static int __region_intersects(struct re
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

resource-replace-open-coded-resource_intersection.patch
resource-introduce-is_type_match-helper-and-use-it.patch


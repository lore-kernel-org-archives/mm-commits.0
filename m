Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9896C2D46B3
	for <mm-commits@vger.kernel.org>; Thu, 29 Jan 2026 22:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769727296; cv=none; b=G94pT8O8Wvk1fpZFw1embhJsTE3QLQI0IBzcU7SeyvGi3qO2E9tXgixb6GXSLbh0TZ8L2rM/7/BqT4NTqdMOVWZpTLqBXgnwuHnIU/KwRSsTTMfMleGrG9OmrCX33nXZAX8LvwtMZsDm+Z8KBzaQzAY5OCnXayTm8O4Ux3m7Pi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769727296; c=relaxed/simple;
	bh=xWdf1aiILvIWrepTgM1TBgOXhRkB6bqazFpzEE8UqmA=;
	h=Date:To:From:Subject:Message-Id; b=W+CzDQ8NAG2g6efrM+EnfZlGMKde01j3sgK7iDnOJqIWxzmRy7/dAYU1XxiQn+smUNbFt3uswAFE2cNB15izS13phNfM4Mba3UUg6z4mPqWbOgIJppzjrHQIGduv0O1a83JmE5ZgpesHFOsDJYq0qV4JK5lwI9MyEYxaY5hlT7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2oMtrC0w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2oMtrC0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB6FC4CEF7;
	Thu, 29 Jan 2026 22:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769727296;
	bh=xWdf1aiILvIWrepTgM1TBgOXhRkB6bqazFpzEE8UqmA=;
	h=Date:To:From:Subject:From;
	b=2oMtrC0wA4CFDykF696cHMMAalU+D/Ii1FgvxykicS/nsTCvQs+MBKo5HIJWLqQUL
	 sH3bUZD91G5LOPa6OL2Gu2RtdH5JOdsEfBcA+VA2JehQzIG3SG+3AWeBHX+TzUVgzh
	 w9X7VxvBbTs5adIlL7Nlj80GfQOCyfZCDaEtrMoY=
Date: Thu, 29 Jan 2026 14:54:55 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-unify-address-range-representation-with-damon_addr_range.patch added to mm-new branch
Message-Id: <20260129225456.1BB6FC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: unify address range representation with damon_addr_range
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-unify-address-range-representation-with-damon_addr_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-unify-address-range-representation-with-damon_addr_range.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-damon-unify-address-range-representation-with-damon_addr_range.patch


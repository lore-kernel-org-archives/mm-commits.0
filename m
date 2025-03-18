Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A987D82D91
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274560; cv=none; b=REUT8pHQwnUHxSL8JKA7YfflSPZdHuoVQLu6Jife2RtNquHBqmfjENpTt5YTiTFtotcWjjz6fu0SQpeINGgOLzW77HmsO1247k3QpbxBy4Z86gGmHQFbaVxFECw9HETOITnlQKNGCuihv3g5XqeGwneNRsC9fHvOQOS7AsoFV0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274560; c=relaxed/simple;
	bh=1ZLbNYeJTTA0Pv/NmMr2iHF9PMEbSX4+bdK2EARlBzY=;
	h=Date:To:From:Subject:Message-Id; b=t59qhATdJfSrPENAWoRHw0T0XlCvYO3uiN1HUZde0+ypLg1FzoJYvS1Z0w1yoqiN8aQtgu51KGSoKgRQ51UKJCZNWTrKgWoGg8tX9SbSvt14ZwBS9SzcsQUJP9ZWohL0PczMmp44xaZgg2xnHv6//rU6QXdb5yL00faP8GzX7x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gH4KUdJH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gH4KUdJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CFA1C4CEEA;
	Tue, 18 Mar 2025 05:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274560;
	bh=1ZLbNYeJTTA0Pv/NmMr2iHF9PMEbSX4+bdK2EARlBzY=;
	h=Date:To:From:Subject:From;
	b=gH4KUdJHZX0Ziex+TIAF+/aKk8M5ET5W/JAM3Vit5gWzwNcPNOmmESI/9+QmX0MWR
	 upcTADq6O/HJDAlJQSlMRiI7ZBOHoiShxQku8BwOmYDDsDWBPOnkWPUu2Rak6UlDpK
	 XJ5nSOi3Q9OwgUrU37ndUHj3mgeSJF9pTkKaiSJ0=
Date: Mon, 17 Mar 2025 22:09:19 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-expose-damos_filter_for_ops-to-damon-kernel-api-callers.patch removed from -mm tree
Message-Id: <20250318050920.7CFA1C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: expose damos_filter_for_ops() to DAMON kernel API callers
has been removed from the -mm tree.  Its filename was
     mm-damon-core-expose-damos_filter_for_ops-to-damon-kernel-api-callers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: expose damos_filter_for_ops() to DAMON kernel API callers
Date: Wed, 5 Mar 2025 14:27:29 -0800

damos_filter_for_ops() can be useful to avoid putting wrong type of
filters in wrong place.  Make it be exposed to DAMON kernel API callers.

Link: https://lkml.kernel.org/r/20250305222733.59089-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    1 +
 mm/damon/core.c       |    9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/include/linux/damon.h~mm-damon-core-expose-damos_filter_for_ops-to-damon-kernel-api-callers
+++ a/include/linux/damon.h
@@ -894,6 +894,7 @@ void damon_update_region_access_rate(str
 struct damos_filter *damos_new_filter(enum damos_filter_type type,
 		bool matching, bool allow);
 void damos_add_filter(struct damos *s, struct damos_filter *f);
+bool damos_filter_for_ops(enum damos_filter_type type);
 void damos_destroy_filter(struct damos_filter *f);
 
 struct damos_quota_goal *damos_new_quota_goal(
--- a/mm/damon/core.c~mm-damon-core-expose-damos_filter_for_ops-to-damon-kernel-api-callers
+++ a/mm/damon/core.c
@@ -281,7 +281,14 @@ struct damos_filter *damos_new_filter(en
 	return filter;
 }
 
-static bool damos_filter_for_ops(enum damos_filter_type type)
+/**
+ * damos_filter_for_ops() - Return if the filter is ops-hndled one.
+ * @type:	type of the filter.
+ *
+ * Return: true if the filter of @type needs to be handled by ops layer, false
+ * otherwise.
+ */
+bool damos_filter_for_ops(enum damos_filter_type type)
 {
 	switch (type) {
 	case DAMOS_FILTER_TYPE_ADDR:
_

Patches currently in -mm which might be from sj@kernel.org are



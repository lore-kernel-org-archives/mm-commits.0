Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA931FBBDE
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837203; cv=none; b=F6YQfwZ2UjO1j4hxEm8WV6e2A9Jic1bfKFN4qYLg7Nbqd62cPAZ8V3P88KMybWYRX8sMipGxkG5jYFL2UH0zxGv8rfQ55mamCEfOHaIe3n8TmcFw7f1sBc0Ctpgb0OAJ7CWiu1IrEyEw/P7tInqt+gn+kTkhcc3/6MM2Tw3rAEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837203; c=relaxed/simple;
	bh=Qo/bd8iWjNEvmUtbYC7yS+yfBDt2dWshgVnHUVn+sFw=;
	h=Date:To:From:Subject:Message-Id; b=rdgnTpx6grpuu0zCpCCupH22NEqkOJMi7+9Ldg04l8JeWRhJL8VTipy1PCxxVHwIXK+ZIA9b4NIPNUeULpj4m1MFUGIVsaQISNMtEk6gUHvDjtbgBDdDMPNDTS4UzbAC4d90VPbF09Txics2d+zdefKcIR8QUCqmYQjuBs5ezo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u0qB1gc7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u0qB1gc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52B6C4CEDD;
	Tue, 14 Jan 2025 06:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837203;
	bh=Qo/bd8iWjNEvmUtbYC7yS+yfBDt2dWshgVnHUVn+sFw=;
	h=Date:To:From:Subject:From;
	b=u0qB1gc7WIEWOO2rmhh9F2CdAazPLJeoM1Ek9g/PWFeGpo51vhfnWkkcY6eg2azhX
	 ZmCe2woWO9RGOq6KO+YR44sz19TboN/Igc6Cux8DrkD6Lz86pMzp4jrkWwO0q+/OdH
	 XyWU4a0md3HZErkH0cLjjaQF4L7K1VSFi4aW6OKU=
Date: Mon, 13 Jan 2025 22:46:43 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-add-damos_filter-allow-field.patch removed from -mm tree
Message-Id: <20250114064643.A52B6C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: add damos_filter->allow field
has been removed from the -mm tree.  Its filename was
     mm-damon-core-add-damos_filter-allow-field.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: add damos_filter->allow field
Date: Thu, 9 Jan 2025 09:51:18 -0800

DAMOS filters work as only exclusive (reject) filters.  This makes it easy
to be confused, and restrictive at combining multiple filters for covering
various types of memory.

Add a field named 'allow' to damos_filter.  The field will be used to
indicate whether the filter should work for inclusion or exclusion.  To
keep the old behavior, set it as 'false' (work as exclusive filter) by
default, from damos_new_filter().

Following two commits will make the core and operations set layers, which
handles damos_filter objects, respect the field, respectively.

Link: https://lkml.kernel.org/r/20250109175126.57878-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    4 +++-
 mm/damon/core.c       |    1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/damon.h~mm-damon-core-add-damos_filter-allow-field
+++ a/include/linux/damon.h
@@ -348,7 +348,8 @@ enum damos_filter_type {
 /**
  * struct damos_filter - DAMOS action target memory filter.
  * @type:	Type of the target memory.
- * @matching:	If the @type-matching memory should be filtered out.
+ * @matching:	Whether this is for @type-matching memory.
+ * @allow:	Whether to include or exclude the @matching memory.
  * @memcg_id:	Memcg id of the question if @type is DAMOS_FILTER_MEMCG.
  * @addr_range:	Address range if @type is DAMOS_FILTER_TYPE_ADDR.
  * @target_idx:	Index of the &struct damon_target of
@@ -365,6 +366,7 @@ enum damos_filter_type {
 struct damos_filter {
 	enum damos_filter_type type;
 	bool matching;
+	bool allow;
 	union {
 		unsigned short memcg_id;
 		struct damon_addr_range addr_range;
--- a/mm/damon/core.c~mm-damon-core-add-damos_filter-allow-field
+++ a/mm/damon/core.c
@@ -275,6 +275,7 @@ struct damos_filter *damos_new_filter(en
 		return NULL;
 	filter->type = type;
 	filter->matching = matching;
+	filter->allow = false;
 	INIT_LIST_HEAD(&filter->list);
 	return filter;
 }
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch


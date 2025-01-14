Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1178523C717
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837063; cv=none; b=aaLN/ctVWEm2WxZTF7k3Jxg49UMnrvz2pNi+dGkdGyVIWMVXQFQXxmRBn9dLIhI4G/WKWC6xyknNFvqTiIbAZoytEzAOM0+QfVHl+SbnbdB84BlaaKX/t27vzwAjKfj765F4T7t7oqgWEpTN1NCKJxQ02y9LrdLFvhSVmkgRXVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837063; c=relaxed/simple;
	bh=+MIoKEwdYHk+GCrrUjxNNFcZ1ryjmATl2qyGfXPu/QM=;
	h=Date:To:From:Subject:Message-Id; b=byhuAGaIv0o+BZDWHb43trBUbenIjb6qjKQRIR1qZQgOJLR+/1pKuro40n6YdMaL91Uyis9krRmu/wHoF9d6dscU0aA2llDrG99ARGbPn5LkgxQk8ZV5lwoXQdid6ILLbe6iBKmtRxTTPKcvGEv6ucgwsgUoMXEqBA9SBoCclGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GMNgBI9w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GMNgBI9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB97AC4CEDD;
	Tue, 14 Jan 2025 06:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837062;
	bh=+MIoKEwdYHk+GCrrUjxNNFcZ1ryjmATl2qyGfXPu/QM=;
	h=Date:To:From:Subject:From;
	b=GMNgBI9wb0OcKBaU4BFo7idS1FIvM+AUw9VMIJJaLvJiSIyDAuHvd4tbKY1Hro7bS
	 LWy1ZZpoKgpGdm65EU7mTlrxImjkiFVjhbbsnej3FS4vj6GPqsprLTtQRJG+Y7Feai
	 F+sDsfl1nCTTRe+X9UKdvnRz5gtibmHW9wUNuvoM=
Date: Mon, 13 Jan 2025 22:44:22 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] samples-damon-prcl-implement-schemes-setup.patch removed from -mm tree
Message-Id: <20250114064422.DB97AC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon/prcl: implement schemes setup
has been removed from the -mm tree.  Its filename was
     samples-damon-prcl-implement-schemes-setup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: samples/damon/prcl: implement schemes setup
Date: Tue, 10 Dec 2024 13:50:30 -0800

Implement a proactive cold memory regions reclaiming logic of prcl sample
module using DAMOS.  The logic treats memory regions that not accessed at
all for five or more seconds as cold, and reclaim those as soon as found.

Link: https://lkml.kernel.org/r/20241210215030.85675-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/prcl.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/samples/damon/prcl.c~samples-damon-prcl-implement-schemes-setup
+++ a/samples/damon/prcl.c
@@ -49,6 +49,7 @@ static int damon_sample_prcl_after_aggre
 static int damon_sample_prcl_start(void)
 {
 	struct damon_target *target;
+	struct damos *scheme;
 
 	pr_info("start\n");
 
@@ -75,6 +76,25 @@ static int damon_sample_prcl_start(void)
 
 	ctx->callback.after_aggregation = damon_sample_prcl_after_aggregate;
 
+	scheme = damon_new_scheme(
+			&(struct damos_access_pattern) {
+			.min_sz_region = PAGE_SIZE,
+			.max_sz_region = ULONG_MAX,
+			.min_nr_accesses = 0,
+			.max_nr_accesses = 0,
+			.min_age_region = 50,
+			.max_age_region = UINT_MAX},
+			DAMOS_PAGEOUT,
+			0,
+			&(struct damos_quota){},
+			&(struct damos_watermarks){},
+			NUMA_NO_NODE);
+	if (!scheme) {
+		damon_destroy_ctx(ctx);
+		return -ENOMEM;
+	}
+	damon_set_schemes(ctx, &scheme, 1);
+
 	return damon_start(&ctx, 1, true);
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch


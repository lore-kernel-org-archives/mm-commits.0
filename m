Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F148138A9AE
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898339; cv=none; b=R1QNU+xeTOMYCmnzJUmmh3P9lMwZjX2ErtRjQciKXW8D1TWvBK9AQQLcPhpgokhPNPbqrEdqLB2Y5VQ1XdBPv78XRTNfmQRgwfgFEoxHKULLMwUXQOip98rEfD43q+ZyanwevWqxWozVIzYLVwfEcjMZS2c+MW0gUfPU/gpD7Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898339; c=relaxed/simple;
	bh=NZNIHUDKRxtgSlw2JegyihHS+PxdepopbzDjggfhQ8g=;
	h=Date:To:From:Subject:Message-Id; b=Jgnl5APbW4NsUb55ljYyci5V6R1/j9BtbzgWN5MuU/m7q53TWD+U9esNZNacba1kkfGdYqLKiokdQm8aot1b8fKAcJBAYaEZD7s49z8JE5s/yZVSynNOQzk/o9mcY4hvaDWjJnj++bmNkThie9u7iP/To68RpIEOtISiW+54RiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qX3Jtxr+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qX3Jtxr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E90C4CEF1;
	Sat, 31 Jan 2026 22:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898338;
	bh=NZNIHUDKRxtgSlw2JegyihHS+PxdepopbzDjggfhQ8g=;
	h=Date:To:From:Subject:From;
	b=qX3Jtxr+XvT+cfy44cY24TxO5yZjosTGZCCnFrUT6WxwYeiNZwPKUs+gH4FRZ7R94
	 N/1L591O5DNqWm5YUZdyTS8U8QDtWhTaGO5pbpj75poTOkfL5o7YOev0BOIG1kcY9X
	 J1rIhoGOlmr7PwqdoSoHR6okdr1a3lFBvsiD8y1Q=
Date: Sat, 31 Jan 2026 14:25:38 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-rename-damos_filter_out-to-damos_core_filter_out.patch removed from -mm tree
Message-Id: <20260131222538.A7E90C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: rename damos_filter_out() to damos_core_filter_out()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-rename-damos_filter_out-to-damos_core_filter_out.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: rename damos_filter_out() to damos_core_filter_out()
Date: Sat, 17 Jan 2026 09:52:53 -0800

DAMOS filters are processed on the core layer and operations layer,
depending on their types.  damos_filter_out() in core.c, which is for only
core layer handled filters, can confuse the fact.  Rename it to
damos_core_filter_out(), to be more explicit about the fact.

Link: https://lkml.kernel.org/r/20260117175256.82826-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-rename-damos_filter_out-to-damos_core_filter_out
+++ a/mm/damon/core.c
@@ -1813,7 +1813,7 @@ static bool damos_filter_match(struct da
 	return matched == filter->matching;
 }
 
-static bool damos_filter_out(struct damon_ctx *ctx, struct damon_target *t,
+static bool damos_core_filter_out(struct damon_ctx *ctx, struct damon_target *t,
 		struct damon_region *r, struct damos *s)
 {
 	struct damos_filter *filter;
@@ -1960,7 +1960,7 @@ static void damos_apply_scheme(struct da
 				goto update_stat;
 			damon_split_region_at(t, r, sz);
 		}
-		if (damos_filter_out(c, t, r, s))
+		if (damos_core_filter_out(c, t, r, s))
 			return;
 		ktime_get_coarse_ts64(&begin);
 		trace_damos_before_apply(cidx, sidx, tidx, r,
_

Patches currently in -mm which might be from sj@kernel.org are



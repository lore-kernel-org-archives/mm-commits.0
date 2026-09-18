Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E063932CE;
	Fri, 18 Sep 2026 05:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789710233; cv=none; b=DAWrFaouggCL6dmDgryQZ8f3Lo2W8yCfxMeSr1v/VnAptBAscDMsPGrsqydJszcyjAPcvXzrtUa0FDPAct+Lc5jRPDJeKEEtlIfR3wmnP6jAQXokbaPJdW9FA7INFxLUyvVhCUbQLv0lPWRlR2xnOVuWeg/9WqdrISIihYEzMVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789710233; c=relaxed/simple;
	bh=jPWFvLWG0y+oiIP+s9cIg3JP+GVAAIRXA2ne/RLw7PI=;
	h=Date:To:From:Subject:Message-Id; b=dra+JS5u/Q/Sy5QoKWhHPA2bRAoNXVmoHMCsEweWJH/altEHGIzqiIt6H4hDNl627n1wjhJ6mAuLHIrSbBkqOIKp9HU5Wf9zX+jBxZoGMVcLM93liEI7LkMThBpP+1SpF0+U+9uM7roc86EsVfGBFQnVkZbSGrgFiVIkgHyEiBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MB71wfuS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MB71wfuS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8013F1F000FF;
	Fri, 18 Sep 2026 05:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789710232;
	bh=e8J+ntapP9KZ+ND2ag/ZMWBaN0t1gSWJ7y7kpvl+RKQ=;
	h=Date:To:From:Subject;
	b=MB71wfuS8Stv+pb1g7lIVv2j6FtCwBifPXKJzxRL9w1o0sptZQAC3JEMoCcagLS9U
	 REDY1UVtvpGelMPuvLOjIvSnRmRPc2i6GakQfWovNRh+NcySQnHqXS19UWCcWMd9hQ
	 bplNd0XyQBAdknPVPCDvu27RET1Xe/p/qZR14BXM=
Date: Thu, 17 Sep 2026 22:43:52 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,aethernet65535@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-core-allow-esz-to-be-set-to-zero.patch removed from -mm tree
Message-Id: <20260918054352.8013F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: allow esz to be set to zero
has been removed from the -mm tree.  Its filename was
     mm-damon-core-allow-esz-to-be-set-to-zero.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liew Rui Yan <aethernet65535@gmail.com>
Subject: mm/damon/core: allow esz to be set to zero
Date: Tue, 8 Sep 2026 06:54:11 -0700

When the temporal quota goal tuner determines that the goal has been
achieved (score >= 10000), it sets esz_bp to zero so that the esz becomes
zero.  However, damos_set_effective_quota() clamps the esz to
min_region_sz when quota->ms is set.

This is a minor issue, the main problem is that it doesn't match the
description in the documentation, which state that if the goal has already
been [over-]achieved, the quota will be set to zero.

Fix this by set quota (esz) as minimum as possible.

Link: https://lore.kernel.org/20260908135413.97570-1-sj@kernel.org
Fixes: 8bbde987c2b8 ("mm/damon/core: disallow time-quota setting zero esz")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # v7.1.x
---

 mm/damon/core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-allow-esz-to-be-set-to-zero
+++ a/mm/damon/core.c
@@ -3091,6 +3091,7 @@ static void damos_set_effective_quota(st
 	struct damos_quota *quota = &s->quota;
 	unsigned long throughput;
 	unsigned long esz = ULONG_MAX;
+	unsigned long esz_time;
 
 	if (!quota->ms && list_empty(&quota->goals)) {
 		quota->esz = quota->sz;
@@ -3111,8 +3112,8 @@ static void damos_set_effective_quota(st
 					1000000, quota->total_charged_ns);
 		else
 			throughput = PAGE_SIZE * 1024;
-		esz = min(throughput * quota->ms, esz);
-		esz = max(ctx->min_region_sz, esz);
+		esz_time = max(throughput * quota->ms, ctx->min_region_sz);
+		esz = min(esz_time, esz);
 	}
 
 	if (quota->sz && quota->sz < esz)
_

Patches currently in -mm which might be from aethernet65535@gmail.com are

docs-mm-damon-design-accurate-semantics-of-nr_snapshots.patch
docs-mm-damon-design-difference-between-watermarks-and-nr_snapshots.patch
docs-mm-damon-design-fix-typo-of-max_nr_snapshots.patch
docs-mm-damon-design-clarify-when-qt_exceeds-increases.patch
docs-mm-damon-design-fix-typos-in-temporal-auto-tuning-algorithm-section.patch


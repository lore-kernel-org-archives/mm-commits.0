Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B352749CE
	for <mm-commits@vger.kernel.org>; Wed, 17 Sep 2025 21:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758144548; cv=none; b=hbtK7SlSnziLo4zVUTrPJdOJSrP0NlbddSplJ/vf0W5lt3Stj3cKzYuGgLNn8AXndmcWReAfBy6LqbPmEfWOVjHVV9ppPINMCHMIYkkOVn3/LpTJVNkBVkJKwRaE4BcQYIHbL7BgXo06Aoja3ZIBVaQ3nLxOZjTVO/14hAoHlsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758144548; c=relaxed/simple;
	bh=ykLqWVEDRVrUauBqYdQmzVSVxIz1+k54a2nLy1pTPtI=;
	h=Date:To:From:Subject:Message-Id; b=UkoGQJAn4N7FbgYCGwuNvKdL1PIAKKJ/w6o1xRdy+EjIAxdXA/7mrseGSZrXllY5bq6puXfyfDggS3W++2oHTss1CqIYqWRHXp+bOHTpRD2yJXOUE8U1DL5BrtWhtOefOfRbgElX+aJyA0EdHxEqH60Dzmp3aKQroJp37xaoCis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rbeTs5Ix; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rbeTs5Ix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD14FC4CEF9;
	Wed, 17 Sep 2025 21:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758144547;
	bh=ykLqWVEDRVrUauBqYdQmzVSVxIz1+k54a2nLy1pTPtI=;
	h=Date:To:From:Subject:From;
	b=rbeTs5IxU02FssHY7DQXZfpahlECLoB9+7BW53sxJLuTEy/gTtKv4zKhCKwTgrOfi
	 hwAOTuR9QEHs1W/PMTcEM9HrRdb0tB06T4gJs5FQTM4vy8TRd6Z/L9++orCbXOgpCS
	 UdKyg80pEe6H7k4Fs7xqFT4UQU/7Eia6QFBRl0NU=
Date: Wed, 17 Sep 2025 14:29:07 -0700
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,wangkefeng.wang@huawei.com,clm@fb.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-set-damon_ctx-min_sz_region-only-for-paddr-use-case.patch added to mm-new branch
Message-Id: <20250917212907.BD14FC4CEF9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: set damon_ctx->min_sz_region only for paddr use case
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-set-damon_ctx-min_sz_region-only-for-paddr-use-case.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-set-damon_ctx-min_sz_region-only-for-paddr-use-case.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: set damon_ctx->min_sz_region only for paddr use case
Date: Wed, 17 Sep 2025 08:31:54 -0700

damon_ctx->addr_unit is respected only for physical address space
monitoring use case.  Meanwhile, damon_ctx->min_sz_region is used by the
core layer for aligning regions, regardless of whether it is set for
physical address space monitoring or virtual address spaces monitoring. 
And it is set as 'DAMON_MIN_REGION / damon_ctx->addr_unit'.  Hence, if
user sets ->addr_unit on virtual address spaces monitoring mode, regions
can be unexpectedly aligned in <PAGE_SIZE granularity.  It shouldn't cause
crash-like issues but make monitoring and DAMOS behavior difficult to
understand.

Fix the unexpected behavior by setting ->min_sz_region only when it is
configured for physical address space monitoring.

The issue was found from a result of Chris' experiments that thankfully
shared with me off-list.

Link: https://lkml.kernel.org/r/20250917160041.53187-1-sj@kernel.org
Fixes: d8f867fa0825 ("mm/damon: add damon_ctx->min_sz_region")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: ze zuo <zuoze1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-set-damon_ctx-min_sz_region-only-for-paddr-use-case
+++ a/mm/damon/sysfs.c
@@ -1435,7 +1435,10 @@ static int damon_sysfs_apply_inputs(stru
 	if (err)
 		return err;
 	ctx->addr_unit = sys_ctx->addr_unit;
-	ctx->min_sz_region = max(DAMON_MIN_REGION / sys_ctx->addr_unit, 1);
+	/* addr_unit is respected by only DAMON_OPS_PADDR */
+	if (sys_ctx->ops_id == DAMON_OPS_PADDR)
+		ctx->min_sz_region = max(
+				DAMON_MIN_REGION / sys_ctx->addr_unit, 1);
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
 	if (err)
 		return err;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-lru_sort-use-param_ctx-for-damon_attrs-staging.patch
mm-damon-core-reset-age-if-nr_accesses-changes-between-non-zero-and-zero.patch
mm-damon-core-set-effective-quota-on-first-charge-window.patch
docs-mm-damon-maintainer-profile-update-community-meetup-for-reservation-requirements.patch
docs-admin-guide-mm-damon-start-add-target_pid-to-damos-example-command.patch
maintainers-rename-damon-section.patch
mm-damon-core-implement-damon_initialized-function.patch
mm-damon-stat-use-damon_initialized.patch
mm-damon-reclaim-use-damon_initialized.patch
mm-damon-lru_sort-use-damon_initialized.patch
samples-damon-wsse-use-damon_initialized.patch
samples-damon-prcl-use-damon_initialized.patch
samples-damon-mtier-use-damon_initialized.patch
mm-damon-stat-expose-the-current-tuned-aggregation-interval.patch
mm-damon-stat-expose-negative-idle-time.patch
mm-damon-sysfs-set-damon_ctx-min_sz_region-only-for-paddr-use-case.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C308F49
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 03:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758597511; cv=none; b=AKzOLY7Y8uSx1bwQlz/fiM0/rpXTlSjKuVApaUTHda+PsOU4CreT9VoGiXwuc7wseOFjZ8q5nE4Ft4PSw4OAUTNgc93Ojil8eNaedZ6RcNRIS799ibuBaOjnEb2kTM0e1uCOrp9LrqQOq/VcAFhmD0Dg0hiSEbKle1Q+UyOmOjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758597511; c=relaxed/simple;
	bh=oDKhwugKXHYCbsdpJEi87Cz5pPJmj9ShTGBt7CIfnmo=;
	h=Date:To:From:Subject:Message-Id; b=W+DFzzO+9OVeGRrNX2rmvuHAulcNxs/svNPkJOb67Yk43llIZ3JRiKnQhrnbZfW/DmVtYkr1TfgwAN7uW26yXTDZVlbPI0f+7ZE4mIBUsfzwvsOVetmAlaP+RnQZ3vQd7nK3ob0KUPTolmWD9CDx4qCudgi7QpOvK8XrBt60ay0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V4+6wMvl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V4+6wMvl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9878C4CEF0;
	Tue, 23 Sep 2025 03:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758597510;
	bh=oDKhwugKXHYCbsdpJEi87Cz5pPJmj9ShTGBt7CIfnmo=;
	h=Date:To:From:Subject:From;
	b=V4+6wMvlwoeJJC+gaDwtTXRUShDXE0RoSvE2RNfPLU/Ex9H3kZHb8sChK449HGoE+
	 jtMyoXvtkgxLRGOcQumZMTncjKjv8txLdF4MNUyg9VeKnL1MNVemX2rUYZPqgOBxMK
	 +Ux9lArBXKgw+/tvXH/UQF9LwGUCxT7mtLvHx8BY=
Date: Mon, 22 Sep 2025 20:18:30 -0700
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,wangkefeng.wang@huawei.com,clm@fb.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-set-damon_ctx-min_sz_region-only-for-paddr-use-case.patch removed from -mm tree
Message-Id: <20250923031830.B9878C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: set damon_ctx->min_sz_region only for paddr use case
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-set-damon_ctx-min_sz_region-only-for-paddr-use-case.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



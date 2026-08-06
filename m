Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEABA3DA7EC
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 21:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786050755; cv=none; b=mEwllSb2woeWj9hv+NuRstBvfxBDFG9Z00gbb/YUfn+ewV41Ki+Z0DTo6LI8o8f5tOaA8NNxTa6q61el0h2i4t6lAjTSuZyh0GZ5BWfWHyKb0gSlA0JNQHwMVtSeIWix4FRfIxMze49gVu2Sr/MYaGrnmmNVShGrS3aTh2o1/Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786050755; c=relaxed/simple;
	bh=fk4whSe3nWDFZEiKyvElg3UXVTNlgQquO1y+++eDbck=;
	h=Date:To:From:Subject:Message-Id; b=EWsHgmZ0YR5w+bLbktemqjB94Qe1eAwhw2QxgOXKJqVtNl5l+Vfla1q+HRxC4uvNo4UaO4wEBLtDymN1lXSaH81GbMdLDtNmsKZIoE3BsEBNVG/cwVssgXVnxPBcpcIunOVNjMpNTEQ+dL9WKlNZdOglyMvtxof8rGORkjDcRic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=akZJDXfa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="akZJDXfa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358121F000E9;
	Thu,  6 Aug 2026 21:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786050753;
	bh=+yqVBwVsjxM4Vsg8xkt4jZHtElKYCD1GmEzu2cJ3M0s=;
	h=Date:To:From:Subject;
	b=akZJDXfa7HRkJ7eWxlhGFnPfx1WSlfdm5hkzXewrAVP2FP+vLMie+Ba5LQ0sJhYcT
	 ArMnh8bAwc2d4Q2PjCHu+F3XEU7X9DEb+x2fB+JWklYPumYVm0LpPuuvHcmYSx+qXw
	 mnbmkyGXkEzrJYkHpphaG7hKju+eb4Mcf+jDpg/g=
Date: Thu, 06 Aug 2026 14:12:32 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shijianlin11@foxmail.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix.patch removed from -mm tree
Message-Id: <20260806211233.358121F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix.patch

This patch was dropped because it was folded into mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix
Date: Mon Aug  3 05:44:48 PM PDT 2026

use ARRAY_SIZE to dimension ratio[]

Cc: Brendan Jackman <jackmanb@google.com>
Cc: Jianlin Shi <shijianlin11@foxmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix
+++ a/mm/page_alloc.c
@@ -6926,7 +6926,7 @@ static int lowmem_reserve_ratio_sysctl_h
 		int write, void *buffer, size_t *length, loff_t *ppos)
 {
 	struct ctl_table tmp = *table;
-	int ratio[MAX_NR_ZONES];
+	int ratio[ARRAY_SIZE(sysctl_lowmem_reserve_ratio)];
 	int rc;
 
 	if (!write)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write.patch
selftests-mm-fix-soft-dirty-kselftest-supported-check-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch


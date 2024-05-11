Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADAD38DC3
	for <mm-commits@vger.kernel.org>; Sat, 11 May 2024 22:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715467340; cv=none; b=g8kEDXWsm4r6Cg4mgD1bbeCf+drpnwzP3bjluiO35vYRWMwQGta2iw1qnfOZkf7Q/6NNWdDV52RTIktq5RcpnwIKKTogJGCN0Kj8GLkg/FXWrup/AdqHHFNN5h9KQdTrGmMj0GqGIuGgjS7VmZZZSPGJUCSdIxzVYAxOTAGb4yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715467340; c=relaxed/simple;
	bh=Ngs0jOs6eDHIF9Wy7eVCa8/fhOo4+OCHtkeU/+CuUeA=;
	h=Date:To:From:Subject:Message-Id; b=Rvv5ctA0VgKM7elPZAgWzMRQAeHxe+cRpGO+OA8R5mJvf3XyRHhn4yFzQZvzN1RXsdFvG/KYaJ0OrR1ezAZKhVHkwAJ4guVP+lqf1scqk2b3tA+/HuZgOPqY+TdsRhElDH3eMpsRYTTN7W/NqBknlmC1kNoM7IQ/9KWHbldHjcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FbJr/E0P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FbJr/E0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40148C2BBFC;
	Sat, 11 May 2024 22:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715467340;
	bh=Ngs0jOs6eDHIF9Wy7eVCa8/fhOo4+OCHtkeU/+CuUeA=;
	h=Date:To:From:Subject:From;
	b=FbJr/E0PPYDKpfTqwm6Ql2YkTZaYoFoWb7g6gujM5mHKrT0YWXhmt4f7xMGj9o/fa
	 AYxJHS50YDrAUHp9Wg9fr8C/TLAug1lVkR02OD+A9nj0u6PBn//T5qxcB9t7K87CFh
	 m4sKuWMUFdkEV8le8Y9OQG0tl+QLQwxfVF6CNOPI=
Date: Sat, 11 May 2024 15:42:19 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,yorha.op@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-fix-return-value-from-damos_wmark_metric_value.patch removed from -mm tree
Message-Id: <20240511224220.40148C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: fix return value from damos_wmark_metric_value
has been removed from the -mm tree.  Its filename was
     mm-damon-core-fix-return-value-from-damos_wmark_metric_value.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alex Rusuf <yorha.op@gmail.com>
Subject: mm/damon/core: fix return value from damos_wmark_metric_value
Date: Mon, 6 May 2024 11:02:38 -0700

damos_wmark_metric_value's return value is 'unsigned long', so returning
-EINVAL as 'unsigned long' may turn out to be very different from the
expected one (using 2's complement) and treat as usual matric's value. 
So, fix that, checking if returned value is not 0.

Link: https://lkml.kernel.org/r/20240506180238.53842-1-sj@kernel.org
Fixes: ee801b7dd782 ("mm/damon/schemes: activate schemes based on a watermarks mechanism")
Signed-off-by: Alex Rusuf <yorha.op@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-fix-return-value-from-damos_wmark_metric_value
+++ a/mm/damon/core.c
@@ -1481,12 +1481,14 @@ static bool kdamond_need_stop(struct dam
 	return true;
 }
 
-static unsigned long damos_wmark_metric_value(enum damos_wmark_metric metric)
+static int damos_get_wmark_metric_value(enum damos_wmark_metric metric,
+					unsigned long *metric_value)
 {
 	switch (metric) {
 	case DAMOS_WMARK_FREE_MEM_RATE:
-		return global_zone_page_state(NR_FREE_PAGES) * 1000 /
+		*metric_value = global_zone_page_state(NR_FREE_PAGES) * 1000 /
 		       totalram_pages();
+		return 0;
 	default:
 		break;
 	}
@@ -1501,10 +1503,9 @@ static unsigned long damos_wmark_wait_us
 {
 	unsigned long metric;
 
-	if (scheme->wmarks.metric == DAMOS_WMARK_NONE)
+	if (damos_get_wmark_metric_value(scheme->wmarks.metric, &metric))
 		return 0;
 
-	metric = damos_wmark_metric_value(scheme->wmarks.metric);
 	/* higher than high watermark or lower than low watermark */
 	if (metric > scheme->wmarks.high || scheme->wmarks.low > metric) {
 		if (scheme->wmarks.activated)
_

Patches currently in -mm which might be from yorha.op@gmail.com are



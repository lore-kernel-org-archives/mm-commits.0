Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DC2201017
	for <mm-commits@vger.kernel.org>; Wed, 25 Jun 2025 22:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750891870; cv=none; b=gDARU5HUxp9IBtHnwNMhdDzUSXKp+YmDA1EM8i7Ukhn9D3rwUZIL2U2ysGwACf1NdezoQ2ulv0cVTgT1/SEOarnqIsLsUrXPTpEErx0Jmw8x7a3+5yv8dgBzCmDaJQsZEP65EnVy5/x21wuHWpM7ViKFmxWsZWdXbKz9ceUnGWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750891870; c=relaxed/simple;
	bh=MMmomMCqJSpWTCAn2TPnv1UzSIX2AyVqD6l3CJdQAv0=;
	h=Date:To:From:Subject:Message-Id; b=EH3r7aji7WxFWlH5LGJppwzTQKLQlnKqxSFgJ7ZnmVZmikn75aPXaa4j6NxZF5zf0zbbfabydLswtP4IGd/X1f/OYDFRVn+6NxwbaotOKGqFrEVeX3Or7tl/zk61qdIUZYaFochKnvRiHTqZ5p175Ri9FXUYrgdjp8qhBAEOK2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r8mbr/Bb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r8mbr/Bb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F294DC4CEEA;
	Wed, 25 Jun 2025 22:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750891869;
	bh=MMmomMCqJSpWTCAn2TPnv1UzSIX2AyVqD6l3CJdQAv0=;
	h=Date:To:From:Subject:From;
	b=r8mbr/BbqZpiCQqToMexWsfe+d7swva93kVjaAhU7jNVdT8Q+Co+Zbom/38gWowOG
	 M4aCO4bBmzpQdDoch8KMxm3R4K5omgsjKjsxw+TLsVQ/T7Ep679DK+CIL/pc+Mvqp7
	 jfNjOM6sd28MnhBugjFllQsYH9sURZFHK10csLcs=
Date: Wed, 25 Jun 2025 15:51:08 -0700
To: mm-commits@vger.kernel.org,yi.zhang@huawei.com,yangerkun@huawei.com,tglx@linutronix.de,ming.lei@redhat.com,john.g.garry@oracle.com,axboe@kernel.dk,yukuai3@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-group_cpus-fix-null-pointer-dereference-from-group_cpus_evenly-fix.patch removed from -mm tree
Message-Id: <20250625225108.F294DC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib-group_cpus-fix-null-pointer-dereference-from-group_cpus_evenly-fix
has been removed from the -mm tree.  Its filename was
     lib-group_cpus-fix-null-pointer-dereference-from-group_cpus_evenly-fix.patch

This patch was dropped because it was folded into lib-group_cpus-fix-null-pointer-dereference-from-group_cpus_evenly.patch

------------------------------------------------------
From: Yu Kuai <yukuai3@huawei.com>
Subject: lib-group_cpus-fix-null-pointer-dereference-from-group_cpus_evenly-fix
Date: Fri, 20 Jun 2025 09:09:58 +0800

also fix the non-SMP version

Link: https://lkml.kernel.org/r/20250620010958.1265984-1-yukuai1@huaweicloud.com
Fixes: 6a6dcae8f486 ("blk-mq: Build default queue map via group_cpus_evenly()")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Cc: ErKun Yang <yangerkun@huawei.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/group_cpus.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/lib/group_cpus.c~lib-group_cpus-fix-null-pointer-dereference-from-group_cpus_evenly-fix
+++ a/lib/group_cpus.c
@@ -429,8 +429,12 @@ struct cpumask *group_cpus_evenly(unsign
 #else /* CONFIG_SMP */
 struct cpumask *group_cpus_evenly(unsigned int numgrps)
 {
-	struct cpumask *masks = kcalloc(numgrps, sizeof(*masks), GFP_KERNEL);
+	struct cpumask *masks;
 
+	if (numgrps == 0)
+		return NULL;
+
+	masks = kcalloc(numgrps, sizeof(*masks), GFP_KERNEL);
 	if (!masks)
 		return NULL;
 
_

Patches currently in -mm which might be from yukuai3@huawei.com are

lib-group_cpus-fix-null-pointer-dereference-from-group_cpus_evenly.patch


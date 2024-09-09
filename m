Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD8318A925
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925224; cv=none; b=S6AAwcc8IRHcEyr2Okfx463k29cfUMq7jef+1UlnTbdCCj8WuJUCPXOXTB6oyeWaiu/2rH9qGiXzRiQ3b7PX4j66YPn7fqTJPTh73NhyJCbZ8bEjQePRSJ/NlVLxytgL88acaif78liP+Z5flG1qJrpVE3eoba1ADESONugm7rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925224; c=relaxed/simple;
	bh=BFTkgAZBI+A94bwg5l8kn6TxYRQRXfI2PpJ0X1zWV0s=;
	h=Date:To:From:Subject:Message-Id; b=oUIZq+7M94h+sXkfY8HTSCDDO7a4RMp8HF1q5tkZ8Mu+M/Nuj5s1sfqjAYs6wJZKEoAkd/kDyaYpcKBqMgr7/nrLznZLop/kyR85Nh9jJCDyo/kd8wZhmORhNeKC8dgPsVxop9CbAqw7nhB1ihnUZZz12RalO9OlJ2ojeZmVii8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GQ9LvsbZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GQ9LvsbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7130DC4CEC5;
	Mon,  9 Sep 2024 23:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925224;
	bh=BFTkgAZBI+A94bwg5l8kn6TxYRQRXfI2PpJ0X1zWV0s=;
	h=Date:To:From:Subject:From;
	b=GQ9LvsbZ9j7U4VjDbThgmiJ3r4vIA6TDn7YdJzv8K39KAd1m+qH6MLe66XpUuAnWx
	 SXEV+LJP4REdUI7XUHYksu8RtAE49EMCFigxmvvJ4PSdxMQ9lDPdCOofxS84C6xGWb
	 DiJ2M3dL2eZPTGD3X9wT/OxqadzXng9s2C88p8dw=
Date: Mon, 09 Sep 2024 16:40:23 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-remove-per-scheme-region-priority-histogram-buffer.patch removed from -mm tree
Message-Id: <20240909234024.7130DC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: remove per-scheme region priority histogram buffer
has been removed from the -mm tree.  Its filename was
     mm-damon-core-remove-per-scheme-region-priority-histogram-buffer.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: remove per-scheme region priority histogram buffer
Date: Sun, 25 Aug 2024 21:23:22 -0700

Nobody is reading from or writing to the per-scheme region priorities
histogram buffer.  It is only wasting memory.  Remove it.

Link: https://lkml.kernel.org/r/20240826042323.87025-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/damon.h~mm-damon-core-remove-per-scheme-region-priority-histogram-buffer
+++ a/include/linux/damon.h
@@ -233,7 +233,6 @@ struct damos_quota {
 	unsigned long charge_addr_from;
 
 	/* For prioritization */
-	unsigned long histogram[DAMOS_MAX_SCORE + 1];
 	unsigned int min_score;
 
 	/* For feedback loop */
_

Patches currently in -mm which might be from sj@kernel.org are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F171917C2
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747118342; cv=none; b=rlQJr1mgLgTR96yEdnrK56LRcRMEGh0c9Izs2zEjphyCZOIBXomF/nNZZ7Un6R8UyVXKTTe67gly4d3jimCdzfKpF4elbTghm83n37FIEWvcieh+MAnwsPrd3HS5w1SM3Wsw1zJsZ762n7vKysY3n4OPWR1WprbT482kMFalwpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747118342; c=relaxed/simple;
	bh=LsMGCRUaTD1qpmxXPEWfLD89Ne8BfWwiMORHN2DgrnM=;
	h=Date:To:From:Subject:Message-Id; b=ZBFl/SeLyWnwNIQAle4bt4MlniIWZjL8Lh5GzTXitYxV+ujVLNayZ56dp6YM0m/fTBgbDfgch+cbedn6EXKlxHx0UzszO1vFs5MVrRivz9NDd0PajPCNk084WwpSbrZz6QJUQV6/ltgxes9ZEESk9QK4kCCQfmgOeoFvKhAPsPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tFW1zQkc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tFW1zQkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA861C4CEE4;
	Tue, 13 May 2025 06:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747118341;
	bh=LsMGCRUaTD1qpmxXPEWfLD89Ne8BfWwiMORHN2DgrnM=;
	h=Date:To:From:Subject:From;
	b=tFW1zQkcXRtCxI7HKnsm94x0tc9X6/c1GZZySHAMxBk/D/bOKHvmMk4pqhkbNcTmT
	 9unyTefKG+sTGIPAkAWqyeuwpqpTpwHT00FYtguuA8l/WoLk+T6vNW1x/BpQtAYg8A
	 o/LxDf8CBOtY5yjXh/PccK/QtWGFoaKfHUaLBqAQ=
Date: Mon, 12 May 2025 23:39:01 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosry.ahmed@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,hezhongkun.hzk@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only-update.patch removed from -mm tree
Message-Id: <20250513063901.AA861C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add max swappiness arg to lru_gen for anonymous memory only
has been removed from the -mm tree.  Its filename was
     mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only-update.patch

This patch was dropped because it was folded into mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only.patch

------------------------------------------------------
From: Zhongkun He <hezhongkun.hzk@bytedance.com>
Subject: mm: add max swappiness arg to lru_gen for anonymous memory only
Date: Wed, 7 May 2025 15:10:57 +0800

 1) use strcmp instead of strncmp from Dan Carpenter
https://lore.kernel.org/all/aBHYT27M1tRxNLRj@stanley.mountain/
 2) If swappiness is not set, use the default value.

Link: https://lkml.kernel.org/r/20250507071057.3184240-1-hezhongkun.hzk@bytedance.com
Signed-off-by: Zhongkun He <hezhongkun.hzk@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only-update
+++ a/mm/vmscan.c
@@ -5592,7 +5592,7 @@ static ssize_t lru_gen_seq_write(struct
 		unsigned int memcg_id;
 		unsigned int nid;
 		unsigned long seq;
-		unsigned int swappiness = -1;
+		unsigned int swappiness;
 		unsigned long opt = -1;
 
 		cur = skip_spaces(cur);
@@ -5606,8 +5606,10 @@ static ssize_t lru_gen_seq_write(struct
 			break;
 		}
 
-		/* set by userspace for anonymous memory only */
-		if (!strncmp("max", swap_string, sizeof("max"))) {
+		if (n == 4)
+			swappiness = -1;
+		else if (!strcmp("max", swap_string)) {
+			/* set by userspace for anonymous memory only */
 			swappiness = SWAPPINESS_ANON_ONLY;
 		} else {
 			err = kstrtouint(swap_string, 0, &swappiness);
_

Patches currently in -mm which might be from hezhongkun.hzk@bytedance.com are

mm-add-swappiness=max-arg-to-memoryreclaim-for-only-anon-reclaim.patch
mm-vmscan-add-more-comments-about-cache_trim_mode.patch
mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only.patch
mm-using-swappiness_anon_only-in-mglru.patch
mm-cma-set-early_pfn-and-bitmap-as-a-union-in-cma_memrange.patch


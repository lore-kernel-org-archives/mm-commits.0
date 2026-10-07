Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B6A2F8EA6
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334236; cv=none; b=XcxDp7ikMob2nqr27KeMMgesvaXzBUZRVUi7I85/imSxq4lZe7Wz81hOHSSYRPY3199BWZ/dxLEy1yca1EyXW0W5TSD2cZIurusTZSphR6I9lcrJlp8EpUDtWzb/esgjuLoZ74BT5Y2OolPgz4WB75Sk/vPMoeb4nyZvtyIQcEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334236; c=relaxed/simple;
	bh=KHivVRpPHAQ7wl8CwWL75i12JfaBsXuG7COKiMuWO6I=;
	h=Date:To:From:Subject:Message-Id; b=O/lDfbmvWa/MhOR5VKC+rbNnTFv9OUAc4HUwgxt4zEGaHmRVjyaBwd11wMTG0dfmyg76mZm6QInhLBdTc1BZ2BgqBHubuqJMLcSMBz+tFOiXnETL2XfSaO8cfxzMs5MoUnMMbebEjCxVav/AXpe6c2cZx279J0V8QMt8lczVLeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NlhLUFPC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NlhLUFPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2311F0089B;
	Wed,  7 Oct 2026 00:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334235;
	bh=lCrlRiZ/0+ZWB7mxiEznATAaHQTw6/W8uJSFjl3MF+g=;
	h=Date:To:From:Subject;
	b=NlhLUFPCqnO+TpCdWzb4gGbXqQ50R6OqSZxZNOqi1vcI16uyo8ypv2G4ku8B8tQyB
	 Rr/HsBLryZnQI14x+L1yrbdUENyAzfNdGySnPZayDO1A/fYCqyQS48U3cDTn7chQrP
	 KMABxRJYJZk5KnVkJahqWrgRF/KSV6mFsZ6mRhzk=
Date: Tue, 06 Oct 2026 17:50:34 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,stevensd@chromium.org,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,chenridong@xiaomi.com,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-make-retry-logic-explicit-in-isolate_folios.patch removed from -mm tree
Message-Id: <20261007005035.4C2311F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: make retry logic explicit in isolate_folios()
has been removed from the -mm tree.  Its filename was
     mm-mglru-make-retry-logic-explicit-in-isolate_folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/mglru: make retry logic explicit in isolate_folios()
Date: Sat, 29 Aug 2026 15:42:04 +0800

The existing mainline code retries the same type once in a rather subtle
way.  `for_each_evictable_type()` may provide one more iteration, allowing
the same type to be retried if we scanned some folios but failed to
isolate any due to protections, promotions, or races.  This patch makes
the retry behavior explicit.

Link: https://lore.kernel.org/20260829074204.45304-3-baohua@kernel.org
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Ridong Chen <chenridong@xiaomi.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
---

 mm/vmscan.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/vmscan.c~mm-mglru-make-retry-logic-explicit-in-isolate_folios
+++ a/mm/vmscan.c
@@ -4840,6 +4840,7 @@ static int isolate_folios(unsigned long
 	bool type_fallback_allowed = !is_single_type_reclaim(swappiness);
 	int type = get_type_to_scan(lruvec, swappiness);
 	int total_scanned = 0, scanned, tier;
+	bool tried = false;
 
 retry:
 	tier = get_tier_idx(lruvec, type);
@@ -4859,9 +4860,18 @@ retry:
 	 */
 	if (!scanned && type_fallback_allowed) {
 		type = !type;
+		tried = true;
 		type_fallback_allowed = false;
 		goto retry;
 	}
+	/*
+	 * We scanned some folios but failed to isolate any due to promotions,
+	 * protections, or races. Retry once to avoid a larger loop.
+	 */
+	if (scanned && !tried) {
+		tried = true;
+		goto retry;
+	}
 
 	return total_scanned;
 }
_

Patches currently in -mm which might be from baohua@kernel.org are

mm-mglru-restore-accidentally-removed-seq-max_seq-check.patch


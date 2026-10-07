Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DAC2EF653
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334237; cv=none; b=NA6pVHLCKEU8xkGdS5LaG6JNYpkwKY0+UBK6jKEW4xOfId48Zno2OgCctsHfujPqd35R73SRPBqj5UGrKHXn2/7ebIFy9vm/LDdAqWK3i5tyaax0FyVgm4Z6N6hMUronfbA8q8NLLGKuBopZS7F1aavF4WGoq/vpuKDsQDGOKYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334237; c=relaxed/simple;
	bh=/zoG97b0F+eFPJs45FAdike2w2Hu9m1d9XN3P2UZNFs=;
	h=Date:To:From:Subject:Message-Id; b=jxOc5tabuMuwQ+PJ/7kCGS1M+MHoQxyPgHgWIcpxn+MLzQhmgZURkoxghADk8qhK0/1Y04C5vwUqxnmMUh6E2t/oZmIPj3GVUDDjr4+XynYif0YyCb27hj2kdyo9oX5c+KonQh8keOoTIpxA7BAZZWL1ty0bK226pWXCUvKihcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GnJfl8vP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GnJfl8vP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3CE1F0089C;
	Wed,  7 Oct 2026 00:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334236;
	bh=wo/fKqRCtwE9u39GcMSnXEegx2MZmz7wmy/N0sF1kss=;
	h=Date:To:From:Subject;
	b=GnJfl8vP+Hr2FeqE+zcXxrzVfy5bW2Xqxvfv0HARzSOLAIyFK9RUzcz1ELmU/PnFG
	 IBlqza1aUenXWySX5YMh9oTVqYEQVHrGKcto6R1+wDtwU+vTkRElwAqxOnkYUERvf5
	 TyjV92AwMF/OgNKj0TyMrToqjw4r4bJ3nDF6/ZzY=
Date: Tue, 06 Oct 2026 17:50:35 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,stevensd@chromium.org,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,chenridong@xiaomi.com,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-make-retry-logic-explicit-in-isolate_folios-fix.patch removed from -mm tree
Message-Id: <20261007005036.5D3CE1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: revert slight behavior change for swappiness 1-200
has been removed from the -mm tree.  Its filename was
     mm-mglru-make-retry-logic-explicit-in-isolate_folios-fix.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm: revert slight behavior change for swappiness 1-200
Date: Thu, 3 Sep 2026 14:48:52 +0800

Baoquan's review found that we unexpectedly introduced a slight behavior
change for swappiness 1-200. We could now have a case like:

1. First scan -> `scanned != 0`
2. Second scan -> `scanned = 0`
3. Type fallback

Step 3 was impossible before. Let's remove this possibility.

Link: https://lore.kernel.org/20260903070500.76379-1-baohua@kernel.org
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Baoquan He <baoquan.he@linux.dev>
Closes: https://lore.kernel.org/linux-mm/apfZQE1X6zGAsBb_@fedora/
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
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

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-mglru-make-retry-logic-explicit-in-isolate_folios-fix
+++ a/mm/vmscan.c
@@ -4858,7 +4858,7 @@ retry:
 	 * We are running out of the current reclaim type. Fall back to
 	 * the other type if allowed.
 	 */
-	if (!scanned && type_fallback_allowed) {
+	if (!scanned && !tried && type_fallback_allowed) {
 		type = !type;
 		tried = true;
 		type_fallback_allowed = false;
_

Patches currently in -mm which might be from baohua@kernel.org are

mm-mglru-restore-accidentally-removed-seq-max_seq-check.patch


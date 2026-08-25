Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2ADE380FC1
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622993; cv=none; b=uAKAQngWBTWFeAxEc7Uy+0Qg11f1uvEliVeZlBuNk63Ye5S929aij6QbTVw6mWj/Ht1sdKEN14k+bVe/vY+VxVITMlACBlEiYnADaXREnnyX1kLGtN2BIt/UlAx3//QKYMNLvAUoo/nBq2cOQgpvL1v0Mfd052avDM/5uBbGrUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622993; c=relaxed/simple;
	bh=hReXeSTAs+F5wT8eUAWyZ2VYsAQlKzWDdx596M4KgT0=;
	h=Date:To:From:Subject:Message-Id; b=VgKJEVtJc6XzFQKRqo/OjI70vhYDFykth6t5Sk/t+KOJcsCjv/lE1iGmRWvnU0x9HWzrUfbQgqlj/waofc+7FdlBDvT18ElZqdVzfI/klqksQVjovmna4XLrEmVNwYnLqCsm6m62x1n95ePXE4bu16lofqnfFQgJk5sVqXSrkbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cKwdd0Dz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cKwdd0Dz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DB81F000E9;
	Tue, 25 Aug 2026 01:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622991;
	bh=Q4rBJ6GVj6uOjzzwjEiPA3j7qEa/JQHHr6pTtP+hfAw=;
	h=Date:To:From:Subject;
	b=cKwdd0DzlEjO64f4B3VysTQrTquggf6Y7aw369xdZpCu5mQo0haNGvvrCKSwHK7kt
	 Yw92Y6keFRJDEcDVvDu40GLA7wKrt+6BWEYshqd2xXWoRln/6kPnj2ZIT+Hk7e9FTS
	 d59Rg/S1EOhY+WQWLFCvqotN6Xj2xNr0nb++AGKM=
Date: Mon, 24 Aug 2026 18:56:31 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,enlin.mu@unisoc.com,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,enlin.mu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-fix-comment-logic-in-balance_pgdat.patch removed from -mm tree
Message-Id: <20260825015631.73DB81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: fix comment logic in balance_pgdat
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-comment-logic-in-balance_pgdat.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Enlin Mu <enlin.mu@linux.dev>
Subject: mm/vmscan: fix comment logic in balance_pgdat
Date: Fri, 21 Aug 2026 14:40:57 +0800

In balance_pgdat(), when the low watermark is met, processes sleeping on
pfmemalloc_wait are woken up because they are able to safely make forward
progress.

However, the comment incorrectly states "they should not be able",
which contradicts the actual code behavior. Fix this typo to accurately
reflect the logic.

Link: https://lore.kernel.org/20260821064057.4081-1-enlin.mu@linux.dev
Signed-off-by: Enlin Mu <enlin.mu@unisoc.com>
Signed-off-by: Enlin Mu <enlin.mu@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-fix-comment-logic-in-balance_pgdat
+++ a/mm/vmscan.c
@@ -7276,7 +7276,7 @@ restart:
 
 		/*
 		 * If the low watermark is met there is no need for processes
-		 * to be throttled on pfmemalloc_wait as they should not be
+		 * to be throttled on pfmemalloc_wait as they should now be
 		 * able to safely make forward progress. Wake them
 		 */
 		if (waitqueue_active(&pgdat->pfmemalloc_wait) &&
_

Patches currently in -mm which might be from enlin.mu@linux.dev are



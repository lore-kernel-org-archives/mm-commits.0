Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C61D3F328C
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 23:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787353305; cv=none; b=tCxSWUGCpEPYvFgHIT6qfUH/LJ23iRHCtFpFju1Xw4NbG1hds8olk4PP+gvpDZwKP3zejItUBSfkls9Y04t4oRuqrrCj35TlGHGMSQ6NNu7sxhvvLUKsnt8l1yMZzQpKIe9fPeGuDhcnJWXtyvvW1xQiwbuztBwKcKqsKRkNdas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787353305; c=relaxed/simple;
	bh=JpwjJoDv7lZ7vi+3beH0U88gXvMl6uSlM74xthR3t5c=;
	h=Date:To:From:Subject:Message-Id; b=sdXRO5//JnMos883KMvVnkrRCTH7IH5PSnqGXNNFYLJtXy67fwoybKX9ozSjY+duiLadWSMBEkHiqSUDXq3FZyj3Z08c9nfjZzTXvC7FJllSrt2sZ7iUf/F/CTejpuEbk4jyonH5BqKXKccYkx6a1oAcAVrU0r1r+7iaJDyNOqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O+oG8EBe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O+oG8EBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB56D1F00A3D;
	Fri, 21 Aug 2026 23:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787353303;
	bh=/HE8BueiCM6KpicjpKlyJmPt1ETBifAMmCo10PWmuSI=;
	h=Date:To:From:Subject;
	b=O+oG8EBenD+QjnqsjB1bJFAJu/2jqKNMJlCDcYioG2WOOA6s+sEBcOCT15ipN9PVZ
	 gF/3E+W+weA45tIFgyTC2kHk5GPUu9MX61q6M7z9AC/oocTsPi8I9tqQySbezzN98a
	 xstl061XHa41zfZeDmp2Qo1Sgto33Ag0huF9gwYI=
Date: Fri, 21 Aug 2026 16:01:43 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,enlin.mu@unisoc.com,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,enlin.mu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-fix-comment-logic-in-balance_pgdat.patch added to mm-unstable branch
Message-Id: <20260821230143.CB56D1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: fix comment logic in balance_pgdat
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-fix-comment-logic-in-balance_pgdat.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-fix-comment-logic-in-balance_pgdat.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
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

mm-vmscan-fix-comment-logic-in-balance_pgdat.patch


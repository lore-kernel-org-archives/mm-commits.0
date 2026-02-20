Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC8F28B4FA
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 22:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771625075; cv=none; b=n2/1TU7RnGz6XWaeIpufnUqu/3UdfWo95Z25Dg7w7hRvc232h204/OIWu55BvKXPIvbK0567EaQza2UC/I74PsBp63R0JicLB7FmhNWqyGb0mOE4+O631Xa9hLR3OcbxA20qotIkgR4GPOoo62nFMeaTHzrxMPyY8YQNteg3ij8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771625075; c=relaxed/simple;
	bh=gbSUkzIkeVRk2S7cmwEavrJTK7ZPkMtN6bQzyRH4+Ag=;
	h=Date:To:From:Subject:Message-Id; b=h1OEs8UOac8OlWizhR7TgfjJ2TzrirZnU9vo9zX0rQ2YI30cRAE1WKZYK6nSBEWQUgFYhXgws7v1rIL2LEn62093YEGb1jJ7kGEFMRFFXZRP11IVxo154wKG5bBYlC/vJllh3GGq0UVAIFL7JaQOYrdM/ueG8cnvICbdsDsMXhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u+Yysyb1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u+Yysyb1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C0AC116C6;
	Fri, 20 Feb 2026 22:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771625074;
	bh=gbSUkzIkeVRk2S7cmwEavrJTK7ZPkMtN6bQzyRH4+Ag=;
	h=Date:To:From:Subject:From;
	b=u+Yysyb1OVucVQOCnUz6QkG/aTYkKgwuQ2DUdu7a1v6gbEhCsWHGoHbrfltpzlMQZ
	 upRHtu736T01xGlpC6ol2bvuW4qkLuwFKZVF4sqdMVx5pdWHUjfaLR1guExpxI2alK
	 isPgFA0ZVm9Gz4n8ddQntwD9hwF/EIw6DE6kufws=
Date: Fri, 20 Feb 2026 14:04:33 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,tjmercier@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,riel@surriel.com,mhocko@kernel.org,hannes@cmpxchg.org,axelrasmussen@google.com,zhaoyang.huang@unisoc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-root_reclaim-checking-in-should_abort_scan.patch added to mm-new branch
Message-Id: <20260220220434.A1C0AC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove '!root_reclaim' checking in should_abort_scan()
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-root_reclaim-checking-in-should_abort_scan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-root_reclaim-checking-in-should_abort_scan.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Subject: mm: remove '!root_reclaim' checking in should_abort_scan()
Date: Thu, 12 Feb 2026 11:21:11 +0800

Nowadays, ANDROID system replaces madivse with memory.reclaim to implement
user space memory management which desires to reclaim a certain amount of
memcg's memory.  However, oversized reclaiming and high latency are
observed as there is no limitation over nr_reclaimed inside
try_to_shrink_lruvec when MGLRU enabled.  Besides, this could also affect
all none root_reclaim such as reclaim_high etc.

Since commit 'b82b530740b9' ("mm: vmscan: restore incremental cgroup
iteration") introduces sc->memcg_full_walk to limit the walk range of
mem_cgroup_iter and keep the fairness among the descendants of one memcg. 
This commit would like to make single memcg's scanning more precised by
removing the criteria of 'if (!root_reclaim)' inside should_abort_scan().

Link: https://lkml.kernel.org/r/20260212032111.408865-1-zhaoyang.huang@unisoc.com
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Suggested-by: T.J.Mercier <tjmercier@google.com>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/vmscan.c~mm-remove-root_reclaim-checking-in-should_abort_scan
+++ a/mm/vmscan.c
@@ -4825,10 +4825,6 @@ static bool should_abort_scan(struct lru
 	int i;
 	enum zone_watermarks mark;
 
-	/* don't abort memcg reclaim to ensure fairness */
-	if (!root_reclaim(sc))
-		return false;
-
 	if (sc->nr_reclaimed >= max(sc->nr_to_reclaim, compact_gap(sc->order)))
 		return true;
 
_

Patches currently in -mm which might be from zhaoyang.huang@unisoc.com are

mm-remove-root_reclaim-checking-in-should_abort_scan.patch


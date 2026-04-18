Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369ED37107F
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776499115; cv=none; b=eaDS/UXyzje99Vy1Nl5gO1TQFLEl09l6ZOooYu9v9LOHYIfGcAhFBWt8u32gOf6NhDY5cvCAePOdGWc8nhLLlmfskiYPgV9AfZdhYh9Al17hKrEvXco0rYVJ2/P6bcEhOEqXdSsFmJNgG6nPECFasjLEpw4kb5Urficrj+KfyZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776499115; c=relaxed/simple;
	bh=/L32epeGlT+v0ccHOuqiZxKXB8KVy5mlz/nwJLiPb24=;
	h=Date:To:From:Subject:Message-Id; b=IXyqZvGe2wEvmbJ29OPfWs2cOR7cRhEipm6bb7R9qW6Y4fQuV0LG4evzAI+bLQtrbRSFPBSMuXkrfiSFisgJLQ3WXV6ti//j6K5uJr+O+FuuOJM6FIkSoX9mPmpApUUTrFaaCC3+rVw3H9GPgNuCHpDd7twIuExaaimKCBT63hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vq81qz9l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vq81qz9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B79C19424;
	Sat, 18 Apr 2026 07:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776499115;
	bh=/L32epeGlT+v0ccHOuqiZxKXB8KVy5mlz/nwJLiPb24=;
	h=Date:To:From:Subject:From;
	b=Vq81qz9lSBmIQT2folcaw4M/GPhbdyOy+pi6isILs5ypyEnyZ4i0/6RDP9ImZSyac
	 kI/p/xSdAJrspN7cUgB8ECBtDF6NBM9fmpaZDYV5iZTYhIgIRrPpFmiGvV51DhymHr
	 RCcXNCsWcqNijLiw4xYpeAjONIG/sQN+5HvggIJk=
Date: Sat, 18 Apr 2026 00:58:29 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,tjmercier@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,riel@surriel.com,qi.zheng@linux.dev,mhocko@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,baohua@kernel.org,axelrasmussen@google.com,zhaoyang.huang@unisoc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-root_reclaim-checking-in-should_abort_scan.patch removed from -mm tree
Message-Id: <20260418075834.59B79C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove '!root_reclaim' checking in should_abort_scan()
has been removed from the -mm tree.  Its filename was
     mm-remove-root_reclaim-checking-in-should_abort_scan.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Subject: mm: remove '!root_reclaim' checking in should_abort_scan()
Date: Thu, 12 Feb 2026 11:21:11 +0800

Android systems usually use memory.reclaim interface to implement user
space memory management which expects that the requested reclaim target
and actually reclaimed amount memory are not diverging by too much. With
the current MGRLU implementation there is, however, no bail out when the
reclaim target is reached and this could lead to an excessive reclaim
that scales with the reclaim hierarchy size.For example, we can get a
nr_reclaimed=394/nr_to_reclaim=32 proactive reclaim under a common 1-N
cgroup hierarchy.

This defect arose from the goal of keeping fairness among memcgs that is,
for try_to_free_mem_cgroup_pages -> shrink_node_memcgs -> shrink_lruvec ->
lru_gen_shrink_lruvec -> try_to_shrink_lruvec, the !root_reclaim(sc) check
was there for reclaim fairness, which was necessary before commit
b82b530740b9 ("mm: vmscan: restore incremental cgroup iteration") because
the fairness depended on attempted proportional reclaim from every memcg
under the target memcg.  However after commit b82b530740b9 there is no
longer a need to visit every memcg to ensure fairness.  Let's have
try_to_shrink_lruvec bail out when the nr_reclaimed achieved.

Link: https://lore.kernel.org/20260318011558.1696310-1-zhaoyang.huang@unisoc.com
Link: https://lore.kernel.org/20260212032111.408865-1-zhaoyang.huang@unisoc.com
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Suggested-by: T.J.Mercier <tjmercier@google.com>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
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
@@ -4971,10 +4971,6 @@ static bool should_abort_scan(struct lru
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



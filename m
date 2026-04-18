Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E613161BE
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498835; cv=none; b=Wm8NTa6Y21NgVL3EK9b7rZgCTICBHKcuamLS/0n//6x2X1o0OW+M3HyVrtNPRMNpMPqGD6/Qd+V0IhIF+R3T7WpW5Pb1XUPYr61L4xGYUqm5UZYEjrY77kPRV0q7H2lqk1vDNzoH2UC/f/wo8+q3Qu2N5AA5K5JUg3fGbm0Q2W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498835; c=relaxed/simple;
	bh=K65/pb+mFg1HOY3VjQjsgBl1L+88Eq44UdmQ3O/DjAI=;
	h=Date:To:From:Subject:Message-Id; b=THZYXY38GSt6CCqh+P3YsnQMNDJ1bh06S3dlnQT6PlOMzBQDR9B4RGvo5e3GI7b52PjN2XckQqFARWdLStsqKlH77/1W+YpE/ZS/m3PBe4Ec6a2/49QSgKwrz6uqHcGbpoAzhBd+v1f+Htm+2XjGPMjIGqvL6YW42Ee+yiHtIz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lqSarvQa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lqSarvQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75F3C19424;
	Sat, 18 Apr 2026 07:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498835;
	bh=K65/pb+mFg1HOY3VjQjsgBl1L+88Eq44UdmQ3O/DjAI=;
	h=Date:To:From:Subject:From;
	b=lqSarvQaHHNKyIQH1ojT0f9/bq+iYkJbWuTla2JBteArvOg/11Ugj7dCBaTAv9an3
	 X/6UlU8d7GTs0ISttzED5BPh8nLSR1g0p0MOeENeIYZJ48ByxBuCNC9s8cdjH7ARNd
	 btkUwllubzrJINqqSg5yLxrsy4OjOsuNvJznlejk=
Date: Sat, 18 Apr 2026 00:53:48 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuzhao@google.com,yuanchu@google.com,willy@infradead.org,weixugc@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,liam.howlett@oracle.com,kaleshsingh@google.com,hannes@cmpxchg.org,david@kernel.org,axelrasmussen@google.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-prevent-mglru-reclaim-from-pinning-address-space.patch removed from -mm tree
Message-Id: <20260418075353.C75F3C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: prevent MGLRU reclaim from pinning address space
has been removed from the -mm tree.  Its filename was
     mm-vmscan-prevent-mglru-reclaim-from-pinning-address-space.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm/vmscan: prevent MGLRU reclaim from pinning address space
Date: Sun, 22 Mar 2026 00:08:43 -0700

When shrinking lruvec, MGLRU pins address space before walking it.  This
is excessive since all it needs for walking the page range is a stable
mm_struct to be able to take and release mmap_read_lock and a stable
mm->mm_mt tree to walk.  This address space pinning results in delays when
releasing the memory of a dying process.  This also prevents mm reapers
(both in-kernel oom-reaper and userspace process_mrelease()) from doing
their job during MGLRU scan because they check task_will_free_mem() which
will yield negative result due to the elevated mm->mm_users.

This affects the system in the sense that if the MM of the killed
process is being reclaimed by kswapd then reapers won't be able to reap
it.  Even the process itself (which might have higher-priority than
kswapd) will not free its memory until kswapd drops the last reference.
IOW, we delay freeing the memory because kswapd is reclaiming it.  In
Android the visible result for us is that process_mrelease() (userspace
reaper) skips MM in such cases and we see process memory not released
for an unusually long time (secs).

Replace unnecessary address space pinning with mm_struct pinning by
replacing mmget/mmput with mmgrab/mmdrop calls.  mm_mt is contained within
mm_struct itself, therefore it won't be freed as long as mm_struct is
stable and it won't change during the walk because mmap_read_lock is being
held.

Link: https://lore.kernel.org/20260322070843.941997-1-surenb@google.com
Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-prevent-mglru-reclaim-from-pinning-address-space
+++ a/mm/vmscan.c
@@ -2863,8 +2863,9 @@ static struct mm_struct *get_next_mm(str
 		return NULL;
 
 	clear_bit(key, &mm->lru_gen.bitmap);
+	mmgrab(mm);
 
-	return mmget_not_zero(mm) ? mm : NULL;
+	return mm;
 }
 
 void lru_gen_add_mm(struct mm_struct *mm)
@@ -3064,7 +3065,7 @@ done:
 		reset_bloom_filter(mm_state, walk->seq + 1);
 
 	if (*iter)
-		mmput_async(*iter);
+		mmdrop(*iter);
 
 	*iter = mm;
 
_

Patches currently in -mm which might be from surenb@google.com are



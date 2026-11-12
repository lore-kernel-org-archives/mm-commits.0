Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794446229;
	b=cq/ECHqaj2DnixfcdaO/DJVOoBSt+/+bUwCPtsbvRFWgFyQ0Lr1uGcxkd/17reFf1LpV
	 790u6iANHemAOCgCGqsPnz3NPOEKR6UfmN24f4fcGYnfgec1D5f8A+KPdcx7PSndORBzF
	 OMXaG1OGhz45YUjL4t0GvVUEX3qYM4zJceX1S8yvITg31zDGgwJEjWn5KilBw+NHRh4Nw
	 8zP9hMD7UJ93FGrpwVz6qZaT1evX81q+ZO9Pp+C5aX6NkH1QKI5zR9drkKMqpb3eAA0OT
	 mAkhzPYzAeEnXQbetIdrHPLBf4kK1YPO0qcRGof9oTTZKlUPoY7B4eLskQG+K/mH5bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794446229;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=JCK6zU2ChkuJZipYDAgPVqEX66k1F6zjG/BsJo5gjic=;
	b=y3VJcOXkv+0CxzM64ogdLGufrChIDTeAVfP1aWbWVjsTgc6k1lTMrawa8PJcAZse8MSS
	 msNPzAyTfJLr/gi4mqKTyfVMlWbzla7KCp1uYBLeswTbkDPXjr5kqKsaWiHAA0Su5G0YD
	 lm3Lfchmcp7vufTcCepECboXQv4f/00Q6naenQvEDG0IYGw+GUXnNXTFd+Qi1INjdCtkD
	 aLlpMnJ0VkoBUxlWsipmczbZy5L/XXhEC75Emzswyk1Crk3xjX0fJl6b02BmJhR6UCxa/
	 aBI+MV0zQpXEm9f3HB4NO45KUG/sLgwU6Z8sG35A+z4CUZHh3a+99l98QTbBu2GGRPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CwVMv9vo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E61606A321
	for <mm-commits@vger.kernel.org>; Thu, 12 Nov 2026 01:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CwVMv9vo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A201F00A05;
	Thu, 12 Nov 2026 01:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794446228;
	bh=JCK6zU2ChkuJZipYDAgPVqEX66k1F6zjG/BsJo5gjic=;
	h=Date:To:From:Subject;
	b=CwVMv9vootK0JO+SE6hwWvo9AsuVBFtgVZ0vHAETHa3VPxRjbcQaRmw21EGuWySjB
	 VvU6HnVKSMVeTg7hpqKvwkvfZDc0kzGL6X8CAotnMbYFamoYx7y/Oi4qfqRVQHxFEZ
	 nH/LjOg6vJ02nOkFGL/YJhl6K94oz7qXduxFfW0M=
Date: Wed, 11 Nov 2026 17:17:08 -0800
To: mm-commits@vger.kernel.org,zhuhui@kylinos.cn,zhangbo56@xiaomi.com,
	yuanchu@google.com,weixugc@google.com,wangzicheng@honor.com,
	surenb@google.com,sidchintamaneni@gmail.com,shakeel.butt@linux.dev,
	ryncsn@gmail.com,rppt@kernel.org,ridong.chen@linux.dev,qi.zheng@linux.dev,
	mhocko@suse.com,lyugaofei@xiaomi.com,liuxiang.277@bytedance.com,
	lianux.mm@gmail.com,liam@infradead.org,kunwu.chan@gmail.com,
	hui.zhu@linux.dev,hannes@cmpxchg.org,chentao@kylinos.cn,baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,
	kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-extract-lruvec_populated_min_seq-helper.patch added to mm-new branch
Message-Id: <20261112011708.B4A201F00A05@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: extract lruvec_populated_min_seq() helper
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-extract-lruvec_populated_min_seq-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-extract-lruvec_populated_min_seq-helper.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: extract lruvec_populated_min_seq() helper
Date: Thu, 12 Nov 2026 07:25:49 +0800

The search for the oldest populated generation of a type, previously
embedded in try_to_inc_min_seq(), is extracted into the new
lruvec_populated_min_seq() helper. It returns the oldest populated seq
of a given type, bounded by the given max_seq so the search never goes
beyond it.

No functional change.

Link: https://lore.kernel.org/20261111232603.9934-3-baohua@kernel.org
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <hui.zhu@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: wang lian <lianux.mm@gmail.com>
Cc: <liuxiang.277@bytedance.com>
Cc: <lyugaofei@xiaomi.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: wangzicheng <wangzicheng@honor.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Bo Zhang <zhangbo56@xiaomi.com>
Cc: Hui Zhu <zhuhui@kylinos.cn>
Cc: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Cc: Kunwu Chan <chentao@kylinos.cn>
---

 mm/vmscan.c |   43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

--- a/mm/vmscan.c~mm-mglru-extract-lruvec_populated_min_seq-helper
+++ a/mm/vmscan.c
@@ -3992,30 +3992,45 @@ done:
 	return true;
 }
 
+/* Similar to lruvec_evictable_size, return the oldest populated seq of the type */
+static unsigned long lruvec_populated_min_seq(struct lruvec *lruvec, int type,
+					      unsigned long max_seq)
+{
+	int gen, zone;
+	unsigned long min_seq;
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+
+	lockdep_assert_held(&lruvec->lru_lock);
+
+	min_seq = READ_ONCE(lrugen->min_seq[type]);
+	while (min_seq <= max_seq) {
+		gen = lru_gen_from_seq(min_seq);
+		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
+			if (!list_empty(&lrugen->folios[gen][type][zone]))
+				return min_seq;
+		}
+		min_seq++;
+	}
+
+	return max_seq;
+}
+
 static void try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
 {
-	int gen, type, zone;
+	int type;
 	bool seq_inc_flag = false;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	DEFINE_MIN_SEQ(lruvec);
+	unsigned long seq;
 
 	VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
 
-	/* find the oldest populated generation */
+	/* Requires at least MIN_NR_GENS gens for basic functionality */
+	seq = lrugen->max_seq - MIN_NR_GENS;
 	for_each_evictable_type(type, swappiness) {
-		while (min_seq[type] + MIN_NR_GENS <= lrugen->max_seq) {
-			gen = lru_gen_from_seq(min_seq[type]);
-
-			for (zone = 0; zone < MAX_NR_ZONES; zone++) {
-				if (!list_empty(&lrugen->folios[gen][type][zone]))
-					goto next;
-			}
-
-			min_seq[type]++;
+		min_seq[type] = lruvec_populated_min_seq(lruvec, type, seq + 1);
+		if (min_seq[type] > lrugen->min_seq[type])
 			seq_inc_flag = true;
-		}
-next:
-		;
 	}
 
 	/*
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-mglru-report-evictable-sizes-per-type.patch
mm-mglru-extract-lruvec_populated_min_seq-helper.patch
mm-mglru-reclaim-from-the-oldest-populated-gen.patch
mm-mglru-lift-the-forced-protection-of-reclaimer.patch
mm-mglru-skip-zones-above-reclaim_idx-instead-of-rotating-them.patch
mm-mglru-return-for-unavailable-anon-reclaim-earlier.patch
mm-mglru-balance-anon-and-file-scan-budget-by-refault-rate.patch
mm-mglru-lift-youngest-gen-protection-for-higher-priority.patch


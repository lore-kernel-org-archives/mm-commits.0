Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794599452;
	b=rX01A1iaJU4jum07+SiUcZQpeivFJ60gi6EivhzWbWClnctmpcbp4fk6Var4Jm51eEwp
	 TB6/c7pzSk3ezuGNd0PS0EkKg6UWAEIk4/E9d4JC9lRN0lsrH8o2rrdtIjQWjOegPTv9S
	 Wf6J3HS0+aFSBYZ3dzQs0Ze9k4N2ezJAENRSXnVy8mf6loGdNT8dSunfHBXkkm6P2LHvX
	 gq/tXH1Dz1N6Pd5qRFdQb+Wau/IUv4cVaNWH88U15LPmMKNMOEtmgFD5PcddpgrneaChY
	 L0RgTzRM5Dqmg5v+yEnTfPkoomf4pnyT5IkcT1MF66pr4jB1B4jjubwSbvi2Uel1n8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794599452;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=mLD3PvMB1CcbVTjgEz4bAtWXsOb2jZaDnj+ZtARna2U=;
	b=ewk+AoZmmJfiUhMjwT7+DEEg0qUrpxKL58+AiyeDuA5TAbpqO/4na34nEyjqjp6rMMiA
	 cEtnXMsm4Om/7tRhN96ev3z3rvvihd0y1ilGPEhfJs6QmYek3+4rkg893MOvTTpwvsDyx
	 FbfPkoT3wulfGFFpM9iigb3LDJObayVbQZCw5TaKRl4Q6+FLp/lGo57btJ52BFMt3kXNW
	 7VeCb4vQ4I9xidJ0b6m4ToDnUXcdbRdZdzcOLRYwaX38ZhqBUOdwy2td9iS+cwPjs1i0m
	 ysZeEvy7Fga4NhMqPCNtcu21G9QiXYbR2c5/V7+4s2M1drNJSgr8EsmTIIPaS/9rI5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PNiDAf8n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAE6606A32E
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 19:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PNiDAf8n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF06D1F000C4;
	Fri, 13 Nov 2026 19:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794599452;
	bh=mLD3PvMB1CcbVTjgEz4bAtWXsOb2jZaDnj+ZtARna2U=;
	h=Date:To:From:Subject;
	b=PNiDAf8nB2YdigCQAMBg2mMblFd+vxIH3Z5WJeBKOSHEGINKovjzJBRmLh+n0lRf+
	 dxW1jTh9XLul3wHzu1VfU4MfAdXxus3+xDINcS5Rgi9ClhETydXewmVjOhUvZRUNbf
	 cHuy7EmSJx4/XaOAWgjGzIUTMrWu0GcuEdox3FHE=
Date: Fri, 13 Nov 2026 11:50:51 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-lift-youngest-gen-protection-for-higher-priority.patch added to mm-new branch
Message-Id: <20261113195051.DF06D1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: lift youngest gen protection for higher priority
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-lift-youngest-gen-protection-for-higher-priority.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-lift-youngest-gen-protection-for-higher-priority.patch

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
Subject: mm/mglru: lift youngest gen protection for higher priority
Date: Sat, 14 Nov 2026 02:55:33 +0800

The forced protection of younger generations contradicts the goal of
minimizing the I/O cost of reclaim.  Under high memory pressure, MGLRU can
repeatedly trigger premature OOMs, while the classic LRU does not.

The problem is that aging may fail to keep up with reclaim.  When this
happens, reclaimers may all abort prematurely because they see only empty
generations or just two generations remaining.

Proactive aging does not solve this problem either.  The number of threads
performing proactive aging is limited, while the number of concurrent
reclaimers can be much larger.  This is a fundamental limitation of MGLRU.
One possible solution is to use an aging lock.  However, the aging lock
introduces significant jitter under heavy memory pressure and has been
reported to cause noticeable lags on Android.

Furthermore, the generation-based reclaim model can conflict with the goal
of swappiness, which is to minimize I/O cost rather than blindly follow
folio hotness.  The previous commit allowed reclaimers running at
non-default priorities to reclaim up to `lrugen->max_seq`, while
reclaimers at the default priority could reclaim only up to
`lrugen->min_seq`.

This patch further refines generation protection based on reclaim
priority.  At the default priority, reclaimers can reclaim generations
down to `lrugen->max_seq - MIN_NR_GENS`.  As reclaim priority increases,
reclaimers are progressively allowed to reclaim younger generations.  With
this graduated protection, premature OOMs are no longer observed, while
swappiness is also respected.

Link: https://lore.kernel.org/20261113185541.70203-9-baohua@kernel.org
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
Cc: Michal Hocko <mhocko@kernel.org>
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
Cc: Bo Zhang <zhangbo0325@gmail.com>
---

 mm/vmscan.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/vmscan.c~mm-mglru-lift-youngest-gen-protection-for-higher-priority
+++ a/mm/vmscan.c
@@ -4772,12 +4772,14 @@ static int scan_folios(unsigned long nr_
 	VM_WARN_ON_ONCE(!list_empty(list));
 
 	/*
-	 * Respect the gen hotness distribution at low priority to avoid
-	 * aging and scan cost, but prefer to satisfy the reclaimers request
-	 * when under pressure to respect swappiness more and reduce IO cost.
+	 * Respect hotness at default priority, and only reach into the
+	 * newest generation when under severe pressure, so hot folios are
+	 * not evicted as soon as priority is raised.
 	 */
 	if (sc->priority == DEF_PRIORITY)
-		seq = lrugen->min_seq[type];
+		seq = lrugen->max_seq - MIN_NR_GENS;
+	else if (sc->priority > DEF_PRIORITY / 2)
+		seq = lrugen->max_seq - 1;
 	else
 		seq = lrugen->max_seq;
 
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


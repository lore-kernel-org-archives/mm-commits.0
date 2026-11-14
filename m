Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794693545;
	b=ZtOLAZpPPOfxlkSzDEMqKkflCRZ7pRkoGWZVFvgigmjtyw5R/49GYIezRi08zQqqEom2
	 Q4ETqQKmeJRayqPcZEwtOWrSn9sVervbreL+xoiTrYvcjGaSLwFSBWYYPmTobPLo7Yhhr
	 ajf2GlL/QtXWY4N3aN+Y82sQ9dDzQOdhiSqjs65jlxSKOGOxBWJ8GSU1DoSUKZn3INn6d
	 zwDie600AHWJ2ZK/VbpTrKk7vr43lLAu8UGbMbursfpPsGMZ4ZHC0OlnfRd++iQaNIALf
	 Y14e4jpmsri9rDIrRTl/Z8QD3IN1pjtjgEQkhbqtKyr6L/tsRU6V48AGbwpDVgv6e1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794693545;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=k9vh98/TSwkzAfZhr+Gb6u3wkrwUBOeVsDf24nVfYjs=;
	b=GpTiv68w5TZiirBtep+FJGhO+JXANC0Q2K+SK7ic7eELA5QZJkQ3A5pIHgRQloRaf+WG
	 toG1QjjWm+XBuHpQi9CmqiOJtZ5PZyiHXhsD10WkKRpXpw0WgIce4ddNwLADGdIkAclOa
	 I+gmeKgT1d/CnvzIPhooiOOZzvN4t61p0sCkdQnDDHGKvbhRWnbnfziSw2NgIoPsBn5Yi
	 G5KtwDgiA79FYMP/bA9n5xDOU+ghRAtjdG3FgfIN5DBuotRLua772MWUTnbW2R9XJUC9O
	 XN+Egcd1r75pmoofz++L+Rx1DtdTsrc5bVidM0502mLgM4I0P+NS33s5+YVbTOZ0GFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XVBVGx+y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982D7606A331
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 21:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XVBVGx+y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24EA91F000C4;
	Sat, 14 Nov 2026 21:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794693545;
	bh=k9vh98/TSwkzAfZhr+Gb6u3wkrwUBOeVsDf24nVfYjs=;
	h=Date:To:From:Subject;
	b=XVBVGx+yoBwpPhf6qIxtVCMPKjJmE48WrOv+xHxqhYhQ+rJ7SnjvTmWWVN2Nh8NgN
	 eATDFFyohh7HJ7qLg1XEGUEVtioyxSdwvABVHD5qY/nArB0q3kJ3pgYffw2fZ9icpQ
	 XZMkzNjT0824n0GUzipNPVH3wsbDZw3MAAvqDeTk=
Date: Sat, 14 Nov 2026 13:59:04 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-extract-lruvec_populated_min_seq-helper.patch removed from -mm tree
Message-Id: <20261114215905.24EA91F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/mglru: extract lruvec_populated_min_seq() helper
has been removed from the -mm tree.  Its filename was
     mm-mglru-extract-lruvec_populated_min_seq-helper.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: extract lruvec_populated_min_seq() helper
Date: Sat, 14 Nov 2026 02:55:27 +0800

The search for the oldest populated generation of a type, previously
embedded in try_to_inc_min_seq(), is extracted into the new
lruvec_populated_min_seq() helper. It returns the oldest populated seq
of a given type, bounded by the given max_seq so the search never goes
beyond it.

No functional change.

Link: https://lore.kernel.org/20261113185541.70203-3-baohua@kernel.org
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

 mm/vmscan.c |   45 +++++++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 16 deletions(-)

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
@@ -4027,8 +4042,6 @@ next:
 
 	/* see the comment on lru_gen_folio */
 	if (swappiness && swappiness <= MAX_SWAPPINESS) {
-		unsigned long seq = lrugen->max_seq - MIN_NR_GENS;
-
 		if (min_seq[LRU_GEN_ANON] > seq && min_seq[LRU_GEN_FILE] < seq)
 			min_seq[LRU_GEN_ANON] = seq;
 		else if (min_seq[LRU_GEN_FILE] > seq && min_seq[LRU_GEN_ANON] < seq)
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-mglru-reclaim-from-the-oldest-populated-gen.patch
mm-mglru-lift-the-forced-protection-of-reclaimer.patch
mm-mglru-skip-zones-above-reclaim_idx-instead-of-rotating-them.patch
mm-mglru-return-for-unavailable-anon-reclaim-earlier.patch
mm-mglru-balance-anon-and-file-scan-budget-by-refault-rate.patch
mm-mglru-lift-youngest-gen-protection-for-higher-priority.patch


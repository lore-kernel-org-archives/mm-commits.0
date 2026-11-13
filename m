Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794598870;
	b=QBU7deHgw66+gncBK/AvstFZEXLJnQbfZWGtY70QEQHGC9YXXDj2T5onMHa3PirrEBju
	 YEJZ6G3LThFIhnOX4AIOygkEcFXGGpD/KKljhoucUAxYp/sKje24u3+Kj07L0+wadvNDF
	 ijZ1N0UsaqB36D8B9zNI9llguWJOhSgBs0JEwvzO+G0U+h0sP9pEQxCc23UtYTRmHcbQf
	 xakZ8oMioF5R4ia07kA8Y71Urq75QxK+aYGcq3fvbD1t8i4tg6XGp31OL7jNvoa2mvyCv
	 2J6tvrpNxbPWnAeA/EQebn0+XR69L6XNccSXLHv6OgbPY6Hc02YcPtS2wMatzCuCZMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794598870;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=H4/y3jPfGI6Jk2TG1visfvgihNEmFaKPdUa+UYD2q54=;
	b=T5j+DJZa3wRbm47enzY0UiwyKZYRYdjeF4yjtqRdvg/KXc5DgII0T568Q0qiyECTP+dZ
	 3sMsBSFfg3T8uzluRlJqhKBYhKOKLesgSopf6CIrFQv7RR+X5OwTSsX9pv6oP1MnSqIZB
	 bTGpalYbp1xE082jTB3OU5NLRHWz4vfK1sI7dLByv5nMYHxv+HEywQD8xyy1lsVM/+eN2
	 ERzHRCPgodjk7qYSa/T8mpZG3dAmJuwjOUGZMJelYtssLprknYpWetZ/FfxBfM55fgWJC
	 P27nBe+E2rGH6dzlALzUY1xiOwP+Ol+YhtQy0LRcloSEqMimNb9y0UPZ44obfj6x0wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="vBq2/ha5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2303606A332
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 19:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vBq2/ha5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EB41F000C4;
	Fri, 13 Nov 2026 19:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794598869;
	bh=H4/y3jPfGI6Jk2TG1visfvgihNEmFaKPdUa+UYD2q54=;
	h=Date:To:From:Subject;
	b=vBq2/ha5+t7/UjS39jE2rwCWgIS55fOzuX8E3iPEXh7luR4f7jEQWRKt9wGYLcnUA
	 fgGvCTakq2h3DlgAEc3rdb/YtULyW2bAIhdie+PWJ+DlMx+ywlloZgLdUbBNxWRrTw
	 Fvb4lTyACNnkBI8QM5CQTXXnXlbhG6DVB9A/KHCk=
Date: Fri, 13 Nov 2026 11:41:09 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-extract-lruvec_populated_min_seq-helper.patch removed from -mm tree
Message-Id: <20261113194109.B1EB41F000C4@smtp.kernel.org>
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

mm-mglru-reclaim-from-the-oldest-populated-gen.patch
mm-mglru-lift-the-forced-protection-of-reclaimer.patch
mm-mglru-skip-zones-above-reclaim_idx-instead-of-rotating-them.patch
mm-mglru-return-for-unavailable-anon-reclaim-earlier.patch
mm-mglru-balance-anon-and-file-scan-budget-by-refault-rate.patch
mm-mglru-lift-youngest-gen-protection-for-higher-priority.patch


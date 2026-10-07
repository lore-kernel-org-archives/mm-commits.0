Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337BE32D7F8
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334376; cv=none; b=domcd5iuhe8R+MvMY7m6ht0/JNDJ0a8VHmM+EjAGBRUQwZz9STZsYYKWRM8lGL0k5VldVLvCkhSl0gmX5G2GREqmGUjXePV16oCWifSQTCGnnHPOKLTSiPOPJnlWtMsNhQev2y3fKvmdgY51dETv4/G0XL0brdYijnXfqvWpMYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334376; c=relaxed/simple;
	bh=LnKD/fzhiz1b4h+/KgysogREgJIeZn3s8wvjMN66bgw=;
	h=Date:To:From:Subject:Message-Id; b=EO0B1ZkkDR5HyA0Puz+6U4+EGDLfhE89Oj2h+AjZge26qtLiTR6XKrOBND9tlbpaoV32ocI3foAP3EK1s4cV7B5lGZJbDVwd4tiQ9vIvgwc8b9/dvQVUtagV4iz4IcB8OS4zPuUZlAoAIiXbfR+iGNnzQWKoWMPC8dttJvcP7Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pmXFU1qx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pmXFU1qx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8CD1F0089B;
	Wed,  7 Oct 2026 00:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334375;
	bh=It3bH0zr7ctZZh1fVa+PaRLxhZb3STYZUctM1Vci69s=;
	h=Date:To:From:Subject;
	b=pmXFU1qxR3rHFRXUQSASFKqNPbfaYXNt/zrMTpT1yBsZ54Hb8Axn0WR5R3iatOEt+
	 NfRLDvRDhmd2CcVZnmr5hsnayGHV1oMEcPXXpl2nUVuMsYFHqczRujwYlT5m6aH3AH
	 j6FfAkWiOrqTJl5/+P5ud96OebPwqVjnTh4GuTAI=
Date: Tue, 06 Oct 2026 17:52:54 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,xueyuan.chen21@gmail.com,weixugc@google.com,stevensd@chromium.org,shakeel.butt@linux.dev,ridong.chen@linux.dev,mhocko@kernel.org,ljs@kernel.org,lianux.mm@gmail.com,kunwu.chan@gmail.com,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-batch-move-folios-to-the-second-oldest-gens-lru.patch removed from -mm tree
Message-Id: <20261007005255.0E8CD1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: batch move folios to the second-oldest gen's LRU
has been removed from the -mm tree.  Its filename was
     mm-mglru-batch-move-folios-to-the-second-oldest-gens-lru.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/mglru: batch move folios to the second-oldest gen's LRU
Date: Wed, 2 Sep 2026 07:24:21 +0800

Detect folios that need to move from the oldest generation to the
second-oldest generation, and batch-move them together.  This can
significantly reduce the sys time of inc_min_seq(), especially when the
other type is significantly behind the preferred type.

Link: https://lore.kernel.org/20260901232421.40157-8-baohua@kernel.org
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Assisted-by: gemini:gemini-3.6-flash
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
---

 mm/vmscan.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-mglru-batch-move-folios-to-the-second-oldest-gens-lru
+++ a/mm/vmscan.c
@@ -3936,6 +3936,19 @@ static void clear_mm_walk(void)
 		kfree(walk);
 }
 
+static inline void flush_lru_batch(struct list_head *head, struct list_head **batch_end,
+				   struct list_head *dst)
+{
+	LIST_HEAD(movable);
+
+	if (!*batch_end)
+		return;
+
+	list_cut_position(&movable, head, *batch_end);
+	list_splice_tail_init(&movable, dst);
+	*batch_end = NULL;
+}
+
 static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 {
 	int zone;
@@ -3958,8 +3971,10 @@ static bool inc_min_seq(struct lruvec *l
 			lru_gen_is_active(lruvec, target_gen));
 	/* prevent cold/hot inversion if the type is evictable */
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
+		struct list_head *target_list = &lrugen->folios[target_gen][type][zone];
 		struct list_head *head = &lrugen->folios[old_gen][type][zone];
 		struct list_head *pos = head->next;
+		struct list_head *batch_end = NULL;
 		long delta = 0;
 
 		while (pos != head) {
@@ -3984,7 +3999,7 @@ static bool inc_min_seq(struct lruvec *l
 			 */
 			if (gen_increased) {
 				delta += nr_pages;
-				list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
+				batch_end = &folio->lru;
 
 				/* don't count the workingset being lazily promoted */
 				if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
@@ -3994,11 +4009,14 @@ static bool inc_min_seq(struct lruvec *l
 						   lrugen->protected[hist][type][tier] + nr_pages);
 				}
 			} else {
+				flush_lru_batch(head, &batch_end, target_list);
 				list_move(&folio->lru, &lrugen->folios[new_gen][type][zone]);
 			}
 			if (!--remaining)
 				break;
 		}
+		flush_lru_batch(head, &batch_end, target_list);
+
 		WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
 			   lrugen->nr_pages[old_gen][type][zone] - delta);
 		WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
_

Patches currently in -mm which might be from baohua@kernel.org are

mm-mglru-restore-accidentally-removed-seq-max_seq-check.patch


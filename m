Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794895001;
	b=VBCpY4PKJhi3295HknasJxEcB+ESVKNLZiQ9UBPKGU8vn7XCSVlVwU4V2yJNQD2pRXum
	 jUTR44pc481XGD/tL2obedXC6z1xC7j/e3omtHltNuzxitl3ym10f2fVNy8LtYgGswIIO
	 zEqIC+C4fj1yfHHps+fjr+C0FusBGPwFwEpZGNtnquMfWE7jgEgf2hmstJgiHk9HT4wCx
	 4XiH1SRQWOoXrJeDqFbPKzKZgCKG5ISypsURbdX0B/ytfe61Qr7YMabByAREfU334OLUk
	 1bPeVyhBpsSlnLrjt/W3Iu4ruUb+TwrY/EVvvYCd4zJc5XOhu6FiXjp8ckvGKdgXERA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794895001;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=DPA4TXi1wQDuPAufchqJyWKXJ3AKV7XudpHkXWh4xwc=;
	b=1sq+5/RBI1cXR00FmxQ2Ru2eTwVqgPkd0ebOMPdALgAFVZPlfrtqN2jSndLtKSTUoRoc
	 /XGR6mZms3+VzXHFIm33abTGF9HtYJcWW8I66klvp2mj6uBC7UjBV2eVxgVHu5P14zjJQ
	 41rSMVaTWHEzVUVA98YrluAYXytxKXGvho6FPgVxRzwgf+HsYpOz06onvwRnKS+hoF5pF
	 EVGo/wO2SKToKGuC+87rgQpplqkebymByvzF4RRt99UN5AIu5g/S9YDEk5iplYsZwdSqN
	 +3vtvIfbKqEF6ToZxZpC2Vlk4wSSytjJtOIMEvn+fRfLoywlcngEddwA9aY75V2G1AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gwMB0uC3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB60606A31C
	for <mm-commits@vger.kernel.org>; Tue, 17 Nov 2026 05:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gwMB0uC3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224C71F000C4;
	Tue, 17 Nov 2026 05:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794895001;
	bh=DPA4TXi1wQDuPAufchqJyWKXJ3AKV7XudpHkXWh4xwc=;
	h=Date:To:From:Subject;
	b=gwMB0uC3UqawRi6Kj4nfl27u1LWVm+gdEEucIPBwaEZeUnUzB+XylD/BB+VcXmWS2
	 uHNHtcD9zY/yefEXzn39O5fdnH9IdN4Mnmea75a/EftafFif0YQ3NouSIBkgZwrXFb
	 bvBuFK2g8F/7qRBm8tH6b2hToW8qaOlmsfxXxv4c=
Date: Mon, 16 Nov 2026 21:56:40 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,
	shakeel.butt@linux.dev,qi.zheng@linux.dev,mhocko@kernel.org,ljs@kernel.org,
	kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,
	zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-use-a-smaller-batch-in-fill-drain_evictable.patch added to mm-new branch
Message-Id: <20261117055641.224C71F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: use a smaller batch in fill/drain_evictable()
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-use-a-smaller-batch-in-fill-drain_evictable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-use-a-smaller-batch-in-fill-drain_evictable.patch

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
From: Hui Zhu <zhuhui@kylinos.cn>
Subject: mm/mglru: use a smaller batch in fill/drain_evictable()
Date: Mon, 16 Nov 2026 14:11:58 +0800

lru_gen_change_state() migrates folios in batches of up to MAX_LRU_BATCH
(4096) folios under lruvec_lock_irq().  A full batch keeps local
interrupts off for up to about a millisecond, and CPUs contending for the
same lru_lock spin with interrupts disabled for that long.

The caller already drops the lock and reschedules between batches, and the
restart protocol does not depend on the batch size: both functions make
monotone progress, so a smaller batch only shortens the irq-off section. 
Use MIN_LRU_BATCH (64) instead, bounding it to about 15us.  This is a cold
path that runs once per kill-switch toggle; the extra
unlock/resched/relock round trips cost a few percent of wall time on an
otherwise idle machine.

Same change as commit 6e9be217a3ce ("mm/mglru: use a smaller batch for
reclaim") made for try_to_shrink_lruvec().

Link: https://lore.kernel.org/20261116061158.333826-1-hui.zhu@linux.dev
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-mglru-use-a-smaller-batch-in-fill-drain_evictable
+++ a/mm/vmscan.c
@@ -5503,7 +5503,7 @@ static bool __maybe_unused state_is_vali
 static bool fill_evictable(struct lruvec *lruvec)
 {
 	enum lru_list lru;
-	int remaining = MAX_LRU_BATCH;
+	int remaining = MIN_LRU_BATCH;
 
 	for_each_evictable_lru(lru) {
 		int type = is_file_lru(lru);
@@ -5548,7 +5548,7 @@ static bool fill_evictable(struct lruvec
 static bool drain_evictable(struct lruvec *lruvec)
 {
 	int gen, type, zone;
-	int remaining = MAX_LRU_BATCH;
+	int remaining = MIN_LRU_BATCH;
 
 	for_each_gen_type_zone(gen, type, zone) {
 		struct list_head *head = &lruvec->lrugen.folios[gen][type][zone];
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are

mm-mglru-fix-a-no-op-lru_gen_clear_refs-call-in-lru_lazyfree.patch
mm-vmstat-annotate-data-race-in-zone_page_state_snapshot.patch
mm-compaction-annotate-data-race-for-zone-free_areanr_free.patch
mm-mglru-use-a-smaller-batch-in-fill-drain_evictable.patch


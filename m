Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415105;
	b=ah38e43vnBgBQI1Cckf8TrKf9X2EjtotlB9ly7TwvfR9BPRBa+mxtHxpMZCzR6/FFZYd
	 +qYjAdveqkhae969crbQUrVN/rxeESk8oMgyb0OVwoWX4fYZ8aYZbe5Q1cLoTXRNBhUH8
	 UI3IYQwFHunBfYh2lZ4p0gGRKG3i0vkzAUE6U/p3wwfxSHB2HAWNBbqkQIzQja2KCe5lk
	 Cd8nNBo2teji3t3L9dCP7MpLmmteEVya39HvLbT9k2HkmerE5JlmGXyjwRD6vgcE+kI9M
	 sHjICFcNQKsF+/QnglqGPu5gUe9NmexrGuFKyFujGbt8DTitvymHoCHSTPKWb8GXBPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415105;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=Wbd7JGcxM2xnlq+7cHsvBk9Yukk+Qby6EFffl9UVlAo=;
	b=zj4XhNHhWYrVBV5CyDyQB6otg6eJayQKvFpn8T576OQqWX9d+dcxzQo8hBFQTvYg45Bb
	 rVUwXhG/07cGWBtuvhC4h8p7CI2Di5eGmbPNJtCOVrkiT/+QTWD11GNNRRrEJC/c1lWz+
	 BjAjv+xTYJ3YRn2+RRb7i4o3vLkntgcysLVFkUKCDK9vL5sfx6Axm6QYLsccIEiu2OWdp
	 W/5+CiP0oZf4pEIVi37PRvMADIjErOHYgeJy/8WrJsWsiW++0uKvlc532wiaF69rEgs7r
	 Eh/kHKG1oLwY8v+t2+/yhVSr3HqUme1eA4EBq6piOhV72z4WTon7bmInDpaJ5aGKG7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mQzSRrRs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0505F606A32D;
	Mon, 23 Nov 2026 06:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mQzSRrRs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8571F000D3;
	Mon, 23 Nov 2026 06:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795415104;
	bh=Wbd7JGcxM2xnlq+7cHsvBk9Yukk+Qby6EFffl9UVlAo=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=mQzSRrRs5ujU/mMwnHX2B3JHOy9JXxOiE4/3SDrkZaH4/MjICaeP7xrmuEAF/pFtw
	 UTOe1QWHxi5DqnlKKclA/zYhdw+McVEoFbJNhCYw4H78gBUHqsRIDofVlgLLdMZ1Z0
	 RkivZlRDOFiDyH0j4eZURjHYA9QHrx+CZLhiyAOo=
Date: Sun, 22 Nov 2026 22:25:04 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ryncsn@gmail.com,
	qi.zheng@linux.dev,noah@feldt.systems,kasong@tencent.com,hannes@cmpxchg.org,
	david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,
	shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261111000913.22943-1-shakeel.butt@linux.dev>
References: <20261111000913.22943-1-shakeel.butt@linux.dev>
Subject: [merged mm-hotfixes-stable] mm-mglru-splice-all-generations-when-reparenting-a-memcg.patch removed from -mm tree
Message-Id: <20261123062504.8A8571F000D3@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: mglru: splice all generations when reparenting a memcg
has been removed from the -mm tree.  Its filename was
     mm-mglru-splice-all-generations-when-reparenting-a-memcg.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: mm: mglru: splice all generations when reparenting a memcg
Date: Tue, 10 Nov 2026 16:09:13 -0800

Noah reported list_del corruption on single-node hosts running 7.2.11,
which already has commit bf4ade7dbd76 ("memcg: keep folio's objcg same as
its node").  The bad pointer is an MGLRU list head in a freed
mem_cgroup_per_node:

  slab mem_cgroup_per_node start ff31bfa36a3c9e00 pointer offset 528 size 1920
  list_del corruption. next->prev should be ffacf881ccc70e08, but was ff31bfa36a3ca010. (next=ff31bfa36a3ca010)

When a memcg goes offline, __lru_gen_reparent_memcg() moves its MGLRU
lists to the parent.  It moves only the generations (gens) from min_seq to
max_seq, and it puts each list at the same index in the parent.

A folio's gen in folio->flags can be ahead of the list it is on.  In the
parent, the same index can stand for an older gen, so the folio's gen can
end up older than its list.  Once the parent's min_seq passes that gen,
sort_folio() puts the folio on the list for max_seq + 1, where it stays
until the next aging.

If the parent goes offline before that aging, the folio is not moved to
the grandparent.  It stays on the parent's list after the parent is freed,
and the next list_del() on it touches freed memory.  This needs two
cgroups on one branch to go offline one after the other, such as a
container and then its pod.

The parent always has MAX_NR_GENS gens at this point, so every index is
valid in it.  Move all MAX_NR_GENS lists, not only the gens from min_seq
to max_seq.

A reproducer that drives these steps through the lru_gen debugfs file gets
a KASAN use-after-free on the freed mem_cgroup_per_node without this
patch, and no report with it.

Link: https://patch.msgid.link/20261111000913.22943-1-shakeel.butt@linux.dev
Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Noah Feldt <noah@feldt.systems>
Closes: https://lore.kernel.org/all/20261110132853.71228-1-noah@feldt.systems/
Reviewed-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Noah Feldt <noah@feldt.systems>
  Link: https://lore.kernel.org/20261115124954.7146-1-noah@feldt.systems
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: <stable@vger.kernel.org>

 mm/vmscan.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-mglru-splice-all-generations-when-reparenting-a-memcg
+++ a/mm/vmscan.c
@@ -4752,19 +4752,25 @@ void max_lru_gen_memcg(struct mem_cgroup
  * The same generation has different meanings in the parent and child memcg,
  * so this compromise method will cause the LRU inversion problem. But as the
  * system runs, this problem will be fixed automatically.
+ *
+ * Move all MAX_NR_GENS lists, not only the gens from min_seq to max_seq.
+ * An earlier reparenting can leave a folio whose gen is older than the list
+ * it is on. Once min_seq passes that gen, sort_folio() puts the folio on the
+ * list for max_seq + 1, where it stays until the next aging. If that list
+ * were skipped, the folio would stay behind on a memcg that is about to be
+ * freed. The parent has MAX_NR_GENS gens here, so every index is valid in it.
  */
 static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec *parent_lruvec,
 				     int zone, int type)
 {
 	struct lru_gen_folio *child_lrugen, *parent_lrugen;
 	enum lru_list lru = type * LRU_INACTIVE_FILE;
-	int i;
+	int gen;
 
 	child_lrugen = &child_lruvec->lrugen;
 	parent_lrugen = &parent_lruvec->lrugen;
 
-	for (i = 0; i < get_nr_gens(child_lruvec, type); i++) {
-		int gen = lru_gen_from_seq(child_lrugen->max_seq - i);
+	for (gen = 0; gen < MAX_NR_GENS; gen++) {
 		long nr_pages = child_lrugen->nr_pages[gen][type][zone];
 		int child_lru_active = lru_gen_is_active(child_lruvec, gen) ? LRU_ACTIVE : 0;
 		int parent_lru_active = lru_gen_is_active(parent_lruvec, gen) ? LRU_ACTIVE : 0;
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-move-memoryhigh-enforcement-out-of-try_charge_memcg.patch
memcg-force-charges-from-reclaim-before-trying-the-limits.patch
memcg-use-high_work-for-kernel-threads.patch
memcg-use-high_work-for-remote-charges.patch
memcg-simplify-high-limit-handling-after-a-charge.patch


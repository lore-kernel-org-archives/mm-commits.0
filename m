Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B4B3B05B6
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068105; cv=none; b=d4MZT+Fs1qKlBeIkW8Wzj8dLF7hvRNNadH/5ROs2rklnl9V1FdcOtvIKBohMMUgL1Z8JHj/reehRgJh6tE07st4G73JJYA9ElNkmgjapiUinV0G3fQ+ZihCJ6uFf2ek1W/uQ0AsTsfNCnmXEjUENYueAzJx+CUkHgeKU/dcaLiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068105; c=relaxed/simple;
	bh=uMggpu/JdKsojgpHWHhMnMReo43jA2rHYjrTxYgj7yM=;
	h=Date:To:From:Subject:Message-Id; b=LflpHGQCBRO9EF3JtfGS/533CubWZNt7/q9GkFn7RZ7p6UtYVYy+YuXKn1ofWzHnlZDs4idVu0sstIgvHI3dg30lFt5KbCcNPWgAvNzDkp119C+K014tEzfCBbf4RU4m0WtmZzth/v3OyrnC8VM+oPj9PFNsVrHvMtYH8lMqozU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1TMYgE4d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1TMYgE4d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5781F000E9;
	Fri,  7 Aug 2026 02:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068104;
	bh=zCSF8FXrEF8/ZXQoFv25kFq5vdaRL1yatBSvmueVWYc=;
	h=Date:To:From:Subject;
	b=1TMYgE4dGGi74ZWpLP7TAJsJYhE63aQqTSipDWMoQCc3DGblg2mPumAfa2nHOxBjn
	 /DzDVIY0IbLS3+CcBkJKbeAuKqxJz5Y7RwZa2BlUCwYmcLBrWCjIH7vvxo9x24llJj
	 JtTUJQjLFxvJNyFPr8dGAU6NieI6i0BNFYMtrNIo=
Date: Thu, 06 Aug 2026 19:01:43 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hezhongkun.hzk@bytedance.com,hannes@cmpxchg.org,david@kernel.org,dave@stgolabs.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-fix-anon-only-reclaim-evicting-file-pages-when-swappiness=max.patch removed from -mm tree
Message-Id: <20260807020144.4D5781F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: fix anon-only reclaim evicting file pages when swappiness=max
has been removed from the -mm tree.  Its filename was
     mm-mglru-fix-anon-only-reclaim-evicting-file-pages-when-swappiness=max.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ridong Chen <chenridong@xiaomi.com>
Subject: mm/mglru: fix anon-only reclaim evicting file pages when swappiness=max
Date: Fri, 24 Jul 2026 11:34:35 +0800

The previous patch fixed this issue for the traditional LRU.  The same
problem exists in MGLRU [1]: when swappiness=max (SWAPPINESS_ANON_ONLY) is
set, reclaim is expected to evict anonymous pages exclusively, but file
pages can still be reclaimed when anonymous pages cannot be reclaimed
(e.g.  no swap and no demotion target).

Fix it the same way as the traditional LRU: keep returning
SWAPPINESS_ANON_ONLY in get_swappiness(), and return 0 from
get_nr_to_scan() when SWAPPINESS_ANON_ONLY is set but anon pages cannot be
reclaimed.  Since get_nr_to_scan() decides how much MGLRU scans, returning
0 skips the scan entirely and avoids the useless scan work when there is
nothing eligible to reclaim.

The test result:
Before fix:

  # cat /sys/kernel/mm/lru_gen/enabled
  0x0007
  # cat memory.stat
  anon 204800
  file 67108864
  ...
  pgsteal_proactive 0
  pgscan_proactive 0

  # echo "64M swappiness=max" > memory.reclaim
  # cat memory.stat
  anon 208896
  file 0
  ...
  pgsteal_proactive 16384
  pgscan_proactive 16384

After fix:

  # cat memory.stat
  anon 188416
  file 67215360
  kernel 1970176
  ...
  pgsteal_proactive 0
  pgscan_proactive 0

  # echo "64M swappiness=max" > memory.reclaim
  -bash: echo: write error: Resource temporarily unavailable
  # cat memory.stat
  anon 204800
  file 67215360
  ...
  pgsteal_proactive 0
  pgscan_proactive 0

Link: https://lore.kernel.org/20260724033435.2573323-5-ridong.chen@linux.dev
Link: https://sashiko.dev/#/patchset/20260717113300.214717-1-ridong.chen@linux.dev [1]
Fixes: 68a1436bde00 ("mm: add swappiness=max arg to memory.reclaim for only anon reclaim")
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zhongkun He <hezhongkun.hzk@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-mglru-fix-anon-only-reclaim-evicting-file-pages-when-swappiness=max
+++ a/mm/vmscan.c
@@ -2701,6 +2701,10 @@ static int get_swappiness(struct lruvec
 {
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+	int swappiness = sc_swappiness(sc, memcg);
+
+	if (swappiness == SWAPPINESS_ANON_ONLY)
+		return swappiness;
 
 	if (!sc->may_swap)
 		return 0;
@@ -2709,7 +2713,7 @@ static int get_swappiness(struct lruvec
 	    mem_cgroup_get_nr_swap_pages(memcg) < MIN_LRU_BATCH)
 		return 0;
 
-	return sc_swappiness(sc, memcg);
+	return swappiness;
 }
 
 static int get_nr_gens(struct lruvec *lruvec, int type)
@@ -4911,6 +4915,20 @@ static long get_nr_to_scan(struct lruvec
 			   struct mem_cgroup *memcg, int swappiness)
 {
 	unsigned long nr_to_scan, evictable;
+	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+
+	/*
+	 * Proactive reclaim initiated by userspace for anonymous memory only.
+	 * SWAPPINESS_ANON_ONLY is set only on the proactive reclaim path, so
+	 * warn if it shows up elsewhere. When anon cannot be reclaimed (e.g.
+	 * no swap), return 0 to skip the scan entirely, avoiding useless scan
+	 * work when there is nothing eligible to reclaim.
+	 */
+	if (swappiness == SWAPPINESS_ANON_ONLY) {
+		WARN_ON_ONCE(!sc->proactive);
+		if (!can_reclaim_anon_pages(memcg, pgdat->node_id, sc))
+			return 0;
+	}
 
 	evictable = lruvec_evictable_size(lruvec, swappiness);
 
_

Patches currently in -mm which might be from chenridong@xiaomi.com are

memcg-move-mem_cgroup_swappiness-and-vm_swappiness-to-mm-swaph.patch
mm-vmscan-fix-node-reclaim-ignoring-swappiness-parameter.patch


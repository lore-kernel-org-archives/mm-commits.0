Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1BB1F12F8
	for <mm-commits@vger.kernel.org>; Fri, 24 Jul 2026 00:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784852721; cv=none; b=Wc+RjXN8JasyV6mTtg8Or14hKwhv9U8Vg/BqlVfPOsXRtxyoUwIJbsk1EtF2vHB+6q32/MHDpUeCon0JM75rCxbNUZVWbm7AzuKqtUWsuejzzlNuyyih0muoHjnc3uGK0t4F2+oCmnHRHVDpDHzJPZGofl/MQwG1sum3D+VHpxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784852721; c=relaxed/simple;
	bh=/sd12fH0rvYDWxHaXnDBKPlQQd/5nGBLSxhMzmUnK6s=;
	h=Date:To:From:Subject:Message-Id; b=pBu9Lc1/z4cc/wKnIadSfi1y/fxeZ8SFUG0H33+rBn6kHCPlggDpQhw+O4sYChD3O3+FPEbPY6D/oLw6FXYf2qLWMhBcIzD5Pxrvc/oB153D+mQJHdKgj5tQEQA0dQUXpFz6E3C8Q9nYzZYd9J24sxDW7A0I+jyxcSugcTfDxG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lHwEY/VR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lHwEY/VR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738C11F00A3A;
	Fri, 24 Jul 2026 00:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784852719;
	bh=Ip7ZMwyKTluhaw3u+AqIEXs3tUuz3+p9SRk8TfAZPy4=;
	h=Date:To:From:Subject;
	b=lHwEY/VRonbDo/NNfmnulDk68PYfUzW9rSOPbD2+cOq9GGVJ62GQ7KG74UjIw1X9B
	 mw99xJ3afyvJOPjWCFl3VCgC3eLiqNb5Y8kemmHnXOFhJytyKiUCOD1mpwHqzUo5kj
	 A5qkiPZIGmd5/NjqMTSmVlrVr8TlX4aRa96U2lAw=
Date: Thu, 23 Jul 2026 17:25:19 -0700
To: mm-commits@vger.kernel.org,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmscan-fix-node-reclaim-ignoring-swappiness-parameter.patch removed from -mm tree
Message-Id: <20260724002519.738C11F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: fix node reclaim ignoring swappiness parameter
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-node-reclaim-ignoring-swappiness-parameter.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Ridong Chen <chenridong@xiaomi.com>
Subject: mm: vmscan: fix node reclaim ignoring swappiness parameter
Date: Thu, 16 Jul 2026 11:17:29 +0800

sc_swappiness() had two separate definitions depending on CONFIG_MEMCG. 
The !CONFIG_MEMCG variant simply returned vm_swappiness, ignoring the
proactive_swappiness value passed through scan_control.  This caused the
swappiness parameter written to /sys/devices/system/node/nodeX/reclaim to
have no effect when CONFIG_MEMCG is disabled.

Fix this by consolidating sc_swappiness() into a single definition that
checks sc->proactive_swappiness first, then falls back to
mem_cgroup_swappiness() which already handles both CONFIG_MEMCG and
!CONFIG_MEMCG.

Before fix (swappiness=max ignored, mostly file pages reclaimed):

    # cat /proc/sys/vm/swappiness
    60
    # cat /proc/vmstat | grep pgsteal
    pgsteal_kswapd 0
    pgsteal_direct 0
    pgsteal_khugepaged 0
    pgsteal_proactive 1840
    pgsteal_anon 25
    pgsteal_file 1815
    # echo "64M swappiness=max" > /sys/devices/system/node/node0/reclaim
    # cat /proc/vmstat | grep pgsteal
    pgsteal_kswapd 0
    pgsteal_direct 0
    pgsteal_khugepaged 0
    pgsteal_proactive 18013
    pgsteal_anon 337
    pgsteal_file 17676

After fix (swappiness=max honored, anon pages reclaimed as expected):

    # cat /proc/vmstat | grep pgsteal
    pgsteal_kswapd 0
    pgsteal_direct 0
    pgsteal_khugepaged 0
    pgsteal_proactive 0
    pgsteal_anon 0
    pgsteal_file 0
    # echo "64M swappiness=max" > /sys/devices/system/node/node0/reclaim
    # cat /proc/vmstat | grep pgsteal
    pgsteal_kswapd 0
    pgsteal_direct 0
    pgsteal_khugepaged 0
    pgsteal_proactive 16283
    pgsteal_anon 16283
    pgsteal_file 0

Link: https://lore.kernel.org/20260716031729.1064007-3-ridong.chen@linux.dev
Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface")
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Tested-by: Song Hu <husong@kylinos.cn>
Reviewed-by: Song Hu <husong@kylinos.cn>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: <stable@vger.kernel.org>	[6.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-fix-node-reclaim-ignoring-swappiness-parameter
+++ a/mm/vmscan.c
@@ -199,6 +199,13 @@ struct scan_control {
  */
 int vm_swappiness = 60;
 
+static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
+{
+	if (sc->proactive && sc->proactive_swappiness)
+		return *sc->proactive_swappiness;
+	return mem_cgroup_swappiness(memcg);
+}
+
 #ifdef CONFIG_MEMCG
 
 /* Returns true for reclaim through cgroup limits or cgroup interfaces. */
@@ -239,13 +246,6 @@ static bool writeback_throttling_sane(st
 #endif
 	return false;
 }
-
-static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
-{
-	if (sc->proactive && sc->proactive_swappiness)
-		return *sc->proactive_swappiness;
-	return mem_cgroup_swappiness(memcg);
-}
 #else
 static bool cgroup_reclaim(struct scan_control *sc)
 {
@@ -261,11 +261,6 @@ static bool writeback_throttling_sane(st
 {
 	return true;
 }
-
-static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
-{
-	return READ_ONCE(vm_swappiness);
-}
 #endif
 
 static inline bool is_exec_file_folio(const struct folio *folio,
_

Patches currently in -mm which might be from chenridong@xiaomi.com are

mm-vmscan-fix-anon-only-reclaim-evicting-file-pages-when-swappiness=max.patch
mm-vmscan-propagate-real-error-code-from-per-node-proactive-reclaim.patch
mm-vmscan-drop-unused-gfp_mask-parameter-from-__node_reclaim.patch


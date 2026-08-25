Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B91449364C;
	Tue, 25 Aug 2026 01:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622314; cv=none; b=n+vI9m//zWj3rKKqLSS6lbuOVwQJwaqU0Xed1eByJN1F3UVPhtUs44HlHLmsjSSaLgsBEgCSWZ1wXyy6J0lgf2rIhO0QKJRNCkT0qn2wEn3hBFHqejxD2ifoo/tdJ8Y1v+N0gmX6yLB5T3iftip+tZ8U+6OFWnrjP+dp3pc4+dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622314; c=relaxed/simple;
	bh=LXIt5UrmBDRLn0p/QxJ4V561V7qHZffm6YWwpQlVk7g=;
	h=Date:To:From:Subject:Message-Id; b=uqbRHVne5rNFhN3VFqc/IgSHTlULPCV/IgRQ46ipgzkgCZWrgcnE4wgpaFytNH2OeNA7AR029ZHnMGpy3YeY5a4e4xqFSvFnLmagzeWO2+0tsUw5yZDwU6Mcq3eGgXIcH1+ZN6iE80YWhuttEPFC9XA1OW1/j2mbOePSvXq5EtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xOiRTA/a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xOiRTA/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF6D1F00A3A;
	Tue, 25 Aug 2026 01:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622312;
	bh=QQMejMuUWGufm3CCrl9thooxt4J/iQbmOBl1tWlSvEE=;
	h=Date:To:From:Subject;
	b=xOiRTA/ahfQ89Q0G2Lx9gHxZdlxNYATzS3juVrQsxHzRyVSBr2WoMdc+PpgQOGWVq
	 ZU8LBAOahM0aElnK2IX3VmtUvWqXd/KUfVfnK6Wtr6RolaqHQBBLRoL1vP7XB/cHM0
	 NlE3UF/0al4XBximJidFq5P6H2MFIry2WZchN334=
Date: Mon, 24 Aug 2026 18:45:11 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,stable@vger.kernel.org,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,qi.zheng@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,husong@kylinos.cn,hannes@cmpxchg.org,david@kernel.org,dave@stgolabs.net,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,axelrasmussen@google.com,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-fix-node-reclaim-ignoring-swappiness-parameter.patch removed from -mm tree
Message-Id: <20260825014512.4CF6D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: fix node reclaim ignoring swappiness parameter
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-node-reclaim-ignoring-swappiness-parameter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ridong Chen <chenridong@xiaomi.com>
Subject: mm: vmscan: fix node reclaim ignoring swappiness parameter
Date: Thu, 23 Jul 2026 11:24:34 +0800

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

Link: https://lore.kernel.org/20260723032434.2016749-3-ridong.chen@linux.dev
Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface")
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Tested-by: Song Hu <husong@kylinos.cn>
Reviewed-by: Song Hu <husong@kylinos.cn>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
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



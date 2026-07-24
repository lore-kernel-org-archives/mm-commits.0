Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110431C5799;
	Fri, 24 Jul 2026 00:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784853291; cv=none; b=Z7gje7fEkQ1xQXFtWqUxoYQuzuThN6G9lHIQ5BcYUEJIrBEpoI02gA1LvAwEYnzY6atqmlcN0K/QICpQFwER6pTo6Oy4oRIBT3Qr8xm+9KSCbdxP1SDNwPDlLEja2vIuzM/i8BZ1YEyy4pmcB3DX7TW+FEmDI42C2YqsB9upoh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784853291; c=relaxed/simple;
	bh=1GupVAdgnh0lmxgtsjqTB23AkfNFdoNx+w0EIZ6NTz8=;
	h=Date:To:From:Subject:Message-Id; b=Go6DO/fehyGUpMWqL4OIRtcM/UxHAmWM7aRGJIN7lmrVU7vX8+uflet2LpLrPxKSZhmA2rQVVWNfb4M/sC/TPVsUXGP7rrldD4DcUYHgBNIfqRUROlsNY4EodmVe7kNF8oI9ZvtM3hEVOqOT9gbGtntiLLQdnGzTE8v2VyejmuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TzdgeIPr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TzdgeIPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98ACE1F000E9;
	Fri, 24 Jul 2026 00:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784853289;
	bh=OwSEswP+0sWy9CAHXh9BNNaCZVj9Bpimr3yevuXjqcQ=;
	h=Date:To:From:Subject;
	b=TzdgeIPrrpQrKraKXg1gLf0mBhb+QtLgwf2GiEush0ShtvXS0U3tthVSpUApBG/K4
	 1dDHAPkAiXI7gIPwpW/OB+dm59Hk5SB9AnteNWoo6o7LfOLs4OOxpsBoIJRHg6N4YW
	 piF0WeyepYYguN4RffQwHvWzU2AlvQlhswpKavuM=
Date: Thu, 23 Jul 2026 17:34:49 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,stable@vger.kernel.org,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,qi.zheng@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,husong@kylinos.cn,hannes@cmpxchg.org,david@kernel.org,dave@stgolabs.net,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,axelrasmussen@google.com,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-fix-node-reclaim-ignoring-swappiness-parameter.patch added to mm-new branch
Message-Id: <20260724003449.98ACE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: fix node reclaim ignoring swappiness parameter
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-fix-node-reclaim-ignoring-swappiness-parameter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-fix-node-reclaim-ignoring-swappiness-parameter.patch

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
memcg-move-mem_cgroup_swappiness-and-vm_swappiness-to-mm-swaph.patch
mm-vmscan-fix-node-reclaim-ignoring-swappiness-parameter.patch


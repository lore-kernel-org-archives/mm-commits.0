Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60592F7AAC
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025854; cv=none; b=TBdQjz/RCQ6flDw6Br+NpNawaYE2QhRdndt7CBiL/S1lZwS/qXHHzb3sviHS8vMy3+dyUGfcQzjFfEYHNMjwhhNfYXKTIfETDXYFhWMNj/2YEc8RxxPUYZ+4z/1KsUVgkcv3ty8Bmcp5zh8h6qaXWp4KMNURGiUTtr8kzfy2eCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025854; c=relaxed/simple;
	bh=MiwoJxpfrGoEHwTYJuBL52DxQxM7bFHwnEMMe9qWI20=;
	h=Date:To:From:Subject:Message-Id; b=TLwBlwIldnsa/+OyvxeXeNXnAJYIAVz7NJfeW249YGpP3BLQ5SjUnkrab+23oQhxweL1TbDLCvfoW5yfMDQONYoNzxPGr3nRjndf63AsF8skWjUXbJEwC1gTjjmlgYQOVGmp43iB1ATjIr2HvKf/jKfyq82kgSDYlsPUa23Ejsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0MpGuWNv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0MpGuWNv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC08DC4CEF1;
	Mon, 24 Nov 2025 23:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025854;
	bh=MiwoJxpfrGoEHwTYJuBL52DxQxM7bFHwnEMMe9qWI20=;
	h=Date:To:From:Subject:From;
	b=0MpGuWNv/zkdzR19x8a5V6KZbPHN4B/uGlLAeXlFTFgLpNeqyy23YO2owCsR7O56Z
	 8G84UTTYReZ0ZO+ar6xUerV9ECJ2EL+xgIozvTvVTlO9wEaBWwYBS4aczwWlQUXYMf
	 xIpowNcthERgZoLNi2VoQWUnGHyfdbOlxTcz2wiM=
Date: Mon, 24 Nov 2025 15:10:54 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,harry.yoo@oracle.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-use-mod_node_page_state-to-update-stats.patch removed from -mm tree
Message-Id: <20251124231054.AC08DC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: use mod_node_page_state to update stats
has been removed from the -mm tree.  Its filename was
     memcg-use-mod_node_page_state-to-update-stats.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: use mod_node_page_state to update stats
Date: Mon, 10 Nov 2025 15:20:05 -0800

Patch series "memcg: cleanup the memcg stats interfaces".

The memcg stats are safe against irq (and nmi) context and thus does not
require disabling irqs.  However for some stats which are also maintained
at node level, it is using irq unsafe interface and thus requiring the
users to still disables irqs or use interfaces which explicitly disables
irqs.  Let's move memcg code to use irq safe node level stats function
which is already optimized for architectures with HAVE_CMPXCHG_LOCAL (all
major ones), so there will not be any performance penalty for its usage.


This patch (of 4):

The memcg stats are safe against irq (and nmi) context and thus does not
require disabling irqs.  However some code paths for memcg stats also
update the node level stats and use irq unsafe interface and thus require
the users to disable irqs.  However node level stats, on architectures
with HAVE_CMPXCHG_LOCAL (all major ones), has interface which does not
require irq disabling.  Let's move memcg stats code to start using that
interface for node level stats.

Link: https://lkml.kernel.org/r/20251110232008.1352063-1-shakeel.butt@linux.dev
Link: https://lkml.kernel.org/r/20251110232008.1352063-2-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 include/linux/vmstat.h     |    4 ++--
 mm/memcontrol.c            |    6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/memcontrol.h~memcg-use-mod_node_page_state-to-update-stats
+++ a/include/linux/memcontrol.h
@@ -1408,7 +1408,7 @@ static inline void __mod_lruvec_kmem_sta
 {
 	struct page *page = virt_to_head_page(p);
 
-	__mod_node_page_state(page_pgdat(page), idx, val);
+	mod_node_page_state(page_pgdat(page), idx, val);
 }
 
 static inline void mod_lruvec_kmem_state(void *p, enum node_stat_item idx,
--- a/include/linux/vmstat.h~memcg-use-mod_node_page_state-to-update-stats
+++ a/include/linux/vmstat.h
@@ -557,7 +557,7 @@ static inline void mod_lruvec_page_state
 static inline void __mod_lruvec_state(struct lruvec *lruvec,
 				      enum node_stat_item idx, int val)
 {
-	__mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
+	mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
 }
 
 static inline void mod_lruvec_state(struct lruvec *lruvec,
@@ -569,7 +569,7 @@ static inline void mod_lruvec_state(stru
 static inline void __lruvec_stat_mod_folio(struct folio *folio,
 					 enum node_stat_item idx, int val)
 {
-	__mod_node_page_state(folio_pgdat(folio), idx, val);
+	mod_node_page_state(folio_pgdat(folio), idx, val);
 }
 
 static inline void lruvec_stat_mod_folio(struct folio *folio,
--- a/mm/memcontrol.c~memcg-use-mod_node_page_state-to-update-stats
+++ a/mm/memcontrol.c
@@ -770,7 +770,7 @@ void __mod_lruvec_state(struct lruvec *l
 			int val)
 {
 	/* Update node */
-	__mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
+	mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
 
 	/* Update memcg and lruvec */
 	if (!mem_cgroup_disabled())
@@ -789,7 +789,7 @@ void __lruvec_stat_mod_folio(struct foli
 	/* Untracked pages have no memcg, no lruvec. Update only the node */
 	if (!memcg) {
 		rcu_read_unlock();
-		__mod_node_page_state(pgdat, idx, val);
+		mod_node_page_state(pgdat, idx, val);
 		return;
 	}
 
@@ -815,7 +815,7 @@ void __mod_lruvec_kmem_state(void *p, en
 	 * vmstats to keep it correct for the root memcg.
 	 */
 	if (!memcg) {
-		__mod_node_page_state(pgdat, idx, val);
+		mod_node_page_state(pgdat, idx, val);
 	} else {
 		lruvec = mem_cgroup_lruvec(memcg, pgdat);
 		__mod_lruvec_state(lruvec, idx, val);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are



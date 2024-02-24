Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE159B663
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739439; cv=none; b=gLelo55XgrgQdsfV2PC61TsSORPpPp8on8Gcy03mNK3BN+4IFc0EkmO8lB8m/UsLlk8jl7bmCmpE4orOdesdH6BCjXvqUZszHFakoZUdaV6+LFOFXoazVXXLj4MkKdD6yY7uJUqe1+l75TwfkERZvP1u4k/4DhD4tr9faUkTEyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739439; c=relaxed/simple;
	bh=mIEbAbIyzmgLsNK7WAVHHkTPQkUNLScCjJslDhvFJXI=;
	h=Date:To:From:Subject:Message-Id; b=PquxutTAIch9iPPnQcE7xHpaNu9xPXBpcwY5RBx4Qg0VrWaylekpUkg2n57WG7BIwG7Av6nNLHcHFvF+fz1TEa36pGVQhLC8vnmx8rOTukkn7s8baa42uLZwODD3QcszT+ot893/t6DA9mSNuljE9zsJ7Nw7z068YC8q6p1u+yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gEJs/1oY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gEJs/1oY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F014C43390;
	Sat, 24 Feb 2024 01:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739438;
	bh=mIEbAbIyzmgLsNK7WAVHHkTPQkUNLScCjJslDhvFJXI=;
	h=Date:To:From:Subject:From;
	b=gEJs/1oYU/t0Ym37oayf5wZWAnPmWtanI5G0j+4TCaex2buR+S7esDlQep68f41Es
	 GabTpS6YxAHNGbQenQ/N7s25wGVytletRKunQ4/v7ZhkySrjzf8+SJci/7ZyYOjUfM
	 KqRPJnyyZuxWEtJUt/g07XjfBI0wUd5TP1xRKyRo=
Date: Fri, 23 Feb 2024 17:50:37 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-early-termination-in-compact_nodes.patch removed from -mm tree
Message-Id: <20240224015038.4F014C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: compaction: early termination in compact_nodes()
has been removed from the -mm tree.  Its filename was
     mm-compaction-early-termination-in-compact_nodes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: compaction: early termination in compact_nodes()
Date: Thu, 8 Feb 2024 10:25:08 +0800

No need to continue try compact memory if pending fatal signal, allow loop
termination earlier in compact_nodes().

The existing fatal_signal_pending() check does make compact_zone()
break out of the while loop, but it still enters the next zone/next
nid, and some unnecessary functions(eg, lru_add_drain) are called. 
There was no observable benefit from the new test, it is just found
from code inspection when refactoring compact_node().

Link: https://lkml.kernel.org/r/20240208022508.1771534-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- a/mm/compaction.c~mm-compaction-early-termination-in-compact_nodes
+++ a/mm/compaction.c
@@ -2808,7 +2808,7 @@ enum compact_result try_to_compact_pages
  * reaching score targets due to various back-off conditions, such as,
  * contention on per-node or per-zone locks.
  */
-static void compact_node(pg_data_t *pgdat, bool proactive)
+static int compact_node(pg_data_t *pgdat, bool proactive)
 {
 	int zoneid;
 	struct zone *zone;
@@ -2826,6 +2826,9 @@ static void compact_node(pg_data_t *pgda
 		if (!populated_zone(zone))
 			continue;
 
+		if (fatal_signal_pending(current))
+			return -EINTR;
+
 		cc.zone = zone;
 
 		compact_zone(&cc, NULL);
@@ -2837,18 +2840,25 @@ static void compact_node(pg_data_t *pgda
 					     cc.total_free_scanned);
 		}
 	}
+
+	return 0;
 }
 
 /* Compact all zones of all nodes in the system */
-static void compact_nodes(void)
+static int compact_nodes(void)
 {
-	int nid;
+	int ret, nid;
 
 	/* Flush pending updates to the LRU lists */
 	lru_add_drain_all();
 
-	for_each_online_node(nid)
-		compact_node(NODE_DATA(nid), false);
+	for_each_online_node(nid) {
+		ret = compact_node(NODE_DATA(nid), false);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 static int compaction_proactiveness_sysctl_handler(struct ctl_table *table, int write,
@@ -2894,9 +2904,9 @@ static int sysctl_compaction_handler(str
 		return -EINVAL;
 
 	if (write)
-		compact_nodes();
+		ret = compact_nodes();
 
-	return 0;
+	return ret;
 }
 
 #if defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

zram-zcomp-remove-zcomp_set_max_streams-declaration.patch


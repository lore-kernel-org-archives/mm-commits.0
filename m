Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F81221545;
	Mon, 19 Jan 2026 20:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768854669; cv=none; b=uuM7pchv1+npYCtfLgzL9WhfKCU0znXFziwyzLPuOO2pc7tHDrDIMJPqMPZak/pJlWlSxwNiWoSqBvXbZQNhBvRozuRJEmw3vKDK3BWNU8+lAzr78I5MDS0eAyHhVtrtJiWfQMa7Iko25LjpW7aWgHQTd/mEeuybIqQe7eX+638=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768854669; c=relaxed/simple;
	bh=HLz25jOG/H1IPRxKelfY2lQfl0mlfpkuPOLuws/pXUo=;
	h=Date:To:From:Subject:Message-Id; b=iSHniboYgW3ShQQfLCxqy2bidQl9VjRBNIV6ltw8hwS/i7ZJLnSgKuCvYssHsbEb0cXopbSujJegOPUuM2Icmw7ng4B27xhZFM4AnIZXAPVG6F4KCOhBANH1GPxBIMwAw/u++iRFtp3uXBfUinaqU2m7BzE4/UrYXb3cu4wEHjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dX97UaQv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dX97UaQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DD2C116C6;
	Mon, 19 Jan 2026 20:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768854669;
	bh=HLz25jOG/H1IPRxKelfY2lQfl0mlfpkuPOLuws/pXUo=;
	h=Date:To:From:Subject:From;
	b=dX97UaQv4OeUr+cAAUMhLFKxSupVH5gQ94IEZwGxir+1v+Ta5DVYrnDU74stlogTu
	 EP01i7Fmg/CSMxEgwm9e4shoV2Y4K0CyFUlZZNZIwc6umg9C7ogd2UK1aIGp560zec
	 BqobxhYzt0sLBIqAXEaCHneJOidi4/gwUVkrGVNA=
Date: Mon, 19 Jan 2026 12:31:08 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,david@kernel.org,dave@stgolabs.net,axelrasmussen@google.com,yosry.ahmed@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-restore-per-memcg-proactive-reclaim-with-config_numa.patch removed from -mm tree
Message-Id: <20260119203109.63DD2C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: restore per-memcg proactive reclaim with !CONFIG_NUMA
has been removed from the -mm tree.  Its filename was
     mm-restore-per-memcg-proactive-reclaim-with-config_numa.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: mm: restore per-memcg proactive reclaim with !CONFIG_NUMA
Date: Fri, 16 Jan 2026 20:52:47 +0000

Commit 2b7226af730c ("mm/memcg: make memory.reclaim interface generic")
moved proactive reclaim logic from memory.reclaim handler to a generic
user_proactive_reclaim() helper to be used for per-node proactive reclaim.

However, user_proactive_reclaim() was only defined under CONFIG_NUMA, with
a stub always returning 0 otherwise.  This broke memory.reclaim on
!CONFIG_NUMA configs, causing it to report success without actually
attempting reclaim.

Move the definition of user_proactive_reclaim() outside CONFIG_NUMA, and
instead define a stub for __node_reclaim() in the !CONFIG_NUMA case. 
__node_reclaim() is only called from user_proactive_reclaim() when a write
is made to sys/devices/system/node/nodeX/reclaim, which is only defined
with CONFIG_NUMA.

Link: https://lkml.kernel.org/r/20260116205247.928004-1-yosry.ahmed@linux.dev
Fixes: 2b7226af730c ("mm/memcg: make memory.reclaim interface generic")
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    8 --------
 mm/vmscan.c   |   13 +++++++++++--
 2 files changed, 11 insertions(+), 10 deletions(-)

--- a/mm/internal.h~mm-restore-per-memcg-proactive-reclaim-with-config_numa
+++ a/mm/internal.h
@@ -538,16 +538,8 @@ extern unsigned long highest_memmap_pfn;
 bool folio_isolate_lru(struct folio *folio);
 void folio_putback_lru(struct folio *folio);
 extern void reclaim_throttle(pg_data_t *pgdat, enum vmscan_throttle_state reason);
-#ifdef CONFIG_NUMA
 int user_proactive_reclaim(char *buf,
 			   struct mem_cgroup *memcg, pg_data_t *pgdat);
-#else
-static inline int user_proactive_reclaim(char *buf,
-			   struct mem_cgroup *memcg, pg_data_t *pgdat)
-{
-	return 0;
-}
-#endif
 
 /*
  * in mm/rmap.c:
--- a/mm/vmscan.c~mm-restore-per-memcg-proactive-reclaim-with-config_numa
+++ a/mm/vmscan.c
@@ -7707,6 +7707,17 @@ int node_reclaim(struct pglist_data *pgd
 	return ret;
 }
 
+#else
+
+static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
+				    unsigned long nr_pages,
+				    struct scan_control *sc)
+{
+	return 0;
+}
+
+#endif
+
 enum {
 	MEMORY_RECLAIM_SWAPPINESS = 0,
 	MEMORY_RECLAIM_SWAPPINESS_MAX,
@@ -7814,8 +7825,6 @@ int user_proactive_reclaim(char *buf,
 	return 0;
 }
 
-#endif
-
 /**
  * check_move_unevictable_folios - Move evictable folios to appropriate zone
  * lru list
_

Patches currently in -mm which might be from yosry.ahmed@linux.dev are

zsmalloc-simplify-read-begin-end-logic.patch


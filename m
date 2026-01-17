Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3562D661C;
	Sat, 17 Jan 2026 02:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768618435; cv=none; b=LH6fG/4FFYwTp/NzoZYCqiXw9gZ2RXtQZhTSjX3WC4GzgL6lgyZqWTWPCqh+G19FRbLqagZR7VNBuFfDSKRgbwCKVsXlERPR4FjVR5cjNHJTgnfuRRdz1/uk4TS7EO1Rz0ZsMkKZDSlqFDxza6ofn6HRdGBbBQDNiOwC/WL2Itw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768618435; c=relaxed/simple;
	bh=JQm5DIRXYiCtzOhWiwjD7Wh+YLz0zu1WzfkxRRNEKas=;
	h=Date:To:From:Subject:Message-Id; b=MPxoacMbvccVNPsxCSSK35g7hafvhq5AHCzaXDV9S4b//WM73aejmFB+ChwkrJ7uB2MzGMe3+PRG75kAsVU/GlfeVS5IkFuYNQiWGKGhciD8jQcW49W6ouzW0tFAkJNpkmqcO9VhGHW8E723+ajqtjPy+AcxvXWxlp3XYHOjkY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RU49QWB0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RU49QWB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FDBC116C6;
	Sat, 17 Jan 2026 02:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768618435;
	bh=JQm5DIRXYiCtzOhWiwjD7Wh+YLz0zu1WzfkxRRNEKas=;
	h=Date:To:From:Subject:From;
	b=RU49QWB0nKgmEkSEn6DseN/sLdnFDafBqeNdpmNSl7LLTuq20Cns/CMBd7Rm3PmTk
	 Z38W0tIoFs2jSnoLvLZDSsCxpos9M7rwNQse94TgrsiXnDMHsfnqjcdhgGMZAHanbK
	 nqJ+yk6o5baqtk53+IYtPAJH4W6Mti0FCWX1NxPQ=
Date: Fri, 16 Jan 2026 18:53:54 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,david@kernel.org,dave@stgolabs.net,axelrasmussen@google.com,yosry.ahmed@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-restore-per-memcg-proactive-reclaim-with-config_numa.patch added to mm-hotfixes-unstable branch
Message-Id: <20260117025355.A2FDBC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: restore per-memcg proactive reclaim with !CONFIG_NUMA
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-restore-per-memcg-proactive-reclaim-with-config_numa.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-restore-per-memcg-proactive-reclaim-with-config_numa.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
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

mm-restore-per-memcg-proactive-reclaim-with-config_numa.patch
zsmalloc-simplify-read-begin-end-logic.patch


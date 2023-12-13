Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAA766113;
	Wed, 13 Dec 2023 01:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IDAUHaEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D20C433C7;
	Wed, 13 Dec 2023 01:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702430461;
	bh=Ogjh4trmb2qhbfxEjRfqgKEnVgKAWQ7vdX+VV1t5OP8=;
	h=Date:To:From:Subject:From;
	b=IDAUHaEUbP+tNycfrhMb5TuCzq6Cc4VS+lQapXku22I2K9/n/EZGvcX1KUWQqNW/6
	 5VnZXmeBTWJAcOwk/yJ6SSjQrZt6O7SPZlOKAq9DypskRXxNKcBWHTBNzYNqvbPC66
	 AM2J+fnVNu9FsfDMVB/LmRqbqYOIzsz3sD2X7KI8=
Date: Tue, 12 Dec 2023 17:21:00 -0800
To: mm-commits@vger.kernel.org,tjmercier@google.com,stable@vger.kernel.org,ryncsn@gmail.com,quic_charante@quicinc.com,kaleshsingh@google.com,jaroslav.pulchart@gooddata.com,hdanton@sina.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mglru-reclaim-offlined-memcgs-harder.patch removed from -mm tree
Message-Id: <20231213012101.56D20C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: reclaim offlined memcgs harder
has been removed from the -mm tree.  Its filename was
     mm-mglru-reclaim-offlined-memcgs-harder.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm/mglru: reclaim offlined memcgs harder
Date: Thu, 7 Dec 2023 23:14:07 -0700

In the effort to reduce zombie memcgs [1], it was discovered that the
memcg LRU doesn't apply enough pressure on offlined memcgs.  Specifically,
instead of rotating them to the tail of the current generation
(MEMCG_LRU_TAIL) for a second attempt, it moves them to the next
generation (MEMCG_LRU_YOUNG) after the first attempt.

Not applying enough pressure on offlined memcgs can cause them to build
up, and this can be particularly harmful to memory-constrained systems.

On Pixel 8 Pro, launching apps for 50 cycles:
                 Before  After  Change
  Zombie memcgs  45      35     -22%

[1] https://lore.kernel.org/CABdmKX2M6koq4Q0Cmp_-=wbP0Qa190HdEGGaHfxNS05gAkUtPA@mail.gmail.com/

Link: https://lkml.kernel.org/r/20231208061407.2125867-4-yuzhao@google.com
Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reported-by: T.J. Mercier <tjmercier@google.com>
Tested-by: T.J. Mercier <tjmercier@google.com>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    8 ++++----
 mm/vmscan.c            |   24 ++++++++++++++++--------
 2 files changed, 20 insertions(+), 12 deletions(-)

--- a/include/linux/mmzone.h~mm-mglru-reclaim-offlined-memcgs-harder
+++ a/include/linux/mmzone.h
@@ -519,10 +519,10 @@ void lru_gen_look_around(struct page_vma
  * 1. Exceeding the soft limit, which triggers MEMCG_LRU_HEAD;
  * 2. The first attempt to reclaim a memcg below low, which triggers
  *    MEMCG_LRU_TAIL;
- * 3. The first attempt to reclaim a memcg below reclaimable size threshold,
- *    which triggers MEMCG_LRU_TAIL;
- * 4. The second attempt to reclaim a memcg below reclaimable size threshold,
- *    which triggers MEMCG_LRU_YOUNG;
+ * 3. The first attempt to reclaim a memcg offlined or below reclaimable size
+ *    threshold, which triggers MEMCG_LRU_TAIL;
+ * 4. The second attempt to reclaim a memcg offlined or below reclaimable size
+ *    threshold, which triggers MEMCG_LRU_YOUNG;
  * 5. Attempting to reclaim a memcg below min, which triggers MEMCG_LRU_YOUNG;
  * 6. Finishing the aging on the eviction path, which triggers MEMCG_LRU_YOUNG;
  * 7. Offlining a memcg, which triggers MEMCG_LRU_OLD.
--- a/mm/vmscan.c~mm-mglru-reclaim-offlined-memcgs-harder
+++ a/mm/vmscan.c
@@ -4598,7 +4598,12 @@ static bool should_run_aging(struct lruv
 	}
 
 	/* try to scrape all its memory if this memcg was deleted */
-	*nr_to_scan = mem_cgroup_online(memcg) ? (total >> sc->priority) : total;
+	if (!mem_cgroup_online(memcg)) {
+		*nr_to_scan = total;
+		return false;
+	}
+
+	*nr_to_scan = total >> sc->priority;
 
 	/*
 	 * The aging tries to be lazy to reduce the overhead, while the eviction
@@ -4719,14 +4724,9 @@ static int shrink_one(struct lruvec *lru
 	bool success;
 	unsigned long scanned = sc->nr_scanned;
 	unsigned long reclaimed = sc->nr_reclaimed;
-	int seg = lru_gen_memcg_seg(lruvec);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
-	/* see the comment on MEMCG_NR_GENS */
-	if (!lruvec_is_sizable(lruvec, sc))
-		return seg != MEMCG_LRU_TAIL ? MEMCG_LRU_TAIL : MEMCG_LRU_YOUNG;
-
 	mem_cgroup_calculate_protection(NULL, memcg);
 
 	if (mem_cgroup_below_min(NULL, memcg))
@@ -4734,7 +4734,7 @@ static int shrink_one(struct lruvec *lru
 
 	if (mem_cgroup_below_low(NULL, memcg)) {
 		/* see the comment on MEMCG_NR_GENS */
-		if (seg != MEMCG_LRU_TAIL)
+		if (lru_gen_memcg_seg(lruvec) != MEMCG_LRU_TAIL)
 			return MEMCG_LRU_TAIL;
 
 		memcg_memory_event(memcg, MEMCG_LOW);
@@ -4750,7 +4750,15 @@ static int shrink_one(struct lruvec *lru
 
 	flush_reclaim_state(sc);
 
-	return success ? MEMCG_LRU_YOUNG : 0;
+	if (success && mem_cgroup_online(memcg))
+		return MEMCG_LRU_YOUNG;
+
+	if (!success && lruvec_is_sizable(lruvec, sc))
+		return 0;
+
+	/* one retry if offlined or too small */
+	return lru_gen_memcg_seg(lruvec) != MEMCG_LRU_TAIL ?
+	       MEMCG_LRU_TAIL : MEMCG_LRU_YOUNG;
 }
 
 #ifdef CONFIG_MEMCG
_

Patches currently in -mm which might be from yuzhao@google.com are



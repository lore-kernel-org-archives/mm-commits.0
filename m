Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDB314B086
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976916; cv=none; b=MQ+6sA2xZ+t/cW3PFGGVcMiZvaM7i5UTH3LybaugNmmW1FSFM0sIuuXC2msmtbzkIdv62z5g2XfOYIqPJTPFiwEdzCm9LFYX8ZqEfV3pkNx+j8Hzzy97C6387zd/P3shDMbgS/ek5kE7iPCuq4E89/HblLsnj0zFMUMZHAI5LGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976916; c=relaxed/simple;
	bh=ewpXpPkiWZL4RKpRkSxntLq7p6Cl5mi1y2Ukb41g+B0=;
	h=Date:To:From:Subject:Message-Id; b=qhSY8txYfToo9m/1vApZ5yn04e8gGKO/NeX7Xf2niWx/GfRyJ1Jext28XYvpzlRPEL6G+OAGh/yJbrwML6MwSQlE2wBjgD3n0Ke85z18DkDNzUKPWJEB8J/5NmbhIEIQBtpajeHKaax0mHSRsuZ4HuUdKFn1XZygyuW99AD2/m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s9ic/jS4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s9ic/jS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E90EEC4CEE3;
	Sun, 20 Jul 2025 02:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976916;
	bh=ewpXpPkiWZL4RKpRkSxntLq7p6Cl5mi1y2Ukb41g+B0=;
	h=Date:To:From:Subject:From;
	b=s9ic/jS4Y34PDI3v5GjkkmpkM1JYDYzvfNvdemkpboWEam85aaaPeV3HVq5K+2pvE
	 C7225ljeU/Xdu19QrxTpPwptIyH3vKPwLrJ4WfuTQ4fJ+7h8PwCeTkqqO1QL7JCDcz
	 UAhg0B84CFbhmF1Nzwh8ku1JH5RPjvBF+GyLyotE=
Date: Sat, 19 Jul 2025 19:01:55 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,dave@stgolabs.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-make-memoryreclaim-interface-generic.patch removed from -mm tree
Message-Id: <20250720020155.E90EEC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memcg: make memory.reclaim interface generic
has been removed from the -mm tree.  Its filename was
     mm-memcg-make-memoryreclaim-interface-generic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mm/memcg: make memory.reclaim interface generic
Date: Mon, 23 Jun 2025 11:58:49 -0700

This adds a general call for both parsing as well as the common reclaim
semantics.  memcg is still the only user and no change in semantics.

[akpm@linux-foundation.org: fix CONFIG_NUMA=n build]
Link: https://lkml.kernel.org/r/20250623185851.830632-3-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |   10 ++++
 mm/memcontrol.c |   77 +-----------------------------------
 mm/vmscan.c     |   98 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 112 insertions(+), 73 deletions(-)

--- a/mm/internal.h~mm-memcg-make-memoryreclaim-interface-generic
+++ a/mm/internal.h
@@ -533,6 +533,16 @@ extern unsigned long highest_memmap_pfn;
 bool folio_isolate_lru(struct folio *folio);
 void folio_putback_lru(struct folio *folio);
 extern void reclaim_throttle(pg_data_t *pgdat, enum vmscan_throttle_state reason);
+#ifdef CONFIG_NUMA
+int user_proactive_reclaim(char *buf,
+			   struct mem_cgroup *memcg, pg_data_t *pgdat);
+#else
+static inline int user_proactive_reclaim(char *buf,
+			   struct mem_cgroup *memcg, pg_data_t *pgdat)
+{
+	return 0;
+}
+#endif
 
 /*
  * in mm/rmap.c:
--- a/mm/memcontrol.c~mm-memcg-make-memoryreclaim-interface-generic
+++ a/mm/memcontrol.c
@@ -51,7 +51,6 @@
 #include <linux/spinlock.h>
 #include <linux/fs.h>
 #include <linux/seq_file.h>
-#include <linux/parser.h>
 #include <linux/vmpressure.h>
 #include <linux/memremap.h>
 #include <linux/mm_inline.h>
@@ -4564,83 +4563,15 @@ static ssize_t memory_oom_group_write(st
 	return nbytes;
 }
 
-enum {
-	MEMORY_RECLAIM_SWAPPINESS = 0,
-	MEMORY_RECLAIM_SWAPPINESS_MAX,
-	MEMORY_RECLAIM_NULL,
-};
-
-static const match_table_t tokens = {
-	{ MEMORY_RECLAIM_SWAPPINESS, "swappiness=%d"},
-	{ MEMORY_RECLAIM_SWAPPINESS_MAX, "swappiness=max"},
-	{ MEMORY_RECLAIM_NULL, NULL },
-};
-
 static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
 			      size_t nbytes, loff_t off)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
-	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
-	unsigned long nr_to_reclaim, nr_reclaimed = 0;
-	int swappiness = -1;
-	unsigned int reclaim_options;
-	char *old_buf, *start;
-	substring_t args[MAX_OPT_ARGS];
-
-	buf = strstrip(buf);
-
-	old_buf = buf;
-	nr_to_reclaim = memparse(buf, &buf) / PAGE_SIZE;
-	if (buf == old_buf)
-		return -EINVAL;
-
-	buf = strstrip(buf);
-
-	while ((start = strsep(&buf, " ")) != NULL) {
-		if (!strlen(start))
-			continue;
-		switch (match_token(start, tokens, args)) {
-		case MEMORY_RECLAIM_SWAPPINESS:
-			if (match_int(&args[0], &swappiness))
-				return -EINVAL;
-			if (swappiness < MIN_SWAPPINESS || swappiness > MAX_SWAPPINESS)
-				return -EINVAL;
-			break;
-		case MEMORY_RECLAIM_SWAPPINESS_MAX:
-			swappiness = SWAPPINESS_ANON_ONLY;
-			break;
-		default:
-			return -EINVAL;
-		}
-	}
-
-	reclaim_options	= MEMCG_RECLAIM_MAY_SWAP | MEMCG_RECLAIM_PROACTIVE;
-	while (nr_reclaimed < nr_to_reclaim) {
-		/* Will converge on zero, but reclaim enforces a minimum */
-		unsigned long batch_size = (nr_to_reclaim - nr_reclaimed) / 4;
-		unsigned long reclaimed;
-
-		if (signal_pending(current))
-			return -EINTR;
-
-		/*
-		 * This is the final attempt, drain percpu lru caches in the
-		 * hope of introducing more evictable pages for
-		 * try_to_free_mem_cgroup_pages().
-		 */
-		if (!nr_retries)
-			lru_add_drain_all();
-
-		reclaimed = try_to_free_mem_cgroup_pages(memcg,
-					batch_size, GFP_KERNEL,
-					reclaim_options,
-					swappiness == -1 ? NULL : &swappiness);
-
-		if (!reclaimed && !nr_retries--)
-			return -EAGAIN;
+	int ret;
 
-		nr_reclaimed += reclaimed;
-	}
+	ret = user_proactive_reclaim(buf, memcg, NULL);
+	if (ret)
+		return ret;
 
 	return nbytes;
 }
--- a/mm/vmscan.c~mm-memcg-make-memoryreclaim-interface-generic
+++ a/mm/vmscan.c
@@ -57,6 +57,7 @@
 #include <linux/rculist_nulls.h>
 #include <linux/random.h>
 #include <linux/mmu_notifier.h>
+#include <linux/parser.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -6714,6 +6715,15 @@ unsigned long try_to_free_mem_cgroup_pag
 
 	return nr_reclaimed;
 }
+#else
+unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
+					   unsigned long nr_pages,
+					   gfp_t gfp_mask,
+					   unsigned int reclaim_options,
+					   int *swappiness)
+{
+	return 0;
+}
 #endif
 
 static void kswapd_age_node(struct pglist_data *pgdat, struct scan_control *sc)
@@ -7708,6 +7718,94 @@ int node_reclaim(struct pglist_data *pgd
 
 	return ret;
 }
+
+enum {
+	MEMORY_RECLAIM_SWAPPINESS = 0,
+	MEMORY_RECLAIM_SWAPPINESS_MAX,
+	MEMORY_RECLAIM_NULL,
+};
+static const match_table_t tokens = {
+	{ MEMORY_RECLAIM_SWAPPINESS, "swappiness=%d"},
+	{ MEMORY_RECLAIM_SWAPPINESS_MAX, "swappiness=max"},
+	{ MEMORY_RECLAIM_NULL, NULL },
+};
+
+int user_proactive_reclaim(char *buf, struct mem_cgroup *memcg, pg_data_t *pgdat)
+{
+	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
+	unsigned long nr_to_reclaim, nr_reclaimed = 0;
+	int swappiness = -1;
+	char *old_buf, *start;
+	substring_t args[MAX_OPT_ARGS];
+
+	if (!buf || (!memcg && !pgdat))
+		return -EINVAL;
+
+	buf = strstrip(buf);
+
+	old_buf = buf;
+	nr_to_reclaim = memparse(buf, &buf) / PAGE_SIZE;
+	if (buf == old_buf)
+		return -EINVAL;
+
+	buf = strstrip(buf);
+
+	while ((start = strsep(&buf, " ")) != NULL) {
+		if (!strlen(start))
+			continue;
+		switch (match_token(start, tokens, args)) {
+		case MEMORY_RECLAIM_SWAPPINESS:
+			if (match_int(&args[0], &swappiness))
+				return -EINVAL;
+			if (swappiness < MIN_SWAPPINESS ||
+			    swappiness > MAX_SWAPPINESS)
+				return -EINVAL;
+			break;
+		case MEMORY_RECLAIM_SWAPPINESS_MAX:
+			swappiness = SWAPPINESS_ANON_ONLY;
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
+	while (nr_reclaimed < nr_to_reclaim) {
+		/* Will converge on zero, but reclaim enforces a minimum */
+		unsigned long batch_size = (nr_to_reclaim - nr_reclaimed) / 4;
+		unsigned long reclaimed;
+
+		if (signal_pending(current))
+			return -EINTR;
+
+		/*
+		 * This is the final attempt, drain percpu lru caches in the
+		 * hope of introducing more evictable pages.
+		 */
+		if (!nr_retries)
+			lru_add_drain_all();
+
+		if (memcg) {
+			unsigned int reclaim_options;
+
+			reclaim_options = MEMCG_RECLAIM_MAY_SWAP |
+					  MEMCG_RECLAIM_PROACTIVE;
+			reclaimed = try_to_free_mem_cgroup_pages(memcg,
+						 batch_size, GFP_KERNEL,
+						 reclaim_options,
+						 swappiness == -1 ? NULL : &swappiness);
+		} else {
+			return -EINVAL;
+		}
+
+		if (!reclaimed && !nr_retries--)
+			return -EAGAIN;
+
+		nr_reclaimed += reclaimed;
+	}
+
+	return 0;
+}
+
 #endif
 
 /**
_

Patches currently in -mm which might be from dave@stgolabs.net are



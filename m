Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5842253F9
	for <mm-commits@vger.kernel.org>; Mon, 23 Jun 2025 21:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715417; cv=none; b=oMFYMf7BrqAVN2ii8lGKHjG1MoqXRmdRSyS9xAxIra/NJQaxDphc6XIRkl1HTLUmi8BGEGUjvHg8ovtMbM9v04jqlfKT6WlbjOz2W9fANRMvserdXIKlmVIAIXcGI7DvS6W1RWj9dIAQoL0gzJc8TsvjklXBEjrxdyqMbENAl0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715417; c=relaxed/simple;
	bh=UtxIGImykJPcmYuW9f60R55RsB+SoRnYk/OBIGSi0pI=;
	h=Date:To:From:Subject:Message-Id; b=q0nuzFe42OkCIQmhaMIEMjWVlqS/ccjSlCODZPRXsEEErwGcH/PVZtr/nCzEr9OzgLIc6GMQNbA2q1OpConuBybeRfEtHL+HA1jGS5cR+2c8+P1sh3uxXl7toJusfyQQyMEHl2Tzpnvun7vr48ooQ3eepYwXi6enTc6Cf4+A0Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZCvNsR19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZCvNsR19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9AEC4CEF1;
	Mon, 23 Jun 2025 21:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750715416;
	bh=UtxIGImykJPcmYuW9f60R55RsB+SoRnYk/OBIGSi0pI=;
	h=Date:To:From:Subject:From;
	b=ZCvNsR19pcOq5aTLwunyL4mZo5ZXOcJ5QmYc0TRo2aAgQc4A00+f0SKwU2Y7slvd5
	 v7XmFehiIQ09vtRZ/h9BiYoNS4ef4ek6NbIYCoZTJ8LDSnMy+TVqclv7uarbvtqGyI
	 oJUJPHsk7/eFfaBsiHKyvqHZagAb8w13BKxD5x/Y=
Date: Mon, 23 Jun 2025 14:50:15 -0700
To: mm-commits@vger.kernel.org,dave@stgolabs.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-make-memoryreclaim-interface-generic.patch added to mm-new branch
Message-Id: <20250623215016.4A9AEC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memcg: make memory.reclaim interface generic
has been added to the -mm mm-new branch.  Its filename is
     mm-memcg-make-memoryreclaim-interface-generic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-make-memoryreclaim-interface-generic.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mm/memcg: make memory.reclaim interface generic
Date: Mon, 23 Jun 2025 11:58:49 -0700

This adds a general call for both parsing as well as the common reclaim
semantics.  memcg is still the only user and no change in semantics.

Link: https://lkml.kernel.org/r/20250623185851.830632-3-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    2 
 mm/memcontrol.c |   77 +-----------------------------------
 mm/vmscan.c     |   98 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 104 insertions(+), 73 deletions(-)

--- a/mm/internal.h~mm-memcg-make-memoryreclaim-interface-generic
+++ a/mm/internal.h
@@ -517,6 +517,8 @@ extern unsigned long highest_memmap_pfn;
 bool folio_isolate_lru(struct folio *folio);
 void folio_putback_lru(struct folio *folio);
 extern void reclaim_throttle(pg_data_t *pgdat, enum vmscan_throttle_state reason);
+int user_proactive_reclaim(char *buf,
+			   struct mem_cgroup *memcg, pg_data_t *pgdat);
 
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
@@ -4566,83 +4565,15 @@ static ssize_t memory_oom_group_write(st
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
@@ -6712,6 +6713,15 @@ unsigned long try_to_free_mem_cgroup_pag
 
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
@@ -7706,6 +7716,94 @@ int node_reclaim(struct pglist_data *pgd
 
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

mm-vmscan-respect-psi_memstall-region-in-node-reclaim.patch
mm-memcg-make-memoryreclaim-interface-generic.patch
mm-vmscan-make-__node_reclaim-more-generic.patch
mm-introduce-per-node-proactive-reclaim-interface.patch


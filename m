Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212F7217673
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188420; cv=none; b=nZEvS1H6LFE38bSH6fbfZTlIiGnJXi4UyDn2lzAmngPpPhLkK+AnOrRNAmUzeOL18BpG99qKqRj1f3ZGBVjtvQBQpfd6zhtiPdFdgCwzl7CbGvw74mAVXTulTz1592HbqClrQ5WLGa6I15SiY0tggqzwv/7Plpy4gadbQj5FiBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188420; c=relaxed/simple;
	bh=ll6KWJFK3lj42MrXeoaRtOAJKkMvO1UmDCmeWzBIWbY=;
	h=Date:To:From:Subject:Message-Id; b=DAZrMYYjutsFs4s9yRd60PPegWupCAYpNMjHKU8kRL3S1MpbTsr/l7L3OOLqBRkt++i1Lhc9gK46v+k4INBGeQC1i8Rm9EmfWyJTO3B5ZD3EbMVktgGCmRq29sXuIs3qZExRB4bhaEEdeqR9YGtmw0aPy4a/joQWXVksVbopdCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kStAI0lD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kStAI0lD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8CBC4CEEC;
	Mon, 17 Mar 2025 05:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188420;
	bh=ll6KWJFK3lj42MrXeoaRtOAJKkMvO1UmDCmeWzBIWbY=;
	h=Date:To:From:Subject:From;
	b=kStAI0lDo8bHGfG/Fys/wob1OeBVuRU4jqRD4vVl1zC3WGvDTRVK+njKwHQYaJtKv
	 loEU7hBLDECnlouaUJM3tYxuG9dFjh7/yTOHAYKoM5ZPJXNKfZADir8HqBl2bFlzoI
	 K5mFZrIrnOmo21/176lsEtAMzyxw2hFPID47LNqE=
Date: Sun, 16 Mar 2025 22:13:39 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-limit-max-recompress-prio-to-num_active_comps.patch removed from -mm tree
Message-Id: <20250317051339.EC8CBC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: limit max recompress prio to num_active_comps
has been removed from the -mm tree.  Its filename was
     zram-limit-max-recompress-prio-to-num_active_comps.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: limit max recompress prio to num_active_comps
Date: Mon, 3 Mar 2025 11:03:17 +0900

Use the actual number of algorithms zram was configure with instead of
theoretical limit of ZRAM_MAX_COMPS.

Also make sure that min prio is not above max prio.

Link: https://lkml.kernel.org/r/20250303022425.285971-9-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-limit-max-recompress-prio-to-num_active_comps
+++ a/drivers/block/zram/zram_drv.c
@@ -2027,16 +2027,19 @@ static ssize_t recompress_store(struct d
 				struct device_attribute *attr,
 				const char *buf, size_t len)
 {
-	u32 prio = ZRAM_SECONDARY_COMP, prio_max = ZRAM_MAX_COMPS;
 	struct zram *zram = dev_to_zram(dev);
 	char *args, *param, *val, *algo = NULL;
 	u64 num_recomp_pages = ULLONG_MAX;
 	struct zram_pp_ctl *ctl = NULL;
 	struct zram_pp_slot *pps;
 	u32 mode = 0, threshold = 0;
+	u32 prio, prio_max;
 	struct page *page;
 	ssize_t ret;
 
+	prio = ZRAM_SECONDARY_COMP;
+	prio_max = zram->num_active_comps;
+
 	args = skip_spaces(buf);
 	while (*args) {
 		args = next_arg(args, &param, &val);
@@ -2089,7 +2092,7 @@ static ssize_t recompress_store(struct d
 			if (prio == ZRAM_PRIMARY_COMP)
 				prio = ZRAM_SECONDARY_COMP;
 
-			prio_max = min(prio + 1, ZRAM_MAX_COMPS);
+			prio_max = prio + 1;
 			continue;
 		}
 	}
@@ -2117,7 +2120,7 @@ static ssize_t recompress_store(struct d
 				continue;
 
 			if (!strcmp(zram->comp_algs[prio], algo)) {
-				prio_max = min(prio + 1, ZRAM_MAX_COMPS);
+				prio_max = prio + 1;
 				found = true;
 				break;
 			}
@@ -2129,6 +2132,12 @@ static ssize_t recompress_store(struct d
 		}
 	}
 
+	prio_max = min(prio_max, (u32)zram->num_active_comps);
+	if (prio >= prio_max) {
+		ret = -EINVAL;
+		goto release_init_lock;
+	}
+
 	page = alloc_page(GFP_KERNEL);
 	if (!page) {
 		ret = -ENOMEM;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are



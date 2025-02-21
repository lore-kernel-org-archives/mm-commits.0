Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC1C24C67B
	for <mm-commits@vger.kernel.org>; Fri, 21 Feb 2025 23:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740181363; cv=none; b=FT7FP98BD++7XnG1lzZDYvjo2BSNMJEVcQvOPPGrGExg6vjLyGqyXplRHXjVliWF1WPlOVSWi99vjEz3IvndBb7ma01qFPsR3gpXJ2kyPEWc+oUkhs8S1eXU/OWm3A3KzcQzzlVWewKq1hfs6uRLBTGgo8dOv1TfVd2EsuPaSOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740181363; c=relaxed/simple;
	bh=x2bv/6WWekCTjMIFTZ4ttCm3QUXwBQTeSNj9je6l46Y=;
	h=Date:To:From:Subject:Message-Id; b=M/2eQ9PjaZepEmwDLp6oeTcyY4SYPBMjgKkWYaxcARllhUdiHUL+YlugfABwC+XA2xFh0rthMBpW3SZVVy4o4+yRXvfJL1m88Qndx28k5evmdGgcYq7Q8ARac7waebfaAxGsKh+f5aUzVfrnT0d6i1KBroNz/G3cHGAOAxsyU0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XGAopBoB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XGAopBoB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FC8C4CED6;
	Fri, 21 Feb 2025 23:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740181362;
	bh=x2bv/6WWekCTjMIFTZ4ttCm3QUXwBQTeSNj9je6l46Y=;
	h=Date:To:From:Subject:From;
	b=XGAopBoBN5B2o5M4eCjbujGOfNJJ0K1982eDc1PcLRx3V+BH+dwMJ6qaVDdwCSzEw
	 iE/hf8LPFoYt6ccRkLS8d8NSgEAVxizY1rR+jZA1Hrj4zhfVR8FEKCdErvGdREh8UO
	 25kn71GWvqdp7klbx0h3GjwSfnot56wkxE9aOPi4=
Date: Fri, 21 Feb 2025 15:42:42 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-limit-max-recompress-prio-to-num_active_comps.patch added to mm-unstable branch
Message-Id: <20250221234242.D2FC8C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: limit max recompress prio to num_active_comps
has been added to the -mm mm-unstable branch.  Its filename is
     zram-limit-max-recompress-prio-to-num_active_comps.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-limit-max-recompress-prio-to-num_active_comps.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: limit max recompress prio to num_active_comps
Date: Sat, 22 Feb 2025 07:25:38 +0900

Use the actual number of algorithms zram was configure with instead of
theoretical limit of ZRAM_MAX_COMPS.

Also make sure that min prio is not above max prio.

Link: https://lkml.kernel.org/r/20250221222958.2225035-8-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-limit-max-recompress-prio-to-num_active_comps
+++ a/drivers/block/zram/zram_drv.c
@@ -2031,16 +2031,19 @@ static ssize_t recompress_store(struct d
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
@@ -2093,7 +2096,7 @@ static ssize_t recompress_store(struct d
 			if (prio == ZRAM_PRIMARY_COMP)
 				prio = ZRAM_SECONDARY_COMP;
 
-			prio_max = min(prio + 1, ZRAM_MAX_COMPS);
+			prio_max = prio + 1;
 			continue;
 		}
 	}
@@ -2121,7 +2124,7 @@ static ssize_t recompress_store(struct d
 				continue;
 
 			if (!strcmp(zram->comp_algs[prio], algo)) {
-				prio_max = min(prio + 1, ZRAM_MAX_COMPS);
+				prio_max = prio + 1;
 				found = true;
 				break;
 			}
@@ -2133,6 +2136,12 @@ static ssize_t recompress_store(struct d
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

zram-sleepable-entry-locking.patch
zram-permit-preemption-with-active-compression-stream.patch
zram-remove-unused-crypto-include.patch
zram-remove-max_comp_streams-device-attr.patch
zram-remove-second-stage-of-handle-allocation.patch
zram-remove-writestall-zram_stats-member.patch
zram-limit-max-recompress-prio-to-num_active_comps.patch
zram-filter-out-recomp-targets-based-on-priority.patch
zram-rework-recompression-loop.patch
zsmalloc-rename-pool-lock.patch
zsmalloc-make-zspage-lock-preemptible.patch
zsmalloc-introduce-new-object-mapping-api.patch
zram-switch-to-new-zsmalloc-object-mapping-api.patch
zram-permit-reclaim-in-zstd-custom-allocator.patch
zram-do-not-leak-page-on-recompress_store-error-path.patch
zram-do-not-leak-page-on-writeback_store-error-path.patch
zram-add-might_sleep-to-zcomp-api.patch
zsmalloc-zram-there-be-preemption.patch


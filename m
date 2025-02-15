Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCECE2BD1B
	for <mm-commits@vger.kernel.org>; Sat, 15 Feb 2025 00:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739578698; cv=none; b=jHJBIt//wFtb3elVM1+4fYU/sdddCS9MqTHKcJMASsx76TUI8HSrto0L7CvY8ga/eJSU7vUbKUYKLR8XvVslebvabCkmv97LjMLXnL0CAd+3GG49PQXm8Pg5Yq6ANSER0Q0QggkBLWl9tl0Tbf6MK9GjhL0UF1mmn/TmgHPQoyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739578698; c=relaxed/simple;
	bh=TdyTYKeT77DpDIxGEvjQLoaX7PdnoV60TAJgUdpAWAs=;
	h=Date:To:From:Subject:Message-Id; b=N8Ypv6v18/MGBIYO7UhskKbJYlbvMWBBHAv642SVENTZHiBSDmUiTvgzvMcbTJSk9TJbD93Cp/K4VOWnPF4AOgqaRR1GCpDxX8km3DCTx4IAePH7LSaEYba54Z6a2L1wdYM+SYS7o1rIxq3wQiKyIduDaEVHTDoPdXU5VyKFj+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WSG+Mmr9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WSG+Mmr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CB5C4CED1;
	Sat, 15 Feb 2025 00:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739578697;
	bh=TdyTYKeT77DpDIxGEvjQLoaX7PdnoV60TAJgUdpAWAs=;
	h=Date:To:From:Subject:From;
	b=WSG+Mmr9D6CrHPPNboBRNjwSjHZRLhC5v+6a976FLRCndA/fRhCtvvEAtO8BqgwLE
	 jAzSiec24/8nf6Zw+IEvqwBLVEbYNtpL7IyFUHGAIupDcwESddERR7tGYAyAYRpYC8
	 z+FRzUkDWESvUpySr2KxZG3wmEua3yuVO7nwDGHk=
Date: Fri, 14 Feb 2025 16:18:17 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-limit-max-recompress-prio-to-num_active_comps.patch added to mm-unstable branch
Message-Id: <20250215001817.A9CB5C4CED1@smtp.kernel.org>
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
Date: Fri, 14 Feb 2025 13:50:19 +0900

Use the actual number of algorithms zram was configure with instead of
theoretical limit of ZRAM_MAX_COMPS.

Also make sure that min prio is not above max prio.

Link: https://lkml.kernel.org/r/20250214045208.1388854-8-senozhatsky@chromium.org
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
@@ -2068,16 +2068,19 @@ static ssize_t recompress_store(struct d
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
@@ -2130,7 +2133,7 @@ static ssize_t recompress_store(struct d
 			if (prio == ZRAM_PRIMARY_COMP)
 				prio = ZRAM_SECONDARY_COMP;
 
-			prio_max = min(prio + 1, ZRAM_MAX_COMPS);
+			prio_max = prio + 1;
 			continue;
 		}
 	}
@@ -2158,7 +2161,7 @@ static ssize_t recompress_store(struct d
 				continue;
 
 			if (!strcmp(zram->comp_algs[prio], algo)) {
-				prio_max = min(prio + 1, ZRAM_MAX_COMPS);
+				prio_max = prio + 1;
 				found = true;
 				break;
 			}
@@ -2170,6 +2173,12 @@ static ssize_t recompress_store(struct d
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
zram-remove-two-staged-handle-allocation.patch
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


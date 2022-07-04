Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56087C43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbiGDBKi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbiGDBKI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:10:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23A06315
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56305B80BD1
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:09:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4095C341C7;
        Mon,  4 Jul 2022 01:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656896998;
        bh=G9gaHzj7Esjfydq/OukYmTgJGifw0g6Wp+SLwzsvXLQ=;
        h=Date:To:From:Subject:From;
        b=SgrY1Gs8TtgWQCxNBMJRDxii6474VWmH49d6wdrnSVJkMzp4s1pqYNOfNxDd0c9eI
         sfmLHarl4I1KXPmeIsep+Xvm2z8m7+JKYJ0daR+bYJ60LYKovCSl/UodFbJ5d/SiRg
         sWGZm0u7yOt3bcatf4GNDmD+IV8A0MbTuhA+kykY=
Date:   Sun, 03 Jul 2022 18:09:57 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-schemes-add-lru_prio-damos-action.patch removed from -mm tree
Message-Id: <20220704010957.E4095C341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/schemes: add 'LRU_PRIO' DAMOS action
has been removed from the -mm tree.  Its filename was
     mm-damon-schemes-add-lru_prio-damos-action.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/schemes: add 'LRU_PRIO' DAMOS action
Date: Mon, 13 Jun 2022 19:22:56 +0000

This commit adds a new DAMOS action called 'LRU_PRIO' for the physical
address space.  The action prioritizes pages in the memory regions of the
user-specified target access pattern on their LRU lists.  This is hence
supposed to be used for frequently accessed (hot) memory regions so that
hot pages could be more likely protected under memory pressure. 
Internally, it simply calls 'mark_page_accessed()'.

Link: https://lkml.kernel.org/r/20220613192301.8817-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 +
 mm/damon/ops-common.c |   42 ++++++++++++++++++++++++++++++++++++++++
 mm/damon/ops-common.h |    2 +
 mm/damon/paddr.c      |   20 +++++++++++++++++++
 mm/damon/sysfs.c      |    1 
 5 files changed, 67 insertions(+)

--- a/include/linux/damon.h~mm-damon-schemes-add-lru_prio-damos-action
+++ a/include/linux/damon.h
@@ -86,6 +86,7 @@ struct damon_target {
  * @DAMOS_PAGEOUT:	Call ``madvise()`` for the region with MADV_PAGEOUT.
  * @DAMOS_HUGEPAGE:	Call ``madvise()`` for the region with MADV_HUGEPAGE.
  * @DAMOS_NOHUGEPAGE:	Call ``madvise()`` for the region with MADV_NOHUGEPAGE.
+ * @DAMOS_LRU_PRIO:	Prioritize the region on its LRU lists.
  * @DAMOS_STAT:		Do nothing but count the stat.
  * @NR_DAMOS_ACTIONS:	Total number of DAMOS actions
  */
@@ -95,6 +96,7 @@ enum damos_action {
 	DAMOS_PAGEOUT,
 	DAMOS_HUGEPAGE,
 	DAMOS_NOHUGEPAGE,
+	DAMOS_LRU_PRIO,
 	DAMOS_STAT,		/* Do nothing but only record the stat */
 	NR_DAMOS_ACTIONS,
 };
--- a/mm/damon/ops-common.c~mm-damon-schemes-add-lru_prio-damos-action
+++ a/mm/damon/ops-common.c
@@ -130,3 +130,45 @@ int damon_pageout_score(struct damon_ctx
 	/* Return coldness of the region */
 	return DAMOS_MAX_SCORE - hotness;
 }
+
+int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
+			struct damos *s)
+{
+	unsigned int max_nr_accesses;
+	int freq_subscore;
+	unsigned int age_in_sec;
+	int age_in_log, age_subscore;
+	unsigned int freq_weight = s->quota.weight_nr_accesses;
+	unsigned int age_weight = s->quota.weight_age;
+	int hotness;
+
+	max_nr_accesses = c->aggr_interval / c->sample_interval;
+	freq_subscore = r->nr_accesses * DAMON_MAX_SUBSCORE / max_nr_accesses;
+
+	age_in_sec = (unsigned long)r->age * c->aggr_interval / 1000000;
+	for (age_in_log = 0; age_in_log < DAMON_MAX_AGE_IN_LOG && age_in_sec;
+			age_in_log++, age_in_sec >>= 1)
+		;
+
+	/* If frequency is 0, higher age means it's colder */
+	if (freq_subscore == 0)
+		age_in_log *= -1;
+
+	/*
+	 * Now age_in_log is in [-DAMON_MAX_AGE_IN_LOG, DAMON_MAX_AGE_IN_LOG].
+	 * Scale it to be in [0, 100] and set it as age subscore.
+	 */
+	age_in_log += DAMON_MAX_AGE_IN_LOG;
+	age_subscore = age_in_log * DAMON_MAX_SUBSCORE /
+		DAMON_MAX_AGE_IN_LOG / 2;
+
+	hotness = (freq_weight * freq_subscore + age_weight * age_subscore);
+	if (freq_weight + age_weight)
+		hotness /= freq_weight + age_weight;
+	/*
+	 * Transform it to fit in [0, DAMOS_MAX_SCORE]
+	 */
+	hotness = hotness * DAMOS_MAX_SCORE / DAMON_MAX_SUBSCORE;
+
+	return hotness;
+}
--- a/mm/damon/ops-common.h~mm-damon-schemes-add-lru_prio-damos-action
+++ a/mm/damon/ops-common.h
@@ -14,3 +14,5 @@ void damon_pmdp_mkold(pmd_t *pmd, struct
 
 int damon_pageout_score(struct damon_ctx *c, struct damon_region *r,
 			struct damos *s);
+int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
+			struct damos *s);
--- a/mm/damon/paddr.c~mm-damon-schemes-add-lru_prio-damos-action
+++ a/mm/damon/paddr.c
@@ -233,6 +233,22 @@ static unsigned long damon_pa_pageout(st
 	return applied * PAGE_SIZE;
 }
 
+static unsigned long damon_pa_mark_accessed(struct damon_region *r)
+{
+	unsigned long addr, applied = 0;
+
+	for (addr = r->ar.start; addr < r->ar.end; addr += PAGE_SIZE) {
+		struct page *page = damon_get_page(PHYS_PFN(addr));
+
+		if (!page)
+			continue;
+		mark_page_accessed(page);
+		put_page(page);
+		applied++;
+	}
+	return applied * PAGE_SIZE;
+}
+
 static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
 		struct damon_target *t, struct damon_region *r,
 		struct damos *scheme)
@@ -240,6 +256,8 @@ static unsigned long damon_pa_apply_sche
 	switch (scheme->action) {
 	case DAMOS_PAGEOUT:
 		return damon_pa_pageout(r);
+	case DAMOS_LRU_PRIO:
+		return damon_pa_mark_accessed(r);
 	default:
 		break;
 	}
@@ -253,6 +271,8 @@ static int damon_pa_scheme_score(struct
 	switch (scheme->action) {
 	case DAMOS_PAGEOUT:
 		return damon_pageout_score(context, r, scheme);
+	case DAMOS_LRU_PRIO:
+		return damon_hot_score(context, r, scheme);
 	default:
 		break;
 	}
--- a/mm/damon/sysfs.c~mm-damon-schemes-add-lru_prio-damos-action
+++ a/mm/damon/sysfs.c
@@ -762,6 +762,7 @@ static const char * const damon_sysfs_da
 	"pageout",
 	"hugepage",
 	"nohugepage",
+	"lru_prio",
 	"stat",
 };
 
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-damon-sysfs-document-lru_prio-scheme-action.patch
mm-damon-schemes-add-lru_deprio-action.patch
docs-admin-guide-damon-sysfs-document-lru_deprio-scheme-action.patch
mm-damon-introduce-damon-based-lru-lists-sorting.patch
docs-admin-guide-damon-add-a-document-for-damon_lru_sort.patch


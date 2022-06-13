Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85B59CCA47D
	for <mm-commits@archiver.kernel.org>; Mon, 13 Jun 2022 20:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbiFMUlv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jun 2022 16:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245660AbiFMUlF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jun 2022 16:41:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1B96154
        for <mm-commits@vger.kernel.org>; Mon, 13 Jun 2022 12:40:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BE3561556
        for <mm-commits@vger.kernel.org>; Mon, 13 Jun 2022 19:40:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4FEC34114;
        Mon, 13 Jun 2022 19:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655149240;
        bh=58a3+eWf6wXxEVwKgIUPlbU31rtMggib/XhiQYVjjFs=;
        h=Date:To:From:Subject:From;
        b=O77oP5n86lO0rmSoPVx/BO+XhbTqHLd8acI96dunLEkJoLfz1ZYqSg6uDZxiJ7SJd
         NrU2BiQVemfbWK+zmTevwORInN5vAAI4fcNZPPPLdti8zkeFGM5r46d2/pEF47h+tA
         jdCxnTyoDWDlm6RVk8nsZnmb7Ag0M3clWWr2ePzo=
Date:   Mon, 13 Jun 2022 12:40:40 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-schemes-add-lru_prio-damos-action.patch added to mm-unstable branch
Message-Id: <20220613194040.CE4FEC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/schemes: add 'LRU_PRIO' DAMOS action
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-schemes-add-lru_prio-damos-action.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-schemes-add-lru_prio-damos-action.patch

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

mm-damon-reclaim-schedule-damon_reclaim_timer-only-after-system_wq-is-initialized.patch
docs-admin-guide-damon-reclaim-remove-a-paragraph-that-been-obsolete-due-to-online-tuning-support.patch
mm-damon-dbgfssysfs-move-target_has_pid-from-dbgfs-to-damonh.patch
mm-damon-reclaim-deduplicate-commit_inputs-handling.patch
mm-damon-sysfs-deduplicate-inputs-applying.patch
mm-damon-reclaim-make-enabled-checking-timer-simpler.patch
mm-damon-reclaim-add-damon_reclaim_-prefix-to-enabled_store.patch
mm-damon-dbgfs-add-and-use-mappings-between-schemes-action-inputs-and-damos_action-values.patch
mm-damon-paddr-use-a-separate-function-for-damos_pageout-handling.patch
mm-damon-schemes-add-lru_prio-damos-action.patch
docs-admin-guide-damon-sysfs-document-lru_prio-scheme-action.patch
mm-damon-schemes-add-lru_deprio-action.patch
docs-admin-guide-damon-sysfs-document-lru_deprio-scheme-action.patch
mm-damon-introduce-damon-based-lru-lists-sorting.patch
docs-admin-guide-damon-add-a-document-for-damon_lru_sort.patch


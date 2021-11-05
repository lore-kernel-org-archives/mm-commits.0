Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99654C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:47:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 841F261279
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233820AbhKEUuS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:50:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233712AbhKEUuS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:50:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4C3A60240;
        Fri,  5 Nov 2021 20:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145258;
        bh=iyLxisym76ZgZIlZBYxW8VfmRFVonZ+VSUjI5fXd/G0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JW0EZ9rEk6hhtJMoxcvtn8x0LkrdIhD5zGWj4qwRGJvnoqCBn9vdrYCC0VA0HECUs
         bgvMOoz/6pIBCKtQkFK7hiybw+kkR5haxji8BJDKRy843ts88C6867uDcWbQCHCQpA
         El2wr9qGB+DagfB2Vjf9hYS22dRbbnIIICGPkyQs=
Date:   Fri, 05 Nov 2021 13:47:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, amit@kernel.org,
        benh@kernel.crashing.org, corbet@lwn.net, david@redhat.com,
        dwmw@amazon.com, elver@google.com, foersleo@amazon.de,
        gthelen@google.com, Jonathan.Cameron@huawei.com,
        linux-mm@kvack.org, markubo@amazon.de, mm-commits@vger.kernel.org,
        rientjes@google.com, shakeelb@google.com, shuah@kernel.org,
        sj@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 246/262] mm/damon/vaddr,paddr: support pageout
 prioritization
Message-ID: <20211105204737.OyQNtK_57%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/vaddr,paddr: support pageout prioritization

This commit makes the default monitoring primitives for virtual address
spaces and the physical address sapce to support memory regions
prioritization for 'PAGEOUT' DAMOS action.  It calculates hotness of each
region as weighted sum of 'nr_accesses' and 'age' of the region and get
the priority score as reverse of the hotness, so that cold regions can be
paged out first.

Link: https://lkml.kernel.org/r/20211019150731.16699-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Amit Shah <amit@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: David Woodhouse <dwmw@amazon.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Leonard Foerster <foersleo@amazon.de>
Cc: Marco Elver <elver@google.com>
Cc: Markus Boehme <markubo@amazon.de>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h   |    4 +++
 mm/damon/paddr.c        |   14 +++++++++++
 mm/damon/prmtv-common.c |   46 ++++++++++++++++++++++++++++++++++++++
 mm/damon/prmtv-common.h |    3 ++
 mm/damon/vaddr.c        |   15 ++++++++++++
 5 files changed, 82 insertions(+)

--- a/include/linux/damon.h~mm-damon-vaddrpaddr-support-pageout-prioritization
+++ a/include/linux/damon.h
@@ -421,6 +421,8 @@ bool damon_va_target_valid(void *t);
 void damon_va_cleanup(struct damon_ctx *ctx);
 int damon_va_apply_scheme(struct damon_ctx *context, struct damon_target *t,
 		struct damon_region *r, struct damos *scheme);
+int damon_va_scheme_score(struct damon_ctx *context, struct damon_target *t,
+		struct damon_region *r, struct damos *scheme);
 void damon_va_set_primitives(struct damon_ctx *ctx);
 
 #endif	/* CONFIG_DAMON_VADDR */
@@ -433,6 +435,8 @@ unsigned int damon_pa_check_accesses(str
 bool damon_pa_target_valid(void *t);
 int damon_pa_apply_scheme(struct damon_ctx *context, struct damon_target *t,
 		struct damon_region *r, struct damos *scheme);
+int damon_pa_scheme_score(struct damon_ctx *context, struct damon_target *t,
+		struct damon_region *r, struct damos *scheme);
 void damon_pa_set_primitives(struct damon_ctx *ctx);
 
 #endif	/* CONFIG_DAMON_PADDR */
--- a/mm/damon/paddr.c~mm-damon-vaddrpaddr-support-pageout-prioritization
+++ a/mm/damon/paddr.c
@@ -246,6 +246,19 @@ int damon_pa_apply_scheme(struct damon_c
 	return 0;
 }
 
+int damon_pa_scheme_score(struct damon_ctx *context, struct damon_target *t,
+		struct damon_region *r, struct damos *scheme)
+{
+	switch (scheme->action) {
+	case DAMOS_PAGEOUT:
+		return damon_pageout_score(context, r, scheme);
+	default:
+		break;
+	}
+
+	return DAMOS_MAX_SCORE;
+}
+
 void damon_pa_set_primitives(struct damon_ctx *ctx)
 {
 	ctx->primitive.init = NULL;
@@ -256,4 +269,5 @@ void damon_pa_set_primitives(struct damo
 	ctx->primitive.target_valid = damon_pa_target_valid;
 	ctx->primitive.cleanup = NULL;
 	ctx->primitive.apply_scheme = damon_pa_apply_scheme;
+	ctx->primitive.get_scheme_score = damon_pa_scheme_score;
 }
--- a/mm/damon/prmtv-common.c~mm-damon-vaddrpaddr-support-pageout-prioritization
+++ a/mm/damon/prmtv-common.c
@@ -85,3 +85,49 @@ void damon_pmdp_mkold(pmd_t *pmd, struct
 	put_page(page);
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 }
+
+#define DAMON_MAX_SUBSCORE	(100)
+#define DAMON_MAX_AGE_IN_LOG	(32)
+
+int damon_pageout_score(struct damon_ctx *c, struct damon_region *r,
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
+	/* Return coldness of the region */
+	return DAMOS_MAX_SCORE - hotness;
+}
--- a/mm/damon/prmtv-common.h~mm-damon-vaddrpaddr-support-pageout-prioritization
+++ a/mm/damon/prmtv-common.h
@@ -15,3 +15,6 @@ struct page *damon_get_page(unsigned lon
 
 void damon_ptep_mkold(pte_t *pte, struct mm_struct *mm, unsigned long addr);
 void damon_pmdp_mkold(pmd_t *pmd, struct mm_struct *mm, unsigned long addr);
+
+int damon_pageout_score(struct damon_ctx *c, struct damon_region *r,
+			struct damos *s);
--- a/mm/damon/vaddr.c~mm-damon-vaddrpaddr-support-pageout-prioritization
+++ a/mm/damon/vaddr.c
@@ -633,6 +633,20 @@ int damon_va_apply_scheme(struct damon_c
 	return damos_madvise(t, r, madv_action);
 }
 
+int damon_va_scheme_score(struct damon_ctx *context, struct damon_target *t,
+		struct damon_region *r, struct damos *scheme)
+{
+
+	switch (scheme->action) {
+	case DAMOS_PAGEOUT:
+		return damon_pageout_score(context, r, scheme);
+	default:
+		break;
+	}
+
+	return DAMOS_MAX_SCORE;
+}
+
 void damon_va_set_primitives(struct damon_ctx *ctx)
 {
 	ctx->primitive.init = damon_va_init;
@@ -643,6 +657,7 @@ void damon_va_set_primitives(struct damo
 	ctx->primitive.target_valid = damon_va_target_valid;
 	ctx->primitive.cleanup = NULL;
 	ctx->primitive.apply_scheme = damon_va_apply_scheme;
+	ctx->primitive.get_scheme_score = damon_va_scheme_score;
 }
 
 #include "vaddr-test.h"
_

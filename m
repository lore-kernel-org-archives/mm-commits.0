Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CF27C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 21:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 152EF608FE
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 21:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhJSVeP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Oct 2021 17:34:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229643AbhJSVeO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Oct 2021 17:34:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3F846101A;
        Tue, 19 Oct 2021 21:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634679121;
        bh=f0ws044DNJeLesBX+p7iavrmR0O17HMvO0SvBk8DP/4=;
        h=Date:From:To:Subject:From;
        b=t0E/cnZwt2XmdtF/ZhCieYgL01Bj1ehrY+K0fuaMh0lxBm8W+tWDlI6LVPgGZ8O4x
         0YDSvjycTzOuKdpu5SZkq8hEUPw4G4mFsFmIXu1fbeCy6iDMJZXJFSnz/Y2gjkeu++
         +9l/eSUjZhDCByibe3Pdk35r1jSmunDrQTzp2Ves=
Date:   Tue, 19 Oct 2021 14:32:00 -0700
From:   akpm@linux-foundation.org
To:     amit@kernel.org, benh@kernel.crashing.org, corbet@lwn.net,
        david@redhat.com, dwmw@amazon.com, elver@google.com,
        foersleo@amazon.de, gthelen@google.com,
        Jonathan.Cameron@huawei.com, markubo@amazon.de,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, shuah@kernel.org, sj@kernel.org
Subject:  +
 mm-damon-vaddrpaddr-support-pageout-prioritization.patch added to -mm tree
Message-ID: <20211019213200.9VNrgs0xS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/vaddr,paddr: support pageout prioritization
has been added to the -mm tree.  Its filename is
     mm-damon-vaddrpaddr-support-pageout-prioritization.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-vaddrpaddr-support-pageout-prioritization.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-vaddrpaddr-support-pageout-prioritization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -431,6 +433,8 @@ void damon_va_set_primitives(struct damo
 void damon_pa_prepare_access_checks(struct damon_ctx *ctx);
 unsigned int damon_pa_check_accesses(struct damon_ctx *ctx);
 bool damon_pa_target_valid(void *t);
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

Patches currently in -mm which might be from sj@kernel.org are

maintainers-update-seongjaes-email-address.patch
mm-damon-core-print-kdamond-start-log-in-debug-mode-only.patch
mm-damon-core-account-age-of-target-regions.patch
mm-damon-core-implement-damon-based-operation-schemes-damos.patch
mm-damon-vaddr-support-damon-based-operation-schemes.patch
mm-damon-dbgfs-support-damon-based-operation-schemes.patch
mm-damon-schemes-implement-statistics-feature.patch
selftests-damon-add-schemes-debugfs-tests.patch
docs-admin-guide-mm-damon-document-damon-based-operation-schemes.patch
mm-damon-dbgfs-allow-users-to-set-initial-monitoring-target-regions.patch
mm-damon-dbgfs-test-add-a-unit-test-case-for-init_regions.patch
docs-admin-guide-mm-damon-document-init_regions-feature.patch
mm-damon-vaddr-separate-commonly-usable-functions.patch
mm-damon-vaddr-separate-commonly-usable-functions-fix.patch
mm-damon-implement-primitives-for-physical-address-space-monitoring.patch
mm-damon-dbgfs-support-physical-memory-monitoring.patch
docs-damon-document-physical-memory-monitoring-support.patch
mm-damon-paddr-support-the-pageout-scheme.patch
mm-damon-schemes-implement-size-quota-for-schemes-application-speed-control.patch
mm-damon-schemes-skip-already-charged-targets-and-regions.patch
mm-damon-schemes-implement-time-quota.patch
mm-damon-dbgfs-support-quotas-of-schemes.patch
mm-damon-selftests-support-schemes-quotas.patch
mm-damon-schemes-prioritize-regions-within-the-quotas.patch
mm-damon-vaddrpaddr-support-pageout-prioritization.patch
mm-damon-dbgfs-support-prioritization-weights.patch
tools-selftests-damon-update-for-regions-prioritization-of-schemes.patch
mm-damon-schemes-activate-schemes-based-on-a-watermarks-mechanism.patch
mm-damon-dbgfs-support-watermarks.patch
selftests-damon-support-watermarks.patch
mm-damon-introduce-damon-based-reclamation-damon_reclaim.patch
documentation-admin-guide-mm-damon-add-a-document-for-damon_reclaim.patch


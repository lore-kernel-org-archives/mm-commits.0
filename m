Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D83BC6FA8A
	for <mm-commits@archiver.kernel.org>; Tue, 13 Sep 2022 21:53:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiIMVxf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Sep 2022 17:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiIMVxe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2022 17:53:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1831A6D9FF
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 14:53:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5C19B810F4
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 21:53:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2A6C433C1;
        Tue, 13 Sep 2022 21:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663106010;
        bh=qEZuRPRq8NK5IQJEUzfDfqam5ANnJCTT7fU5OCWIFak=;
        h=Date:To:From:Subject:From;
        b=y/2cSpQOU3dDGIzn9edtEb2B2vpgGrXEnw2GeS+tjJXbss9CF4gAmCl2WYhy+up5T
         IrFpGSQV3wDwsKQaA04doii7wqHgdaE5CmNhvPVenxiVEDbA4RPMteRDSbs6X9AK7f
         1uIK84e93ifqq/PUPL8Os2rWmcdWliNJZWZNjG2M=
Date:   Tue, 13 Sep 2022 14:53:29 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-copy-struct-to-struct-instead-of-field-to-field-in-damon_new_scheme.patch added to mm-unstable branch
Message-Id: <20220913215330.6C2A6C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: copy struct-to-struct instead of field-to-field in damon_new_scheme()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-copy-struct-to-struct-instead-of-field-to-field-in-damon_new_scheme.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-copy-struct-to-struct-instead-of-field-to-field-in-damon_new_scheme.patch

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
Subject: mm/damon/core: copy struct-to-struct instead of field-to-field in damon_new_scheme()
Date: Tue, 13 Sep 2022 17:44:30 +0000

The function for new 'struct damos' creation, 'damon_new_scheme()', copies
each field of the struct one by one, though it could simply copied via
struct to struct.  This commit replaces the unnecessarily verbose
field-to-field copies with struct-to-struct copies to make code simple and
short.

Link: https://lkml.kernel.org/r/20220913174449.50645-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-copy-struct-to-struct-instead-of-field-to-field-in-damon_new_scheme
+++ a/mm/damon/core.c
@@ -266,22 +266,13 @@ struct damos *damon_new_scheme(struct da
 	scheme = kmalloc(sizeof(*scheme), GFP_KERNEL);
 	if (!scheme)
 		return NULL;
-	scheme->pattern.min_sz_region = pattern->min_sz_region;
-	scheme->pattern.max_sz_region = pattern->max_sz_region;
-	scheme->pattern.min_nr_accesses = pattern->min_nr_accesses;
-	scheme->pattern.max_nr_accesses = pattern->max_nr_accesses;
-	scheme->pattern.min_age_region = pattern->min_age_region;
-	scheme->pattern.max_age_region = pattern->max_age_region;
+	scheme->pattern = *pattern;
 	scheme->action = action;
 	scheme->stat = (struct damos_stat){};
 	INIT_LIST_HEAD(&scheme->list);
 
-	scheme->quota.ms = quota->ms;
-	scheme->quota.sz = quota->sz;
-	scheme->quota.reset_interval = quota->reset_interval;
-	scheme->quota.weight_sz = quota->weight_sz;
-	scheme->quota.weight_nr_accesses = quota->weight_nr_accesses;
-	scheme->quota.weight_age = quota->weight_age;
+	scheme->quota = *quota;
+	/* caller might not zero-initialized the private fileds */
 	scheme->quota.total_charged_sz = 0;
 	scheme->quota.total_charged_ns = 0;
 	scheme->quota.esz = 0;
@@ -290,11 +281,7 @@ struct damos *damon_new_scheme(struct da
 	scheme->quota.charge_target_from = NULL;
 	scheme->quota.charge_addr_from = 0;
 
-	scheme->wmarks.metric = wmarks->metric;
-	scheme->wmarks.interval = wmarks->interval;
-	scheme->wmarks.high = wmarks->high;
-	scheme->wmarks.mid = wmarks->mid;
-	scheme->wmarks.low = wmarks->low;
+	scheme->wmarks = *wmarks;
 	scheme->wmarks.activated = true;
 
 	return scheme;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix.patch
selftest-damon-add-a-test-for-duplicate-context-dirs-creation.patch
mm-damon-core-avoid-holes-in-newly-set-monitoring-target-ranges.patch
mm-damon-core-test-test-damon_set_regions.patch
docs-admin-guide-mm-damon-rename-the-title-of-the-document.patch
mm-damon-kconfig-notify-debugfs-deprecation-plan.patch
docs-admin-guide-mm-damon-start-mention-the-dependency-as-sysfs-instead-of-debugfs.patch
docs-admin-guide-mm-damon-usage-note-damon-debugfs-interface-deprecation-plan.patch
mm-damon-paddr-make-supported-damos-actions-of-paddr-clear.patch
mm-damon-paddr-deduplicate-damon_pa_mark_accesseddeactivate_pages.patch
mm-damon-core-copy-struct-to-struct-instead-of-field-to-field-in-damon_new_scheme.patch
mm-damon-core-factor-out-damos_quota-private-fileds-initialization.patch
mm-damon-core-use-a-dedicated-struct-for-monitoring-attributes.patch
mm-damon-core-reduce-parameters-for-damon_set_attrs.patch
mm-damon-reclaim-use-struct-damon_attrs-for-storing-parameters-for-it.patch
mm-damon-lru_sort-use-struct-damon_attrs-for-storing-parameters-for-it.patch
mm-damon-implement-a-monitoring-attributes-module-parameters-generator-macro.patch
mm-damon-lru_sort-use-monitoring-attributes-parameters-generaotr-macro.patch
mm-damon-reclaim-use-monitoring-attributes-parameters-generator-macro.patch
mm-damon-modules-common-implement-a-watermarks-module-parameters-generator-macro.patch
mm-damon-lru_sort-use-watermarks-parameters-generator-macro.patch
mm-damon-reclaim-use-watermarks-parameters-generator-macro.patch
mm-damon-modules-common-implement-a-stats-parameters-generator-macro.patch
mm-damon-reclaim-use-stat-parameters-generator.patch
mm-damon-lru_sort-use-stat-generator.patch
mm-damon-modules-common-implement-a-damos-quota-params-generator.patch
mm-damon-modules-common-implement-damos-time-quota-params-generator.patch
mm-damon-reclaim-use-the-quota-params-generator-macro.patch
mm-damon-lru_sort-use-quotas-param-generator.patch
mm-damon-lru_sort-deduplicate-hot-cold-schemes-generators.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F041FC54EE9
	for <mm-commits@archiver.kernel.org>; Tue, 13 Sep 2022 21:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiIMVya (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Sep 2022 17:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiIMVyI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2022 17:54:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04DD46E2CF
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 14:54:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6774B810EA
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 21:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF29C433D6;
        Tue, 13 Sep 2022 21:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663106044;
        bh=R687mn8JzfvcnzfseGGExQO34rc34QN6Pk7YTJ/4qos=;
        h=Date:To:From:Subject:From;
        b=jih4zm/wXKV1l65Q7gTONejZoFw34dq1O5PZ9Mvp4AeqIpVGjJ55qBrC7lY4xgIKt
         mAJ1EzVe/eRsA121lWt4cEOG6FlBVSH7EemruU1KHuo3YYp7PLKRmSj/wBwht/uCF7
         a/dy/uf6utqiJQG2a9cOhHtjdFmuchTJDAdCuM88=
Date:   Tue, 13 Sep 2022 14:54:03 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-modules-common-implement-a-damos-quota-params-generator.patch added to mm-unstable branch
Message-Id: <20220913215404.5EF29C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/modules-common: implement a damos quota params generator
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-modules-common-implement-a-damos-quota-params-generator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-modules-common-implement-a-damos-quota-params-generator.patch

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
Subject: mm/damon/modules-common: implement a damos quota params generator
Date: Tue, 13 Sep 2022 17:44:45 +0000

DAMON_RECLAIM and DAMON_LRU_SORT have module parameters for DAMOS quotas
that having same names.  This commit implements a macro for generating
such module parameters so that we can reuse later.

Link: https://lkml.kernel.org/r/20220913174449.50645-19-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/modules-common.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/damon/modules-common.h~mm-damon-modules-common-implement-a-damos-quota-params-generator
+++ a/mm/damon/modules-common.h
@@ -17,6 +17,12 @@
 	module_param_named(max_nr_regions, attrs.max_nr_regions, ulong,	\
 			0600);
 
+#define DEFINE_DAMON_MODULES_DAMOS_QUOTAS(quota)			\
+	module_param_named(quota_ms, quota.ms, ulong, 0600);		\
+	module_param_named(quota_sz, quota.sz, ulong, 0600);		\
+	module_param_named(quota_reset_interval_ms,			\
+			quota.reset_interval, ulong, 0600);
+
 #define DEFINE_DAMON_MODULES_WMARKS_PARAMS(wmarks)			\
 	module_param_named(wmarks_interval, wmarks.interval, ulong,	\
 			0600);						\
@@ -33,5 +39,5 @@
 			0400);						\
 	module_param_named(bytes_##succ_name, stat.sz_applied, ulong,	\
 			0400);						\
-	module_param_named(qt_exceed_name, stat.qt_exceeds, ulong,	\
+	module_param_named(nr_##qt_exceed_name, stat.qt_exceeds, ulong,	\
 			0400);
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


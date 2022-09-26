Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52E6EC32771
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 20:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbiIZU71 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 16:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbiIZU70 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 16:59:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D49BA0331
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 13:59:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 391BD612D7
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 20:59:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB09C433C1;
        Mon, 26 Sep 2022 20:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664225964;
        bh=a2lL2wVtuyfyH4sFcMoSo3TECCeQOIvM/4O+7jDRLFE=;
        h=Date:To:From:Subject:From;
        b=IqgeDiFSZMr8lWyRb+xVe1DduwBtf+WYG9ECCRrTzi6yfEV/fQahly6XfeeAYtQDg
         wlGEAqjQS6wZ7Yf59M4jQgo0AiC2JrBocT4YYvSk54EkdMeuKKOjO6KkmGhNH0uH+H
         /c2H9t8qUpKGUdG5OyQpKddtzdaIyL1V8qx63U5M=
Date:   Mon, 26 Sep 2022 13:59:23 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        weixugc@google.com, tim.c.chen@intel.com, shy828301@gmail.com,
        mhocko@kernel.org, jvgediya.oss@gmail.com,
        Jonathan.Cameron@huawei.com, hesham.almatary@huawei.com,
        hannes@cmpxchg.org, dave@stgolabs.net, dave.hansen@intel.com,
        dan.j.williams@intel.com, bharata@amd.com, apopple@nvidia.com,
        aneesh.kumar@linux.ibm.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix.patch removed from -mm tree
Message-Id: <20220926205924.8AB09C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kernel/sched/fair: include missed header file, memory-tiers.h
has been removed from the -mm tree.  Its filename was
     mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix.patch

This patch was dropped because it was folded into mm-demotion-update-node_is_toptier-to-work-with-memory-tiers.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: kernel/sched/fair: include missed header file, memory-tiers.h
Date: Sat, 20 Aug 2022 19:07:20 +0000

Commit f66f3c261487 ("mm/demotion: update node_is_toptier to work with
memory tiers") of the 'mm-unstable' tree moved the declaration of
'node_is_toptier()' from 'node.h' to 'memory-tiers.h' but didn't include
the header in a source file using the function, 'kernel/sched/fair.c'.
As a result, build fails as below:

    linux/kernel/sched/fair.c: In function `should_numa_migrate_memory':
    linux/kernel/sched/fair.c:1571:7: error: implicit declaration of function `node_is_toptier' [-Werror=implicit-function-declaration]
     1571 |      !node_is_toptier(src_nid)) {
          |       ^~~~~~~~~~~~~~~
    cc1: some warnings being treated as errors

This commit fixes the error by including the missed header file.

Link: https://lkml.kernel.org/r/20220820190720.248704-1-sj@kernel.org
Fixes: f66f3c261487 ("mm/demotion: update node_is_toptier to work with memory tiers") on mm-unstable
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hesham Almatary <hesham.almatary@huawei.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jagdish Gediya <jvgediya.oss@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/fair.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/sched/fair.c~mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix
+++ a/kernel/sched/fair.c
@@ -40,6 +40,7 @@
 
 #include <linux/cpuidle.h>
 #include <linux/interrupt.h>
+#include <linux/memory-tiers.h>
 #include <linux/mempolicy.h>
 #include <linux/mutex_api.h>
 #include <linux/profile.h>
_

Patches currently in -mm which might be from sj@kernel.org are

mm-demotion-update-node_is_toptier-to-work-with-memory-tiers.patch
selftest-damon-add-a-test-for-duplicate-context-dirs-creation.patch
mm-damon-core-avoid-holes-in-newly-set-monitoring-target-ranges.patch
mm-damon-core-avoid-holes-in-newly-set-monitoring-target-ranges-fix.patch
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


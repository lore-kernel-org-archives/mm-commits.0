Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13FFFECAAD8
	for <mm-commits@archiver.kernel.org>; Tue, 13 Sep 2022 21:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiIMVyN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Sep 2022 17:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiIMVyC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2022 17:54:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572BF6E2C9
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 14:53:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7E0061589
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 21:53:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6DDC433C1;
        Tue, 13 Sep 2022 21:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663106038;
        bh=TOH2DnDbXflBUh4ule4svX/Q1+5tb7J1hhpQGWaCVSc=;
        h=Date:To:From:Subject:From;
        b=cfH6jilA9YhrNqatSXsZmo8KYiSVo/1DcFqTq5/W6k4jjopme4j+8UEQKNa0ha2X/
         9hfoIZGOPMJ589pTj3Oy6HOeeH5SXk/YjGHnI/hxYj0aCzADjqUqCPvJ8sblyca6jV
         4PtKVrGNhkALQI2tAyVqlJWk749ta4MpwSfOzYdU=
Date:   Tue, 13 Sep 2022 14:53:57 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-modules-common-implement-a-stats-parameters-generator-macro.patch added to mm-unstable branch
Message-Id: <20220913215358.3A6DDC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/modules-common: implement a stats parameters generator macro
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-modules-common-implement-a-stats-parameters-generator-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-modules-common-implement-a-stats-parameters-generator-macro.patch

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
Subject: mm/damon/modules-common: implement a stats parameters generator macro
Date: Tue, 13 Sep 2022 17:44:42 +0000

DAMON_RECLAIM and DAMON_LRU_SORT have module parameters for DAMOS
statistics that having same names.  This commit implements a macro for
generating such module parameters so that we can reuse later.

Link: https://lkml.kernel.org/r/20220913174449.50645-16-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/modules-common.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/damon/modules-common.h~mm-damon-modules-common-implement-a-stats-parameters-generator-macro
+++ a/mm/damon/modules-common.h
@@ -23,3 +23,15 @@
 	module_param_named(wmarks_high, wmarks.high, ulong, 0600);	\
 	module_param_named(wmarks_mid, wmarks.mid, ulong, 0600);	\
 	module_param_named(wmarks_low, wmarks.low, ulong, 0600);
+
+#define DEFINE_DAMON_MODULES_DAMOS_STATS_PARAMS(stat, try_name,		\
+		succ_name, qt_exceed_name)				\
+	module_param_named(nr_##try_name, stat.nr_tried, ulong, 0400);	\
+	module_param_named(bytes_##try_name, stat.sz_tried, ulong,	\
+			0400);						\
+	module_param_named(nr_##succ_name, stat.nr_applied, ulong,	\
+			0400);						\
+	module_param_named(bytes_##succ_name, stat.sz_applied, ulong,	\
+			0400);						\
+	module_param_named(qt_exceed_name, stat.qt_exceeds, ulong,	\
+			0400);
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


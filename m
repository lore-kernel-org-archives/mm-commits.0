Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57168ECAAD8
	for <mm-commits@archiver.kernel.org>; Tue, 13 Sep 2022 21:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiIMVxm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Sep 2022 17:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiIMVxg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2022 17:53:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7336DAD0
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 14:53:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A524CB810EE
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 21:53:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5985EC433C1;
        Tue, 13 Sep 2022 21:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663106012;
        bh=rooBnIGo2Znhr+JI/cpJLEImLBZAWKf7ImKiVATgktQ=;
        h=Date:To:From:Subject:From;
        b=zayeMsFNV+rjXPA1BoT/ncHDYD8n1jWIe8THtXfe6DDHEXBChePNrz5Vc3kEoU6hh
         V8hZ5RYhE2Kh6TI7Jhtzmo8ca7PIlxfuw3OcpeTtcLmPwf9NCaKxyg7rzSd1Kir3Z8
         yN/7aFZVI1H8azDcTFj0r7cgWTMWwG3LgoXIk6ck=
Date:   Tue, 13 Sep 2022 14:53:31 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-factor-out-damos_quota-private-fileds-initialization.patch added to mm-unstable branch
Message-Id: <20220913215332.5985EC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: factor out 'damos_quota' private fileds initialization
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-factor-out-damos_quota-private-fileds-initialization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-factor-out-damos_quota-private-fileds-initialization.patch

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
Subject: mm/damon/core: factor out 'damos_quota' private fileds initialization
Date: Tue, 13 Sep 2022 17:44:31 +0000

The 'struct damos' creation function, 'damon_new_scheme()', does
initialization of private fileds of 'struct damos_quota' in it.  As its
verbose and makes the function unnecessarily long, this commit factors it
out to separate function.

Link: https://lkml.kernel.org/r/20220913174449.50645-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-factor-out-damos_quota-private-fileds-initialization
+++ a/mm/damon/core.c
@@ -257,6 +257,19 @@ int damon_set_regions(struct damon_targe
 	return 0;
 }
 
+/* initialize private fields of damos_quota and return the pointer */
+static struct damos_quota *damos_quota_init_priv(struct damos_quota *quota)
+{
+	quota->total_charged_sz = 0;
+	quota->total_charged_ns = 0;
+	quota->esz = 0;
+	quota->charged_sz = 0;
+	quota->charged_from = 0;
+	quota->charge_target_from = NULL;
+	quota->charge_addr_from = 0;
+	return quota;
+}
+
 struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
 			enum damos_action action, struct damos_quota *quota,
 			struct damos_watermarks *wmarks)
@@ -271,15 +284,7 @@ struct damos *damon_new_scheme(struct da
 	scheme->stat = (struct damos_stat){};
 	INIT_LIST_HEAD(&scheme->list);
 
-	scheme->quota = *quota;
-	/* caller might not zero-initialized the private fileds */
-	scheme->quota.total_charged_sz = 0;
-	scheme->quota.total_charged_ns = 0;
-	scheme->quota.esz = 0;
-	scheme->quota.charged_sz = 0;
-	scheme->quota.charged_from = 0;
-	scheme->quota.charge_target_from = NULL;
-	scheme->quota.charge_addr_from = 0;
+	scheme->quota = *(damos_quota_init_priv(quota));
 
 	scheme->wmarks = *wmarks;
 	scheme->wmarks.activated = true;
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


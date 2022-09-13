Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3597C54EE9
	for <mm-commits@archiver.kernel.org>; Tue, 13 Sep 2022 22:07:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbiIMWHZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Sep 2022 18:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiIMWHX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2022 18:07:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCA774B9E
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 15:07:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EA4E61595
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 22:07:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E654CC433C1;
        Tue, 13 Sep 2022 22:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663106842;
        bh=ouHHQOGuYAGaOPQbpu8p0bmD2YiUsyD82sOmmlshUi0=;
        h=Date:To:From:Subject:From;
        b=fcWEINNT/mkxrv6ZCZqw29GRel9i9tnBT5IxrJ07ZwVMUBwVUXFZ5T87woDQggKFK
         oQdDT4ei29yZ5Zhhkbgg2FGJbivj2EkvaI4i/2/azv+OKoUuxn0wMoF/xj9NJDwwAq
         nhV+Hm7vbUfiq+8pMd2ZHPmTqqdcxXuuCK48EPLk=
Date:   Tue, 13 Sep 2022 15:07:21 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-avoid-holes-in-newly-set-monitoring-target-ranges-fix.patch added to mm-unstable branch
Message-Id: <20220913220721.E654CC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: handle error from 'damon_fill_regions_holes()'
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-avoid-holes-in-newly-set-monitoring-target-ranges-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-avoid-holes-in-newly-set-monitoring-target-ranges-fix.patch

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
Subject: mm/damon/core: handle error from 'damon_fill_regions_holes()'
Date: Tue, 13 Sep 2022 21:54:20 +0000

Commit 91fc6af21c61 ("mm/damon/core: avoid holes in newly set monitoring
target ranges") in mm-unstable tree introduces
'damon_fill_regions_holes()', which does not check failures of
'damon_new_region()' call, so NULL dereferencing is available.  This
commit fixes the issue by checking failure of the function and returning
an error code.

Link: https://lkml.kernel.org/r/20220913215420.57761-1-sj@kernel.org
Fixes: 91fc6af21c61 ("mm/damon/core: avoid holes in newly set monitoring target ranges") in mm-unstable
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Coverity Static Analyzer CID 1524904
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-avoid-holes-in-newly-set-monitoring-target-ranges-fix
+++ a/mm/damon/core.c
@@ -171,7 +171,7 @@ static bool damon_intersect(struct damon
 /*
  * Fill holes in regions with new regions.
  */
-static void damon_fill_regions_holes(struct damon_region *first,
+static int damon_fill_regions_holes(struct damon_region *first,
 		struct damon_region *last, struct damon_target *t)
 {
 	struct damon_region *r = first;
@@ -184,9 +184,12 @@ static void damon_fill_regions_holes(str
 		next = damon_next_region(r);
 		if (r->ar.end != next->ar.start) {
 			newr = damon_new_region(r->ar.end, next->ar.start);
+			if (!newr)
+				return -ENOMEM;
 			damon_insert_region(newr, r, next, t);
 		}
 	}
+	return 0;
 }
 
 /*
@@ -205,6 +208,7 @@ int damon_set_regions(struct damon_targe
 {
 	struct damon_region *r, *next;
 	unsigned int i;
+	int err;
 
 	/* Remove regions which are not in the new ranges */
 	damon_for_each_region_safe(r, next, t) {
@@ -249,7 +253,9 @@ int damon_set_regions(struct damon_targe
 			last->ar.end = ALIGN(range->end, DAMON_MIN_REGION);
 
 			/* fill possible holes in the range */
-			damon_fill_regions_holes(first, last, t);
+			err = damon_fill_regions_holes(first, last, t);
+			if (err)
+				return err;
 		}
 	}
 	return 0;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix.patch
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


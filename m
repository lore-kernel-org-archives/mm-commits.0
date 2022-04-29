Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3007C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 16:26:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377207AbiD2Q30 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 12:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379063AbiD2Q3T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 12:29:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C717FD557C
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 09:26:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64300622A9
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 16:26:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA6FC385B1;
        Fri, 29 Apr 2022 16:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651249559;
        bh=fGhBRgK+xJiv8AllOcIRW7CWuWub/EbtNT4B2x4xyzA=;
        h=Date:To:From:Subject:From;
        b=wxJKjSORYpD0wrU5TfdX4GGExh5GHgQSEpCDUlJgJGG37hnAwsXh3brej7jTUhpBl
         rBfZB8nNw7xieilgFNl4maMguktiKiIBA2ccuokKuJFufwzyoiz/Ez8jHPb/Zm23SW
         TwnOoRRJTY90thhgSOYOIChSdIX3hrw4vBkzC4D8=
Date:   Fri, 29 Apr 2022 09:25:59 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-remove-damon_va_apply_three_regions.patch added to mm-unstable branch
Message-Id: <20220429162559.ABA6FC385B1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/vaddr: remove damon_va_apply_three_regions()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-vaddr-remove-damon_va_apply_three_regions.patch

This patch should soon appear in the mm-unstable branch at
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
Subject: mm/damon/vaddr: remove damon_va_apply_three_regions()

'damon_va_apply_three_regions()' is just a wrapper of its general version,
'damon_set_regions()'.  This commit replaces the wrapper calls to directly
call the general version.

Link: https://lkml.kernel.org/r/20220429160606.127307-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr-test.h |    6 +++---
 mm/damon/vaddr.c      |   18 +-----------------
 2 files changed, 4 insertions(+), 20 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-remove-damon_va_apply_three_regions
+++ a/mm/damon/vaddr.c
@@ -282,22 +282,6 @@ static void damon_va_init(struct damon_c
 }
 
 /*
- * Functions for the dynamic monitoring target regions update
- */
-
-/*
- * Update damon regions for the three big regions of the given target
- *
- * t		the given target
- * bregions	the three big regions of the target
- */
-static void damon_va_apply_three_regions(struct damon_target *t,
-		struct damon_addr_range bregions[3])
-{
-	damon_set_regions(t, bregions, 3);
-}
-
-/*
  * Update regions for current memory mappings
  */
 static void damon_va_update(struct damon_ctx *ctx)
@@ -308,7 +292,7 @@ static void damon_va_update(struct damon
 	damon_for_each_target(t, ctx) {
 		if (damon_va_three_regions(t, three_regions))
 			continue;
-		damon_va_apply_three_regions(t, three_regions);
+		damon_set_regions(t, three_regions, 3);
 	}
 }
 
--- a/mm/damon/vaddr-test.h~mm-damon-vaddr-remove-damon_va_apply_three_regions
+++ a/mm/damon/vaddr-test.h
@@ -109,7 +109,7 @@ static struct damon_region *__nth_region
 }
 
 /*
- * Test 'damon_va_apply_three_regions()'
+ * Test 'damon_set_regions()'
  *
  * test			kunit object
  * regions		an array containing start/end addresses of current
@@ -124,7 +124,7 @@ static struct damon_region *__nth_region
  * the change, DAMON periodically reads the mappings, simplifies it to the
  * three regions, and updates the monitoring target regions to fit in the three
  * regions.  The update of current target regions is the role of
- * 'damon_va_apply_three_regions()'.
+ * 'damon_set_regions()'.
  *
  * This test passes the given target regions and the new three regions that
  * need to be applied to the function and check whether it updates the regions
@@ -145,7 +145,7 @@ static void damon_do_test_apply_three_re
 		damon_add_region(r, t);
 	}
 
-	damon_va_apply_three_regions(t, three_regions);
+	damon_set_regions(t, three_regions, 3);
 
 	for (i = 0; i < nr_expected / 2; i++) {
 		r = __nth_region_of(t, i);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-test-add-a-kunit-test-case-for-ops-registration.patch
mm-damon-core-add-a-function-for-damon_operations-registration-checks.patch
mm-damon-sysfs-add-a-file-for-listing-available-monitoring-ops.patch
selftets-damon-sysfs-test-existence-and-permission-of-avail_operations.patch
docs-abiadmin-guide-damon-document-avail_operations-sysfs-file.patch
mm-damon-vaddr-register-a-damon_operations-for-fixed-virtual-address-ranges-monitoring.patch
mm-damon-sysfs-support-fixed-virtual-address-ranges-monitoring.patch
docs-abiadmin-guide-damon-update-for-fixed-virtual-address-ranges-monitoring.patch
mm-damon-core-add-a-new-callback-for-watermarks-checks.patch
mm-damon-core-finish-kdamond-as-soon-as-any-callback-returns-an-error.patch
mm-damon-vaddr-generalize-damon_va_apply_three_regions.patch
mm-damon-vaddr-move-damon_set_regions-to-core.patch
mm-damon-vaddr-remove-damon_va_apply_three_regions.patch
mm-damon-sysfs-prohibit-multiple-physical-address-space-monitoring-targets.patch
mm-damon-sysfs-move-targets-setup-code-to-a-separated-function.patch
mm-damon-sysfs-reuse-damon_set_regions-for-regions-setting.patch
mm-damon-sysfs-use-enum-for-state-input-handling.patch
mm-damon-sysfs-update-schemes-stat-in-the-kdamond-context.patch
mm-damon-sysfs-support-online-inputs-update.patch
docs-abiadmin-guide-damon-update-for-state-sysfs-file-input-keyword-commit.patch
mm-damon-reclaim-support-online-inputs-update.patch
docs-admin-guide-mm-damon-reclaim-document-commit_inputs-parameter.patch


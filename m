Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDBDAC2BA1A
	for <mm-commits@archiver.kernel.org>; Sat, 16 Sep 2023 20:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbjIPUSb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 16 Sep 2023 16:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233681AbjIPUSN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 16 Sep 2023 16:18:13 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF2DCDA
        for <mm-commits@vger.kernel.org>; Sat, 16 Sep 2023 13:18:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF97C433C7;
        Sat, 16 Sep 2023 20:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694895487;
        bh=IF8OQcrmEGousZ3ihk/0z03+cYjHzhxA9ztugozPUcE=;
        h=Date:To:From:Subject:From;
        b=LDhIkGPlac1iwc3zP5wfyaxGGNLKVgf7oGfmfR+Y8HtC7pl2f7KE99eUqT2P9/+gZ
         nhA4OqVfugR8OqTi08j2/P4yrI183D64S5ZN+NBTn9D/P0G+zRm6XoYcjvru+oDh/8
         SvjtA+wkhowiQDVNhS/ws4BTtW5vv5cB+J2q6yxE=
Date:   Sat, 16 Sep 2023 13:18:07 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, rostedt@goodmis.org,
        corbet@lwn.net, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-use-nr_accesses_bp-as-the-source-of-tried_regions-n-nr_accesses.patch added to mm-unstable branch
Message-Id: <20230916201807.CFF97C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs-schemes: use nr_accesses_bp as the source of tried_regions/<N>/nr_accesses
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-use-nr_accesses_bp-as-the-source-of-tried_regions-n-nr_accesses.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-use-nr_accesses_bp-as-the-source-of-tried_regions-n-nr_accesses.patch

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
Subject: mm/damon/sysfs-schemes: use nr_accesses_bp as the source of tried_regions/<N>/nr_accesses
Date: Sat, 16 Sep 2023 02:09:38 +0000

DAMON sysfs interface exposes access rate of each region via DAMOS tried
regions directory.  For this, the nr_accesses field of the region is used.
DAMOS was actually using nr_accesses in the past, but it uses
nr_accesses_bp now.  Use the value that it is really using as the source.

Note that this doesn't expose nr_accesses_bp as is (in basis point), but
after converting it to the natural number by dividing the value by 10,000.
Hence there is no behavioral change from users' perspective.

Link: https://lkml.kernel.org/r/20230916020945.47296-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-use-nr_accesses_bp-as-the-source-of-tried_regions-n-nr_accesses
+++ a/mm/damon/sysfs-schemes.c
@@ -31,7 +31,7 @@ static struct damon_sysfs_scheme_region
 		return NULL;
 	sysfs_region->kobj = (struct kobject){};
 	sysfs_region->ar = region->ar;
-	sysfs_region->nr_accesses = region->nr_accesses;
+	sysfs_region->nr_accesses = region->nr_accesses_bp / 10000;
 	sysfs_region->age = region->age;
 	INIT_LIST_HEAD(&sysfs_region->list);
 	return sysfs_region;
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-mm-damon-usage-fixup-missed-ref-keyword.patch
docs-admin-guide-mm-damon-usage-place-debugfs-usage-at-the-bottom.patch
docs-admin-guide-mm-damon-usage-move-debugfs-intro-to-the-bottom-of-the-section.patch
docs-mm-damon-design-explicitly-introduce-nr_accesses.patch
docs-admin-guide-mm-damon-usage-explain-the-format-of-damon_aggregate-tracepoint.patch
docs-mm-damon-design-add-a-section-for-kdamond-and-damon-context.patch
docs-admin-guide-mm-damon-usage-link-design-doc-for-details-of-kdamond-and-context.patch
mm-damon-core-fix-a-comment-about-damon_set_attrs-call-timings.patch
mm-damon-core-add-more-comments-for-nr_accesses.patch
mm-damon-core-remove-duplicated-comment-for-watermarks-based-deactivation.patch
mm-damon-core-remove-struct-target-parameter-from-damon_aggregated-tracepoint.patch
mm-damon-core-add-a-tracepoint-for-damos-apply-target-regions.patch
docs-admin-guide-mm-damon-usage-document-damos_before_apply-tracepoint.patch
mm-damon-core-use-number-of-passed-access-sampling-as-a-timer.patch
mm-damon-core-define-and-use-a-dedicated-function-for-region-access-rate-update.patch
mm-damon-vaddr-call-damon_update_region_access_rate-always.patch
mm-damon-core-implement-a-pseudo-moving-sum-function.patch
mm-damon-core-test-add-a-unit-test-for-damon_moving_sum.patch
mm-damon-core-introduce-nr_accesses_bp.patch
mm-damon-core-use-pseudo-moving-sum-for-nr_accesses_bp.patch
mm-damon-core-skip-updating-nr_accesses_bp-for-each-aggregation-interval.patch
mm-damon-core-mark-damon_moving_sum-as-a-static-function.patch
mm-damon-core-make-damos-uses-nr_accesses_bp-instead-of-nr_accesses.patch
mm-damon-sysfs-schemes-use-nr_accesses_bp-as-the-source-of-tried_regions-n-nr_accesses.patch
mm-damon-core-use-nr_accesses_bp-as-a-source-of-damos_before_apply-tracepoint.patch
mm-damon-core-implement-scheme-specific-apply-interval.patch
docs-mm-damon-design-document-damos-apply-intervals.patch
mm-damon-sysfs-schemes-support-damos-apply-interval.patch
selftests-damon-sysfs-test-damos-apply-intervals.patch
docs-admin-guide-mm-damon-usage-update-for-damos-apply-intervals.patch
docs-abi-damon-update-for-damos-apply-intervals.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F56CEED61C
	for <mm-commits@archiver.kernel.org>; Fri, 15 Sep 2023 16:37:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234789AbjIOQhQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Sep 2023 12:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235142AbjIOQgu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Sep 2023 12:36:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE3A619A9
        for <mm-commits@vger.kernel.org>; Fri, 15 Sep 2023 09:36:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45589C433C8;
        Fri, 15 Sep 2023 16:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694795805;
        bh=zMDtCYHA3cv3PAVWMtu0kXrL4apm5IrIIvIrS3pUXBQ=;
        h=Date:To:From:Subject:From;
        b=mjMDhKzAtDSDU1EKGRMYKAkQ53A6dvwt+UnyUddj+15IvpNkMsoXv4P4fSxLX9iKv
         +WyhCW37WtRqGlGMpPLC1Ep7xceR7x8ksxua4z6b3E0mhCIC3xXJloTg4bdZOLf2oH
         3xbKfR97Sej1U7Z92plWo3R2FRqcfZf0IVzCsoiI=
Date:   Fri, 15 Sep 2023 09:36:44 -0700
To:     mm-commits@vger.kernel.org, brendanhiggins@google.com,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-mark-damon_moving_sum-as-a-static-function.patch added to mm-unstable branch
Message-Id: <20230915163645.45589C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: mark damon_moving_sum() as a static function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-mark-damon_moving_sum-as-a-static-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-mark-damon_moving_sum-as-a-static-function.patch

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
Subject: mm/damon/core: mark damon_moving_sum() as a static function
Date: Fri, 15 Sep 2023 02:52:51 +0000

The function is used by only mm/damon/core.c.  Mark it as a static
function.

Link: https://lkml.kernel.org/r/20230915025251.72816-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 --
 mm/damon/core.c       |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-mark-damon_moving_sum-as-a-static-function
+++ a/include/linux/damon.h
@@ -632,8 +632,6 @@ void damon_add_region(struct damon_regio
 void damon_destroy_region(struct damon_region *r, struct damon_target *t);
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges);
-unsigned int damon_moving_sum(unsigned int mvsum, unsigned int nomvsum,
-		unsigned int len_window, unsigned int new_value);
 void damon_update_region_access_rate(struct damon_region *r, bool accessed,
 		struct damon_attrs *attrs);
 
--- a/mm/damon/core.c~mm-damon-core-mark-damon_moving_sum-as-a-static-function
+++ a/mm/damon/core.c
@@ -1587,7 +1587,7 @@ int damon_set_region_biggest_system_ram_
  *
  * Return: Pseudo-moving average after getting the @new_value.
  */
-unsigned int damon_moving_sum(unsigned int mvsum, unsigned int nomvsum,
+static unsigned int damon_moving_sum(unsigned int mvsum, unsigned int nomvsum,
 		unsigned int len_window, unsigned int new_value)
 {
 	return mvsum - nomvsum / len_window + new_value;
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


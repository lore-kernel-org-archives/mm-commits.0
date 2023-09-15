Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A68AEED619
	for <mm-commits@archiver.kernel.org>; Fri, 15 Sep 2023 16:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234847AbjIOQgo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Sep 2023 12:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235051AbjIOQgi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Sep 2023 12:36:38 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 650D3AC
        for <mm-commits@vger.kernel.org>; Fri, 15 Sep 2023 09:36:33 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0093EC433C8;
        Fri, 15 Sep 2023 16:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694795793;
        bh=1d2mp3MSrKtQpkI2tAHLoZHCTY4Y0QYL0PYQKsJllm8=;
        h=Date:To:From:Subject:From;
        b=s9nqkFVHC++2DoTAo/MG8Suo534YW6kM4refyYlgsdm6WlTUH7HN1TdJwUcEeEL4T
         EvVXuWYfppY2DC8N5f/uX4O917X0NflqwRsx9D81p7MoJXYhA8WOL7LQWqbProCGHk
         a64d5peOz7QX7KW8MSpMj0dep0NWdjre6VGqnhKg=
Date:   Fri, 15 Sep 2023 09:36:32 -0700
To:     mm-commits@vger.kernel.org, brendanhiggins@google.com,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-call-damon_update_region_access_rate-always.patch added to mm-unstable branch
Message-Id: <20230915163633.0093EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/vaddr: call damon_update_region_access_rate() always
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-vaddr-call-damon_update_region_access_rate-always.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-call-damon_update_region_access_rate-always.patch

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
Subject: mm/damon/vaddr: call damon_update_region_access_rate() always
Date: Fri, 15 Sep 2023 02:52:45 +0000

When getting mm_struct of the monitoring target process fails, there wil
be no need to increase the access rate counter (nr_accesses) of the
regions for the process.  Hence, damon_va_check_accesses() skips calling
damon_update_region_access_rate() in the case.  This breaks the assumption
that damon_update_region_access_rate() is called for every region, for
every sampling interval.  Call the function for every region even in the
case.  This might increase the overhead in some cases, but such case would
not be frequent, so no significant impact is really expected.

Link: https://lkml.kernel.org/r/20230915025251.72816-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-call-damon_update_region_access_rate-always
+++ a/mm/damon/vaddr.c
@@ -563,6 +563,11 @@ static void __damon_va_check_access(stru
 	static unsigned long last_folio_sz = PAGE_SIZE;
 	static bool last_accessed;
 
+	if (!mm) {
+		damon_update_region_access_rate(r, false);
+		return;
+	}
+
 	/* If the region is in the last checked page, reuse the result */
 	if (same_target && (ALIGN_DOWN(last_addr, last_folio_sz) ==
 				ALIGN_DOWN(r->sampling_addr, last_folio_sz))) {
@@ -586,15 +591,14 @@ static unsigned int damon_va_check_acces
 
 	damon_for_each_target(t, ctx) {
 		mm = damon_get_mm(t);
-		if (!mm)
-			continue;
 		same_target = false;
 		damon_for_each_region(r, t) {
 			__damon_va_check_access(mm, r, same_target);
 			max_nr_accesses = max(r->nr_accesses, max_nr_accesses);
 			same_target = true;
 		}
-		mmput(mm);
+		if (mm)
+			mmput(mm);
 	}
 
 	return max_nr_accesses;
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


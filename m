Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C1D0C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 29 Dec 2021 23:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbhL2XVp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Dec 2021 18:21:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59222 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232759AbhL2XVp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Dec 2021 18:21:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67D9761579
        for <mm-commits@vger.kernel.org>; Wed, 29 Dec 2021 23:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB9BC36AE9;
        Wed, 29 Dec 2021 23:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640820104;
        bh=sL/ngFYyJKAg7LJPgFOx8Ryu86x2432C9LfY9A6tAUU=;
        h=Date:From:To:Subject:From;
        b=TXOR1mjjY8tBjjzw7odg3xNCSKLiTYDYckVpf1zrDvALmKbXECOR200pl2e8Oi+2R
         vnEP16iY1ekwkMe/DPrCCUTFWM8lNrDD3MDNSHPLR/DgytzEqpuhnGs+aAW0j+tqYD
         3jiRlww71wBzXO17+xfcmS6IUU2AIvqM5YwcgEtY=
Date:   Wed, 29 Dec 2021 15:21:45 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org
Subject:  +
 mm-damon-vaddr-use-pr_debug-for-damon_va_three_regions-failure-logging.patch
 added to -mm tree
Message-ID: <20211229232145.hjZwj%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/vaddr: use pr_debug() for damon_va_three_regions() failure logging
has been added to the -mm tree.  Its filename is
     mm-damon-vaddr-use-pr_debug-for-damon_va_three_regions-failure-logging.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-vaddr-use-pr_debug-for-damon_va_three_regions-failure-logging.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-vaddr-use-pr_debug-for-damon_va_three_regions-failure-logging.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/vaddr: use pr_debug() for damon_va_three_regions() failure logging

Failure of 'damon_va_three_regions()' is logged using 'pr_err()'.  But,
the function can fail in legal situations.  To avoid making users be
surprised and to keep the kernel clean, this commit makes the log to be
printed using 'pr_debug()'.

Link: https://lkml.kernel.org/r/20211229131016.23641-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-use-pr_debug-for-damon_va_three_regions-failure-logging
+++ a/mm/damon/vaddr.c
@@ -238,7 +238,7 @@ static void __damon_va_init_regions(stru
 	int i;
 
 	if (damon_va_three_regions(t, regions)) {
-		pr_err("Failed to get three regions of target %lu\n", t->id);
+		pr_debug("Failed to get three regions of target %lu\n", t->id);
 		return;
 	}
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix.patch
mm-damon-convert-macro-functions-to-static-inline-functions.patch
docs-admin-guide-mm-damon-usage-update-for-scheme-quotas-and-watermarks.patch
docs-admin-guide-mm-damon-usage-remove-redundant-information.patch
docs-admin-guide-mm-damon-usage-mention-tracepoint-at-the-beginning.patch
docs-admin-guide-mm-damon-usage-update-for-kdamond_pid-and-mkrm_contexts.patch
mm-damon-remove-a-mistakenly-added-comment-for-a-future-feature.patch
mm-damon-schemes-account-scheme-actions-that-successfully-applied.patch
mm-damon-schemes-account-how-many-times-quota-limit-has-exceeded.patch
mm-damon-reclaim-provide-reclamation-statistics.patch
docs-admin-guide-mm-damon-reclaim-document-statistics-parameters.patch
mm-damon-dbgfs-support-all-damos-stats.patch
docs-admin-guide-mm-damon-usage-update-for-schemes-statistics.patch
mm-damon-dbgfs-remove-a-unnecessary-variable.patch
mm-damon-vaddr-use-pr_debug-for-damon_va_three_regions-failure-logging.patch
mm-damon-vaddr-hide-kernel-pointer-from-damon_va_three_regions-failure-log.patch
mm-damon-hide-kernel-pointer-from-tracepoint-event.patch


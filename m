Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4136C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Dec 2021 16:50:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244171AbhLJQyL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Dec 2021 11:54:11 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:60018 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244194AbhLJQyJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Dec 2021 11:54:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B1B1FCE2C28
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 16:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5B4C00446;
        Fri, 10 Dec 2021 16:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639155030;
        bh=8jrm1UjVjzrjLblHviFkoB98rH+U5tnxoFJPnyK94no=;
        h=Date:From:To:Subject:From;
        b=jH1pgBCzK6MvwNUAbTD4z1UkaTzRupgHB2+miG9l8+lViXAvapBqMTkKwj4X8UgKZ
         /yqhqzsQKeFzdh6Cg7te78gMaCq4PUD6v3qrP58YxIDX4gh+oX5YEgevQS0eUIpt5s
         1F9LTgnf+IkHdkcs9cuiRjQMSv4blTwboOpnzqYA=
Date:   Fri, 10 Dec 2021 08:50:30 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org
Subject:  +
 docs-admin-guide-mm-damon-usage-update-for-schemes-statistics.patch added
 to -mm tree
Message-ID: <20211210165030.UHH0utDD2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update for schemes statistics
has been added to the -mm tree.  Its filename is
     docs-admin-guide-mm-damon-usage-update-for-schemes-statistics.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/docs-admin-guide-mm-damon-usage-update-for-schemes-statistics.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/docs-admin-guide-mm-damon-usage-update-for-schemes-statistics.patch

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
Subject: Docs/admin-guide/mm/damon/usage: update for schemes statistics

This commit updates DAMON debugfs interface for statistics of schemes
successfully applied regions and time/space quota limit exceeds counts.

Link: https://lkml.kernel.org/r/20211210150016.35349-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-for-schemes-statistics
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -223,12 +223,13 @@ is activated.
 Statistics
 ~~~~~~~~~~
 
-It also counts the total number and bytes of regions that each scheme is
-applied.  This statistics can be used for online analysis or tuning of the
-schemes.
+It also counts the total number and bytes of regions that each scheme is tried
+to be applied, the two numbers for the regions that each scheme is successfully
+applied, and the total number of the quota limit exceeds.  This statistics can
+be used for online analysis or tuning of the schemes.
 
 The statistics can be shown by reading the ``schemes`` file.  Reading the file
-will show each scheme you entered in each line, and the two numbers for the
+will show each scheme you entered in each line, and the five numbers for the
 statistics will be added at the end of each line.
 
 Example
_

Patches currently in -mm which might be from sj@kernel.org are

timers-implement-usleep_idle_range.patch
mm-damon-core-fix-fake-load-reports-due-to-uninterruptible-sleeps.patch
mm-damon-core-use-better-timer-mechanisms-selection-threshold.patch
mm-damon-dbgfs-remove-an-unnecessary-error-message.patch
mm-damon-core-remove-unnecessary-error-messages.patch
mm-damon-vaddr-remove-an-unnecessary-warning-message.patch
mm-damon-vaddr-test-split-a-test-function-having-1024-bytes-frame-size.patch
mm-damon-vaddr-test-remove-unnecessary-variables.patch
selftests-damon-skip-test-if-damon-is-running.patch
selftests-damon-test-damon-enabling-with-empty-target_ids-case.patch
selftests-damon-test-wrong-damos-condition-ranges-input.patch
selftests-damon-test-debugfs-file-reads-writes-with-huge-count.patch
selftests-damon-split-test-cases.patch
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


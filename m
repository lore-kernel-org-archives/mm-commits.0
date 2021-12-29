Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6EB2C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 29 Dec 2021 23:21:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbhL2XVt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Dec 2021 18:21:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47220 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232759AbhL2XVt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Dec 2021 18:21:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36F3BB81985
        for <mm-commits@vger.kernel.org>; Wed, 29 Dec 2021 23:21:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE71C36AEA;
        Wed, 29 Dec 2021 23:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640820106;
        bh=snVvlQC0MPi10OyRLoP0HKHSfggVGRE0mWONEWecAAU=;
        h=Date:From:To:Subject:From;
        b=anbSE0Lz2/fZIzd9eYY/ZdolP4yXApfZvps9jsXrFb2vqMCqAijALWfYvh5gMpJXi
         C6NY7zS7MQ6JrT6DZ4G6OEgzJGX6VokUFgm0cLE9LgTxWI0/+PpxKQvJDIQeBAUmh6
         fkBFA6rA17ZAu6oBbI5eAre/9GX/xTqAlJsUtXgQ=
Date:   Wed, 29 Dec 2021 15:21:47 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org
Subject:  +
 =?us-ascii?Q?mm-damon-vaddr-hide-kernel-pointer-from-damon=5Fva=5Fthr?=
 =?us-ascii?Q?ee=5Fregions-failure-log.patch?= added to -mm tree
Message-ID: <20211229232147.pjCJj%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/vaddr: hide kernel pointer from damon_va_three_regions() failure log
has been added to the -mm tree.  Its filename is
     mm-damon-vaddr-hide-kernel-pointer-from-damon_va_three_regions-failure-log.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-vaddr-hide-kernel-pointer-from-damon_va_three_regions-failure-log.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-vaddr-hide-kernel-pointer-from-damon_va_three_regions-failure-log.patch

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
Subject: mm/damon/vaddr: hide kernel pointer from damon_va_three_regions() failure log

The failure log message for 'damon_va_three_regions()' prints the target
id, which is a 'struct pid' pointer in the case.  To avoid exposing the
kernel pointer via the log, this commit makes the log to use the index of
the target in the context's targets list instead.

Link: https://lkml.kernel.org/r/20211229131016.23641-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-hide-kernel-pointer-from-damon_va_three_regions-failure-log
+++ a/mm/damon/vaddr.c
@@ -232,13 +232,19 @@ static int damon_va_three_regions(struct
 static void __damon_va_init_regions(struct damon_ctx *ctx,
 				     struct damon_target *t)
 {
+	struct damon_target *ti;
 	struct damon_region *r;
 	struct damon_addr_range regions[3];
 	unsigned long sz = 0, nr_pieces;
-	int i;
+	int i, tidx = 0;
 
 	if (damon_va_three_regions(t, regions)) {
-		pr_debug("Failed to get three regions of target %lu\n", t->id);
+		damon_for_each_target(ti, ctx) {
+			if (ti == t)
+				break;
+			tidx++;
+		}
+		pr_debug("Failed to get three regions of %dth target\n", tidx);
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


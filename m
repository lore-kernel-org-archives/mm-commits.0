Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9298ECDB474
	for <mm-commits@archiver.kernel.org>; Fri, 20 Oct 2023 17:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjJTRSu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Oct 2023 13:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjJTRSu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Oct 2023 13:18:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477E0A3;
        Fri, 20 Oct 2023 10:18:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6EEAC433C7;
        Fri, 20 Oct 2023 17:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697822327;
        bh=QAjNN0bCu/hgiA6kDpt0CE8GUJR8wSW7cNvulRSHR8Q=;
        h=Date:To:From:Subject:From;
        b=MeTz0CSVzuljBxPFVQYH+lbbQJc+e447iWGOWF0NTbYdvXEwXz+rd9YzXTlYYElcH
         n8UYPKz6dQxX8n+7V4bt//TQKQsBQ5XJUuOSCvDDmEYrp3WyPnn5j451IQlrAGeKXH
         U7gPfc8Cc3DgqnAPvPdSS58VcWeJWdgflD9dQraw=
Date:   Fri, 20 Oct 2023 10:18:47 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-implement-a-function-for-max-nr_accesses-safe-calculation.patch added to mm-hotfixes-unstable branch
Message-Id: <20231020171847.C6EEAC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: implement a function for max nr_accesses safe calculation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-implement-a-function-for-max-nr_accesses-safe-calculation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-implement-a-function-for-max-nr_accesses-safe-calculation.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm/damon: implement a function for max nr_accesses safe calculation
Date: Thu, 19 Oct 2023 19:49:20 +0000

Patch series "avoid divide-by-zero due to max_nr_accesses overflow".

The maximum nr_accesses of given DAMON context can be calculated by
dividing the aggregation interval by the sampling interval.  Some logics
in DAMON uses the maximum nr_accesses as a divisor.  Hence, the value
shouldn't be zero.  Such case is avoided since DAMON avoids setting the
agregation interval as samller than the sampling interval.  However, since
nr_accesses is unsigned int while the intervals are unsigned long, the
maximum nr_accesses could be zero while casting.

Avoid the divide-by-zero by implementing a function that handles the
corner case (first patch), and replaces the vulnerable direct max
nr_accesses calculations (remaining patches).

Note that the patches for the replacements are divided for broken commits,
to make backporting on required tres easier.  Especially, the last patch
is for a patch that not yet merged into the mainline but in mm tree.


This patch (of 4):

The maximum nr_accesses of given DAMON context can be calculated by
dividing the aggregation interval by the sampling interval.  Some logics
in DAMON uses the maximum nr_accesses as a divisor.  Hence, the value
shouldn't be zero.  Such case is avoided since DAMON avoids setting the
agregation interval as samller than the sampling interval.  However, since
nr_accesses is unsigned int while the intervals are unsigned long, the
maximum nr_accesses could be zero while casting.  Implement a function
that handles the corner case.

Note that this commit is not fixing the real issue since this is only
introducing the safe function that will replaces the problematic
divisions.  The replacements will be made by followup commits, to make
backporting on stable series easier.

Link: https://lkml.kernel.org/r/20231019194924.100347-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20231019194924.100347-2-sj@kernel.org
Fixes: 198f0f4c58b9 ("mm/damon/vaddr,paddr: support pageout prioritization")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[5.16+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/include/linux/damon.h~mm-damon-implement-a-function-for-max-nr_accesses-safe-calculation
+++ a/include/linux/damon.h
@@ -642,6 +642,13 @@ static inline bool damon_target_has_pid(
 	return ctx->ops.id == DAMON_OPS_VADDR || ctx->ops.id == DAMON_OPS_FVADDR;
 }
 
+static inline unsigned int damon_max_nr_accesses(const struct damon_attrs *attrs)
+{
+	/* {aggr,sample}_interval are unsigned long, hence could overflow */
+	return min(attrs->aggr_interval / attrs->sample_interval,
+			(unsigned long)UINT_MAX);
+}
+
 
 int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive);
 int damon_stop(struct damon_ctx **ctxs, int nr_ctxs);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-implement-a-function-for-max-nr_accesses-safe-calculation.patch
mm-damon-core-avoid-divide-by-zero-during-monitoring-results-update.patch
mm-damon-ops-common-avoid-divide-by-zero-during-region-hotness-calculation.patch
mm-damon-lru_sort-avoid-divide-by-zero-in-hot-threshold-calculation.patch


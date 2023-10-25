Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B46BC0032E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235050AbjJYXvD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234999AbjJYXtd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:49:33 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E57C1700;
        Wed, 25 Oct 2023 16:49:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09EB9C433CA;
        Wed, 25 Oct 2023 23:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277754;
        bh=GwYfXA5tzoOCLLpThtBBCoI0RYf7i5nypn0un1JdwVQ=;
        h=Date:To:From:Subject:From;
        b=ZKZGevI8yrfkTx88Y7WnC5vBMY4Gdu6nsYTH/ZaEUkVaKfUCbKy1Qvtrvwn74jWsb
         iUYKpGuzfH633UKjCfiGjikdW6DHVO/cWX308UkPVEomrT3a3UvI/9QqGLAo+gg7lH
         hzTpooRsYU5I6NTX2CWQbauveNh3cmASHNS2Qn2Y=
Date:   Wed, 25 Oct 2023 16:49:13 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        acsjakub@amazon.de, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-implement-a-function-for-max-nr_accesses-safe-calculation.patch removed from -mm tree
Message-Id: <20231025234914.09EB9C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon: implement a function for max nr_accesses safe calculation
has been removed from the -mm tree.  Its filename was
     mm-damon-implement-a-function-for-max-nr_accesses-safe-calculation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reported-by: Jakub Acs <acsjakub@amazon.de>
Cc: <stable@vger.kernel.org>	[5.16+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/include/linux/damon.h~mm-damon-implement-a-function-for-max-nr_accesses-safe-calculation
+++ a/include/linux/damon.h
@@ -681,6 +681,13 @@ static inline bool damon_target_has_pid(
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

mm-damon-sysfs-remove-requested-targets-when-online-commit-inputs.patch


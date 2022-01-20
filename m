Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A8C7C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347599AbiATV2w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:28:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59106 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377899AbiATV2w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:28:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3CE3B81E69
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D688C340E0;
        Thu, 20 Jan 2022 21:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714129;
        bh=++cChmO9E6noGqiAqCR3i1Fl/I1d84ewm2k+j67YIJA=;
        h=Date:From:To:Subject:From;
        b=oLozHx/FuVxwhzUYJWMDmZc8yLaZldho2HRAwiNTgzILBJJdk6nEoQ6JlC1t6zvpK
         WR5KbLVS7gZqZE3wTQZanTqn2V+SjDM5y1/IjFH/7gcwm9F4HzrpPME2hXEugH9LVK
         5oGROoLyrRLx9B/A3GahIcb8x7TgYGBEu7VPrE0s=
Date:   Thu, 20 Jan 2022 13:28:49 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org
Subject:  [merged]
 mm-damon-schemes-account-how-many-times-quota-limit-has-exceeded.patch
 removed from -mm tree
Message-ID: <20220120212849.quSWr_206%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/schemes: account how many times quota limit has exceeded
has been removed from the -mm tree.  Its filename was
     mm-damon-schemes-account-how-many-times-quota-limit-has-exceeded.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/schemes: account how many times quota limit has exceeded

If the time/space quotas of a given DAMON-based operation scheme is too
small, the scheme could show unexpectedly slow progress.  However, there
is no good way to notice the case in runtime.  This commit extends the
DAMOS stat to provide how many times the quota limits exceeded so that the
users can easily notice the case and tune the scheme.

Link: https://lkml.kernel.org/r/20211210150016.35349-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 ++
 mm/damon/core.c       |    2 ++
 2 files changed, 4 insertions(+)

--- a/include/linux/damon.h~mm-damon-schemes-account-how-many-times-quota-limit-has-exceeded
+++ a/include/linux/damon.h
@@ -198,12 +198,14 @@ struct damos_watermarks {
  * @sz_tried:	Total size of regions that the scheme is tried to be applied.
  * @nr_applied:	Total number of regions that the scheme is applied.
  * @sz_applied:	Total size of regions that the scheme is applied.
+ * @qt_exceeds: Total number of times the quota of the scheme has exceeded.
  */
 struct damos_stat {
 	unsigned long nr_tried;
 	unsigned long sz_tried;
 	unsigned long nr_applied;
 	unsigned long sz_applied;
+	unsigned long qt_exceeds;
 };
 
 /**
--- a/mm/damon/core.c~mm-damon-schemes-account-how-many-times-quota-limit-has-exceeded
+++ a/mm/damon/core.c
@@ -693,6 +693,8 @@ static void kdamond_apply_schemes(struct
 		if (time_after_eq(jiffies, quota->charged_from +
 					msecs_to_jiffies(
 						quota->reset_interval))) {
+			if (quota->esz && quota->charged_sz >= quota->esz)
+				s->stat.qt_exceeds++;
 			quota->total_charged_sz += quota->charged_sz;
 			quota->charged_from = jiffies;
 			quota->charged_sz = 0;
_

Patches currently in -mm which might be from sj@kernel.org are



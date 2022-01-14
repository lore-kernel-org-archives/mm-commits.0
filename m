Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC6D8C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:10:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbiANWKY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiANWKX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:10:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C75C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:10:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DDD4B8262E
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0B9C36AE9;
        Fri, 14 Jan 2022 22:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198221;
        bh=CVm+MwUZ4sjp+DltbKcOTE15F9vbCL+4dpAHq0TNcEk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=t+JaDgjN4UbDdpbSbe9Kh4GrlJBfkEUUOPabyr6CvTBL+DF4PN5pe/tV5lStwXa18
         32IzEVjkaY3YTwUUuAlW2lp6cwYG970sDu9lVJQh/Cy7td9PEciOoUNvOiLup6M6P7
         3+UvW1SUi1k1VXlp9yCNwesmKCSG8zGgDV6tY6as=
Date:   Fri, 14 Jan 2022 14:10:20 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 136/146] mm/damon/schemes: account how many times
 quota limit has exceeded
Message-ID: <20220114221020.IMbqpzsPF%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

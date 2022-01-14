Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FDBAC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiANWKe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:10:34 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:38534 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiANWKd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:10:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B840DCE2497
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5E6C36AE9;
        Fri, 14 Jan 2022 22:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198230;
        bh=f7ebOWbgDygOOHI24vYnOZH5qj2LJ+FCPcXNn+80hAo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0hXGqa4fhLbkBmmE4Bin2do8gxX7DQxs4nIcMzj0Jpl3hy0OuCNkriK83uOxJjx1E
         JiR/vmiNGCrYIO1UE+Gs8BNDdJizQPnuqImDo+SUWoOpWCQAfogtW2/FkBuOlNKoqs
         EGFbCw+y3Uu+AK33Zp5uexBSXXzYmyA77cjrxUeY=
Date:   Fri, 14 Jan 2022 14:10:29 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 139/146] mm/damon/dbgfs: support all DAMOS stats
Message-ID: <20220114221029.jCyyux7ns%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/dbgfs: support all DAMOS stats

Currently, DAMON debugfs interface is not supporting DAMON-based Operation
Schemes (DAMOS) stats for schemes successfully applied regions and
time/space quota limit exceeds.  This commit adds the support.

Link: https://lkml.kernel.org/r/20211210150016.35349-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-support-all-damos-stats
+++ a/mm/damon/dbgfs.c
@@ -105,7 +105,7 @@ static ssize_t sprint_schemes(struct dam
 
 	damon_for_each_scheme(s, c) {
 		rc = scnprintf(&buf[written], len - written,
-				"%lu %lu %u %u %u %u %d %lu %lu %lu %u %u %u %d %lu %lu %lu %lu %lu %lu\n",
+				"%lu %lu %u %u %u %u %d %lu %lu %lu %u %u %u %d %lu %lu %lu %lu %lu %lu %lu %lu %lu\n",
 				s->min_sz_region, s->max_sz_region,
 				s->min_nr_accesses, s->max_nr_accesses,
 				s->min_age_region, s->max_age_region,
@@ -117,7 +117,9 @@ static ssize_t sprint_schemes(struct dam
 				s->quota.weight_age,
 				s->wmarks.metric, s->wmarks.interval,
 				s->wmarks.high, s->wmarks.mid, s->wmarks.low,
-				s->stat.nr_tried, s->stat.sz_tried);
+				s->stat.nr_tried, s->stat.sz_tried,
+				s->stat.nr_applied, s->stat.sz_applied,
+				s->stat.qt_exceeds);
 		if (!rc)
 			return -ENOMEM;
 
_

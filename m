Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68336C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347940AbiATV27 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:28:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347624AbiATV26 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:28:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F28C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:28:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02425B81E68
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A916C340E0;
        Thu, 20 Jan 2022 21:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714135;
        bh=0OgChKIZjhIqgYroHWYgFR1h/3DqC8fvb1NOz4vHkK8=;
        h=Date:From:To:Subject:From;
        b=wqp0aKZua3fm+caCosgzUN+Vh9KFmo4lMopodihCkkJOgN2Cmfh4UTMnXr6+asfi9
         xkZuz/AxG9iQFs5Vt4CDl3zyoD+286HmgLsewsvL3NbX1YBqCYpktOkXoWihxuA4My
         wkMkA+cWJJIolzxJaX7dnwaz4znIWS2lJ5KldVhk=
Date:   Thu, 20 Jan 2022 13:28:55 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org
Subject:  [merged] mm-damon-dbgfs-support-all-damos-stats.patch
 removed from -mm tree
Message-ID: <20220120212855.NhDRcUt_7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs: support all DAMOS stats
has been removed from the -mm tree.  Its filename was
     mm-damon-dbgfs-support-all-damos-stats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from sj@kernel.org are



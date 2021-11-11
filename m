Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2338C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1B2F61361
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbhKKCxC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:53:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:57018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234469AbhKKCxB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:53:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA61D60F26;
        Thu, 11 Nov 2021 02:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599013;
        bh=mNjXJPQjCoS10OMQj++8h5ru8fv+V7+7aqif6lxUKhA=;
        h=Date:From:To:Subject:From;
        b=p7GowwvasBjGmy2PBA8f7/pQJcBr75rVhvKrfKBB8jQ0YQaRDioHdarPp4xEuUC7C
         XQT0aSsDHy1s/yS1YKw1GOAWZJZ7lQGq35Wz8gczPjZeoHTW4b9aRzMQDfNwnGas0n
         2/gK/exj68ocPFXy3jcmF3p2KFVfoO6u8v8umMwQ=
Date:   Wed, 10 Nov 2021 18:50:12 -0800
From:   akpm@linux-foundation.org
To:     amit@kernel.org, benh@kernel.crashing.org, corbet@lwn.net,
        david@redhat.com, dwmw@amazon.com, elver@google.com,
        foersleo@amazon.de, gthelen@google.com,
        Jonathan.Cameron@huawei.com, markubo@amazon.de,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, shuah@kernel.org, sj@kernel.org
Subject:  [merged] mm-damon-dbgfs-support-watermarks.patch removed
 from -mm tree
Message-ID: <20211111025012.5vWwMzrdP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs: support watermarks
has been removed from the -mm tree.  Its filename was
     mm-damon-dbgfs-support-watermarks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/dbgfs: support watermarks

This commit updates DAMON debugfs interface to support the watermarks
based schemes activation.  For this, now 'schemes' file receives five more
values.

Link: https://lkml.kernel.org/r/20211019150731.16699-13-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Amit Shah <amit@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: David Woodhouse <dwmw@amazon.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Leonard Foerster <foersleo@amazon.de>
Cc: Marco Elver <elver@google.com>
Cc: Markus Boehme <markubo@amazon.de>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-support-watermarks
+++ a/mm/damon/dbgfs.c
@@ -105,7 +105,7 @@ static ssize_t sprint_schemes(struct dam
 
 	damon_for_each_scheme(s, c) {
 		rc = scnprintf(&buf[written], len - written,
-				"%lu %lu %u %u %u %u %d %lu %lu %lu %u %u %u %lu %lu\n",
+				"%lu %lu %u %u %u %u %d %lu %lu %lu %u %u %u %d %lu %lu %lu %lu %lu %lu\n",
 				s->min_sz_region, s->max_sz_region,
 				s->min_nr_accesses, s->max_nr_accesses,
 				s->min_age_region, s->max_age_region,
@@ -115,6 +115,8 @@ static ssize_t sprint_schemes(struct dam
 				s->quota.weight_sz,
 				s->quota.weight_nr_accesses,
 				s->quota.weight_age,
+				s->wmarks.metric, s->wmarks.interval,
+				s->wmarks.high, s->wmarks.mid, s->wmarks.low,
 				s->stat_count, s->stat_sz);
 		if (!rc)
 			return -ENOMEM;
@@ -195,18 +197,18 @@ static struct damos **str_to_schemes(con
 	*nr_schemes = 0;
 	while (pos < len && *nr_schemes < max_nr_schemes) {
 		struct damos_quota quota = {};
-		struct damos_watermarks wmarks = {
-			.metric = DAMOS_WMARK_NONE,
-		};
+		struct damos_watermarks wmarks;
 
 		ret = sscanf(&str[pos],
-				"%lu %lu %u %u %u %u %u %lu %lu %lu %u %u %u%n",
+				"%lu %lu %u %u %u %u %u %lu %lu %lu %u %u %u %u %lu %lu %lu %lu%n",
 				&min_sz, &max_sz, &min_nr_a, &max_nr_a,
 				&min_age, &max_age, &action, &quota.ms,
 				&quota.sz, &quota.reset_interval,
 				&quota.weight_sz, &quota.weight_nr_accesses,
-				&quota.weight_age, &parsed);
-		if (ret != 13)
+				&quota.weight_age, &wmarks.metric,
+				&wmarks.interval, &wmarks.high, &wmarks.mid,
+				&wmarks.low, &parsed);
+		if (ret != 18)
 			break;
 		if (!damos_action_valid(action)) {
 			pr_err("wrong action %d\n", action);
_

Patches currently in -mm which might be from sj@kernel.org are



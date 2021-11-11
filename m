Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 376E1C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:50:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 211AD6135E
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:50:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234490AbhKKCww (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:52:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:56904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234469AbhKKCww (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:52:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B33C2610A2;
        Thu, 11 Nov 2021 02:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599004;
        bh=3rI4ICAZ7zowKGBw+TdDO6rPj42Wj6rDayK8NchUN7E=;
        h=Date:From:To:Subject:From;
        b=Qct4z8fG1h8hcIwLOSqTRZkhRSO4HLkU34iT0+72U4Xn+bjgAnWvO1/l6hac15TtY
         W69tOc4YWomciqiI0Q7iHsxBfHlIOkjDfFdWY19Jj9qh7qRdbBcu9r+3QZzbhOftj2
         WOnp4XkkD/udeVNoxxOb6bs7dc/ciLFtx9wIxWPc=
Date:   Wed, 10 Nov 2021 18:50:03 -0800
From:   akpm@linux-foundation.org
To:     amit@kernel.org, benh@kernel.crashing.org, corbet@lwn.net,
        david@redhat.com, dwmw@amazon.com, elver@google.com,
        foersleo@amazon.de, gthelen@google.com,
        Jonathan.Cameron@huawei.com, markubo@amazon.de,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, shuah@kernel.org, sj@kernel.org
Subject:  [merged]
 mm-damon-dbgfs-support-prioritization-weights.patch removed from -mm tree
Message-ID: <20211111025003.mR5V550Gn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs: support prioritization weights
has been removed from the -mm tree.  Its filename was
     mm-damon-dbgfs-support-prioritization-weights.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/dbgfs: support prioritization weights

This commit allows DAMON debugfs interface users set the prioritization
weights by putting three more numbers to the 'schemes' file.

Link: https://lkml.kernel.org/r/20211019150731.16699-10-sj@kernel.org
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

 mm/damon/dbgfs.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-support-prioritization-weights
+++ a/mm/damon/dbgfs.c
@@ -105,13 +105,16 @@ static ssize_t sprint_schemes(struct dam
 
 	damon_for_each_scheme(s, c) {
 		rc = scnprintf(&buf[written], len - written,
-				"%lu %lu %u %u %u %u %d %lu %lu %lu %lu %lu\n",
+				"%lu %lu %u %u %u %u %d %lu %lu %lu %u %u %u %lu %lu\n",
 				s->min_sz_region, s->max_sz_region,
 				s->min_nr_accesses, s->max_nr_accesses,
 				s->min_age_region, s->max_age_region,
 				s->action,
 				s->quota.ms, s->quota.sz,
 				s->quota.reset_interval,
+				s->quota.weight_sz,
+				s->quota.weight_nr_accesses,
+				s->quota.weight_age,
 				s->stat_count, s->stat_sz);
 		if (!rc)
 			return -ENOMEM;
@@ -193,11 +196,14 @@ static struct damos **str_to_schemes(con
 	while (pos < len && *nr_schemes < max_nr_schemes) {
 		struct damos_quota quota = {};
 
-		ret = sscanf(&str[pos], "%lu %lu %u %u %u %u %u %lu %lu %lu%n",
+		ret = sscanf(&str[pos],
+				"%lu %lu %u %u %u %u %u %lu %lu %lu %u %u %u%n",
 				&min_sz, &max_sz, &min_nr_a, &max_nr_a,
 				&min_age, &max_age, &action, &quota.ms,
-				&quota.sz, &quota.reset_interval, &parsed);
-		if (ret != 10)
+				&quota.sz, &quota.reset_interval,
+				&quota.weight_sz, &quota.weight_nr_accesses,
+				&quota.weight_age, &parsed);
+		if (ret != 13)
 			break;
 		if (!damos_action_valid(action)) {
 			pr_err("wrong action %d\n", action);
_

Patches currently in -mm which might be from sj@kernel.org are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 358C0C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:49:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18B6961108
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:49:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234484AbhKKCwk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:52:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:56734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234469AbhKKCwk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:52:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA9AD60F26;
        Thu, 11 Nov 2021 02:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598992;
        bh=GSmOLPUywb++GlOok3rMoXLZQvuk732i0nVFHjYF8Z0=;
        h=Date:From:To:Subject:From;
        b=M1BKUgHgHeowrWTpk5beqqBCuS1W6Bvgq9xQbya2H57b3rLRHy4EHQG3B3ouk9qyD
         Vr762iwNiAw1iCAVZIb7QDsPWqC3W9LrUJ9VAWhWqDmO+6zzvsvajPdjjoXU7h1CT4
         ZO7uX4atu04nnXpSmsEMNzX2adFxN3nDzh2mGS1w=
Date:   Wed, 10 Nov 2021 18:49:51 -0800
From:   akpm@linux-foundation.org
To:     amit@kernel.org, benh@kernel.crashing.org, corbet@lwn.net,
        david@redhat.com, dwmw@amazon.com, elver@google.com,
        foersleo@amazon.de, gthelen@google.com,
        Jonathan.Cameron@huawei.com, markubo@amazon.de,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, shuah@kernel.org, sj@kernel.org
Subject:  [merged] mm-damon-dbgfs-support-quotas-of-schemes.patch
 removed from -mm tree
Message-ID: <20211111024951.-epoB9s5U%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs: support quotas of schemes
has been removed from the -mm tree.  Its filename was
     mm-damon-dbgfs-support-quotas-of-schemes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/dbgfs: support quotas of schemes

This commit makes the debugfs interface of DAMON support the scheme quotas
by chaning the format of the input for the schemes file.

Link: https://lkml.kernel.org/r/20211019150731.16699-6-sj@kernel.org
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

 mm/damon/dbgfs.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-support-quotas-of-schemes
+++ a/mm/damon/dbgfs.c
@@ -105,11 +105,14 @@ static ssize_t sprint_schemes(struct dam
 
 	damon_for_each_scheme(s, c) {
 		rc = scnprintf(&buf[written], len - written,
-				"%lu %lu %u %u %u %u %d %lu %lu\n",
+				"%lu %lu %u %u %u %u %d %lu %lu %lu %lu %lu\n",
 				s->min_sz_region, s->max_sz_region,
 				s->min_nr_accesses, s->max_nr_accesses,
 				s->min_age_region, s->max_age_region,
-				s->action, s->stat_count, s->stat_sz);
+				s->action,
+				s->quota.ms, s->quota.sz,
+				s->quota.reset_interval,
+				s->stat_count, s->stat_sz);
 		if (!rc)
 			return -ENOMEM;
 
@@ -190,10 +193,11 @@ static struct damos **str_to_schemes(con
 	while (pos < len && *nr_schemes < max_nr_schemes) {
 		struct damos_quota quota = {};
 
-		ret = sscanf(&str[pos], "%lu %lu %u %u %u %u %u%n",
+		ret = sscanf(&str[pos], "%lu %lu %u %u %u %u %u %lu %lu %lu%n",
 				&min_sz, &max_sz, &min_nr_a, &max_nr_a,
-				&min_age, &max_age, &action, &parsed);
-		if (ret != 7)
+				&min_age, &max_age, &action, &quota.ms,
+				&quota.sz, &quota.reset_interval, &parsed);
+		if (ret != 10)
 			break;
 		if (!damos_action_valid(action)) {
 			pr_err("wrong action %d\n", action);
_

Patches currently in -mm which might be from sj@kernel.org are



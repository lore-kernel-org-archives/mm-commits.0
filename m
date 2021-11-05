Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CB3BC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1805B610D0
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233817AbhKEUuI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:50:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233712AbhKEUuI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:50:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B1E460240;
        Fri,  5 Nov 2021 20:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145248;
        bh=8I7lkhEPQq4e+L/qSplU2QVURMjtUbuSOP1m2V3MBQM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=MrY455RTkvX7y1uTm5GZaWVgaoyDuZX5lAFkg+qRVpztGPZdYwD3olOwEJ28yFj8E
         kzABJBqNJdO15/Sq95lGEQE+b+NprL445JSeJpQsYVtIqtuvhzxllahPINNLoejVEA
         G5N7gLry+IHfxYbP1e0hGeMtckzmfd+6viglu0Tc=
Date:   Fri, 05 Nov 2021 13:47:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, amit@kernel.org,
        benh@kernel.crashing.org, corbet@lwn.net, david@redhat.com,
        dwmw@amazon.com, elver@google.com, foersleo@amazon.de,
        gthelen@google.com, Jonathan.Cameron@huawei.com,
        linux-mm@kvack.org, markubo@amazon.de, mm-commits@vger.kernel.org,
        rientjes@google.com, shakeelb@google.com, shuah@kernel.org,
        sj@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 243/262] mm/damon/dbgfs: support quotas of schemes
Message-ID: <20211105204727.-oOh-u_xL%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

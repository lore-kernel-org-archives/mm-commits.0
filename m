Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94546C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:47:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F77E60FC1
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbhKEUuC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:50:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:45160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233712AbhKEUuB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:50:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B53CB60174;
        Fri,  5 Nov 2021 20:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145241;
        bh=dz8aWE2IgrDbRc52OFX/xMjZBZws4fLOuSCZThcNkDg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=o7ppkFP80dFgJVgKL0qg2B0G04Vhtg80KuLGbQdln8xqk5FFS3KFlFUP4ZA1Grws4
         hFkEHGfYx3xbReHvfBvIvU1p9xlYk16m5XNC5554CW4QTPc6z40vJWXqSQU0Q4wUoV
         PCLc65XKpfhKEfddwcO+19SEHDabKZIhATXPwdsQ=
Date:   Fri, 05 Nov 2021 13:47:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, amit@kernel.org,
        benh@kernel.crashing.org, corbet@lwn.net, david@redhat.com,
        dwmw@amazon.com, elver@google.com, foersleo@amazon.de,
        gthelen@google.com, Jonathan.Cameron@huawei.com,
        linux-mm@kvack.org, markubo@amazon.de, mm-commits@vger.kernel.org,
        rientjes@google.com, shakeelb@google.com, shuah@kernel.org,
        sj@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 241/262] mm/damon/schemes: skip already charged
 targets and regions
Message-ID: <20211105204720.97KHLUzyC%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/schemes: skip already charged targets and regions

If DAMOS has stopped applying action in the middle of a group of memory
regions due to its size quota, it starts the work again from the beginning
of the address space in the next charge window.  If there is a huge memory
region at the beginning of the address space and it fulfills the scheme's
target data access pattern always, the action will applied to only the
region.

This commit mitigates the case by skipping memory regions that charged in
current charge window at the beginning of next charge window.

Link: https://lkml.kernel.org/r/20211019150731.16699-4-sj@kernel.org
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

 include/linux/damon.h |    5 +++++
 mm/damon/core.c       |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

--- a/include/linux/damon.h~mm-damon-schemes-skip-already-charged-targets-and-regions
+++ a/include/linux/damon.h
@@ -107,6 +107,8 @@ struct damos_quota {
 /* private: For charging the quota */
 	unsigned long charged_sz;
 	unsigned long charged_from;
+	struct damon_target *charge_target_from;
+	unsigned long charge_addr_from;
 };
 
 /**
@@ -307,6 +309,9 @@ struct damon_ctx {
 #define damon_prev_region(r) \
 	(container_of(r->list.prev, struct damon_region, list))
 
+#define damon_last_region(t) \
+	(list_last_entry(&t->regions_list, struct damon_region, list))
+
 #define damon_for_each_region(r, t) \
 	list_for_each_entry(r, &t->regions_list, list)
 
--- a/mm/damon/core.c~mm-damon-schemes-skip-already-charged-targets-and-regions
+++ a/mm/damon/core.c
@@ -111,6 +111,8 @@ struct damos *damon_new_scheme(
 	scheme->quota.reset_interval = quota->reset_interval;
 	scheme->quota.charged_sz = 0;
 	scheme->quota.charged_from = 0;
+	scheme->quota.charge_target_from = NULL;
+	scheme->quota.charge_addr_from = 0;
 
 	return scheme;
 }
@@ -553,6 +555,37 @@ static void damon_do_apply_schemes(struc
 		if (quota->sz && quota->charged_sz >= quota->sz)
 			continue;
 
+		/* Skip previously charged regions */
+		if (quota->charge_target_from) {
+			if (t != quota->charge_target_from)
+				continue;
+			if (r == damon_last_region(t)) {
+				quota->charge_target_from = NULL;
+				quota->charge_addr_from = 0;
+				continue;
+			}
+			if (quota->charge_addr_from &&
+					r->ar.end <= quota->charge_addr_from)
+				continue;
+
+			if (quota->charge_addr_from && r->ar.start <
+					quota->charge_addr_from) {
+				sz = ALIGN_DOWN(quota->charge_addr_from -
+						r->ar.start, DAMON_MIN_REGION);
+				if (!sz) {
+					if (r->ar.end - r->ar.start <=
+							DAMON_MIN_REGION)
+						continue;
+					sz = DAMON_MIN_REGION;
+				}
+				damon_split_region_at(c, t, r, sz);
+				r = damon_next_region(r);
+				sz = r->ar.end - r->ar.start;
+			}
+			quota->charge_target_from = NULL;
+			quota->charge_addr_from = 0;
+		}
+
 		/* Check the target regions condition */
 		if (sz < s->min_sz_region || s->max_sz_region < sz)
 			continue;
@@ -573,6 +606,10 @@ static void damon_do_apply_schemes(struc
 			}
 			c->primitive.apply_scheme(c, t, r, s);
 			quota->charged_sz += sz;
+			if (quota->sz && quota->charged_sz >= quota->sz) {
+				quota->charge_target_from = t;
+				quota->charge_addr_from = r->ar.end + 1;
+			}
 		}
 		if (s->action != DAMOS_STAT)
 			r->age = 0;
_

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD093C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:47:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6FBD61056
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:47:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233816AbhKEUuF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:50:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233712AbhKEUuE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:50:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29BF860FBF;
        Fri,  5 Nov 2021 20:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145244;
        bh=43n69Oi6XLnLLtBTXtXAlvj3k0wVNQ3MKEnvr51CoPU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hAOqPnXdWocEmuVs2Tvx5v7n8wRC16qoHDr2pMnV9nreZAWBB77awrKRjrHFAsT9m
         plCNuWpTsGTV2amZ2J5bWM9R0s629Hw6ytljkXcdP/+Bw+MWbfjOFRaKqe5v+9pQ3F
         KvgjqNeOuuyEjIUVl69WliL6UiX2dBuxckO7qYNI=
Date:   Fri, 05 Nov 2021 13:47:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, amit@kernel.org,
        benh@kernel.crashing.org, corbet@lwn.net, david@redhat.com,
        dwmw@amazon.com, elver@google.com, foersleo@amazon.de,
        gthelen@google.com, Jonathan.Cameron@huawei.com,
        linux-mm@kvack.org, markubo@amazon.de, mm-commits@vger.kernel.org,
        rientjes@google.com, shakeelb@google.com, shuah@kernel.org,
        sj@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 242/262] mm/damon/schemes: implement time quota
Message-ID: <20211105204723.yxHbbIXWq%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/schemes: implement time quota

The size quota feature of DAMOS is useful for IO resource-critical
systems, but not so intuitive for CPU time-critical systems.  Systems
using zram or zswap-like swap device would be examples.

To provide another intuitive ways for such systems, this commit implements
time-based quota for DAMON-based Operation Schemes.  If the quota is set,
DAMOS tries to use only up to the user-defined quota of CPU time within a
given time window.

Link: https://lkml.kernel.org/r/20211019150731.16699-5-sj@kernel.org
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

 include/linux/damon.h |   25 +++++++++++++++++-----
 mm/damon/core.c       |   45 +++++++++++++++++++++++++++++++++++-----
 2 files changed, 60 insertions(+), 10 deletions(-)

--- a/include/linux/damon.h~mm-damon-schemes-implement-time-quota
+++ a/include/linux/damon.h
@@ -91,20 +91,35 @@ enum damos_action {
 
 /**
  * struct damos_quota - Controls the aggressiveness of the given scheme.
+ * @ms:			Maximum milliseconds that the scheme can use.
  * @sz:			Maximum bytes of memory that the action can be applied.
  * @reset_interval:	Charge reset interval in milliseconds.
  *
  * To avoid consuming too much CPU time or IO resources for applying the
- * &struct damos->action to large memory, DAMON allows users to set a size
- * quota.  The quota can be set by writing non-zero values to &sz.  If the size
- * quota is set, DAMON tries to apply the action only up to &sz bytes within
- * &reset_interval.
+ * &struct damos->action to large memory, DAMON allows users to set time and/or
+ * size quotas.  The quotas can be set by writing non-zero values to &ms and
+ * &sz, respectively.  If the time quota is set, DAMON tries to use only up to
+ * &ms milliseconds within &reset_interval for applying the action.  If the
+ * size quota is set, DAMON tries to apply the action only up to &sz bytes
+ * within &reset_interval.
+ *
+ * Internally, the time quota is transformed to a size quota using estimated
+ * throughput of the scheme's action.  DAMON then compares it against &sz and
+ * uses smaller one as the effective quota.
  */
 struct damos_quota {
+	unsigned long ms;
 	unsigned long sz;
 	unsigned long reset_interval;
 
-/* private: For charging the quota */
+/* private: */
+	/* For throughput estimation */
+	unsigned long total_charged_sz;
+	unsigned long total_charged_ns;
+
+	unsigned long esz;	/* Effective size quota in bytes */
+
+	/* For charging the quota */
 	unsigned long charged_sz;
 	unsigned long charged_from;
 	struct damon_target *charge_target_from;
--- a/mm/damon/core.c~mm-damon-schemes-implement-time-quota
+++ a/mm/damon/core.c
@@ -107,8 +107,12 @@ struct damos *damon_new_scheme(
 	scheme->stat_sz = 0;
 	INIT_LIST_HEAD(&scheme->list);
 
+	scheme->quota.ms = quota->ms;
 	scheme->quota.sz = quota->sz;
 	scheme->quota.reset_interval = quota->reset_interval;
+	scheme->quota.total_charged_sz = 0;
+	scheme->quota.total_charged_ns = 0;
+	scheme->quota.esz = 0;
 	scheme->quota.charged_sz = 0;
 	scheme->quota.charged_from = 0;
 	scheme->quota.charge_target_from = NULL;
@@ -550,9 +554,10 @@ static void damon_do_apply_schemes(struc
 	damon_for_each_scheme(s, c) {
 		struct damos_quota *quota = &s->quota;
 		unsigned long sz = r->ar.end - r->ar.start;
+		struct timespec64 begin, end;
 
 		/* Check the quota */
-		if (quota->sz && quota->charged_sz >= quota->sz)
+		if (quota->esz && quota->charged_sz >= quota->esz)
 			continue;
 
 		/* Skip previously charged regions */
@@ -597,16 +602,21 @@ static void damon_do_apply_schemes(struc
 
 		/* Apply the scheme */
 		if (c->primitive.apply_scheme) {
-			if (quota->sz && quota->charged_sz + sz > quota->sz) {
-				sz = ALIGN_DOWN(quota->sz - quota->charged_sz,
+			if (quota->esz &&
+					quota->charged_sz + sz > quota->esz) {
+				sz = ALIGN_DOWN(quota->esz - quota->charged_sz,
 						DAMON_MIN_REGION);
 				if (!sz)
 					goto update_stat;
 				damon_split_region_at(c, t, r, sz);
 			}
+			ktime_get_coarse_ts64(&begin);
 			c->primitive.apply_scheme(c, t, r, s);
+			ktime_get_coarse_ts64(&end);
+			quota->total_charged_ns += timespec64_to_ns(&end) -
+				timespec64_to_ns(&begin);
 			quota->charged_sz += sz;
-			if (quota->sz && quota->charged_sz >= quota->sz) {
+			if (quota->esz && quota->charged_sz >= quota->esz) {
 				quota->charge_target_from = t;
 				quota->charge_addr_from = r->ar.end + 1;
 			}
@@ -620,6 +630,29 @@ update_stat:
 	}
 }
 
+/* Shouldn't be called if quota->ms and quota->sz are zero */
+static void damos_set_effective_quota(struct damos_quota *quota)
+{
+	unsigned long throughput;
+	unsigned long esz;
+
+	if (!quota->ms) {
+		quota->esz = quota->sz;
+		return;
+	}
+
+	if (quota->total_charged_ns)
+		throughput = quota->total_charged_sz * 1000000 /
+			quota->total_charged_ns;
+	else
+		throughput = PAGE_SIZE * 1024;
+	esz = throughput * quota->ms;
+
+	if (quota->sz && quota->sz < esz)
+		esz = quota->sz;
+	quota->esz = esz;
+}
+
 static void kdamond_apply_schemes(struct damon_ctx *c)
 {
 	struct damon_target *t;
@@ -629,15 +662,17 @@ static void kdamond_apply_schemes(struct
 	damon_for_each_scheme(s, c) {
 		struct damos_quota *quota = &s->quota;
 
-		if (!quota->sz)
+		if (!quota->ms && !quota->sz)
 			continue;
 
 		/* New charge window starts */
 		if (time_after_eq(jiffies, quota->charged_from +
 					msecs_to_jiffies(
 						quota->reset_interval))) {
+			quota->total_charged_sz += quota->charged_sz;
 			quota->charged_from = jiffies;
 			quota->charged_sz = 0;
+			damos_set_effective_quota(quota);
 		}
 	}
 
_

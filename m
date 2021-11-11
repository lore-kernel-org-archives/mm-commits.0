Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13035C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:49:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 008506135E
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234482AbhKKCwe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:52:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:56650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234469AbhKKCwe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:52:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 863FD6103C;
        Thu, 11 Nov 2021 02:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598986;
        bh=0WIfe5AoHTZH+tSiTkxfL5SMa4vFu77d5kPh//uhAlg=;
        h=Date:From:To:Subject:From;
        b=Y2VZp3qC+P6yYgPk3ZnIGY7suCJIW88KqAl/JXYazSIKsJCaQTbVt0yYO0bwBuNmR
         YjU96f827P4k5h4QmmDmzmmRXt4DRHCgyJxWnv2ZrMWNGROj9Py2aPDKGP04LBOT7+
         BRnY0souRNVZvJmHLZcpk/sOOfjtnd1mmYWVDRKA=
Date:   Wed, 10 Nov 2021 18:49:45 -0800
From:   akpm@linux-foundation.org
To:     amit@kernel.org, benh@kernel.crashing.org, corbet@lwn.net,
        david@redhat.com, dwmw@amazon.com, elver@google.com,
        foersleo@amazon.de, gthelen@google.com,
        Jonathan.Cameron@huawei.com, markubo@amazon.de,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, shuah@kernel.org, sj@kernel.org
Subject:  [merged]
 mm-damon-schemes-skip-already-charged-targets-and-regions.patch removed
 from -mm tree
Message-ID: <20211111024945.p6fJ6l0bO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/schemes: skip already charged targets and regions
has been removed from the -mm tree.  Its filename was
     mm-damon-schemes-skip-already-charged-targets-and-regions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from sj@kernel.org are



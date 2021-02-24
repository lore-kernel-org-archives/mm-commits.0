Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14118C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4C5C64F2A
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235314AbhBXUFy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:05:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:55484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235096AbhBXUFO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:05:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E65B264F2F;
        Wed, 24 Feb 2021 20:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197039;
        bh=QqTMeJTbGJz/dCouHrhTiGyDXHQTRy1K8qh2winai+g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ciRXpoESzD+p9ZztBT1g0MSZArxQlGEmnhiU1WjUpvuymDEzfXp2GBdKDFpdRIAVc
         PnesOG00K0r1DdCe4XvlhPuSR37iEMd0kFNL/jBiMzjZtBw6ewhXSkZknFGJiSx3Q0
         EMAZ2w8NAsiQRoCyD86lm2n8V8drO1ZD+tAM+cz4=
Date:   Wed, 24 Feb 2021 12:03:58 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        torvalds@linux-foundation.org
Subject:  [patch 067/173] mm: kmem: make __memcg_kmem_(un)charge
 static
Message-ID: <20210224200358.hE1s6mymp%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Roman Gushchin <guro@fb.com>
Subject: mm: kmem: make __memcg_kmem_(un)charge static

I've noticed that __memcg_kmem_charge() and __memcg_kmem_uncharge() are
not used anywhere except memcontrol.c.  Yet they are not declared as
non-static and are declared in memcontrol.h.

This patch makes them static.

Link: https://lkml.kernel.org/r/20210108020332.4096911-1-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    3 ---
 mm/memcontrol.c            |   11 ++++++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/include/linux/memcontrol.h~mm-kmem-make-__memcg_kmem_uncharge-static
+++ a/include/linux/memcontrol.h
@@ -1592,9 +1592,6 @@ static inline void memcg_set_shrinker_bi
 #endif
 
 #ifdef CONFIG_MEMCG_KMEM
-int __memcg_kmem_charge(struct mem_cgroup *memcg, gfp_t gfp,
-			unsigned int nr_pages);
-void __memcg_kmem_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages);
 int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order);
 void __memcg_kmem_uncharge_page(struct page *page, int order);
 
--- a/mm/memcontrol.c~mm-kmem-make-__memcg_kmem_uncharge-static
+++ a/mm/memcontrol.c
@@ -255,6 +255,11 @@ struct cgroup_subsys_state *vmpressure_t
 #ifdef CONFIG_MEMCG_KMEM
 extern spinlock_t css_set_lock;
 
+static int __memcg_kmem_charge(struct mem_cgroup *memcg, gfp_t gfp,
+			       unsigned int nr_pages);
+static void __memcg_kmem_uncharge(struct mem_cgroup *memcg,
+				  unsigned int nr_pages);
+
 static void obj_cgroup_release(struct percpu_ref *ref)
 {
 	struct obj_cgroup *objcg = container_of(ref, struct obj_cgroup, refcnt);
@@ -3087,8 +3092,8 @@ static void memcg_free_cache_id(int id)
  *
  * Returns 0 on success, an error code on failure.
  */
-int __memcg_kmem_charge(struct mem_cgroup *memcg, gfp_t gfp,
-			unsigned int nr_pages)
+static int __memcg_kmem_charge(struct mem_cgroup *memcg, gfp_t gfp,
+			       unsigned int nr_pages)
 {
 	struct page_counter *counter;
 	int ret;
@@ -3120,7 +3125,7 @@ int __memcg_kmem_charge(struct mem_cgrou
  * @memcg: memcg to uncharge
  * @nr_pages: number of pages to uncharge
  */
-void __memcg_kmem_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages)
+static void __memcg_kmem_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		page_counter_uncharge(&memcg->kmem, nr_pages);
_

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08857C43381
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:25:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A71C664F27
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:25:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234114AbhBYTZh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:25:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:35726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234567AbhBYTXR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:23:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9564864F69;
        Thu, 25 Feb 2021 19:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280460;
        bh=OcIDncsoJMt1A1eOSb02/+bFItM9HjmTJcuWPZh4c0w=;
        h=Date:From:To:Subject:From;
        b=xkdamgRY9KaAVdZIAqkd1v8BgOsh2D3S4K7feTJKGEJ1iJPsGTrrwfyl1wKxUakPg
         F1JGLkhKMPxKaX7m9/sXDW2F1uTXei+4qq9DUTPxh/gMjd8gvFPVfVLT9v0RldKtuo
         tdV1zXYgPiJ0SdYodb+9oYNjMMRM6dm74Uu4Vi28=
Date:   Thu, 25 Feb 2021 11:14:20 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  [merged] mm-kmem-make-__memcg_kmem_uncharge-static.patch
 removed from -mm tree
Message-ID: <20210225191420.TF3pASa6l%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmem: make __memcg_kmem_(un)charge static
has been removed from the -mm tree.  Its filename was
     mm-kmem-make-__memcg_kmem_uncharge-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from guro@fb.com are

mm-cma-allocate-cma-areas-bottom-up.patch
mm-cma-allocate-cma-areas-bottom-up-fix.patch
mm-cma-allocate-cma-areas-bottom-up-fix-2.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch


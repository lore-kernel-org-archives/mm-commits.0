Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DB82C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:22:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64F8C61CED
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbhF2AYu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 20:24:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231996AbhF2AYs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 20:24:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFBA961CF9;
        Tue, 29 Jun 2021 00:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624926141;
        bh=ODOQ7fP7MyqAYDZiTi3nM3UntWYgWGur+9k9Z6zCH+k=;
        h=Date:From:To:Subject:From;
        b=CntKZXW5zxIcvDOfV3XVstiyvFxgm/hIad5i9pcPpPN/mfM3donhrTEh0HAGBZxX9
         //qMQsO/co+rR1Q87q5AwzUCkBRRkq+erFQcbl+fgFeGFgLxcjm2iRBR4VVYeyPvc9
         iKItS/zd+bxCHUjpWSbC1POXv2nIPLxux1RPb67U=
Date:   Mon, 28 Jun 2021 17:22:21 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, longman@redhat.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        vdavydov.dev@gmail.com
Subject:  [folded-merged]
 mm-memcg-optimize-user-context-object-stock-access-fix.patch removed from
 -mm tree
Message-ID: <20210629002221.eeawFmQh_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: fix potential uninitialized variable warning
has been removed from the -mm tree.  Its filename was
     mm-memcg-optimize-user-context-object-stock-access-fix.patch

This patch was dropped because it was folded into mm-memcg-optimize-user-context-object-stock-access.patch

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm/memcontrol.c: fix potential uninitialized variable warning

If the -Wno-maybe-uninitialized gcc option is not specified, compilation
of memcontrol.c may generate the following warnings:

mm/memcontrol.c: In function `refill_obj_stock':
./arch/x86/include/asm/irqflags.h:127:17: warning: `flags' may be used uninitialized in this function [-Wmaybe-uninitialized]
  return !(flags & X86_EFLAGS_IF);
          ~~~~~~~^~~~~~~~~~~~~~~~
mm/memcontrol.c:3216:16: note: `flags' was declared here
  unsigned long flags;
                ^~~~~
In file included from mm/memcontrol.c:29:
mm/memcontrol.c: In function `uncharge_page':
./include/linux/memcontrol.h:797:2: warning: `objcg' may be used uninitialized in this function [-Wmaybe-uninitialized]
  percpu_ref_put(&objcg->refcnt);
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fix that by properly initializing *pflags in get_obj_stock() and
introducing a use_objcg bool variable in uncharge_page() to avoid
potentially accessing the struct page data twice.

Link: https://lkml.kernel.org/r/20210526193602.8742-1-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-optimize-user-context-object-stock-access-fix
+++ a/mm/memcontrol.c
@@ -2115,6 +2115,7 @@ static inline struct obj_stock *get_obj_
 	struct memcg_stock_pcp *stock;
 
 	if (likely(in_task())) {
+		*pflags = 0UL;
 		preempt_disable();
 		stock = this_cpu_ptr(&memcg_stock);
 		return &stock->task_obj;
@@ -6832,6 +6833,7 @@ static void uncharge_page(struct page *p
 	unsigned long nr_pages;
 	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
+	bool use_objcg = PageMemcgKmem(page);
 
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 
@@ -6840,7 +6842,7 @@ static void uncharge_page(struct page *p
 	 * page memcg or objcg at this point, we have fully
 	 * exclusive access to the page.
 	 */
-	if (PageMemcgKmem(page)) {
+	if (use_objcg) {
 		objcg = __page_objcg(page);
 		/*
 		 * This get matches the put at the end of the function and
@@ -6868,7 +6870,7 @@ static void uncharge_page(struct page *p
 
 	nr_pages = compound_nr(page);
 
-	if (PageMemcgKmem(page)) {
+	if (use_objcg) {
 		ug->nr_memory += nr_pages;
 		ug->nr_kmem += nr_pages;
 
_

Patches currently in -mm which might be from longman@redhat.com are

mm-memcg-move-mod_objcg_state-to-memcontrolc.patch
mm-memcg-cache-vmstat-data-in-percpu-memcg_stock_pcp.patch
mm-memcg-improve-refill_obj_stock-performance.patch
mm-memcg-optimize-user-context-object-stock-access.patch
mm-memcg-slab-properly-set-up-gfp-flags-for-objcg-pointer-array.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5.patch
mm-memcg-slab-disable-cache-merging-for-kmalloc_normal-caches.patch


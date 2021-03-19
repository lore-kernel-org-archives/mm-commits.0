Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA4B8C433E1
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 17:12:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 725FC61965
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 17:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhCSRLt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Mar 2021 13:11:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230286AbhCSRLd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Mar 2021 13:11:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6ADCE61963;
        Fri, 19 Mar 2021 17:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616173893;
        bh=w6AdRE8mXfZIggCdgXtTrdG3LtkBQdElKmt+uTiY+6M=;
        h=Date:From:To:Subject:From;
        b=jKkQI5Qbg588dWU36h/PRYkb9uZhd5IrfhOGluti/2z9lmeIYkSAZCUyPphBAxW4c
         V0d7/GqjL2YwApjJoLszq5PEP6Ia6TkVvE/CM0bdROH6NIeeAXFzTALCzbnlIl/WSf
         uhE+YG0C8nNm3IDjr+WKSng8dH1W4oindSV6Lw5A=
Date:   Fri, 19 Mar 2021 10:11:33 -0700
From:   akpm@linux-foundation.org
To:     duanxiongchun@bytedance.com, guro@fb.com, hannes@cmpxchg.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, vdavydov.dev@gmail.com
Subject:  +
 =?US-ASCII?Q?mm-memcontrol-inline-=5F=5Fmemcg=5Fkmem=5Funcharge-into-obj?=
 =?US-ASCII?Q?=5Fcgroup=5Funcharge=5Fpages.patch?= added to -mm tree
Message-ID: <20210319171133.H7blB45xB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: inline __memcg_kmem_{un}charge() into obj_cgroup_{un}charge_pages()
has been added to the -mm tree.  Its filename is
     mm-memcontrol-inline-__memcg_kmem_uncharge-into-obj_cgroup_uncharge_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-inline-__memcg_kmem_uncharge-into-obj_cgroup_uncharge_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-inline-__memcg_kmem_uncharge-into-obj_cgroup_uncharge_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: inline __memcg_kmem_{un}charge() into obj_cgroup_{un}charge_pages()

There is only one user of __memcg_kmem_charge(), so manually inline
__memcg_kmem_charge() to obj_cgroup_charge_pages().  Similarly manually
inline __memcg_kmem_uncharge() into obj_cgroup_uncharge_pages() and call
obj_cgroup_uncharge_pages() in obj_cgroup_release().

This is just code cleanup without any functionality changes.

Link: https://lkml.kernel.org/r/20210319163821.20704-7-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   63 ++++++++++++++++++----------------------------
 1 file changed, 25 insertions(+), 38 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-inline-__memcg_kmem_uncharge-into-obj_cgroup_uncharge_pages
+++ a/mm/memcontrol.c
@@ -255,10 +255,8 @@ struct cgroup_subsys_state *vmpressure_t
 #ifdef CONFIG_MEMCG_KMEM
 extern spinlock_t css_set_lock;
 
-static int __memcg_kmem_charge(struct mem_cgroup *memcg, gfp_t gfp,
-			       unsigned int nr_pages);
-static void __memcg_kmem_uncharge(struct mem_cgroup *memcg,
-				  unsigned int nr_pages);
+static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
+				      unsigned int nr_pages);
 
 static void obj_cgroup_release(struct percpu_ref *ref)
 {
@@ -295,7 +293,7 @@ static void obj_cgroup_release(struct pe
 	spin_lock_irqsave(&css_set_lock, flags);
 	memcg = obj_cgroup_memcg(objcg);
 	if (nr_pages)
-		__memcg_kmem_uncharge(memcg, nr_pages);
+		obj_cgroup_uncharge_pages(objcg, nr_pages);
 	list_del(&objcg->list);
 	mem_cgroup_put(memcg);
 	spin_unlock_irqrestore(&css_set_lock, flags);
@@ -3015,46 +3013,45 @@ static void memcg_free_cache_id(int id)
 	ida_simple_remove(&memcg_cache_ida, id);
 }
 
+/*
+ * obj_cgroup_uncharge_pages: uncharge a number of kernel pages from a objcg
+ * @objcg: object cgroup to uncharge
+ * @nr_pages: number of pages to uncharge
+ */
 static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
 				      unsigned int nr_pages)
 {
 	struct mem_cgroup *memcg;
 
 	memcg = get_mem_cgroup_from_objcg(objcg);
-	__memcg_kmem_uncharge(memcg, nr_pages);
-	css_put(&memcg->css);
-}
 
-static int obj_cgroup_charge_pages(struct obj_cgroup *objcg, gfp_t gfp,
-				   unsigned int nr_pages)
-{
-	struct mem_cgroup *memcg;
-	int ret;
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		page_counter_uncharge(&memcg->kmem, nr_pages);
+	refill_stock(memcg, nr_pages);
 
-	memcg = get_mem_cgroup_from_objcg(objcg);
-	ret = __memcg_kmem_charge(memcg, gfp, nr_pages);
 	css_put(&memcg->css);
-
-	return ret;
 }
 
-/**
- * __memcg_kmem_charge: charge a number of kernel pages to a memcg
- * @memcg: memory cgroup to charge
+/*
+ * obj_cgroup_charge_pages: charge a number of kernel pages to a objcg
+ * @objcg: object cgroup to charge
  * @gfp: reclaim mode
  * @nr_pages: number of pages to charge
  *
  * Returns 0 on success, an error code on failure.
  */
-static int __memcg_kmem_charge(struct mem_cgroup *memcg, gfp_t gfp,
-			       unsigned int nr_pages)
+static int obj_cgroup_charge_pages(struct obj_cgroup *objcg, gfp_t gfp,
+				   unsigned int nr_pages)
 {
 	struct page_counter *counter;
+	struct mem_cgroup *memcg;
 	int ret;
 
+	memcg = get_mem_cgroup_from_objcg(objcg);
+
 	ret = try_charge(memcg, gfp, nr_pages);
 	if (ret)
-		return ret;
+		goto out;
 
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) &&
 	    !page_counter_try_charge(&memcg->kmem, nr_pages, &counter)) {
@@ -3066,25 +3063,15 @@ static int __memcg_kmem_charge(struct me
 		 */
 		if (gfp & __GFP_NOFAIL) {
 			page_counter_charge(&memcg->kmem, nr_pages);
-			return 0;
+			goto out;
 		}
 		cancel_charge(memcg, nr_pages);
-		return -ENOMEM;
+		ret = -ENOMEM;
 	}
-	return 0;
-}
-
-/**
- * __memcg_kmem_uncharge: uncharge a number of kernel pages from a memcg
- * @memcg: memcg to uncharge
- * @nr_pages: number of pages to uncharge
- */
-static void __memcg_kmem_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages)
-{
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		page_counter_uncharge(&memcg->kmem, nr_pages);
+out:
+	css_put(&memcg->css);
 
-	refill_stock(memcg, nr_pages);
+	return ret;
 }
 
 /**
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-fix-kernel-stack-account.patch
mm-memcontrol-slab-fix-obtain-a-reference-to-a-freeing-memcg.patch
mm-memcontrol-introduce-obj_cgroup_uncharge_pages.patch
mm-memcontrol-directly-access-page-memcg_data-in-mm-page_allocc.patch
mm-memcontrol-change-ug-dummy_page-only-if-memcg-changed.patch
mm-memcontrol-use-obj_cgroup-apis-to-charge-kmem-pages.patch
mm-memcontrol-inline-__memcg_kmem_uncharge-into-obj_cgroup_uncharge_pages.patch
mm-memcontrol-move-pagememcgkmem-to-the-scope-of-config_memcg_kmem.patch


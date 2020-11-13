Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AC60C2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 01:12:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A377322201
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 01:12:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="BhWrva+B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgKMBMt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 20:12:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:38850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbgKMBMt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 20:12:49 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6BBE216C4;
        Fri, 13 Nov 2020 01:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605229968;
        bh=ODPvLz4SlVdM2E3zQA73OleHbYt7ulgRr/Ggw+ur3ao=;
        h=Date:From:To:Subject:From;
        b=BhWrva+ByJO39TdO5rDQ7kp2oVcZAbRgZ40FDjr9bRiOPDylO6PxoqmjTjSiudFIK
         t6ILONFAS95vWalKiIJy706ZxwDS0USfshnSZIRBwMS/iPSptA/v6JMFxhIbljaJR3
         qozN9a+6pSC+lM47o/1byILpgH0eWYqaiulrTASU=
Date:   Thu, 12 Nov 2020 17:12:47 -0800
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  +
 =?US-ASCII?Q?mm-memcg-slab-pre-allocate-obj=5Fcgroups-for-slab-caches-wi?=
 =?US-ASCII?Q?th-slab=5Faccount-v2.patch?= added to -mm tree
Message-ID: <20201113011247.Rj12L9UAq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-v2
has been added to the -mm tree.  Its filename is
     mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-v2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-v2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-v2

open-code set_page_objcgs() and add some comments, by Johannes

Link: https://lkml.kernel.org/r/20201113001926.GA2934489@carbon.dhcp.thefacebook.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   25 -------------------------
 mm/memcontrol.c            |   23 +++++++++++++++++++----
 mm/slab.h                  |    8 ++++----
 3 files changed, 23 insertions(+), 33 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-v2
+++ a/include/linux/memcontrol.h
@@ -480,25 +480,6 @@ static inline struct obj_cgroup **page_o
 	return (struct obj_cgroup **)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
 }
 
-/*
- * set_page_objcgs - associate a page with a object cgroups vector
- * @page: a pointer to the page struct
- * @objcgs: a pointer to the object cgroups vector
- * @atomic: save the value atomically
- *
- * Atomically associates a page with a vector of object cgroups.
- */
-static inline bool set_page_objcgs(struct page *page,
-				   struct obj_cgroup **objcgs, bool atomic)
-{
-	unsigned long memcg_data = (unsigned long) objcgs | MEMCG_DATA_OBJCGS;
-
-	if (atomic)
-		return !cmpxchg(&page->memcg_data, 0, memcg_data);
-
-	page->memcg_data = memcg_data;
-	return true;
-}
 #else
 static inline struct obj_cgroup **page_objcgs(struct page *page)
 {
@@ -509,12 +490,6 @@ static inline struct obj_cgroup **page_o
 {
 	return NULL;
 }
-
-static inline bool set_page_objcgs(struct page *page,
-				   struct obj_cgroup **objcgs, bool atomic)
-{
-	return true;
-}
 #endif
 
 static __always_inline bool memcg_stat_item_in_bytes(int idx)
--- a/mm/memcontrol.c~mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-v2
+++ a/mm/memcontrol.c
@@ -2879,9 +2879,10 @@ static void commit_charge(struct page *p
 
 #ifdef CONFIG_MEMCG_KMEM
 int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
-				 gfp_t gfp, bool atomic)
+				 gfp_t gfp, bool new_page)
 {
 	unsigned int objects = objs_per_slab_page(s, page);
+	unsigned long memcg_data;
 	void *vec;
 
 	vec = kcalloc_node(objects, sizeof(struct obj_cgroup *), gfp,
@@ -2889,11 +2890,25 @@ int memcg_alloc_page_obj_cgroups(struct
 	if (!vec)
 		return -ENOMEM;
 
-	if (!set_page_objcgs(page, vec, atomic))
+	memcg_data = (unsigned long) vec | MEMCG_DATA_OBJCGS;
+	if (new_page) {
+		/*
+		 * If the slab page is brand new and nobody can yet access
+		 * it's memcg_data, no synchronization is required and
+		 * memcg_data can be simply assigned.
+		 */
+		page->memcg_data = memcg_data;
+	} else if (cmpxchg(&page->memcg_data, 0, memcg_data)) {
+		/*
+		 * If the slab page is already in use, somebody can allocate
+		 * and assign obj_cgroups in parallel. In this case the existing
+		 * objcg vector should be reused.
+		 */
 		kfree(vec);
-	else
-		kmemleak_not_leak(vec);
+		return 0;
+	}
 
+	kmemleak_not_leak(vec);
 	return 0;
 }
 
--- a/mm/slab.h~mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-v2
+++ a/mm/slab.h
@@ -240,7 +240,7 @@ static inline bool kmem_cache_debug_flag
 
 #ifdef CONFIG_MEMCG_KMEM
 int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
-				 gfp_t gfp, bool atomic);
+				 gfp_t gfp, bool new_page);
 
 static inline void memcg_free_page_obj_cgroups(struct page *page)
 {
@@ -308,7 +308,7 @@ static inline void memcg_slab_post_alloc
 
 			if (!page_objcgs(page) &&
 			    memcg_alloc_page_obj_cgroups(page, s, flags,
-							 true)) {
+							 false)) {
 				obj_cgroup_uncharge(objcg, obj_full_size(s));
 				continue;
 			}
@@ -373,7 +373,7 @@ static inline struct mem_cgroup *memcg_f
 
 static inline int memcg_alloc_page_obj_cgroups(struct page *page,
 					       struct kmem_cache *s, gfp_t gfp,
-					       bool atomic)
+					       bool new_page)
 {
 	return 0;
 }
@@ -418,7 +418,7 @@ static __always_inline void account_slab
 					      gfp_t gfp)
 {
 	if (memcg_kmem_enabled() && (s->flags & SLAB_ACCOUNT))
-		memcg_alloc_page_obj_cgroups(page, s, gfp, false);
+		memcg_alloc_page_obj_cgroups(page, s, gfp, true);
 
 	mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
 			    PAGE_SIZE << order);
_

Patches currently in -mm which might be from guro@fb.com are

mm-memcontrol-use-helpers-to-read-pages-memcg-data.patch
mm-memcontrol-slab-use-helpers-to-access-slab-pages-memcg_data.patch
mm-introduce-page-memcg-flags.patch
mm-convert-page-kmemcg-type-to-a-page-memcg-flag.patch
mm-memcg-fix-obsolete-code-comments.patch
mm-slub-call-account_slab_page-after-slab-page-initialization.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-v2.patch
mm-memcg-deprecate-the-non-hierarchical-mode.patch
docs-cgroup-v1-reflect-the-deprecation-of-the-non-hierarchical-mode.patch
cgroup-remove-obsoleted-broken_hierarchy-and-warned_broken_hierarchy.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch


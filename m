Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A01AEC433E0
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 20:46:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50A1C22AB9
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 20:46:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbgLVUqh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 15:46:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:60998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725850AbgLVUqg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 15:46:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4A1E224F4;
        Tue, 22 Dec 2020 20:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608669955;
        bh=k8QPitssUVIym0BkVRt9G/SVPt63bn3aPxJBILzGsNU=;
        h=Date:From:To:Subject:From;
        b=s2280c5rPBwl2l3/RN0iG7R60FOeXquUMq3QquaLUe7cujtAMd7GO93baLc5B3HhK
         xNom5qnyz0NShbnf8v7iYVHCCSqqbNNHUGTPGEONoBs4ZErwPcghaVh4+IKf3XbuKb
         j903xsqmvA9j7wJVrLTSXEzzBD50cKxfpgyoNE0s=
Date:   Tue, 22 Dec 2020 12:45:55 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, shakeelb@google.com, mhocko@kernel.org,
        hannes@cmpxchg.org, cl@linux.com, guro@fb.com
Subject:  [folded-merged]
 =?us-ascii?Q?mm-memcg-slab-pre-allocate-obj=5Fcgroups-for-slab-caches-wi?=
 =?us-ascii?Q?th-slab=5Faccount-v2.patch?= removed from -mm tree
Message-ID: <20201222204555._CBZV%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-v2
has been removed from the -mm tree.  Its filename was
     mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-v2.patch

This patch was dropped because it was folded into mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account.patch

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
@@ -475,25 +475,6 @@ static inline struct obj_cgroup **page_o
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
@@ -504,12 +485,6 @@ static inline struct obj_cgroup **page_o
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
@@ -2972,9 +2972,10 @@ static void commit_charge(struct page *p
 
 #ifdef CONFIG_MEMCG_KMEM
 int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
-				 gfp_t gfp, bool atomic)
+				 gfp_t gfp, bool new_page)
 {
 	unsigned int objects = objs_per_slab_page(s, page);
+	unsigned long memcg_data;
 	void *vec;
 
 	vec = kcalloc_node(objects, sizeof(struct obj_cgroup *), gfp,
@@ -2982,11 +2983,25 @@ int memcg_alloc_page_obj_cgroups(struct
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
@@ -318,7 +318,7 @@ static inline void memcg_slab_post_alloc
 
 			if (!page_objcgs(page) &&
 			    memcg_alloc_page_obj_cgroups(page, s, flags,
-							 true)) {
+							 false)) {
 				obj_cgroup_uncharge(objcg, obj_full_size(s));
 				continue;
 			}
@@ -383,7 +383,7 @@ static inline struct mem_cgroup *memcg_f
 
 static inline int memcg_alloc_page_obj_cgroups(struct page *page,
 					       struct kmem_cache *s, gfp_t gfp,
-					       bool atomic)
+					       bool new_page)
 {
 	return 0;
 }
@@ -428,7 +428,7 @@ static __always_inline void account_slab
 					      gfp_t gfp)
 {
 	if (memcg_kmem_enabled() && (s->flags & SLAB_ACCOUNT))
-		memcg_alloc_page_obj_cgroups(page, s, gfp, false);
+		memcg_alloc_page_obj_cgroups(page, s, gfp, true);
 
 	mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
 			    PAGE_SIZE << order);
_

Patches currently in -mm which might be from guro@fb.com are

mm-slub-call-account_slab_page-after-slab-page-initialization.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch


Return-Path: <SRS0=6wtZ=ED=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24EF9C56201
	for <mm-commits@archiver.kernel.org>; Wed, 28 Oct 2020 23:29:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D851D207CD
	for <mm-commits@archiver.kernel.org>; Wed, 28 Oct 2020 23:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603927753;
	bh=PSDss6g4++BtIaTiNFq7AChiRoPAiJfnpZwJ+MrQ3tg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=pQ7eydvbkogTt34zcdSYLZ1fk3mjrnTupzCjM5J9N+GYWXQiEL3J1Io3TfRSPr+nQ
	 r7A6yU2XsA+SJLMU+pDFj+Kq7uzaf3atXOFTdgiLpDqpHa/cuhP5nzE/N1IpKOd9DF
	 60XdkSl8zoCiyw3loa8+YLXHb7VaWNJwli6C2DqA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390489AbgJ1X3M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Oct 2020 19:29:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390488AbgJ1X3L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 28 Oct 2020 19:29:11 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11422207C4;
        Wed, 28 Oct 2020 23:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603927749;
        bh=PSDss6g4++BtIaTiNFq7AChiRoPAiJfnpZwJ+MrQ3tg=;
        h=Date:From:To:Subject:From;
        b=lffISK9UhBObVz5Jo5gSr6S3OmATkYjaVqQJEHgWeR78ElslOlH1fVBDBz44Aehyv
         Vk6y7VfmlrLlrqBQMK2Gi/sfYiaF+38bpxyjcgxVc8BAhCz5aLkZSV5/Blpq8og54b
         QQEdlk407RUEXUDsXPct8tGva9UiAfUWh4I5wqX4=
Date:   Wed, 28 Oct 2020 16:29:08 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  +
 mm-memcontrol-slab-use-helpers-to-access-slab-pages-memcg_data.patch added
 to -mm tree
Message-ID: <20201028232908.YJ5s_zavH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol/slab: use helpers to access slab page's memcg_data
has been added to the -mm tree.  Its filename is
     mm-memcontrol-slab-use-helpers-to-access-slab-pages-memcg_data.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-slab-use-helpers-to-access-slab-pages-memcg_data.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-slab-use-helpers-to-access-slab-pages-memcg_data.patch

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
Subject: mm: memcontrol/slab: use helpers to access slab page's memcg_data

To gather all direct accesses to struct page's memcg_data field in one
place, let's introduce 3 new helpers to use in the slab accounting code:

  struct obj_cgroup **page_objcgs(struct page *page);
  struct obj_cgroup **page_objcgs_check(struct page *page);
  bool set_page_objcgs(struct page *page, struct obj_cgroup **objcgs);

They are similar to the corresponding API for generic pages, except that
the setter can return false, indicating that the value has been already
set from a different thread.

Link: https://lkml.kernel.org/r/20201027001657.3398190-3-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   64 +++++++++++++++++++++++++++++++++++
 mm/memcontrol.c            |    6 +--
 mm/slab.h                  |   35 ++++---------------
 3 files changed, 75 insertions(+), 30 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-slab-use-helpers-to-access-slab-pages-memcg_data
+++ a/include/linux/memcontrol.h
@@ -416,6 +416,70 @@ static inline struct mem_cgroup *page_me
 	return (struct mem_cgroup *)memcg_data;
 }
 
+#ifdef CONFIG_MEMCG_KMEM
+/*
+ * page_objcgs - get the object cgroups vector associated with a page
+ * @page: a pointer to the page struct
+ *
+ * Returns a pointer to the object cgroups vector associated with the page,
+ * or NULL. This function assumes that the page is known to have an
+ * associated object cgroups vector. It's not safe to call this function
+ * against pages, which might have an associated memory cgroup: e.g.
+ * kernel stack pages.
+ */
+static inline struct obj_cgroup **page_objcgs(struct page *page)
+{
+	return (struct obj_cgroup **)(READ_ONCE(page->memcg_data) & ~0x1UL);
+}
+
+/*
+ * page_objcgs_check - get the object cgroups vector associated with a page
+ * @page: a pointer to the page struct
+ *
+ * Returns a pointer to the object cgroups vector associated with the page,
+ * or NULL. This function is safe to use if the page can be directly associated
+ * with a memory cgroup.
+ */
+static inline struct obj_cgroup **page_objcgs_check(struct page *page)
+{
+	unsigned long memcg_data = READ_ONCE(page->memcg_data);
+
+	if (memcg_data && (memcg_data & 0x1UL))
+		return (struct obj_cgroup **)(memcg_data & ~0x1UL);
+
+	return NULL;
+}
+
+/*
+ * set_page_objcgs - associate a page with a object cgroups vector
+ * @page: a pointer to the page struct
+ * @objcgs: a pointer to the object cgroups vector
+ *
+ * Atomically associates a page with a vector of object cgroups.
+ */
+static inline bool set_page_objcgs(struct page *page,
+					struct obj_cgroup **objcgs)
+{
+	return !cmpxchg(&page->memcg_data, 0, (unsigned long)objcgs | 0x1UL);
+}
+#else
+static inline struct obj_cgroup **page_objcgs(struct page *page)
+{
+	return NULL;
+}
+
+static inline struct obj_cgroup **page_objcgs_check(struct page *page)
+{
+	return NULL;
+}
+
+static inline bool set_page_objcgs(struct page *page,
+					struct obj_cgroup **objcgs)
+{
+	return true;
+}
+#endif
+
 static __always_inline bool memcg_stat_item_in_bytes(int idx)
 {
 	if (idx == MEMCG_PERCPU_B)
--- a/mm/memcontrol.c~mm-memcontrol-slab-use-helpers-to-access-slab-pages-memcg_data
+++ a/mm/memcontrol.c
@@ -2887,7 +2887,7 @@ int memcg_alloc_page_obj_cgroups(struct
 	if (!vec)
 		return -ENOMEM;
 
-	if (cmpxchg(&page->memcg_data, 0, (unsigned long)vec | 0x1UL))
+	if (!set_page_objcgs(page, vec))
 		kfree(vec);
 	else
 		kmemleak_not_leak(vec);
@@ -2921,12 +2921,12 @@ struct mem_cgroup *mem_cgroup_from_obj(v
 	 * Memcg membership data for each individual object is saved in
 	 * the page->obj_cgroups.
 	 */
-	if (page_has_obj_cgroups(page)) {
+	if (page_objcgs_check(page)) {
 		struct obj_cgroup *objcg;
 		unsigned int off;
 
 		off = obj_to_index(page->slab_cache, page, p);
-		objcg = page_obj_cgroups(page)[off];
+		objcg = page_objcgs(page)[off];
 		if (objcg)
 			return obj_cgroup_memcg(objcg);
 
--- a/mm/slab.h~mm-memcontrol-slab-use-helpers-to-access-slab-pages-memcg_data
+++ a/mm/slab.h
@@ -239,28 +239,12 @@ static inline bool kmem_cache_debug_flag
 }
 
 #ifdef CONFIG_MEMCG_KMEM
-static inline struct obj_cgroup **page_obj_cgroups(struct page *page)
-{
-	/*
-	 * Page's memory cgroup and obj_cgroups vector are sharing the same
-	 * space. To distinguish between them in case we don't know for sure
-	 * that the page is a slab page (e.g. page_cgroup_ino()), let's
-	 * always set the lowest bit of obj_cgroups.
-	 */
-	return (struct obj_cgroup **)(page->memcg_data & ~0x1UL);
-}
-
-static inline bool page_has_obj_cgroups(struct page *page)
-{
-	return page->memcg_data & 0x1UL;
-}
-
 int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
 				 gfp_t gfp);
 
 static inline void memcg_free_page_obj_cgroups(struct page *page)
 {
-	kfree(page_obj_cgroups(page));
+	kfree(page_objcgs(page));
 	page->memcg_data = 0;
 }
 
@@ -322,7 +306,7 @@ static inline void memcg_slab_post_alloc
 		if (likely(p[i])) {
 			page = virt_to_head_page(p[i]);
 
-			if (!page_has_obj_cgroups(page) &&
+			if (!page_objcgs(page) &&
 			    memcg_alloc_page_obj_cgroups(page, s, flags)) {
 				obj_cgroup_uncharge(objcg, obj_full_size(s));
 				continue;
@@ -330,7 +314,7 @@ static inline void memcg_slab_post_alloc
 
 			off = obj_to_index(s, page, p[i]);
 			obj_cgroup_get(objcg);
-			page_obj_cgroups(page)[off] = objcg;
+			page_objcgs(page)[off] = objcg;
 			mod_objcg_state(objcg, page_pgdat(page),
 					cache_vmstat_idx(s), obj_full_size(s));
 		} else {
@@ -344,6 +328,7 @@ static inline void memcg_slab_free_hook(
 					void **p, int objects)
 {
 	struct kmem_cache *s;
+	struct obj_cgroup **objcgs;
 	struct obj_cgroup *objcg;
 	struct page *page;
 	unsigned int off;
@@ -357,7 +342,8 @@ static inline void memcg_slab_free_hook(
 			continue;
 
 		page = virt_to_head_page(p[i]);
-		if (!page_has_obj_cgroups(page))
+		objcgs = page_objcgs(page);
+		if (!objcgs)
 			continue;
 
 		if (!s_orig)
@@ -366,11 +352,11 @@ static inline void memcg_slab_free_hook(
 			s = s_orig;
 
 		off = obj_to_index(s, page, p[i]);
-		objcg = page_obj_cgroups(page)[off];
+		objcg = objcgs[off];
 		if (!objcg)
 			continue;
 
-		page_obj_cgroups(page)[off] = NULL;
+		objcgs[off] = NULL;
 		obj_cgroup_uncharge(objcg, obj_full_size(s));
 		mod_objcg_state(objcg, page_pgdat(page), cache_vmstat_idx(s),
 				-obj_full_size(s));
@@ -379,11 +365,6 @@ static inline void memcg_slab_free_hook(
 }
 
 #else /* CONFIG_MEMCG_KMEM */
-static inline bool page_has_obj_cgroups(struct page *page)
-{
-	return false;
-}
-
 static inline struct mem_cgroup *memcg_from_slab_obj(void *ptr)
 {
 	return NULL;
_

Patches currently in -mm which might be from guro@fb.com are

mm-memcontrol-use-helpers-to-read-pages-memcg-data.patch
mm-memcontrol-slab-use-helpers-to-access-slab-pages-memcg_data.patch
mm-introduce-page-memcg-flags.patch
mm-convert-page-kmemcg-type-to-a-page-memcg-flag.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch


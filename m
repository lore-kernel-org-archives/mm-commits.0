Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1560C55ABD
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 20:50:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44C2A206B5
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 20:50:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="MMotLivj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgKJUuw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 15:50:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:58222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgKJUuw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 15:50:52 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C16F20665;
        Tue, 10 Nov 2020 20:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605041451;
        bh=2RLYt9BmeYj3vbxEtuVT37/i3Bcyzo8OevecHLgB7to=;
        h=Date:From:To:Subject:From;
        b=MMotLivjStbayCctU0xyxkS9Z8I3uQo+IQ35jm4SyByNdvUSo+qVW9gof8SmHFDjn
         mfZXhqaty2mtvj2TfWxDrKoqACAV49EILT/V5E/MPk2u7ag67WlWzN8t44iqPzMQ+h
         WVmOsl23wHtNaOcSunl1YfD/YV7ManhyPzbzLj0w=
Date:   Tue, 10 Nov 2020 12:50:50 -0800
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  +
 =?US-ASCII?Q?mm-memcg-slab-pre-allocate-obj=5Fcgroups-for-slab-caches-wit?=
 =?US-ASCII?Q?h-slab=5Faccount.patch?= added to -mm tree
Message-ID: <20201110205050.PglbuSC22%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg/slab: pre-allocate obj_cgroups for slab caches with SLAB_ACCOUNT
has been added to the -mm tree.  Its filename is
     mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account.patch

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
Subject: mm: memcg/slab: pre-allocate obj_cgroups for slab caches with SLAB_ACCOUNT

In general it's unknown in advance if a slab page will contain accounted
objects or not.  In order to avoid memory waste, an obj_cgroup vector is
allocated dynamically when a need to account of a new object arises.  Such
approach is memory efficient, but requires an expensive cmpxchg() to set
up the memcg/objcgs pointer, because an allocation can race with a
different allocation on another cpu.

But in some common cases it's known for sure that a slab page will contain
accounted objects: if the page belongs to a slab cache with a SLAB_ACCOUNT
flag set.  It includes such popular objects like vm_area_struct, anon_vma,
task_struct, etc.

In such cases we can pre-allocate the objcgs vector and simple assign it
to the page without any atomic operations, because at this early stage the
page is not visible to anyone else.

Link: https://lkml.kernel.org/r/20201110195753.530157-2-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   14 ++++++++++----
 mm/memcontrol.c            |    4 ++--
 mm/slab.c                  |    2 +-
 mm/slab.h                  |   14 ++++++++++----
 4 files changed, 23 insertions(+), 11 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account
+++ a/include/linux/memcontrol.h
@@ -484,14 +484,20 @@ static inline struct obj_cgroup **page_o
  * set_page_objcgs - associate a page with a object cgroups vector
  * @page: a pointer to the page struct
  * @objcgs: a pointer to the object cgroups vector
+ * @atomic: save the value atomically
  *
  * Atomically associates a page with a vector of object cgroups.
  */
 static inline bool set_page_objcgs(struct page *page,
-					struct obj_cgroup **objcgs)
+				   struct obj_cgroup **objcgs, bool atomic)
 {
-	return !cmpxchg(&page->memcg_data, 0, (unsigned long)objcgs |
-			MEMCG_DATA_OBJCGS);
+	unsigned long memcg_data = (unsigned long) objcgs | MEMCG_DATA_OBJCGS;
+
+	if (atomic)
+		return !cmpxchg(&page->memcg_data, 0, memcg_data);
+
+	page->memcg_data = memcg_data;
+	return true;
 }
 #else
 static inline struct obj_cgroup **page_objcgs(struct page *page)
@@ -505,7 +511,7 @@ static inline struct obj_cgroup **page_o
 }
 
 static inline bool set_page_objcgs(struct page *page,
-					struct obj_cgroup **objcgs)
+				   struct obj_cgroup **objcgs, bool atomic)
 {
 	return true;
 }
--- a/mm/memcontrol.c~mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account
+++ a/mm/memcontrol.c
@@ -2879,7 +2879,7 @@ static void commit_charge(struct page *p
 
 #ifdef CONFIG_MEMCG_KMEM
 int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
-				 gfp_t gfp)
+				 gfp_t gfp, bool atomic)
 {
 	unsigned int objects = objs_per_slab_page(s, page);
 	void *vec;
@@ -2889,7 +2889,7 @@ int memcg_alloc_page_obj_cgroups(struct
 	if (!vec)
 		return -ENOMEM;
 
-	if (!set_page_objcgs(page, vec))
+	if (!set_page_objcgs(page, vec, atomic))
 		kfree(vec);
 	else
 		kmemleak_not_leak(vec);
--- a/mm/slab.c~mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account
+++ a/mm/slab.c
@@ -1379,7 +1379,7 @@ static struct page *kmem_getpages(struct
 		return NULL;
 	}
 
-	account_slab_page(page, cachep->gfporder, cachep);
+	account_slab_page(page, cachep->gfporder, cachep, flags);
 	__SetPageSlab(page);
 	/* Record if ALLOC_NO_WATERMARKS was set when allocating the slab */
 	if (sk_memalloc_socks() && page_is_pfmemalloc(page))
--- a/mm/slab.h~mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account
+++ a/mm/slab.h
@@ -240,7 +240,7 @@ static inline bool kmem_cache_debug_flag
 
 #ifdef CONFIG_MEMCG_KMEM
 int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
-				 gfp_t gfp);
+				 gfp_t gfp, bool atomic);
 
 static inline void memcg_free_page_obj_cgroups(struct page *page)
 {
@@ -307,7 +307,8 @@ static inline void memcg_slab_post_alloc
 			page = virt_to_head_page(p[i]);
 
 			if (!page_objcgs(page) &&
-			    memcg_alloc_page_obj_cgroups(page, s, flags)) {
+			    memcg_alloc_page_obj_cgroups(page, s, flags,
+							 true)) {
 				obj_cgroup_uncharge(objcg, obj_full_size(s));
 				continue;
 			}
@@ -371,7 +372,8 @@ static inline struct mem_cgroup *memcg_f
 }
 
 static inline int memcg_alloc_page_obj_cgroups(struct page *page,
-					       struct kmem_cache *s, gfp_t gfp)
+					       struct kmem_cache *s, gfp_t gfp,
+					       bool atomic)
 {
 	return 0;
 }
@@ -412,8 +414,12 @@ static inline struct kmem_cache *virt_to
 }
 
 static __always_inline void account_slab_page(struct page *page, int order,
-					      struct kmem_cache *s)
+					      struct kmem_cache *s,
+					      gfp_t gfp)
 {
+	if (memcg_kmem_enabled() && (s->flags & SLAB_ACCOUNT))
+		memcg_alloc_page_obj_cgroups(page, s, gfp, false);
+
 	mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
 			    PAGE_SIZE << order);
 }
_

Patches currently in -mm which might be from guro@fb.com are

mm-memcontrol-use-helpers-to-read-pages-memcg-data.patch
mm-memcontrol-slab-use-helpers-to-access-slab-pages-memcg_data.patch
mm-introduce-page-memcg-flags.patch
mm-convert-page-kmemcg-type-to-a-page-memcg-flag.patch
mm-memcg-fix-obsolete-code-comments.patch
mm-slub-call-account_slab_page-after-slab-page-initialization.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch


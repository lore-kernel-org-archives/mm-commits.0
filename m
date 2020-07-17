Return-Path: <SRS0=ColI=A4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94D0FC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jul 2020 23:03:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B4E320759
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jul 2020 23:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595027034;
	bh=Zun/NYoo7uRQkLZCmYumsKEao+6GLmLZqi5p/Z0rhks=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=TsD9Mm+E1BnZSSGlxEB41yez+vdPlRCzyyAwtTnOPcp1t8X4C7wbuCjUhJ89aT21R
	 ttrFJVpquuw0tCWu7e3m+UrALSkvx/sLszyB/If9rLCoid1wcLpUWbPlXySVKvH5LE
	 0mvsB7FCwh1LvfdA2prZRBCuxG1V+/B4kNXR0qWw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgGQXDy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jul 2020 19:03:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:42328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726204AbgGQXDx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Jul 2020 19:03:53 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5D242070E;
        Fri, 17 Jul 2020 23:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595027032;
        bh=Zun/NYoo7uRQkLZCmYumsKEao+6GLmLZqi5p/Z0rhks=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Yj3ccvHxt4gfpu9xzULMMy5OzN6hlWlGXK81owA9EjQn3BzRvzeR9gSPRlKv8ZgV8
         7MH+qRNIGtnjrKmgEaPLXnRpsc41oRWTytWaq4lMPvQUxRLhAnlRNy9q5VII6FFox/
         AqrBfpDVNOtulqF9eydeAUB/0RW5zxqF9SxGYKbs=
Date:   Fri, 17 Jul 2020 16:03:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     guro@fb.com, mm-commits@vger.kernel.org, naresh.kamboju@linaro.org,
        sfr@canb.auug.org.au
Subject:  +
 mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-allocations-fix.patch
 added to -mm tree
Message-ID: <20200717230352.m_H8lrZE9%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slab/memcg: fix build on MIPS
has been added to the -mm tree.  Its filename is
     mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-allocations-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-allocations-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-allocations-fix.patch

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
Subject: mm: slab/memcg: fix build on MIPS

Naresh reported that linux-next build is broken on MIPS.  The problem is
reproducible using gcc 8 and 9, but not 10.

make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=mips
CROSS_COMPILE=mips-linux-gnu- HOSTCC=gcc CC="sccache
mips-linux-gnu-gcc" O=build
../mm/slub.c: In function `slab_alloc.constprop':
../mm/slub.c:2897:30: error: inlining failed in call to always_inline
`slab_alloc.constprop': recursive inlining
 2897 | static __always_inline void *slab_alloc(struct kmem_cache *s,
      |                              ^~~~~~~~~~
../mm/slub.c:2905:14: note: called from here
 2905 |  void *ret = slab_alloc(s, gfpflags, _RET_IP_);
      |              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../mm/slub.c: In function `sysfs_slab_alias':
../mm/slub.c:2897:30: error: inlining failed in call to always_inline
`slab_alloc.constprop': recursive inlining
 2897 | static __always_inline void *slab_alloc(struct kmem_cache *s,
      |                              ^~~~~~~~~~
../mm/slub.c:2905:14: note: called from here
 2905 |  void *ret = slab_alloc(s, gfpflags, _RET_IP_);
      |              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../mm/slub.c: In function `sysfs_slab_add':
../mm/slub.c:2897:30: error: inlining failed in call to always_inline
`slab_alloc.constprop': recursive inlining
 2897 | static __always_inline void *slab_alloc(struct kmem_cache *s,
      |                              ^~~~~~~~~~
../mm/slub.c:2905:14: note: called from here
 2905 |  void *ret = slab_alloc(s, gfpflags, _RET_IP_);
      |              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The problem was introduced by commit "mem: memcg/slab: use a single set of
kmem_caches for all allocations", which added an allocation of the space
for the obj_cgroup vector into the slab post hook and created a recursive
inlining.

The easies way to fix this is to move memcg_alloc_page_obj_cgroups() to
memcontrol.c and make it a generic (not static inline) function.  It
breaks the inlining recursion and fixes the build.

Link: http://lkml.kernel.org/r/20200717214810.3733082-1-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   20 ++++++++++++++++++++
 mm/slab.h       |   21 ++-------------------
 2 files changed, 22 insertions(+), 19 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-allocations-fix
+++ a/mm/memcontrol.c
@@ -2800,6 +2800,26 @@ static void commit_charge(struct page *p
 }
 
 #ifdef CONFIG_MEMCG_KMEM
+int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
+				 gfp_t gfp)
+{
+	unsigned int objects = objs_per_slab_page(s, page);
+	void *vec;
+
+	vec = kcalloc_node(objects, sizeof(struct obj_cgroup *), gfp,
+			   page_to_nid(page));
+	if (!vec)
+		return -ENOMEM;
+
+	if (cmpxchg(&page->obj_cgroups, NULL,
+		    (struct obj_cgroup **) ((unsigned long)vec | 0x1UL)))
+		kfree(vec);
+	else
+		kmemleak_not_leak(vec);
+
+	return 0;
+}
+
 /*
  * Returns a pointer to the memory cgroup to which the kernel object is charged.
  *
--- a/mm/slab.h~mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-allocations-fix
+++ a/mm/slab.h
@@ -257,25 +257,8 @@ static inline bool page_has_obj_cgroups(
 	return ((unsigned long)page->obj_cgroups & 0x1UL);
 }
 
-static inline int memcg_alloc_page_obj_cgroups(struct page *page,
-					       struct kmem_cache *s, gfp_t gfp)
-{
-	unsigned int objects = objs_per_slab_page(s, page);
-	void *vec;
-
-	vec = kcalloc_node(objects, sizeof(struct obj_cgroup *), gfp,
-			   page_to_nid(page));
-	if (!vec)
-		return -ENOMEM;
-
-	if (cmpxchg(&page->obj_cgroups, NULL,
-		    (struct obj_cgroup **) ((unsigned long)vec | 0x1UL)))
-		kfree(vec);
-	else
-		kmemleak_not_leak(vec);
-
-	return 0;
-}
+int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
+				 gfp_t gfp);
 
 static inline void memcg_free_page_obj_cgroups(struct page *page)
 {
_

Patches currently in -mm which might be from guro@fb.com are

mm-kmem-make-memcg_kmem_enabled-irreversible.patch
mm-memcg-factor-out-memcg-and-lruvec-level-changes-out-of-__mod_lruvec_state.patch
mm-memcg-prepare-for-byte-sized-vmstat-items.patch
mm-memcg-convert-vmstat-slab-counters-to-bytes.patch
mm-slub-implement-slub-version-of-obj_to_index.patch
mm-memcg-slab-obj_cgroup-api.patch
mm-memcg-slab-allocate-obj_cgroups-for-non-root-slab-pages.patch
mm-memcg-slab-save-obj_cgroup-for-non-root-slab-objects.patch
mm-memcg-slab-charge-individual-slab-objects-instead-of-pages.patch
mm-memcg-slab-deprecate-memorykmemslabinfo.patch
mm-memcg-slab-move-memcg_kmem_bypass-to-memcontrolh.patch
mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-accounted-allocations.patch
mm-memcg-slab-simplify-memcg-cache-creation.patch
mm-memcg-slab-remove-memcg_kmem_get_cache.patch
mm-memcg-slab-deprecate-slab_root_caches.patch
mm-memcg-slab-remove-redundant-check-in-memcg_accumulate_slabinfo.patch
mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-allocations.patch
mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-allocations-fix.patch
kselftests-cgroup-add-kernel-memory-accounting-tests.patch
tools-cgroup-add-memcg_slabinfopy-tool.patch
percpu-return-number-of-released-bytes-from-pcpu_free_area.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics-v3.patch
mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup.patch
kselftests-cgroup-add-perpcu-memory-accounting-test.patch
mm-memcg-slab-remove-unused-argument-by-charge_slab_page.patch
mm-slab-rename-uncharge_slab_page-to-unaccount_slab_page.patch
mm-kmem-switch-to-static_branch_likely-in-memcg_kmem_enabled.patch
mm-memcontrol-avoid-workload-stalls-when-lowering-memoryhigh.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch


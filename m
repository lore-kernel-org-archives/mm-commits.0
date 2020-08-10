Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC8AFC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:35:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86F35206C3
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026915;
	bh=9hA1HbXxsMzr9mP1knvTblRIdTfxIoHCEx3RjLDznnI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=vSLKKGU64DoDKz2M6Lnn7cdn5n7DvRvHYQ6Nc4ctn8x20g/1bUCkPAGRBo94xOwkr
	 vfwu21/a7+ZMgrMkMyN/L9pwkcDf6iDkBeSfVCHaKOfowRApplGPLYtz/fiVLTWhob
	 alQSXVzmA9pL8NZMkBxoNbDrYzb1yswt63kiXBEk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgHJCfP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:35:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCfP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:35:15 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BE902073E;
        Mon, 10 Aug 2020 02:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026914;
        bh=9hA1HbXxsMzr9mP1knvTblRIdTfxIoHCEx3RjLDznnI=;
        h=Date:From:To:Subject:From;
        b=Bx6hSM3gQTRHUA8BG+qmVOMkBWG1Yv6ybtuSfJYppGa1uoWi9K/mz8ue/CaG2KZfT
         ZTV1cxFtWmcXfgPtKvbuyWYKlBrNiZXfAP97QPSF+VkTDO/LTruSFngvbCuC7TOLL1
         Ce3I+EZg+dJdoV3jSRXoH7AOKFtWiwa28KhiRtp4=
Date:   Sun, 09 Aug 2020 19:35:14 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, jannh@google.com,
        keescook@chromium.org, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, vbabka@suse.cz,
        vjitta@codeaurora.org
Subject:  [merged]
 mm-slab-slub-move-and-improve-cache_from_obj.patch removed from -mm tree
Message-ID: <20200810023514.V-mKoOkZb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slab/slub: move and improve cache_from_obj()
has been removed from the -mm tree.  Its filename was
     mm-slab-slub-move-and-improve-cache_from_obj.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slab/slub: move and improve cache_from_obj()

The function cache_from_obj() was added by commit b9ce5ef49f00 ("sl[au]b:
always get the cache from its page in kmem_cache_free()") to support
kmemcg, where per-memcg cache can be different from the root one, so we
can't use the kmem_cache pointer given to kmem_cache_free().

Prior to that commit, SLUB already had debugging check+warning that could
be enabled to compare the given kmem_cache pointer to one referenced by
the slab page where the object-to-be-freed resides.  This check was moved
to cache_from_obj().  Later the check was also enabled for
SLAB_FREELIST_HARDENED configs by commit 598a0717a816 ("mm/slab: validate
cache membership under freelist hardening").

These checks and warnings can be useful especially for the debugging,
which can be improved.  Commit 598a0717a816 changed the pr_err() with
WARN_ON_ONCE() to WARN_ONCE() so only the first hit is now reported,
others are silent.  This patch changes it to WARN() so that all errors are
reported.

It's also useful to print SLUB allocation/free tracking info for the
offending object, if tracking is enabled.  We could export the SLUB
print_tracking() function and provide an empty one for SLAB, or realize
that both the debugging and hardening cases in cache_from_obj() are only
supported by SLUB anyway.  So this patch moves cache_from_obj() from
slab.h to separate instances in slab.c and slub.c, where the SLAB version
only does the kmemcg lookup and even could be completely removed once the
kmemcg rework [1] is merged.  The SLUB version can thus easily use the
print_tracking() function.  It can also use the kmem_cache_debug_flags()
static key check for improved performance in kernels without the hardening
and with debugging not enabled on boot.

[1] https://lore.kernel.org/r/20200608230654.828134-18-guro@fb.com

Link: http://lkml.kernel.org/r/20200610163135.17364-10-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    8 ++++++++
 mm/slab.h |   23 -----------------------
 mm/slub.c |   21 +++++++++++++++++++++
 3 files changed, 29 insertions(+), 23 deletions(-)

--- a/mm/slab.c~mm-slab-slub-move-and-improve-cache_from_obj
+++ a/mm/slab.c
@@ -3678,6 +3678,14 @@ void *__kmalloc_track_caller(size_t size
 }
 EXPORT_SYMBOL(__kmalloc_track_caller);
 
+static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
+{
+	if (memcg_kmem_enabled())
+		return virt_to_cache(x);
+	else
+		return s;
+}
+
 /**
  * kmem_cache_free - Deallocate an object
  * @cachep: The cache the allocation was from.
--- a/mm/slab.h~mm-slab-slub-move-and-improve-cache_from_obj
+++ a/mm/slab.h
@@ -504,29 +504,6 @@ static __always_inline void uncharge_sla
 	memcg_uncharge_slab(page, order, s);
 }
 
-static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
-{
-	struct kmem_cache *cachep;
-
-	/*
-	 * When kmemcg is not being used, both assignments should return the
-	 * same value. but we don't want to pay the assignment price in that
-	 * case. If it is not compiled in, the compiler should be smart enough
-	 * to not do even the assignment. In that case, slab_equal_or_root
-	 * will also be a constant.
-	 */
-	if (!memcg_kmem_enabled() &&
-	    !IS_ENABLED(CONFIG_SLAB_FREELIST_HARDENED) &&
-	    !unlikely(s->flags & SLAB_CONSISTENCY_CHECKS))
-		return s;
-
-	cachep = virt_to_cache(x);
-	WARN_ONCE(cachep && !slab_equal_or_root(cachep, s),
-		  "%s: Wrong slab cache. %s but object is from %s\n",
-		  __func__, s->name, cachep->name);
-	return cachep;
-}
-
 static inline size_t slab_ksize(const struct kmem_cache *s)
 {
 #ifndef CONFIG_SLUB
--- a/mm/slub.c~mm-slab-slub-move-and-improve-cache_from_obj
+++ a/mm/slub.c
@@ -1525,6 +1525,10 @@ static bool freelist_corrupted(struct km
 {
 	return false;
 }
+
+static void print_tracking(struct kmem_cache *s, void *object)
+{
+}
 #endif /* CONFIG_SLUB_DEBUG */
 
 /*
@@ -3171,6 +3175,23 @@ void ___cache_free(struct kmem_cache *ca
 }
 #endif
 
+static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
+{
+	struct kmem_cache *cachep;
+
+	if (!IS_ENABLED(CONFIG_SLAB_FREELIST_HARDENED) &&
+	    !memcg_kmem_enabled() &&
+	    !kmem_cache_debug_flags(s, SLAB_CONSISTENCY_CHECKS))
+		return s;
+
+	cachep = virt_to_cache(x);
+	if (WARN(cachep && !slab_equal_or_root(cachep, s),
+		  "%s: Wrong slab cache. %s but object is from %s\n",
+		  __func__, s->name, cachep->name))
+		print_tracking(cachep, x);
+	return cachep;
+}
+
 void kmem_cache_free(struct kmem_cache *s, void *x)
 {
 	s = cache_from_obj(s, x);
_

Patches currently in -mm which might be from vbabka@suse.cz are



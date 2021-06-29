Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59E92C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:23:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2930B61CF6
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbhF2AZe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 20:25:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231996AbhF2AZe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 20:25:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD5F061CF4;
        Tue, 29 Jun 2021 00:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624926187;
        bh=nhccjv8AcFInWW9XFD+OAKUB1wRWmtwuc5mleUVCKds=;
        h=Date:From:To:Subject:From;
        b=Er4ccuSMgdUYJUeFwniAfJXWrx8oJnjrVWGzS1mp+VN2gMGgRfM4oUv4rBfP+SNK5
         HdQN3CQOZWGcmE25JmvH5Z6RTCXrFVSfX06JasaT9e27KplbyF/U50DgcK2Cx/VWzt
         WHHmUl5YpV5tnYnR6lnwTK+ThdOuUfiG4ObSlN9s=
Date:   Mon, 28 Jun 2021 17:23:06 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org,
        iamjoonsoo.kim@lge.com, longman@redhat.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, shakeelb@google.com, vbabka@suse.cz,
        vdavydov.dev@gmail.com
Subject:  [folded-merged]
 mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-fix.patch removed
 from -mm tree
Message-ID: <20210629002306.RGtbiyj9Y%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg/slab: don't create kmalloc-cg caches with cgroup.memory=nokmem
has been removed from the -mm tree.  Its filename was
     mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-fix.patch

This patch was dropped because it was folded into mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: memcg/slab: don't create kmalloc-cg caches with cgroup.memory=nokmem

The caches should not be created when kmemcg is disabled on boot,
otherwise they are also filled by kmalloc(__GFP_ACCOUNT) allocations. 
When booted with cgroup.memory=nokmem, link the
kmalloc_caches[KMALLOC_CGROUP] entries to KMALLOC_NORMAL entries instead.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Waiman Long <longman@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h    |    5 +++++
 mm/memcontrol.c  |    2 +-
 mm/slab_common.c |    9 +++++++--
 3 files changed, 13 insertions(+), 3 deletions(-)

--- a/mm/internal.h~mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-fix
+++ a/mm/internal.h
@@ -116,6 +116,11 @@ extern void putback_lru_page(struct page
 extern pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address);
 
 /*
+ * in mm/memcontrol.c:
+ */
+extern bool cgroup_memory_nokmem;
+
+/*
  * in mm/page_alloc.c
  */
 
--- a/mm/memcontrol.c~mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-fix
+++ a/mm/memcontrol.c
@@ -83,7 +83,7 @@ DEFINE_PER_CPU(struct mem_cgroup *, int_
 static bool cgroup_memory_nosocket;
 
 /* Kernel memory accounting disabled? */
-static bool cgroup_memory_nokmem;
+bool cgroup_memory_nokmem;
 
 /* Whether the swap controller is active */
 #ifdef CONFIG_MEMCG_SWAP
--- a/mm/slab_common.c~mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-fix
+++ a/mm/slab_common.c
@@ -842,10 +842,15 @@ void __init setup_kmalloc_cache_index_ta
 static void __init
 new_kmalloc_cache(int idx, enum kmalloc_cache_type type, slab_flags_t flags)
 {
-	if (type == KMALLOC_RECLAIM)
+	if (type == KMALLOC_RECLAIM) {
 		flags |= SLAB_RECLAIM_ACCOUNT;
-	else if (IS_ENABLED(CONFIG_MEMCG_KMEM) && (type == KMALLOC_CGROUP))
+	} else if (IS_ENABLED(CONFIG_MEMCG_KMEM) && (type == KMALLOC_CGROUP)) {
+		if (cgroup_memory_nokmem) {
+			kmalloc_caches[type][idx] = kmalloc_caches[KMALLOC_NORMAL][idx];
+			return;
+		}
 		flags |= SLAB_ACCOUNT;
+	}
 
 	kmalloc_caches[type][idx] = create_kmalloc_cache(
 					kmalloc_info[idx].name[type],
_

Patches currently in -mm which might be from vbabka@suse.cz are

kunit-make-test-lock-irq-safe.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches.patch
mm-slub-use-stackdepot-to-save-stack-trace-in-objects-fix-2.patch


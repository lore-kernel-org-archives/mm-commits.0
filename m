Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F978C433B4
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 03:41:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D519461421
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 03:41:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhEIDm3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 23:42:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229558AbhEIDm3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 23:42:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE56F613CE;
        Sun,  9 May 2021 03:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620531686;
        bh=Lwwf66B446BpW9YnbpeMBmq8M/rf2ftlLCtX2nCSCi8=;
        h=Date:From:To:Subject:From;
        b=svPkSMtOCaxl077al4/hoRtcLpkav81U/dWQLgGG1saGNQi5UX2/mUIuOc5yHhD7z
         f2ifThho/w5QSy0rVGWTVg+9YlZy8fUGDg9fZ58OdEpkPpi9YOrcle3pHgUNOxEhAv
         XWSDYiJpKrKuJCjjBdb7xmTBY/wsdNUGAy113jI4=
Date:   Sat, 08 May 2021 20:41:25 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org,
        iamjoonsoo.kim@lge.com, longman@redhat.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, shakeelb@google.com, vbabka@suse.cz,
        vdavydov.dev@gmail.com
Subject:  +
 mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-fix.patch added to
 -mm tree
Message-ID: <20210509034125.bjgTg2PUi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg/slab: don't create kmalloc-cg caches with cgroup.memory=nokmem
has been added to the -mm tree.  Its filename is
     mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-slub-move-slub_debug-static-key-enabling-outside-slab_mutex.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-fix.patch


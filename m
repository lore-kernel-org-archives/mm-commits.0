Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 758B4C5519F
	for <mm-commits@archiver.kernel.org>; Wed, 18 Nov 2020 05:53:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0536524698
	for <mm-commits@archiver.kernel.org>; Wed, 18 Nov 2020 05:53:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0+J6xYZL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgKRFxW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Nov 2020 00:53:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:39832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgKRFxW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 18 Nov 2020 00:53:22 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E11F32468F;
        Wed, 18 Nov 2020 05:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605678801;
        bh=y8j5NuFgvyN790FFOLPVbCT+VP/LTubQJxCBstAarqw=;
        h=Date:From:To:Subject:From;
        b=0+J6xYZLXCZfQeskatb8TgWTjGWBPHgR5d/Wpg4p3F5j+mi8TmlrB2R2w2K2OdZ/g
         KNfuOADZNlB9jyVSOt8VFNIdIY3HOb5NVvwVULPLW8ohZkvu++OOhsoq3rAMghWsvi
         NtDKGVG8sQM5kl4x/g2CKVpi6k8bqKy/ZfejEmow=
Date:   Tue, 17 Nov 2020 21:53:20 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mm-commits@vger.kernel.org,
        shakeelb@google.com, songmuchun@bytedance.com
Subject:  +
 mm-memcg-slab-rename-_lruvec_slab_state-to-_lruvec_kmem_state.patch added
 to -mm tree
Message-ID: <20201118055320.Vr6mq7qfq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg/slab: rename *_lruvec_slab_state to *_lruvec_kmem_state
has been added to the -mm tree.  Its filename is
     mm-memcg-slab-rename-_lruvec_slab_state-to-_lruvec_kmem_state.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-slab-rename-_lruvec_slab_state-to-_lruvec_kmem_state.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-slab-rename-_lruvec_slab_state-to-_lruvec_kmem_state.patch

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
Subject: mm: memcg/slab: rename *_lruvec_slab_state to *_lruvec_kmem_state

The *_lruvec_slab_state is also suitable for pages allocated from buddy,
not just for the slab objects.  But the function name seems to tell us
that only slab object is applicable.  So we can rename the keyword of slab
to kmem.

Link: https://lkml.kernel.org/r/20201117085249.24319-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   18 +++++++++---------
 kernel/fork.c              |    2 +-
 mm/memcontrol.c            |    2 +-
 mm/workingset.c            |    8 ++++----
 4 files changed, 15 insertions(+), 15 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-slab-rename-_lruvec_slab_state-to-_lruvec_kmem_state
+++ a/include/linux/memcontrol.h
@@ -817,15 +817,15 @@ void __mod_memcg_lruvec_state(struct lru
 			      int val);
 void __mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			int val);
-void __mod_lruvec_slab_state(void *p, enum node_stat_item idx, int val);
+void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val);
 
-static inline void mod_lruvec_slab_state(void *p, enum node_stat_item idx,
+static inline void mod_lruvec_kmem_state(void *p, enum node_stat_item idx,
 					 int val)
 {
 	unsigned long flags;
 
 	local_irq_save(flags);
-	__mod_lruvec_slab_state(p, idx, val);
+	__mod_lruvec_kmem_state(p, idx, val);
 	local_irq_restore(flags);
 }
 
@@ -1291,7 +1291,7 @@ static inline void mod_lruvec_page_state
 	mod_node_page_state(page_pgdat(page), idx, val);
 }
 
-static inline void __mod_lruvec_slab_state(void *p, enum node_stat_item idx,
+static inline void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx,
 					   int val)
 {
 	struct page *page = virt_to_head_page(p);
@@ -1299,7 +1299,7 @@ static inline void __mod_lruvec_slab_sta
 	__mod_node_page_state(page_pgdat(page), idx, val);
 }
 
-static inline void mod_lruvec_slab_state(void *p, enum node_stat_item idx,
+static inline void mod_lruvec_kmem_state(void *p, enum node_stat_item idx,
 					 int val)
 {
 	struct page *page = virt_to_head_page(p);
@@ -1398,14 +1398,14 @@ static inline void __dec_lruvec_page_sta
 	__mod_lruvec_page_state(page, idx, -1);
 }
 
-static inline void __inc_lruvec_slab_state(void *p, enum node_stat_item idx)
+static inline void __inc_lruvec_kmem_state(void *p, enum node_stat_item idx)
 {
-	__mod_lruvec_slab_state(p, idx, 1);
+	__mod_lruvec_kmem_state(p, idx, 1);
 }
 
-static inline void __dec_lruvec_slab_state(void *p, enum node_stat_item idx)
+static inline void __dec_lruvec_kmem_state(void *p, enum node_stat_item idx)
 {
-	__mod_lruvec_slab_state(p, idx, -1);
+	__mod_lruvec_kmem_state(p, idx, -1);
 }
 
 /* idx can be of type enum memcg_stat_item or node_stat_item */
--- a/kernel/fork.c~mm-memcg-slab-rename-_lruvec_slab_state-to-_lruvec_kmem_state
+++ a/kernel/fork.c
@@ -385,7 +385,7 @@ static void account_kernel_stack(struct
 		mod_lruvec_page_state(vm->pages[0], NR_KERNEL_STACK_KB,
 				      account * (THREAD_SIZE / 1024));
 	else
-		mod_lruvec_slab_state(stack, NR_KERNEL_STACK_KB,
+		mod_lruvec_kmem_state(stack, NR_KERNEL_STACK_KB,
 				      account * (THREAD_SIZE / 1024));
 }
 
--- a/mm/memcontrol.c~mm-memcg-slab-rename-_lruvec_slab_state-to-_lruvec_kmem_state
+++ a/mm/memcontrol.c
@@ -856,7 +856,7 @@ void __mod_lruvec_state(struct lruvec *l
 		__mod_memcg_lruvec_state(lruvec, idx, val);
 }
 
-void __mod_lruvec_slab_state(void *p, enum node_stat_item idx, int val)
+void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
 {
 	pg_data_t *pgdat = page_pgdat(virt_to_page(p));
 	struct mem_cgroup *memcg;
--- a/mm/workingset.c~mm-memcg-slab-rename-_lruvec_slab_state-to-_lruvec_kmem_state
+++ a/mm/workingset.c
@@ -443,12 +443,12 @@ void workingset_update_node(struct xa_no
 	if (node->count && node->count == node->nr_values) {
 		if (list_empty(&node->private_list)) {
 			list_lru_add(&shadow_nodes, &node->private_list);
-			__inc_lruvec_slab_state(node, WORKINGSET_NODES);
+			__inc_lruvec_kmem_state(node, WORKINGSET_NODES);
 		}
 	} else {
 		if (!list_empty(&node->private_list)) {
 			list_lru_del(&shadow_nodes, &node->private_list);
-			__dec_lruvec_slab_state(node, WORKINGSET_NODES);
+			__dec_lruvec_kmem_state(node, WORKINGSET_NODES);
 		}
 	}
 }
@@ -542,7 +542,7 @@ static enum lru_status shadow_lru_isolat
 	}
 
 	list_lru_isolate(lru, item);
-	__dec_lruvec_slab_state(node, WORKINGSET_NODES);
+	__dec_lruvec_kmem_state(node, WORKINGSET_NODES);
 
 	spin_unlock(lru_lock);
 
@@ -557,7 +557,7 @@ static enum lru_status shadow_lru_isolat
 		goto out_invalid;
 	mapping->nrexceptional -= node->nr_values;
 	xa_delete_node(node, workingset_update_node);
-	__inc_lruvec_slab_state(node, WORKINGSET_NODERECLAIM);
+	__inc_lruvec_kmem_state(node, WORKINGSET_NODERECLAIM);
 
 out_invalid:
 	xa_unlock_irq(&mapping->i_pages);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcg-slab-fix-root-memcg-vmstats.patch
mm-memcontrol-remove-unused-mod_memcg_obj_state.patch
mm-memcg-slab-fix-return-child-memcg-objcg-for-root-memcg.patch
mm-memcg-slab-fix-use-after-free-in-obj_cgroup_charge.patch
mm-memcg-slab-rename-_lruvec_slab_state-to-_lruvec_kmem_state.patch


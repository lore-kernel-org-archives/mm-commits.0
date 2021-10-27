Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43162C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 21:24:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24BAF610C7
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 21:24:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236119AbhJ0V0k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Oct 2021 17:26:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232126AbhJ0VZH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Oct 2021 17:25:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF35860231;
        Wed, 27 Oct 2021 21:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635369762;
        bh=SjwUuEQcFribBmQ2xOxm1/7MbnZ3iVbOm+hb8ccCum4=;
        h=Date:From:To:Subject:From;
        b=o9dtMn7p5oSVGbii4BMmckJDN6vuzB0VSPdTMlRwL0AShdRk0Tgu17G5rnTDpvPZq
         2b/6ni/GFTmVNDCbKRaOhUdYgbbgvAcZ4FnB74VI1isdNuqkUci8ntasM5vzd0jA3S
         Ps7asHjwRYi6S7qn6qjEgzIG8masXcL/EDOTI99E=
Date:   Wed, 27 Oct 2021 14:22:41 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, willy@infradead.org
Subject:  +
 mm-list_lru-only-add-memcg-aware-lrus-to-the-global-lru-list.patch added to
 -mm tree
Message-ID: <20211027212241.mdh1g7BcY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: list_lru: only add memcg-aware lrus to the global lru list
has been added to the -mm tree.  Its filename is
     mm-list_lru-only-add-memcg-aware-lrus-to-the-global-lru-list.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-list_lru-only-add-memcg-aware-lrus-to-the-global-lru-list.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-list_lru-only-add-memcg-aware-lrus-to-the-global-lru-list.patch

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
Subject: mm: list_lru: only add memcg-aware lrus to the global lru list

The non-memcg-aware lru is always skiped when traversing the global lru
list, which is not efficient.  We can only add the memcg-aware lru to the
global lru list instead to make traversing more efficient.

Link: https://lkml.kernel.org/r/20211025124353.55781-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |   35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

--- a/mm/list_lru.c~mm-list_lru-only-add-memcg-aware-lrus-to-the-global-lru-list
+++ a/mm/list_lru.c
@@ -15,18 +15,29 @@
 #include "slab.h"
 
 #ifdef CONFIG_MEMCG_KMEM
-static LIST_HEAD(list_lrus);
+static LIST_HEAD(memcg_list_lrus);
 static DEFINE_MUTEX(list_lrus_mutex);
 
+static inline bool list_lru_memcg_aware(struct list_lru *lru)
+{
+	return lru->memcg_aware;
+}
+
 static void list_lru_register(struct list_lru *lru)
 {
+	if (!list_lru_memcg_aware(lru))
+		return;
+
 	mutex_lock(&list_lrus_mutex);
-	list_add(&lru->list, &list_lrus);
+	list_add(&lru->list, &memcg_list_lrus);
 	mutex_unlock(&list_lrus_mutex);
 }
 
 static void list_lru_unregister(struct list_lru *lru)
 {
+	if (!list_lru_memcg_aware(lru))
+		return;
+
 	mutex_lock(&list_lrus_mutex);
 	list_del(&lru->list);
 	mutex_unlock(&list_lrus_mutex);
@@ -37,11 +48,6 @@ static int lru_shrinker_id(struct list_l
 	return lru->shrinker_id;
 }
 
-static inline bool list_lru_memcg_aware(struct list_lru *lru)
-{
-	return lru->memcg_aware;
-}
-
 static inline struct list_lru_one *
 list_lru_from_memcg_idx(struct list_lru_node *nlru, int idx)
 {
@@ -457,9 +463,6 @@ static int memcg_update_list_lru(struct
 {
 	int i;
 
-	if (!list_lru_memcg_aware(lru))
-		return 0;
-
 	for_each_node(i) {
 		if (memcg_update_list_lru_node(&lru->node[i],
 					       old_size, new_size))
@@ -482,9 +485,6 @@ static void memcg_cancel_update_list_lru
 {
 	int i;
 
-	if (!list_lru_memcg_aware(lru))
-		return;
-
 	for_each_node(i)
 		memcg_cancel_update_list_lru_node(&lru->node[i],
 						  old_size, new_size);
@@ -497,7 +497,7 @@ int memcg_update_all_list_lrus(int new_s
 	int old_size = memcg_nr_cache_ids;
 
 	mutex_lock(&list_lrus_mutex);
-	list_for_each_entry(lru, &list_lrus, list) {
+	list_for_each_entry(lru, &memcg_list_lrus, list) {
 		ret = memcg_update_list_lru(lru, old_size, new_size);
 		if (ret)
 			goto fail;
@@ -506,7 +506,7 @@ out:
 	mutex_unlock(&list_lrus_mutex);
 	return ret;
 fail:
-	list_for_each_entry_continue_reverse(lru, &list_lrus, list)
+	list_for_each_entry_continue_reverse(lru, &memcg_list_lrus, list)
 		memcg_cancel_update_list_lru(lru, old_size, new_size);
 	goto out;
 }
@@ -543,9 +543,6 @@ static void memcg_drain_list_lru(struct
 {
 	int i;
 
-	if (!list_lru_memcg_aware(lru))
-		return;
-
 	for_each_node(i)
 		memcg_drain_list_lru_node(lru, i, src_idx, dst_memcg);
 }
@@ -555,7 +552,7 @@ void memcg_drain_all_list_lrus(int src_i
 	struct list_lru *lru;
 
 	mutex_lock(&list_lrus_mutex);
-	list_for_each_entry(lru, &list_lrus, list)
+	list_for_each_entry(lru, &memcg_list_lrus, list)
 		memcg_drain_list_lru(lru, src_idx, dst_memcg);
 	mutex_unlock(&list_lrus_mutex);
 }
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-list_lru-remove-holding-lru-lock.patch
mm-list_lru-fix-the-return-value-of-list_lru_count_one.patch
mm-memcontrol-remove-kmemcg_id-reparenting.patch
mm-memcontrol-remove-the-kmem-states.patch
mm-list_lru-only-add-memcg-aware-lrus-to-the-global-lru-list.patch


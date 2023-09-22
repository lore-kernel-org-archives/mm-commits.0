Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E45FCD4844
	for <mm-commits@archiver.kernel.org>; Fri, 22 Sep 2023 16:57:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjIVQ5c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Sep 2023 12:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231905AbjIVQ5b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Sep 2023 12:57:31 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C143199
        for <mm-commits@vger.kernel.org>; Fri, 22 Sep 2023 09:57:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E67C433C7;
        Fri, 22 Sep 2023 16:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695401844;
        bh=losXbAXC9NZY2mYeD1CXV12K6/awBjHuQ3kzapxPDqk=;
        h=Date:To:From:Subject:From;
        b=nyJ3z5Vrp2Iq2WMtUROZltsLLxewxOIq9y6HjeqXDx060gWO3/ij4ugjDaFQgNWB2
         fQ4DceXG5TUMfrZOlkfuJOsMf3I+StaIEl2p0opwBUlnlhNZYnjKDq4x81k8Zk3kU6
         h7wwYHS282iiYaaPD2JNFYpmRq1oZ+wMnzQAjZOA=
Date:   Fri, 22 Sep 2023 09:57:23 -0700
To:     mm-commits@vger.kernel.org, abaci@linux.alibaba.com,
        jiapeng.chong@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-list_lru-remove-unused-function.patch added to mm-nonmm-unstable branch
Message-Id: <20230922165724.87E67C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/list_lru: remove unused function
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-list_lru-remove-unused-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-list_lru-remove-unused-function.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: mm/list_lru: remove unused function
Date: Fri, 22 Sep 2023 18:07:47 +0800

The function is defined in list_lru.c, but not called elsewhere, so delete
the unused function.

mm/list_lru.c:64:1: warning: unused function 'list_lru_from_kmem'.

Link: https://lkml.kernel.org/r/20230922100747.17045-1-jiapeng.chong@linux.alibaba.com
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=6677
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |   30 ------------------------------
 1 file changed, 30 deletions(-)

--- a/mm/list_lru.c~mm-list_lru-remove-unused-function
+++ a/mm/list_lru.c
@@ -60,27 +60,6 @@ list_lru_from_memcg_idx(struct list_lru
 	return &lru->node[nid].lru;
 }
 
-static inline struct list_lru_one *
-list_lru_from_kmem(struct list_lru *lru, int nid, void *ptr,
-		   struct mem_cgroup **memcg_ptr)
-{
-	struct list_lru_node *nlru = &lru->node[nid];
-	struct list_lru_one *l = &nlru->lru;
-	struct mem_cgroup *memcg = NULL;
-
-	if (!list_lru_memcg_aware(lru))
-		goto out;
-
-	memcg = mem_cgroup_from_slab_obj(ptr);
-	if (!memcg)
-		goto out;
-
-	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
-out:
-	if (memcg_ptr)
-		*memcg_ptr = memcg;
-	return l;
-}
 #else
 static void list_lru_register(struct list_lru *lru)
 {
@@ -105,15 +84,6 @@ list_lru_from_memcg_idx(struct list_lru
 {
 	return &lru->node[nid].lru;
 }
-
-static inline struct list_lru_one *
-list_lru_from_kmem(struct list_lru *lru, int nid, void *ptr,
-		   struct mem_cgroup **memcg_ptr)
-{
-	if (memcg_ptr)
-		*memcg_ptr = NULL;
-	return &lru->node[nid].lru;
-}
 #endif /* CONFIG_MEMCG_KMEM */
 
 bool list_lru_add(struct list_lru *lru, struct list_head *item)
_

Patches currently in -mm which might be from jiapeng.chong@linux.alibaba.com are

mm-list_lru-remove-unused-function.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40A68C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  1 Feb 2022 21:33:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbiBAVd2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Feb 2022 16:33:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50562 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiBAVd0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2022 16:33:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0631616EA
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 21:33:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F3FC340EB;
        Tue,  1 Feb 2022 21:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643751205;
        bh=bl92YtqEWrzZXK/WwtSa/+EcJ/+vNndzzgQKeUQQAzw=;
        h=Date:To:From:Subject:From;
        b=qD4D5yQGJr0dCqBGZL1rD//OqtyoVfU/76bQkrhKm55vrK8/XYDevrhIB7H8Mi4Gy
         O6nRSRctdwDJMOe8UL69J9sCBhzGWi6WVK42Fkl2lZ4qzZ4CO99kdWBj6Fbpi+lhLm
         qm27F978tmyFQeOlqgNXNB8MBTivjwrLFO5S1M1Q=
Received: by hp1 (sSMTP sendmail emulation); Tue, 01 Feb 2022 13:33:23 -0800
Date:   Tue, 01 Feb 2022 13:33:23 -0800
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com, vbabka@suse.cz,
        surenb@google.com, songmuchun@bytedance.com, shy828301@gmail.com,
        shakeelb@google.com, rppt@linux.ibm.com, mhocko@suse.com,
        hannes@cmpxchg.org, guro@fb.com, richard.weiyang@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-retrieve-parent-memcg-from-cssparent.patch added to -mm tree
Message-Id: <20220201213323.D3F3FC340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: retrieve parent memcg from css.parent
has been added to the -mm tree.  Its filename is
     mm-memcg-retrieve-parent-memcg-from-cssparent.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-retrieve-parent-memcg-from-cssparent.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-retrieve-parent-memcg-from-cssparent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/memcg: retrieve parent memcg from css.parent

The parent we get from page_counter is correct, while this is two
different hierarchy.

Let's retrieve the parent memcg from css.parent just like parent_cs(),
blkcg_parent(), etc.

Link: https://lkml.kernel.org/r/20220201004643.8391-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-retrieve-parent-memcg-from-cssparent
+++ a/include/linux/memcontrol.h
@@ -841,9 +841,7 @@ static inline struct mem_cgroup *lruvec_
  */
 static inline struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg)
 {
-	if (!memcg->memory.parent)
-		return NULL;
-	return mem_cgroup_from_counter(memcg->memory.parent, memory);
+	return mem_cgroup_from_css(memcg->css.parent);
 }
 
 static inline bool mem_cgroup_is_descendant(struct mem_cgroup *memcg,
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-memcg-mem_cgroup_per_node-is-already-set-to-0-on-allocation.patch
mm-memcg-retrieve-parent-memcg-from-cssparent.patch
mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch
mm-page_alloc-add-penalty-to-local_node.patch
memcg-do-not-tweak-node-in-alloc_mem_cgroup_per_node_info.patch


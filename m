Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81347C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:03:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbjHKXD0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236020AbjHKXBq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:01:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3614209
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 615C862BDB
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DE2C433C7;
        Fri, 11 Aug 2023 23:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794854;
        bh=x7p/I6Th4qRJGD4DH5aQ1hYodBMfzvfhLMDewjzqvPc=;
        h=Date:To:From:Subject:From;
        b=grLgLVZAXbD6tLyjb+jLUSfMTUU2QwmWkCchdGS4h0V7Mu8hf1SYuRS/4kYjbUIGa
         QNDL4OD/CPzLbavA5sRDHf1qTu7wZKJToTCkjmQLb+BFYWG4Rg0Hov/UoXvC9HlBOj
         0IMltlH5wuUQVe/Mcm+FD/mn8xxdEwOAO1Bm4MgQ=
Date:   Fri, 11 Aug 2023 16:00:54 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-fix-obsolete-comment-above-mem_cgroup_max_reclaim_loops.patch removed from -mm tree
Message-Id: <20230811230054.B8DE2C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memcg: fix obsolete comment above MEM_CGROUP_MAX_RECLAIM_LOOPS
has been removed from the -mm tree.  Its filename was
     mm-memcg-fix-obsolete-comment-above-mem_cgroup_max_reclaim_loops.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memcg: fix obsolete comment above MEM_CGROUP_MAX_RECLAIM_LOOPS
Date: Thu, 13 Jul 2023 20:14:32 +0800

Since commit 5660048ccac8 ("mm: move memcg hierarchy reclaim to generic
reclaim code"), mem_cgroup_hierarchical_reclaim() is already renamed to
mem_cgroup_soft_reclaim().  Update the corresponding comment.

Link: https://lkml.kernel.org/r/20230713121432.273381-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-fix-obsolete-comment-above-mem_cgroup_max_reclaim_loops
+++ a/mm/memcontrol.c
@@ -197,7 +197,7 @@ static struct move_charge_struct {
 };
 
 /*
- * Maximum loops in mem_cgroup_hierarchical_reclaim(), used for soft
+ * Maximum loops in mem_cgroup_soft_reclaim(), used for soft
  * limit reclaim to prevent infinite loops, if they ever occur.
  */
 #define	MEM_CGROUP_MAX_RECLAIM_LOOPS		100
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch
mm-memcg-fix-obsolete-function-name-in-mem_cgroup_protection.patch
mm-memory-failure-add-pageoffline-check.patch
mm-page_alloc-avoid-unneeded-alike_pages-calculation.patch
mm-memcg-update-obsolete-comment-above-parent_mem_cgroup.patch
mm-page_alloc-remove-unneeded-variable-base.patch
mm-memcg-fix-wrong-function-name-above-obj_cgroup_charge_zswap.patch
mm-memory-failure-use-helper-macro-llist_for_each_entry_safe.patch
mm-mm_init-use-helper-macro-bits_per_long-and-bits_per_byte.patch


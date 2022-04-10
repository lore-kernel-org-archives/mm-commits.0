Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA080C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 10 Apr 2022 04:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbiDJEl3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Apr 2022 00:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231939AbiDJElY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 10 Apr 2022 00:41:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52FE42459A
        for <mm-commits@vger.kernel.org>; Sat,  9 Apr 2022 21:39:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC0CEB80B89
        for <mm-commits@vger.kernel.org>; Sun, 10 Apr 2022 04:39:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE9BC385A5;
        Sun, 10 Apr 2022 04:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649565549;
        bh=ZevUxo+h5JR4KWuIEIWX5oUkrsrPXM3xvzZxcGyHYEk=;
        h=Date:To:From:Subject:From;
        b=i/biNLjUcv/l6c6GEad3PABqWEjCApK9tv3L2GFBwhPAWUGIbxldQhUisKSM4i3pv
         EosyRtS7NV70zHwEKYPC2eYAnNoc1n/RF4I73byzv0nAebmjf+WcikjOWTkUCuUlmq
         p7o3v9NJjh8A39AKMLoJM6/tksdMO2D6UkE81wM8=
Date:   Sat, 09 Apr 2022 21:39:08 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@suse.com,
        longman@redhat.com, hannes@cmpxchg.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-list_lruc-revert-mm-list_lru-optimize-memcg_reparent_list_lru_node.patch removed from -mm tree
Message-Id: <20220410043909.8AE9BC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/list_lru.c: revert "mm/list_lru: optimize memcg_reparent_list_lru_node()"
has been removed from the -mm tree.  Its filename was
     mm-list_lruc-revert-mm-list_lru-optimize-memcg_reparent_list_lru_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/list_lru.c: revert "mm/list_lru: optimize memcg_reparent_list_lru_node()"

405cc51fc1049c73 ("mm/list_lru: optimize memcg_reparent_list_lru_node()")
has subtle races which are proving ugly to fix.  Revert the original
optimization.  If quantitative testing indicates that we have a
significant problem here then other implementations can be looked at.

Fixes: 405cc51fc1049c73 ("mm/list_lru: optimize memcg_reparent_list_lru_node()")
Acked-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/list_lru.c~mm-list_lruc-revert-mm-list_lru-optimize-memcg_reparent_list_lru_node
+++ a/mm/list_lru.c
@@ -395,12 +395,6 @@ static void memcg_reparent_list_lru_node
 	struct list_lru_one *src, *dst;
 
 	/*
-	 * If there is no lru entry in this nlru, we can skip it immediately.
-	 */
-	if (!READ_ONCE(nlru->nr_items))
-		return;
-
-	/*
 	 * Since list_lru_{add,del} may be called under an IRQ-safe lock,
 	 * we have to use IRQ-safe primitives here to avoid deadlock.
 	 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-create-new-mm-swaph-header-file-fix.patch
mm-shmem-make-shmem_init-return-void-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch


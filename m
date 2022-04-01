Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9980AC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  1 Apr 2022 01:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiDABN1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 21:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239082AbiDABN0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 21:13:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4036F236BB8
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 18:11:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDAA0B822B1
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 01:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DBF8C340EE;
        Fri,  1 Apr 2022 01:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648775495;
        bh=V1Cd+4tfMSrD4EshodDcrTyIpQ8nyzICR6Alw3BhmgY=;
        h=Date:To:From:Subject:From;
        b=gdtyi0cKqpkL9qtm/b4ERf3ypDpltYVaIeNXPgthRmb7iOSlzE0Ln7MXmFC78Yybu
         q/4ZOa2rHfuOvqYobXximPx/Rlh9iaGwSMCsxYXHpVLy9K51xVBpUgOHwzGRrkYGPi
         3TmpExdoYXMwNYAPTKRSsooFTlWxTy6B6g8Tferc=
Date:   Thu, 31 Mar 2022 18:11:34 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@suse.com,
        longman@redhat.com, hannes@cmpxchg.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-list_lruc-revert-mm-list_lru-optimize-memcg_reparent_list_lru_node.patch added to -mm tree
Message-Id: <20220401011135.6DBF8C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/list_lru.c: revert "mm/list_lru: optimize memcg_reparent_list_lru_node()"
has been added to the -mm tree.  Its filename is
     mm-list_lruc-revert-mm-list_lru-optimize-memcg_reparent_list_lru_node.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-list_lruc-revert-mm-list_lru-optimize-memcg_reparent_list_lru_node.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-list_lruc-revert-mm-list_lru-optimize-memcg_reparent_list_lru_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/list_lru.c: revert "mm/list_lru: optimize memcg_reparent_list_lru_node()"

405cc51fc1049c73 ("mm/list_lru: optimize memcg_reparent_list_lru_node()")
has subtle races which are proving ugly to fix.  Revert the original
optimization.  If quantitative testing indicates that we have a
significant problem here then other implementations can be looked at.

Fixes: 405cc51fc1049c73 ("mm/list_lru: optimize memcg_reparent_list_lru_node()")
Cc: Waiman Long <longman@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
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

mm-list_lruc-revert-mm-list_lru-optimize-memcg_reparent_list_lru_node.patch
mm.patch
mm-shmem-make-shmem_init-return-void-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
b.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 895C9C7EE43
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:12:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbjFIXL7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbjFIXL6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:11:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678A52D52
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:11:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06A3064C41
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:11:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5958DC433D2;
        Fri,  9 Jun 2023 23:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686352316;
        bh=pensDyAatPyUUHOE06TTMaCmJQEITPT5MvvYK2MaRQk=;
        h=Date:To:From:Subject:From;
        b=AJppoeL4GX9yRSjMVwy9yyEWfn+qozpuPepA1vHO8lrEVklF7VLN2+UeDV0S0e5x3
         Ph4wpNA1EOZGs6J2kx5qEvUf6KqHGFkGAVp65o1LkkUaPOX+AT2gnOFyktPxxZHB67
         agxoi+kgqf7J5V6Z+2XRqKpwpvw8oJ4aeZkFfoWY=
Date:   Fri, 09 Jun 2023 16:11:55 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        syzbot+3c6cac1550288f8e7060@syzkaller.appspotmail.com,
        nphamcs@gmail.com, mtk.manpages@gmail.com, hannes@cmpxchg.org,
        bfoster@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] workingset-refactor-lru-refault-to-expose-refault-recency-check-fix.patch removed from -mm tree
Message-Id: <20230609231156.5958DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: workingset: add missing rcu_read_unlock() in lru_gen_refault()
has been removed from the -mm tree.  Its filename was
     workingset-refactor-lru-refault-to-expose-refault-recency-check-fix.patch

This patch was dropped because it was folded into workingset-refactor-lru-refault-to-expose-refault-recency-check.patch

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: workingset: add missing rcu_read_unlock() in lru_gen_refault()
Date: Wed, 10 May 2023 07:22:55 +0900

syzbot is reporting sleep in RCU context, for commit d66c718d28ac
("workingset: refactor LRU refault to expose refault recency check")
missed rcu_read_unlock().

Link: https://lkml.kernel.org/r/610781bc-cf11-fc89-a46f-87cb8235d439@I-love.SAKURA.ne.jp
Reported-by: syzbot <syzbot+3c6cac1550288f8e7060@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=3c6cac1550288f8e7060
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: d66c718d28ac ("workingset: refactor LRU refault to expose refault recency check")
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/workingset.c~workingset-refactor-lru-refault-to-expose-refault-recency-check-fix
+++ a/mm/workingset.c
@@ -303,7 +303,7 @@ static void lru_gen_refault(struct folio
 		goto unlock;
 
 	if (pgdat != folio_pgdat(folio))
-		return;
+		goto unlock;
 
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
 	lrugen = &lruvec->lrugen;
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

workingset-refactor-lru-refault-to-expose-refault-recency-check.patch
mm-page_alloc-dont-wake-kswapd-from-rmqueue-unless-__gfp_kswapd_reclaim-is-specified.patch
kasankmsan-remove-__gfp_kswapd_reclaim-usage-from-kasan-kmsan.patch


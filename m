Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1DCDC77B75
	for <mm-commits@archiver.kernel.org>; Fri, 12 May 2023 20:52:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238678AbjELUwP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 May 2023 16:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbjELUwO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2023 16:52:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470DA1FE5
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 13:52:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD4636159B
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 20:52:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262EDC433D2;
        Fri, 12 May 2023 20:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683924732;
        bh=QYw8Xb3dFLu5GayJl+aBtLlnonJPYmDmRd73o7Y9Nck=;
        h=Date:To:From:Subject:From;
        b=EALmigtU9Wb/Lv9wxRAMb2akIT4R3Kkjqo46YPHMPA2QPoDXRCxgQrlNLHy2Vcusi
         FvRtjvLUkkx0pjMZYqme9MSEn9TRvhO6LW01IgYp8A2gCtr0Bur9Wyp4pP5eJmRJ0D
         VZhdg/aLmv1TsL4RXUUV3+JlzVrTeW3ysTdQDIsQ=
Date:   Fri, 12 May 2023 13:52:11 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        syzbot+3c6cac1550288f8e7060@syzkaller.appspotmail.com,
        nphamcs@gmail.com, mtk.manpages@gmail.com, hannes@cmpxchg.org,
        bfoster@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + workingset-refactor-lru-refault-to-expose-refault-recency-check-fix.patch added to mm-unstable branch
Message-Id: <20230512205212.262EDC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: workingset: add missing rcu_read_unlock() in lru_gen_refault()
has been added to the -mm mm-unstable branch.  Its filename is
     workingset-refactor-lru-refault-to-expose-refault-recency-check-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/workingset-refactor-lru-refault-to-expose-refault-recency-check-fix.patch

This patch will later appear in the mm-unstable branch at
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

workingset-refactor-lru-refault-to-expose-refault-recency-check-fix.patch
mm-page_alloc-dont-wake-up-kswapd-from-rmqueue-unless-__gfp_kswapd_reclaim-is-specified.patch


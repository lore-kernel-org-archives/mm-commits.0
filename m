Return-Path: <SRS0=qjDH=DG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75C3CC2D0A8
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 01:10:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23EBD2083B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 01:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601341857;
	bh=3gliKLLYqhx12wMTTcpONsfzxAqBKyGvTVfvrbIHydM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=HuETgFBKsZ1a3qH+hxwk/ZhitsibOsb6QGKVOy6XYUjTfEl2kcqIqDBCx8bYkpm7d
	 yiMU1QTzV6bUl5CFnfQEeK/rQu4RVwcqsFpRX/gGquIzYGGxKwt0xGp7+CYX/783vQ
	 pXE4PCRTpe+aLardIXFGZkp8sfCJUUTtZpMxHX5Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgI2BK4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Sep 2020 21:10:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725272AbgI2BK4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Sep 2020 21:10:56 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1BED207C4;
        Tue, 29 Sep 2020 01:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601341855;
        bh=3gliKLLYqhx12wMTTcpONsfzxAqBKyGvTVfvrbIHydM=;
        h=Date:From:To:Subject:From;
        b=Dy+VSSHVoWrebTQOWw07whCawR6L8EoyZ8LwmfoIfOaajyf6spx5leBiwFqMhoc6y
         Wm92s7dJ9MrNxhuXhHtswD2W7CzBPalyYpI+Qt/BVHIb/G76wO2lS9pFIoAU66FBcA
         MfxiXFDwsfUeb8WZWOlJudyLCuw8DqzQS/9o49UU=
Date:   Mon, 28 Sep 2020 18:10:55 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        sh_def@163.com
Subject:  +
 mmz3fold-use-xx_zalloc-instead-xx_alloc-and-memset.patch added to -mm tree
Message-ID: <20200929011055.3o9EjcoL_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold.c: use xx_zalloc instead xx_alloc and memset
has been added to the -mm tree.  Its filename is
     mmz3fold-use-xx_zalloc-instead-xx_alloc-and-memset.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmz3fold-use-xx_zalloc-instead-xx_alloc-and-memset.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmz3fold-use-xx_zalloc-instead-xx_alloc-and-memset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hui Su <sh_def@163.com>
Subject: mm/z3fold.c: use xx_zalloc instead xx_alloc and memset

alloc_slots() allocates memory for slots using kmem_cache_alloc(), then
memsets it.  We can just use kmem_cache_zalloc().

Link: https://lkml.kernel.org/r/20200926100834.GA184671@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/z3fold.c~mmz3fold-use-xx_zalloc-instead-xx_alloc-and-memset
+++ a/mm/z3fold.c
@@ -212,13 +212,12 @@ static inline struct z3fold_buddy_slots
 {
 	struct z3fold_buddy_slots *slots;
 
-	slots = kmem_cache_alloc(pool->c_handle,
+	slots = kmem_cache_zalloc(pool->c_handle,
 				 (gfp & ~(__GFP_HIGHMEM | __GFP_MOVABLE)));
 
 	if (slots) {
 		/* It will be freed separately in free_handle(). */
 		kmemleak_not_leak(slots);
-		memset(slots->slot, 0, sizeof(slots->slot));
 		slots->pool = (unsigned long)pool;
 		rwlock_init(&slots->lock);
 	}
_

Patches currently in -mm which might be from sh_def@163.com are

mmkmemleak-testc-move-kmemleak-testc-to-samples-dir.patch
mm-vmallocc-update-the-comment-in-__vmalloc_area_node.patch
mm-vmallocc-fix-the-comment-of-find_vm_area.patch
mm-vmscan-fix-comments-for-isolate_lru_page.patch
mmz3fold-use-xx_zalloc-instead-xx_alloc-and-memset.patch
mm-fix-some-comments-in-page_allocc-and-mempolicyc.patch


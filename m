Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1742DC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 27 May 2022 16:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349163AbiE0QhE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 May 2022 12:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349801AbiE0QfA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2022 12:35:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CC252B1D
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 09:34:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1CF561DE3
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 16:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A1EC385B8;
        Fri, 27 May 2022 16:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653669297;
        bh=vvMOsSUsuaJRNlGXisvTIlFwMUb3BYAD5/cIPrH2NIY=;
        h=Date:To:From:Subject:From;
        b=SiDYjBFwtefK1WenN5bkyDVf3Gc8XuaYkPbZlk6Dew2SpHOzq19u9QCehaAGTxn+g
         PjgnGNUNC544FLuU/pXfJQ8f3/WtktL+siuE43oBcLZ7pf65P72vI71pIGVTWn0tVb
         oCqbP3gAmai8VxcZlT7ULHEzz3bferrmcmGvpTPg=
Date:   Fri, 27 May 2022 09:34:56 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] revert-mm-z3foldc-allow-__gfp_highmem-in-z3fold_alloc.patch removed from -mm tree
Message-Id: <20220527163457.20A1EC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: revert "mm/z3fold.c: allow __GFP_HIGHMEM in z3fold_alloc"
has been removed from the -mm tree.  Its filename was
     revert-mm-z3foldc-allow-__gfp_highmem-in-z3fold_alloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: revert "mm/z3fold.c: allow __GFP_HIGHMEM in z3fold_alloc"
Date: Fri, 29 Apr 2022 14:40:43 +0800

Revert commit f1549cb5ab2b ("mm/z3fold.c: allow __GFP_HIGHMEM in
z3fold_alloc").

z3fold can't support GFP_HIGHMEM page now.  page_address is used directly
at all places.  Moreover, z3fold_header is on per cpu unbuddied list which
could be accessed anytime.  So we should remove the support of GFP_HIGHMEM
allocation for z3fold.

Link: https://lkml.kernel.org/r/20220429064051.61552-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/z3fold.c~revert-mm-z3foldc-allow-__gfp_highmem-in-z3fold_alloc
+++ a/mm/z3fold.c
@@ -212,10 +212,8 @@ static int size_to_chunks(size_t size)
 static inline struct z3fold_buddy_slots *alloc_slots(struct z3fold_pool *pool,
 							gfp_t gfp)
 {
-	struct z3fold_buddy_slots *slots;
-
-	slots = kmem_cache_zalloc(pool->c_handle,
-				 (gfp & ~(__GFP_HIGHMEM | __GFP_MOVABLE)));
+	struct z3fold_buddy_slots *slots = kmem_cache_zalloc(pool->c_handle,
+							     gfp);
 
 	if (slots) {
 		/* It will be freed separately in free_handle(). */
@@ -1075,7 +1073,7 @@ static int z3fold_alloc(struct z3fold_po
 	enum buddy bud;
 	bool can_sleep = gfpflags_allow_blocking(gfp);
 
-	if (!size)
+	if (!size || (gfp & __GFP_HIGHMEM))
 		return -EINVAL;
 
 	if (size > PAGE_SIZE)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are



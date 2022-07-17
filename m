Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67622C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jul 2022 04:37:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbiGQEhz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 00:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbiGQEhy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 00:37:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF392220D6
        for <mm-commits@vger.kernel.org>; Sat, 16 Jul 2022 21:37:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35D1460EBA
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 04:37:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E24EC341CA;
        Sun, 17 Jul 2022 04:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658032672;
        bh=c1q6j7Y+l4hQ9X/EFpmGJu73e6kmiyqS/Lt4HFyh6pk=;
        h=Date:To:From:Subject:From;
        b=pS766ecR52mts/iyd2V3YhED9F2y5XXIC5HiAlErSCIIsLMvPRmAGu4QJ1qt7fS+S
         le6VRkCx3E9q7pdTXdYwF5h7b+xW9MceB3S4n0nk3X2SsvmYZnQ1d41ypaWLZHydeB
         1/Y6lY3u0sU9a88Q6y8ZgSbd0k0eZtLi+Tl0TQsQ=
Date:   Sat, 16 Jul 2022 21:37:51 -0700
To:     mm-commits@vger.kernel.org, geert+renesas@glider.be,
        elver@google.com, catalin.marinas@arm.com, yee.lee@mediatek.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-kfence-apply-kmemleak_ignore_phys-on-early-allocated-pool.patch removed from -mm tree
Message-Id: <20220717043752.8E24EC341CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: kfence: apply kmemleak_ignore_phys on early allocated pool
has been removed from the -mm tree.  Its filename was
     mm-kfence-apply-kmemleak_ignore_phys-on-early-allocated-pool.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yee Lee <yee.lee@mediatek.com>
Subject: mm: kfence: apply kmemleak_ignore_phys on early allocated pool
Date: Tue, 28 Jun 2022 19:37:11 +0800

This patch solves two issues.

(1) The pool allocated by memblock needs to unregister from
kmemleak scanning. Apply kmemleak_ignore_phys to replace the
original kmemleak_free as its address now is stored in the phys tree.

(2) The pool late allocated by page-alloc doesn't need to unregister.
Move out the freeing operation from its call path.

Link: https://lkml.kernel.org/r/20220628113714.7792-2-yee.lee@mediatek.com
Fixes: 0c24e061196c21d5 ("mm: kmemleak: add rbtree and store physical address for objects allocated with PA")
Signed-off-by: Yee Lee <yee.lee@mediatek.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Suggested-by: Marco Elver <elver@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/kfence/core.c~mm-kfence-apply-kmemleak_ignore_phys-on-early-allocated-pool
+++ a/mm/kfence/core.c
@@ -603,14 +603,6 @@ static unsigned long kfence_init_pool(vo
 		addr += 2 * PAGE_SIZE;
 	}
 
-	/*
-	 * The pool is live and will never be deallocated from this point on.
-	 * Remove the pool object from the kmemleak object tree, as it would
-	 * otherwise overlap with allocations returned by kfence_alloc(), which
-	 * are registered with kmemleak through the slab post-alloc hook.
-	 */
-	kmemleak_free(__kfence_pool);
-
 	return 0;
 }
 
@@ -623,8 +615,16 @@ static bool __init kfence_init_pool_earl
 
 	addr = kfence_init_pool();
 
-	if (!addr)
+	if (!addr) {
+		/*
+		 * The pool is live and will never be deallocated from this point on.
+		 * Ignore the pool object from the kmemleak phys object tree, as it would
+		 * otherwise overlap with allocations returned by kfence_alloc(), which
+		 * are registered with kmemleak through the slab post-alloc hook.
+		 */
+		kmemleak_ignore_phys(__pa(__kfence_pool));
 		return true;
+	}
 
 	/*
 	 * Only release unprotected pages, and do not try to go back and change
_

Patches currently in -mm which might be from yee.lee@mediatek.com are



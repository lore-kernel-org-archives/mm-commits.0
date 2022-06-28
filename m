Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71461C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jun 2022 18:56:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbiF1S4F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Jun 2022 14:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiF1S4F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2022 14:56:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F54319C3C
        for <mm-commits@vger.kernel.org>; Tue, 28 Jun 2022 11:56:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12760B81F21
        for <mm-commits@vger.kernel.org>; Tue, 28 Jun 2022 18:56:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF63C3411D;
        Tue, 28 Jun 2022 18:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656442561;
        bh=9PjH+qoypRNVqxqFIeOriz6xvSz9c4SCq2TM+EcHruo=;
        h=Date:To:From:Subject:From;
        b=L2+tETrhsJbdO1bm157MSW/nmtOekJxkP4W1nba+ky1UAY0YKTkkRv9/97yL+rnxj
         bETBJYLT8fr5QDpWcQKrNDJgRKPCTNCGP22oVFKehr5CD5fgjvnsA+0xmJaF22Vkbn
         Vr9t7Z/MNPOpGeWIFoM5xaHAnkWNcfvN+ZBlIfVE=
Date:   Tue, 28 Jun 2022 11:56:01 -0700
To:     mm-commits@vger.kernel.org, elver@google.com,
        catalin.marinas@arm.com, yee.lee@mediatek.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kfence-apply-kmemleak_ignore_phys-on-early-allocated-pool.patch added to mm-hotfixes-unstable branch
Message-Id: <20220628185601.BFF63C3411D@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kfence: apply kmemleak_ignore_phys on early allocated pool
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-kfence-apply-kmemleak_ignore_phys-on-early-allocated-pool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kfence-apply-kmemleak_ignore_phys-on-early-allocated-pool.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Signed-off-by: Yee Lee <yee.lee@mediatek.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Suggested-by: Marco Elver <elver@google.com>
Reviewed-by: Marco Elver <elver@google.com>
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

mm-kfence-apply-kmemleak_ignore_phys-on-early-allocated-pool.patch


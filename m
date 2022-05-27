Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E009C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 27 May 2022 16:37:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbiE0QhF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 May 2022 12:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349694AbiE0Qe7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2022 12:34:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BAB252B0A
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 09:34:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E120B825B0
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 16:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FC9C385B8;
        Fri, 27 May 2022 16:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653669294;
        bh=hH8RtuHwLr4L7hBQL1+f6wqemY824L2gk2jb4ai0gI0=;
        h=Date:To:From:Subject:From;
        b=BhaVC5UDLiomCrFOqG0O8KS64Aj7De27QI6LhJ+7bTUyz/lkVKudecaDgGEzOHtR6
         vjZUalviy+mHyTVOtnyfDMscqRhcu98+rfz9xRtr5hS5NLm8NVmLqT2yc5IaMj2+Zl
         Psh3YM+DOLh8odM/GkxCMR9xWnkYTPlWk1q8rTHk=
Date:   Fri, 27 May 2022 09:34:54 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-z3fold-remove-buggy-use-of-stale-list-for-allocation.patch removed from -mm tree
Message-Id: <20220527163454.D0FC9C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/z3fold: remove buggy use of stale list for allocation
has been removed from the -mm tree.  Its filename was
     mm-z3fold-remove-buggy-use-of-stale-list-for-allocation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/z3fold: remove buggy use of stale list for allocation
Date: Fri, 29 Apr 2022 14:40:43 +0800

Currently if z3fold couldn't find an unbuddied page it would first try to
pull a page off the stale list.  But this approach is problematic.  If
init z3fold page fails later, the page should be freed via
free_z3fold_page to clean up the relevant resource instead of using
__free_page directly.  And if page is successfully reused, it will BUG_ON
later in __SetPageMovable because it's already non-lru movable page, i.e. 
PAGE_MAPPING_MOVABLE is already set in page->mapping.  In order to fix all
of these issues, we can simply remove the buggy use of stale list for
allocation because can_sleep should always be false and we never really
hit the reusing code path now.

Link: https://lkml.kernel.org/r/20220429064051.61552-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

--- a/mm/z3fold.c~mm-z3fold-remove-buggy-use-of-stale-list-for-allocation
+++ a/mm/z3fold.c
@@ -1102,28 +1102,7 @@ retry:
 		bud = FIRST;
 	}
 
-	page = NULL;
-	if (can_sleep) {
-		spin_lock(&pool->stale_lock);
-		zhdr = list_first_entry_or_null(&pool->stale,
-						struct z3fold_header, buddy);
-		/*
-		 * Before allocating a page, let's see if we can take one from
-		 * the stale pages list. cancel_work_sync() can sleep so we
-		 * limit this case to the contexts where we can sleep
-		 */
-		if (zhdr) {
-			list_del(&zhdr->buddy);
-			spin_unlock(&pool->stale_lock);
-			cancel_work_sync(&zhdr->work);
-			page = virt_to_page(zhdr);
-		} else {
-			spin_unlock(&pool->stale_lock);
-		}
-	}
-	if (!page)
-		page = alloc_page(gfp);
-
+	page = alloc_page(gfp);
 	if (!page)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are



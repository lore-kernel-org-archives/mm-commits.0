Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B304FC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 27 May 2022 16:37:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243072AbiE0QhB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 May 2022 12:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354006AbiE0QfB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2022 12:35:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BACA3B56F
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 09:35:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7BDFB825AF
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 16:34:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2FCC385A9;
        Fri, 27 May 2022 16:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653669298;
        bh=0qCF9TgTHd4noKypk/9WyC9LaW0Nxr04hEJbwCXKCkU=;
        h=Date:To:From:Subject:From;
        b=TATQ26UB8yLDt7Km1a16eva1k5GkkWVh4uqmlEN0Zvlsq7rQLGJolvd0RcI/mVF+9
         iWvsX1f19WwGApbjBz/RvYXWzVug1oIQRht7fEoKPxMZlH4OhL6igBuNSNrlQhCI7l
         PnrWoJFCfxinZIU6cVo0dKx5T9pRcKgCM9VA72oA=
Date:   Fri, 27 May 2022 09:34:57 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-z3fold-put-z3fold-page-back-into-unbuddied-list-when-reclaim-or-migration-fails.patch removed from -mm tree
Message-Id: <20220527163458.4A2FCC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/z3fold: put z3fold page back into unbuddied list when reclaim or migration fails
has been removed from the -mm tree.  Its filename was
     mm-z3fold-put-z3fold-page-back-into-unbuddied-list-when-reclaim-or-migration-fails.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/z3fold: put z3fold page back into unbuddied list when reclaim or migration fails
Date: Fri, 29 Apr 2022 14:40:43 +0800

When doing z3fold page reclaim or migration, the page is removed from
unbuddied list.  If reclaim or migration succeeds, it's fine as page is
released.  But in case it fails, the page is not put back into unbuddied
list now.  The page will be leaked until next compaction work, reclaim or
migration is done.

Link: https://lkml.kernel.org/r/20220429064051.61552-7-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/z3fold.c~mm-z3fold-put-z3fold-page-back-into-unbuddied-list-when-reclaim-or-migration-fails
+++ a/mm/z3fold.c
@@ -1422,6 +1422,8 @@ next:
 			spin_lock(&pool->lock);
 			list_add(&page->lru, &pool->lru);
 			spin_unlock(&pool->lock);
+			if (list_empty(&zhdr->buddy))
+				add_to_unbuddied(pool, zhdr);
 			z3fold_page_unlock(zhdr);
 			clear_bit(PAGE_CLAIMED, &page->private);
 		}
@@ -1638,6 +1640,8 @@ static void z3fold_page_putback(struct p
 	spin_lock(&pool->lock);
 	list_add(&page->lru, &pool->lru);
 	spin_unlock(&pool->lock);
+	if (list_empty(&zhdr->buddy))
+		add_to_unbuddied(pool, zhdr);
 	clear_bit(PAGE_CLAIMED, &page->private);
 	z3fold_page_unlock(zhdr);
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are



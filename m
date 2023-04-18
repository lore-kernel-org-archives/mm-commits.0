Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1907DC77B76
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:35:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbjDRXfx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbjDRXev (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:34:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9A1AF12
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE28962CA1
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FBFBC433EF;
        Tue, 18 Apr 2023 23:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860864;
        bh=mv/gTPDTiM2fzUqgAD0liQSp7KJHmbuLkAHTzlFnfiY=;
        h=Date:To:From:Subject:From;
        b=Qlitz2rbjFkE3UNxXS56c7Nhcdj0JFq/FNnGKWXyuq2YYpxzu890LrUqpyKaZxh/i
         zVQNDfuoNL+oX0WJ4ZhL165D7HVE/gxB/Ctqey5kUtzn4yyO+5nFaC1uj+Rtr9o9Xz
         YyufbRg6bMzdT95iJL6bhQ0cOHyd/X/vE9S3W/WQ=
Date:   Tue, 18 Apr 2023 16:34:23 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        mgorman@suse.de, lstoakes@gmail.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mlock-use-folios_put-in-mlock_folio_batch.patch removed from -mm tree
Message-Id: <20230418233424.0FBFBC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: mlock: use folios_put() in mlock_folio_batch()
has been removed from the -mm tree.  Its filename was
     mm-mlock-use-folios_put-in-mlock_folio_batch.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: mlock: use folios_put() in mlock_folio_batch()
Date: Thu, 6 Apr 2023 00:18:54 +0800

Since we have updated mlock to use folios, it's better to call
folios_put() instead of calling release_pages() directly.

Link: https://lkml.kernel.org/r/20230405161854.6931-2-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mlock.c~mm-mlock-use-folios_put-in-mlock_folio_batch
+++ a/mm/mlock.c
@@ -206,7 +206,7 @@ static void mlock_folio_batch(struct fol
 
 	if (lruvec)
 		unlock_page_lruvec_irq(lruvec);
-	release_pages(fbatch->folios, fbatch->nr);
+	folios_put(fbatch->folios, folio_batch_count(fbatch));
 	folio_batch_reinit(fbatch);
 }
 
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are



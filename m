Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8E7EC678D4
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjASBWB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:22:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbjASBT7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:19:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD94689EF
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E03F06176F
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F13C433F0;
        Thu, 19 Jan 2023 01:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090999;
        bh=eGNqqOUuLOnJzxeaGmL+4vYkFKnNvHdOa3+LxXWmqJ0=;
        h=Date:To:From:Subject:From;
        b=rT4qP4o2r8YPAxlzTcLbc+9IU1bGj/praNf7UBqYtgN4R3V/HtznLrrH9e+Vp+xod
         pha9r8LP5is7he72RWAsj5t7Qh8kT6/iu1nlDdTIrSDAyHqoEomuM62fGpwaQeyVJV
         Vgd8+7H0F8rF0mMXcvnTS6HRVXtHNL16d8ysuWZE=
Date:   Wed, 18 Jan 2023 17:16:38 -0800
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        senozhatsky@chromium.org, minchan@kernel.org, linmiaohe@huawei.com,
        hch@lst.de, david@redhat.com, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-pagemovable-export.patch removed from -mm tree
Message-Id: <20230119011639.46F13C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove PageMovable export
has been removed from the -mm tree.  Its filename was
     mm-remove-pagemovable-export.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: mm: remove PageMovable export
Date: Fri, 6 Jan 2023 14:59:00 +0100

The only in-kernel users that need PageMovable() to be exported are z3fold
and zsmalloc and they are only using it for dubious debugging
functionality.  So remove those usages and the export so that no driver
code accidentally thinks that they are allowed to use this symbol.

Link: https://lkml.kernel.org/r/20230106135900.3763622-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    1 -
 mm/z3fold.c     |    2 --
 mm/zsmalloc.c   |    3 ---
 3 files changed, 6 deletions(-)

--- a/mm/compaction.c~mm-remove-pagemovable-export
+++ a/mm/compaction.c
@@ -122,7 +122,6 @@ bool PageMovable(struct page *page)
 
 	return false;
 }
-EXPORT_SYMBOL(PageMovable);
 
 void __SetPageMovable(struct page *page, const struct movable_operations *mops)
 {
--- a/mm/z3fold.c~mm-remove-pagemovable-export
+++ a/mm/z3fold.c
@@ -1450,7 +1450,6 @@ static bool z3fold_page_isolate(struct p
 	struct z3fold_header *zhdr;
 	struct z3fold_pool *pool;
 
-	VM_BUG_ON_PAGE(!PageMovable(page), page);
 	VM_BUG_ON_PAGE(PageIsolated(page), page);
 
 	if (test_bit(PAGE_HEADLESS, &page->private))
@@ -1490,7 +1489,6 @@ static int z3fold_page_migrate(struct pa
 	struct z3fold_header *zhdr, *new_zhdr;
 	struct z3fold_pool *pool;
 
-	VM_BUG_ON_PAGE(!PageMovable(page), page);
 	VM_BUG_ON_PAGE(!PageIsolated(page), page);
 	VM_BUG_ON_PAGE(!test_bit(PAGE_CLAIMED, &page->private), page);
 	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
--- a/mm/zsmalloc.c~mm-remove-pagemovable-export
+++ a/mm/zsmalloc.c
@@ -1973,7 +1973,6 @@ static bool zs_page_isolate(struct page
 	 * Page is locked so zspage couldn't be destroyed. For detail, look at
 	 * lock_zspage in free_zspage.
 	 */
-	VM_BUG_ON_PAGE(!PageMovable(page), page);
 	VM_BUG_ON_PAGE(PageIsolated(page), page);
 
 	zspage = get_zspage(page);
@@ -2005,7 +2004,6 @@ static int zs_page_migrate(struct page *
 	if (mode == MIGRATE_SYNC_NO_COPY)
 		return -EINVAL;
 
-	VM_BUG_ON_PAGE(!PageMovable(page), page);
 	VM_BUG_ON_PAGE(!PageIsolated(page), page);
 
 	/* The page is locked, so this pointer must remain valid */
@@ -2070,7 +2068,6 @@ static void zs_page_putback(struct page
 {
 	struct zspage *zspage;
 
-	VM_BUG_ON_PAGE(!PageMovable(page), page);
 	VM_BUG_ON_PAGE(!PageIsolated(page), page);
 
 	zspage = get_zspage(page);
_

Patches currently in -mm which might be from gregkh@linuxfoundation.org are



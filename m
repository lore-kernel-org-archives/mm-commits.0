Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B4E7C54EBD
	for <mm-commits@archiver.kernel.org>; Sat,  7 Jan 2023 00:57:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbjAGA5m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Jan 2023 19:57:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236370AbjAGA5l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jan 2023 19:57:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A23E7FEEF
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 16:57:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3979161FBF
        for <mm-commits@vger.kernel.org>; Sat,  7 Jan 2023 00:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82CA6C433D2;
        Sat,  7 Jan 2023 00:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673053059;
        bh=0VFq72dCYv6fJAISxg3qRGSVfxcaael0NyV6dXNkAGQ=;
        h=Date:To:From:Subject:From;
        b=PByzDH0UIpsG899uPvurIJWos5v0htaK6ZsWpjmcAMpz3eRVTUpgOhD9RAi0R7aKS
         1k8HlShrFXvdvWR4vleLD7iHIVIF0Bq9CA+p1JXoRF96Lxb3tWLq6U2O+vvq7Z2JeB
         mJi0Bm6Mpz2Xra1Nnbfn6cSVJOKlpZq2oCgm6iz0=
Date:   Fri, 06 Jan 2023 16:57:38 -0800
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        senozhatsky@chromium.org, minchan@kernel.org, linmiaohe@huawei.com,
        gregkh@linuxfoundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-pagemovable-export.patch added to mm-unstable branch
Message-Id: <20230107005739.82CA6C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove PageMovable export
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-pagemovable-export.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-pagemovable-export.patch

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
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: mm: remove PageMovable export
Date: Fri, 6 Jan 2023 14:59:00 +0100

The only in-kernel users that need PageMovable() to be exported are z3fold
and zsmalloc and they are only using it for dubious debugging
functionality.  So remove those usages and the export so that no driver
code accidentally thinks that they are allowed to use this symbol.

Link: https://lkml.kernel.org/r/20230106135900.3763622-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
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

mm-remove-pagemovable-export.patch


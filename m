Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12A26C4321E
	for <mm-commits@archiver.kernel.org>; Tue, 29 Nov 2022 21:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235589AbiK2V4Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:56:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235880AbiK2V4Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 29 Nov 2022 16:56:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1CE76C73A
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2022 13:56:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EA476190F
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2022 21:56:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F30C433C1;
        Tue, 29 Nov 2022 21:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669758981;
        bh=g2mlJjg2jsEaccz3FvTdtUiBGULAQP6bEgXWzGl1o2s=;
        h=Date:To:From:Subject:From;
        b=0v4yr+xK8ErU4KVV1PL1e9N42mN+pLSQWZxYGm9n8FYYyoINysPLYzSmk3d4EvNpd
         iRzb4Mel8y6NrrTmHp6xk2g1u77IWy4RGwXjpwLahlT1KmZVrhFz1CnaPqvB8Fzz7j
         /m7ejA5x31bstTrgDPVN8Wf31Zk+/vlxWOjiTla0=
Date:   Tue, 29 Nov 2022 13:56:21 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mszeredi@redhat.com, mike.kravetz@oracle.com,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fuse-convert-fuse_try_move_page-to-use-folios.patch added to mm-unstable branch
Message-Id: <20221129215621.B9F30C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fuse: convert fuse_try_move_page() to use folios
has been added to the -mm mm-unstable branch.  Its filename is
     fuse-convert-fuse_try_move_page-to-use-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fuse-convert-fuse_try_move_page-to-use-folios.patch

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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: fuse: convert fuse_try_move_page() to use folios
Date: Tue, 1 Nov 2022 10:53:23 -0700

Converts the function to try to move folios instead of pages. Also
converts fuse_check_page() to fuse_get_folio() since this is its only
caller. This change removes 15 calls to compound_head().

Link: https://lkml.kernel.org/r/20221101175326.13265-3-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dev.c |   55 ++++++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 27 deletions(-)

--- a/fs/fuse/dev.c~fuse-convert-fuse_try_move_page-to-use-folios
+++ a/fs/fuse/dev.c
@@ -764,11 +764,11 @@ static int fuse_copy_do(struct fuse_copy
 	return ncpy;
 }
 
-static int fuse_check_page(struct page *page)
+static int fuse_check_folio(struct folio *folio)
 {
-	if (page_mapcount(page) ||
-	    page->mapping != NULL ||
-	    (page->flags & PAGE_FLAGS_CHECK_AT_PREP &
+	if (folio_mapped(folio) ||
+	    folio->mapping != NULL ||
+	    (folio->flags & PAGE_FLAGS_CHECK_AT_PREP &
 	     ~(1 << PG_locked |
 	       1 << PG_referenced |
 	       1 << PG_uptodate |
@@ -778,7 +778,7 @@ static int fuse_check_page(struct page *
 	       1 << PG_reclaim |
 	       1 << PG_waiters |
 	       LRU_GEN_MASK | LRU_REFS_MASK))) {
-		dump_page(page, "fuse: trying to steal weird page");
+		dump_page(&folio->page, "fuse: trying to steal weird page");
 		return 1;
 	}
 	return 0;
@@ -787,11 +787,11 @@ static int fuse_check_page(struct page *
 static int fuse_try_move_page(struct fuse_copy_state *cs, struct page **pagep)
 {
 	int err;
-	struct page *oldpage = *pagep;
-	struct page *newpage;
+	struct folio *oldfolio = page_folio(*pagep);
+	struct folio *newfolio;
 	struct pipe_buffer *buf = cs->pipebufs;
 
-	get_page(oldpage);
+	folio_get(oldfolio);
 	err = unlock_request(cs->req);
 	if (err)
 		goto out_put_old;
@@ -814,35 +814,36 @@ static int fuse_try_move_page(struct fus
 	if (!pipe_buf_try_steal(cs->pipe, buf))
 		goto out_fallback;
 
-	newpage = buf->page;
+	newfolio = page_folio(buf->page);
 
-	if (!PageUptodate(newpage))
-		SetPageUptodate(newpage);
+	if (!folio_test_uptodate(newfolio))
+		folio_mark_uptodate(newfolio);
 
-	ClearPageMappedToDisk(newpage);
+	folio_clear_mappedtodisk(newfolio);
 
-	if (fuse_check_page(newpage) != 0)
+	if (fuse_check_folio(newfolio) != 0)
 		goto out_fallback_unlock;
 
 	/*
 	 * This is a new and locked page, it shouldn't be mapped or
 	 * have any special flags on it
 	 */
-	if (WARN_ON(page_mapped(oldpage)))
+	if (WARN_ON(folio_mapped(oldfolio)))
 		goto out_fallback_unlock;
-	if (WARN_ON(page_has_private(oldpage)))
+	if (WARN_ON(folio_has_private(oldfolio)))
 		goto out_fallback_unlock;
-	if (WARN_ON(PageDirty(oldpage) || PageWriteback(oldpage)))
+	if (WARN_ON(folio_test_dirty(oldfolio) ||
+				folio_test_writeback(oldfolio)))
 		goto out_fallback_unlock;
-	if (WARN_ON(PageMlocked(oldpage)))
+	if (WARN_ON(folio_test_mlocked(oldfolio)))
 		goto out_fallback_unlock;
 
-	replace_page_cache_folio(page_folio(oldpage), page_folio(newpage));
+	replace_page_cache_folio(oldfolio, newfolio);
 
-	get_page(newpage);
+	folio_get(newfolio);
 
 	if (!(buf->flags & PIPE_BUF_FLAG_LRU))
-		lru_cache_add(newpage);
+		folio_add_lru(newfolio);
 
 	/*
 	 * Release while we have extra ref on stolen page.  Otherwise
@@ -855,28 +856,28 @@ static int fuse_try_move_page(struct fus
 	if (test_bit(FR_ABORTED, &cs->req->flags))
 		err = -ENOENT;
 	else
-		*pagep = newpage;
+		*pagep = &newfolio->page;
 	spin_unlock(&cs->req->waitq.lock);
 
 	if (err) {
-		unlock_page(newpage);
-		put_page(newpage);
+		folio_unlock(newfolio);
+		folio_put(newfolio);
 		goto out_put_old;
 	}
 
-	unlock_page(oldpage);
+	folio_unlock(oldfolio);
 	/* Drop ref for ap->pages[] array */
-	put_page(oldpage);
+	folio_put(oldfolio);
 	cs->len = 0;
 
 	err = 0;
 out_put_old:
 	/* Drop ref obtained in this function */
-	put_page(oldpage);
+	folio_put(oldfolio);
 	return err;
 
 out_fallback_unlock:
-	unlock_page(newpage);
+	folio_unlock(newfolio);
 out_fallback:
 	cs->pg = buf->page;
 	cs->offset = buf->offset;
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

ext4-convert-move_extent_per_page-to-use-folios.patch
khugepage-replace-try_to_release_page-with-filemap_release_folio.patch
memory-failure-convert-truncate_error_page-to-use-folio.patch
folio-compat-remove-try_to_release_page.patch
filemap-convert-replace_page_cache_page-to-replace_page_cache_folio.patch
fuse-convert-fuse_try_move_page-to-use-folios.patch
userfualtfd-replace-lru_cache-functions-with-folio_add-functions.patch
khugepage-replace-lru_cache_add-with-folio_add_lru.patch
folio-compat-remove-lru_cache_add.patch


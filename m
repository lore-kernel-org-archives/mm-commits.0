Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C01FC433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:20:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2C1064F35
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233896AbhBYTTR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:19:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:57190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234568AbhBYTRL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:17:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91F1164F46;
        Thu, 25 Feb 2021 19:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280349;
        bh=OAMURF30n5KCTs+Hqi1PXQ0nYbysJpYCo0inZeUVs/w=;
        h=Date:From:To:Subject:From;
        b=ui9y2Uy59rDhZUS6jqypW36RppGTDZsYzBYKzOmnEJHTIKYLBuDCsoEGyhAKv564s
         NHgDb+2wxSmzVC13Qf+eRQxt6WEum/9SncGjIPEoyPPXrKRkFfJCL0aAbMT/2NA9CM
         /hTbnNSfyzkV0eTjLVruzcwPb59/0zPLrw406L9c=
Date:   Thu, 25 Feb 2021 11:12:29 -0800
From:   akpm@linux-foundation.org
To:     baolin.wang@linux.alibaba.com, miklos@szeredi.hu,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 =?US-ASCII?Q?mm-filemap-remove-unused-parameter-and-change-to-void-type-f?=
 =?US-ASCII?Q?or-replace=5Fpage=5Fcache=5Fpage.patch?= removed from -mm
 tree
Message-ID: <20210225191229.vboS5hglD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: remove unused parameter and change to void type for replace_page_cache_page()
has been removed from the -mm tree.  Its filename was
     mm-filemap-remove-unused-parameter-and-change-to-void-type-for-replace_page_cache_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm/filemap: remove unused parameter and change to void type for replace_page_cache_page()

Since commit 74d609585d8b ("page cache: Add and replace pages using the
XArray") was merged, the replace_page_cache_page() can not fail and always
return 0, we can remove the redundant return value and void it.  Moreover
remove the unused gfp_mask.

Link: https://lkml.kernel.org/r/609c30e5274ba15d8b90c872fd0d8ac437a9b2bb.1610071401.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dev.c           |    6 +-----
 include/linux/pagemap.h |    2 +-
 mm/filemap.c            |    7 +------
 3 files changed, 3 insertions(+), 12 deletions(-)

--- a/fs/fuse/dev.c~mm-filemap-remove-unused-parameter-and-change-to-void-type-for-replace_page_cache_page
+++ a/fs/fuse/dev.c
@@ -844,11 +844,7 @@ static int fuse_try_move_page(struct fus
 	if (WARN_ON(PageMlocked(oldpage)))
 		goto out_fallback_unlock;
 
-	err = replace_page_cache_page(oldpage, newpage, GFP_KERNEL);
-	if (err) {
-		unlock_page(newpage);
-		goto out_put_old;
-	}
+	replace_page_cache_page(oldpage, newpage);
 
 	get_page(newpage);
 
--- a/include/linux/pagemap.h~mm-filemap-remove-unused-parameter-and-change-to-void-type-for-replace_page_cache_page
+++ a/include/linux/pagemap.h
@@ -757,7 +757,7 @@ int add_to_page_cache_lru(struct page *p
 				pgoff_t index, gfp_t gfp_mask);
 extern void delete_from_page_cache(struct page *page);
 extern void __delete_from_page_cache(struct page *page, void *shadow);
-int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask);
+void replace_page_cache_page(struct page *old, struct page *new);
 void delete_from_page_cache_batch(struct address_space *mapping,
 				  struct pagevec *pvec);
 
--- a/mm/filemap.c~mm-filemap-remove-unused-parameter-and-change-to-void-type-for-replace_page_cache_page
+++ a/mm/filemap.c
@@ -777,7 +777,6 @@ EXPORT_SYMBOL(file_write_and_wait_range)
  * replace_page_cache_page - replace a pagecache page with a new one
  * @old:	page to be replaced
  * @new:	page to replace with
- * @gfp_mask:	allocation mode
  *
  * This function replaces a page in the pagecache with a new one.  On
  * success it acquires the pagecache reference for the new page and
@@ -786,10 +785,8 @@ EXPORT_SYMBOL(file_write_and_wait_range)
  * caller must do that.
  *
  * The remove + add is atomic.  This function cannot fail.
- *
- * Return: %0
  */
-int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask)
+void replace_page_cache_page(struct page *old, struct page *new)
 {
 	struct address_space *mapping = old->mapping;
 	void (*freepage)(struct page *) = mapping->a_ops->freepage;
@@ -824,8 +821,6 @@ int replace_page_cache_page(struct page
 	if (freepage)
 		freepage(old);
 	put_page(old);
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(replace_page_cache_page);
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are



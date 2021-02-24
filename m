Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC84C43381
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:03:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AA7564F31
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:03:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235344AbhBXUDz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:03:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:56138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235385AbhBXUCx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:02:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1618764E60;
        Wed, 24 Feb 2021 20:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196903;
        bh=Gx2UYBXkLKplZFlSpc9Xu7tBsp3g7Fq+GrNge51Cqsg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Z85b3vtFhKgUpbwj5fuw71BjQtykRpL+418oZL5X5gFFGL0xNEKb7gArTSWofk5sv
         rBnt9RZ3sti89Bm0Aqyoz9Oc2yiuPY7zls3uj/mDgvMyhhcRgjJ03Dcnayf8HN+Btf
         0sVfLORhQws6aNfKFwwzwfIq+QqXuml0EgkT3IVo=
Date:   Wed, 24 Feb 2021 12:01:42 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
        linux-mm@kvack.org, miklos@szeredi.hu, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 028/173] mm/filemap: remove unused parameter and
 change to void type for replace_page_cache_page()
Message-ID: <20210224200142.Kn7XyNig0%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

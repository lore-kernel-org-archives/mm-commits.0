Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48602C433E0
	for <mm-commits@archiver.kernel.org>; Sat,  9 Jan 2021 01:45:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 129DC23A1E
	for <mm-commits@archiver.kernel.org>; Sat,  9 Jan 2021 01:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbhAIBpP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jan 2021 20:45:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:39568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbhAIBpP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 8 Jan 2021 20:45:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF91C2399A;
        Sat,  9 Jan 2021 01:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610156674;
        bh=+nROqm89LGhUngDVW1dwUbNQrNU9a2g87r+TdXv+o+0=;
        h=Date:From:To:Subject:From;
        b=MnKgLZiZSDUGoqEm65KIkMEkTyH81QWFLcNrOGSixhfF83cg0vjbnfm774M/k5O4l
         GVtRggTmiVKdO0D/NwQHEsRMCeRSAh+3VWOxr+RFLCzL9TWfNI0P5Q35pKDdD25vuP
         Bo3CQKh4NYoYJ1Xtr/4usGoz9UzlU7Y7QOWjd7yk=
Date:   Fri, 08 Jan 2021 17:44:34 -0800
From:   akpm@linux-foundation.org
To:     baolin.wang@linux.alibaba.com, miklos@szeredi.hu,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  +
 =?US-ASCII?Q?mm-filemap-remove-unused-parameter-and-change-to-void-type-f?=
 =?US-ASCII?Q?or-replace=5Fpage=5Fcache=5Fpage.patch?= added to -mm tree
Message-ID: <20210109014434.g5z4Q4edi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: remove unused parameter and change to void type for replace_page_cache_page()
has been added to the -mm tree.  Its filename is
     mm-filemap-remove-unused-parameter-and-change-to-void-type-for-replace_page_cache_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-remove-unused-parameter-and-change-to-void-type-for-replace_page_cache_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-remove-unused-parameter-and-change-to-void-type-for-replace_page_cache_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -775,7 +775,6 @@ EXPORT_SYMBOL(file_write_and_wait_range)
  * replace_page_cache_page - replace a pagecache page with a new one
  * @old:	page to be replaced
  * @new:	page to replace with
- * @gfp_mask:	allocation mode
  *
  * This function replaces a page in the pagecache with a new one.  On
  * success it acquires the pagecache reference for the new page and
@@ -784,10 +783,8 @@ EXPORT_SYMBOL(file_write_and_wait_range)
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
@@ -822,8 +819,6 @@ int replace_page_cache_page(struct page
 	if (freepage)
 		freepage(old);
 	put_page(old);
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(replace_page_cache_page);
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-filemap-remove-unused-parameter-and-change-to-void-type-for-replace_page_cache_page.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59180C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FD37610E8
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350167AbhICU5j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:57:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350205AbhICU5f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:57:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90A49601FD;
        Fri,  3 Sep 2021 20:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702594;
        bh=xT+QTsghBZKnUaYkKKWvPQiTspf7S7BWeF16Orl18Ak=;
        h=Date:From:To:Subject:From;
        b=EMdQnQVeFFBlkuPedWrNVUpdRDsQetcoeIwodMQ7Cc+/pSfqIUAr9GYqnmrGJGDpA
         rZ06V5BtLH0r6AkHKhD2JtraFMg8tnkr5paqL82LocSQHX88BK+02FJpMf9w6SQ7wT
         evM+scbPxMkdXavIYpwGkCT1EJ7eJVqex2GFZLW8=
Date:   Fri, 03 Sep 2021 13:56:34 -0700
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, gor@linux.ibm.com, hca@linux.ibm.com,
        hch@lst.de, jhubbard@nvidia.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  [merged]
 mm-gup-remove-try_get_page-call-try_get_compound_head-directly.patch
 removed from -mm tree
Message-ID: <20210903205634.1hqISszi4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: remove try_get_page(), call try_get_compound_head() directly
has been removed from the -mm tree.  Its filename was
     mm-gup-remove-try_get_page-call-try_get_compound_head-directly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: remove try_get_page(), call try_get_compound_head() directly

try_get_page() is very similar to try_get_compound_head(), and in fact
try_get_page() has fallen a little behind in terms of maintenance:
try_get_compound_head() handles speculative page references more
thoroughly.

There are only two try_get_page() callsites, so just call
try_get_compound_head() directly from those, and remove try_get_page()
entirely.

Also, seeing as how this changes try_get_compound_head() into a non-static
function, provide some kerneldoc documentation for it.

Link: https://lkml.kernel.org/r/20210813044133.1536842-4-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/fault.c |    2 +-
 fs/pipe.c            |    2 +-
 include/linux/mm.h   |   10 +---------
 mm/gup.c             |   21 +++++++++++++++++----
 4 files changed, 20 insertions(+), 15 deletions(-)

--- a/arch/s390/mm/fault.c~mm-gup-remove-try_get_page-call-try_get_compound_head-directly
+++ a/arch/s390/mm/fault.c
@@ -817,7 +817,7 @@ void do_secure_storage_access(struct pt_
 		break;
 	case KERNEL_FAULT:
 		page = phys_to_page(addr);
-		if (unlikely(!try_get_page(page)))
+		if (unlikely(!try_get_compound_head(page, 1)))
 			break;
 		rc = arch_make_page_accessible(page);
 		put_page(page);
--- a/fs/pipe.c~mm-gup-remove-try_get_page-call-try_get_compound_head-directly
+++ a/fs/pipe.c
@@ -191,7 +191,7 @@ EXPORT_SYMBOL(generic_pipe_buf_try_steal
  */
 bool generic_pipe_buf_get(struct pipe_inode_info *pipe, struct pipe_buffer *buf)
 {
-	return try_get_page(buf->page);
+	return try_get_compound_head(buf->page, 1);
 }
 EXPORT_SYMBOL(generic_pipe_buf_get);
 
--- a/include/linux/mm.h~mm-gup-remove-try_get_page-call-try_get_compound_head-directly
+++ a/include/linux/mm.h
@@ -1217,15 +1217,7 @@ bool __must_check try_grab_page(struct p
 struct page *try_grab_compound_head(struct page *page, int refs,
 				    unsigned int flags);
 
-
-static inline __must_check bool try_get_page(struct page *page)
-{
-	page = compound_head(page);
-	if (WARN_ON_ONCE(page_ref_count(page) <= 0))
-		return false;
-	page_ref_inc(page);
-	return true;
-}
+struct page *try_get_compound_head(struct page *page, int refs);
 
 static inline void put_page(struct page *page)
 {
--- a/mm/gup.c~mm-gup-remove-try_get_page-call-try_get_compound_head-directly
+++ a/mm/gup.c
@@ -62,11 +62,24 @@ static void put_page_refs(struct page *p
 	put_page(page);
 }
 
-/*
- * Return the compound head page with ref appropriately incremented,
- * or NULL if that failed.
+/**
+ * try_get_compound_head() - return the compound head page with refcount
+ * appropriately incremented, or NULL if that failed.
+ *
+ * This handles potential refcount overflow correctly. It also works correclty
+ * for various lockless get_user_pages()-related callers, due to the use of
+ * page_cache_add_speculative().
+ *
+ * Even though the name includes "compound_head", this function is still
+ * appropriate for callers that have a non-compound @page to get.
+ *
+ * @page:  pointer to page to be gotten
+ * @refs:  the value to add to the page's refcount
+ *
+ * Return: head page (with refcount appropriately incremented) for success, or
+ * NULL upon failure.
  */
-static inline struct page *try_get_compound_head(struct page *page, int refs)
+struct page *try_get_compound_head(struct page *page, int refs)
 {
 	struct page *head = compound_head(page);
 
_

Patches currently in -mm which might be from jhubbard@nvidia.com are



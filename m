Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9951BC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 20:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C1EA611AD
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 20:38:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245624AbhIIUjc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 16:39:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245195AbhIIUjc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 16:39:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 141266113A;
        Thu,  9 Sep 2021 20:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631219902;
        bh=tIRM0Op5mYl9J9KJhZyC7QRI+rA3pprat69hd4TsrtM=;
        h=Date:From:To:Subject:From;
        b=dJJLpyyE0K8dIVtlHTKdTmuQc3itm10AkDRAzmMIIrn5gW4xw8FVkIQNZ7UR2Kh6w
         bIJSCsEZHWYbtSpihGzvn+NDwnNn8KDNuogOKubEfLIeCw7vC+DpbLM2/QOT+qo5gN
         GeIGRYyV10s1m33iSzY8lvonTiXDx7IusXL5o8WI=
Date:   Thu, 09 Sep 2021 13:38:21 -0700
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, gor@linux.ibm.com, hca@linux.ibm.com,
        hch@lst.de, jhubbard@nvidia.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  [to-be-updated]
 mm-gup-remove-try_get_page-call-try_get_compound_head-directly.patch
 removed from -mm tree
Message-ID: <20210909203821.l3lYZIcM4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: remove try_get_page(), call try_get_compound_head() directly
has been removed from the -mm tree.  Its filename was
     mm-gup-remove-try_get_page-call-try_get_compound_head-directly.patch

This patch was dropped because an updated version will be merged

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



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B0FC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:39:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbiCVVlP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235893AbiCVVlL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:41:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394375EBE2
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:39:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E37FB81D9E
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BDA6C340EC;
        Tue, 22 Mar 2022 21:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985169;
        bh=Id/frEGWAdaMUtqBKCeCRkwo7IwmnmPnzqwExFWQhBI=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=fY0uLUfZzss1suVmucxqiXxQoQ4/4748btUggZ8WKxtA9ZeHzzsgvcpTXLqHEVEWQ
         ofnUmdpTRNwdNd7dRSe3QbprcKGf1XeXoPGZOGza5lhG5cGlTQvAij2XZBGcwFTchX
         54I+Vsu9ybNZY5Bognr2eTeGsSe07daFQPFMQ+Ws=
Date:   Tue, 22 Mar 2022 14:39:28 -0700
To:     willy@infradead.org, william.kucharski@oracle.com, vbabka@suse.cz,
        kirill.shutemov@linux.intel.com, hch@lst.de, hannes@cmpxchg.org,
        dhowells@redhat.com, agruenba@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 019/227] filemap: remove find_get_pages()
Message-Id: <20220322213929.5BDA6C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: filemap: remove find_get_pages()

It's unused now. Remove it and clean up the relevant comment.

Link: https://lkml.kernel.org/r/20220208134149.47299-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    7 -------
 mm/filemap.c            |   11 ++++++-----
 2 files changed, 6 insertions(+), 12 deletions(-)

--- a/include/linux/pagemap.h~filemap-remove-find_get_pages
+++ a/include/linux/pagemap.h
@@ -594,13 +594,6 @@ static inline struct page *find_subpage(
 unsigned find_get_pages_range(struct address_space *mapping, pgoff_t *start,
 			pgoff_t end, unsigned int nr_pages,
 			struct page **pages);
-static inline unsigned find_get_pages(struct address_space *mapping,
-			pgoff_t *start, unsigned int nr_pages,
-			struct page **pages)
-{
-	return find_get_pages_range(mapping, start, (pgoff_t)-1, nr_pages,
-				    pages);
-}
 unsigned find_get_pages_contig(struct address_space *mapping, pgoff_t start,
 			       unsigned int nr_pages, struct page **pages);
 unsigned find_get_pages_range_tag(struct address_space *mapping, pgoff_t *index,
--- a/mm/filemap.c~filemap-remove-find_get_pages
+++ a/mm/filemap.c
@@ -2229,8 +2229,9 @@ out:
  * @nr_pages:	The maximum number of pages
  * @pages:	Where the resulting pages are placed
  *
- * find_get_pages_contig() works exactly like find_get_pages(), except
- * that the returned number of pages are guaranteed to be contiguous.
+ * find_get_pages_contig() works exactly like find_get_pages_range(),
+ * except that the returned number of pages are guaranteed to be
+ * contiguous.
  *
  * Return: the number of pages which were found.
  */
@@ -2290,9 +2291,9 @@ EXPORT_SYMBOL(find_get_pages_contig);
  * @nr_pages:	the maximum number of pages
  * @pages:	where the resulting pages are placed
  *
- * Like find_get_pages(), except we only return head pages which are tagged
- * with @tag.  @index is updated to the index immediately after the last
- * page we return, ready for the next iteration.
+ * Like find_get_pages_range(), except we only return head pages which are
+ * tagged with @tag.  @index is updated to the index immediately after the
+ * last page we return, ready for the next iteration.
  *
  * Return: the number of pages which were found.
  */
_

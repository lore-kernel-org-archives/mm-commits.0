Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7353AC43217
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357325AbiCYBbx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357328AbiCYBbb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:31:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FCB31DE5
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:29:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EB2F617C7
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:29:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C5CC340ED;
        Fri, 25 Mar 2022 01:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171797;
        bh=NIBNQ800+DBcYrsy8Hyq/lW0hadgUmTNoB9QMBbf1xU=;
        h=Date:To:From:Subject:From;
        b=KjFRrOP0uC+s6IkCcWC+ZJrBWf/JVMTUtpywqi2nfJbdKcY/UhleDsxnPJcv7Kc2S
         0xOiiPkeyu9kagiH3oNCXLF5CTClxAH5EUcTEYfwlskzVWySKOrEMugaKPkM1NEc9z
         6simDzVB3kB9PsxeUQzUZ00xAddOKdfCA0sfqgYw=
Date:   Thu, 24 Mar 2022 18:29:56 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, vbabka@suse.cz,
        kirill.shutemov@linux.intel.com, hch@lst.de, hannes@cmpxchg.org,
        dhowells@redhat.com, agruenba@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] filemap-remove-find_get_pages.patch removed from -mm tree
Message-Id: <20220325012957.62C5CC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: filemap: remove find_get_pages()
has been removed from the -mm tree.  Its filename was
     filemap-remove-find_get_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch


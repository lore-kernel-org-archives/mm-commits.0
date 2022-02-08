Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC2DC4167E
	for <mm-commits@archiver.kernel.org>; Tue,  8 Feb 2022 22:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386545AbiBHWZt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Feb 2022 17:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386436AbiBHUcv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Feb 2022 15:32:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED65C0613CB
        for <mm-commits@vger.kernel.org>; Tue,  8 Feb 2022 12:32:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 176A5B81A85
        for <mm-commits@vger.kernel.org>; Tue,  8 Feb 2022 20:32:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A887CC004E1;
        Tue,  8 Feb 2022 20:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644352367;
        bh=7KjLi91XIfWzN2uIHENu5L39CmwE92QgH3YYPx8mk3g=;
        h=Date:To:From:Subject:From;
        b=odljKDVb16IhRe88k2UgX5qa8X4lZ4QkUEYB2+5BAooihnSHpapsCRrK5AurF2ztf
         vMJL1nS9jTpUFgHguLcd1nGpA7LG7XDYS5ENEkIsoVLxC6c09UVOrowz4yvdbhKdJ8
         MT3tbsIlDF6hJkQ8YQuo9h5ucEyhg2+D2EQ3eXnc=
Date:   Tue, 08 Feb 2022 12:32:47 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, vbabka@suse.cz,
        kirill.shutemov@linux.intel.com, hannes@cmpxchg.org,
        dhowells@redhat.com, agruenba@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-remove-find_get_pages.patch added to -mm tree
Message-Id: <20220208203247.A887CC004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: filemap: remove find_get_pages()
has been added to the -mm tree.  Its filename is
     filemap-remove-find_get_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/filemap-remove-find_get_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/filemap-remove-find_get_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: filemap: remove find_get_pages()

It's unused now. Remove it and clean up the relevant comment.

Link: https://lkml.kernel.org/r/20220208134149.47299-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
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

mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory.patch
filemap-remove-find_get_pages.patch
mm-sparse-make-mminit_validate_memmodel_limits-static.patch
mm-vmalloc-remove-unneeded-function-forward-declaration.patch
mm-mmzoneh-remove-unused-macros.patch
mm-balloon_compaction-make-balloon-page-compaction-callbacks-static.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages.patch
mm-memory_hotplug-avoid-calling-zone_intersects-for-zone_normal.patch
mm-memory_hotplug-clean-up-try_offline_node.patch
mm-memory_hotplug-fix-misplaced-comment-in-offline_pages.patch
mm-highmem-remove-unnecessary-done-label.patch
mm-hmmc-remove-unneeded-local-variable-ret.patch


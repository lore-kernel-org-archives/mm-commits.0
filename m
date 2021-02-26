Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59102C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:16:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1705164F26
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:16:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbhBZBQH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:16:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:47728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229508AbhBZBQH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:16:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0190364EE1;
        Fri, 26 Feb 2021 01:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302126;
        bh=mAXHuw68jKfGEcqhuOgPAPFnqCvQu/KRezWzAMPsR/Q=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=h/yrAmym+1SMOavDpoe1jZah+wd+k/evHWLVInfVx1LigtkqhjaGYWInTdkU0/0BX
         nIJ4lvg6A6X9Zx1SMPSwN+UdrxvrJ3Y260p6rQPSBNTn0miwu45JVI1Tx4NE2GDT6I
         3FdW+2V89H92PDNBCsdvMGflQr+sJ1tVPPSA1qvw=
Date:   Thu, 25 Feb 2021 17:15:25 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dchinner@redhat.com, hannes@cmpxchg.org,
        hch@lst.de, hughd@google.com, jack@suse.cz,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        william.kucharski@oracle.com, willy@infradead.org,
        yang.shi@linux.alibaba.com
Subject:  [patch 001/118] mm: make pagecache tagged lookups return
 only head pages
Message-ID: <20210226011525.jSx19jby_%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: make pagecache tagged lookups return only head pages

Patch series "Overhaul multi-page lookups for THP", v4.

This THP prep patchset changes several page cache iteration APIs to only
return head pages.

 - It's only possible to tag head pages in the page cache, so only
   return head pages, not all their subpages.
 - Factor a lot of common code out of the various batch lookup routines
 - Add mapping_seek_hole_data()
 - Unify find_get_entries() and pagevec_lookup_entries()
 - Make find_get_entries only return head pages, like find_get_entry().

These are only loosely connected, but they seem to make sense together as
a series.


This patch (of 14):

Pagecache tags are used for dirty page writeback.  Since dirtiness is
tracked on a per-THP basis, we only want to return the head page rather
than each subpage of a tagged page.  All the filesystems which use huge
pages today are in-memory, so there are no tagged huge pages today.

Link: https://lkml.kernel.org/r/20201112212641.27837-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/filemap.c~mm-make-pagecache-tagged-lookups-return-only-head-pages
+++ a/mm/filemap.c
@@ -2062,7 +2062,7 @@ retry:
 EXPORT_SYMBOL(find_get_pages_contig);
 
 /**
- * find_get_pages_range_tag - find and return pages in given range matching @tag
+ * find_get_pages_range_tag - Find and return head pages matching @tag.
  * @mapping:	the address_space to search
  * @index:	the starting page index
  * @end:	The final page index (inclusive)
@@ -2070,8 +2070,9 @@ EXPORT_SYMBOL(find_get_pages_contig);
  * @nr_pages:	the maximum number of pages
  * @pages:	where the resulting pages are placed
  *
- * Like find_get_pages, except we only return pages which are tagged with
- * @tag.   We update @index to index the next page for the traversal.
+ * Like find_get_pages(), except we only return head pages which are tagged
+ * with @tag.  @index is updated to the index immediately after the last
+ * page we return, ready for the next iteration.
  *
  * Return: the number of pages which were found.
  */
@@ -2105,9 +2106,9 @@ unsigned find_get_pages_range_tag(struct
 		if (unlikely(page != xas_reload(&xas)))
 			goto put_page;
 
-		pages[ret] = find_subpage(page, xas.xa_index);
+		pages[ret] = page;
 		if (++ret == nr_pages) {
-			*index = xas.xa_index + 1;
+			*index = page->index + thp_nr_pages(page);
 			goto out;
 		}
 		continue;
_

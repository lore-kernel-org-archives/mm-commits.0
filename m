Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D2A1C77B7A
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 20:01:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbjFGUBA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jun 2023 16:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbjFGUAX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jun 2023 16:00:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6469E211B
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 13:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43944642D0
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 20:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B5DC433D2;
        Wed,  7 Jun 2023 20:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686168019;
        bh=vv4hG3X+3yHl7uU+KobQZmslN8KF9iYjlyhGZcF6SP0=;
        h=Date:To:From:Subject:From;
        b=vp5cF+hrtz082+RKVgMSb7tm7kAv7BW3kde0pTxrQOFN7fMq/Tf0gSAKd6aWOSuW/
         mXmX1RvL0IYYRS4oVGfsMw/JPCk8jW1KB0aY7fMW6bqQqjKx9DZebkbU+vv6ygwOeT
         VB44FGZZxSne2GWGIQ/uz8obRDebd9Hnz55uggx4=
Date:   Wed, 07 Jun 2023 13:00:19 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vannapurve@google.com, songmuchun@bytedance.com,
        sidhartha.kumar@oracle.com, gregkh@linuxfoundation.org,
        erdemaktas@google.com, ackerleytng@google.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] page-cache-fix-page_cache_next-prev_miss-off-by-one.patch removed from -mm tree
Message-Id: <20230607200019.97B5DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: page cache: fix page_cache_next/prev_miss off by one
has been removed from the -mm tree.  Its filename was
     page-cache-fix-page_cache_next-prev_miss-off-by-one.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: page cache: fix page_cache_next/prev_miss off by one
Date: Fri, 2 Jun 2023 15:57:47 -0700

Ackerley Tng reported an issue with hugetlbfs fallocate here[1].  The
issue showed up after the conversion of hugetlb page cache lookup code to
use page_cache_next_miss.  Code in hugetlb fallocate, userfaultfd and GUP
is now using page_cache_next_miss to determine if a page is present the
page cache.  The following statement is used.

	present = page_cache_next_miss(mapping, index, 1) != index;

There are two issues with page_cache_next_miss when used in this way.
1) If the passed value for index is equal to the 'wrap-around' value,
   the same index will always be returned.  This wrap-around value is 0,
   so 0 will be returned even if page is present at index 0.
2) If there is no gap in the range passed, the last index in the range
   will be returned.  When passed a range of 1 as above, the passed
   index value will be returned even if the page is present.
The end result is the statement above will NEVER indicate a page is
present in the cache, even if it is.

As noted by Ackerley in [1], users can see this by hugetlb fallocate
incorrectly returning EEXIST if pages are already present in the file.  In
addition, hugetlb pages will not be included in core dumps if they need to
be brought in via GUP.  userfaultfd UFFDIO_COPY also uses this code and
will not notice pages already present in the cache.  It may try to
allocate a new page and potentially return ENOMEM as opposed to EEXIST.

Both page_cache_next_miss and page_cache_prev_miss have similar issues.
Fix by:
- Check for index equal to 'wrap-around' value and do not exit early.
- If no gap is found in range, return index outside range.
- Update function description to say 'wrap-around' value could be
  returned if passed as index.

[1] https://lore.kernel.org/linux-mm/cover.1683069252.git.ackerleytng@google.com/

Link: https://lkml.kernel.org/r/20230602225747.103865-2-mike.kravetz@oracle.com
Fixes: d0ce0e47b323 ("mm/hugetlb: convert hugetlb fault paths to use alloc_hugetlb_folio()")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Ackerley Tng <ackerleytng@google.com>
Cc: Erdem Aktas <erdemaktas@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/mm/filemap.c~page-cache-fix-page_cache_next-prev_miss-off-by-one
+++ a/mm/filemap.c
@@ -1760,7 +1760,9 @@ bool __folio_lock_or_retry(struct folio
  *
  * Return: The index of the gap if found, otherwise an index outside the
  * range specified (in which case 'return - index >= max_scan' will be true).
- * In the rare case of index wrap-around, 0 will be returned.
+ * In the rare case of index wrap-around, 0 will be returned.  0 will also
+ * be returned if index == 0 and there is a gap at the index.  We can not
+ * wrap-around if passed index == 0.
  */
 pgoff_t page_cache_next_miss(struct address_space *mapping,
 			     pgoff_t index, unsigned long max_scan)
@@ -1770,12 +1772,13 @@ pgoff_t page_cache_next_miss(struct addr
 	while (max_scan--) {
 		void *entry = xas_next(&xas);
 		if (!entry || xa_is_value(entry))
-			break;
-		if (xas.xa_index == 0)
-			break;
+			return xas.xa_index;
+		if (xas.xa_index == 0 && index != 0)
+			return xas.xa_index;
 	}
 
-	return xas.xa_index;
+	/* No gaps in range and no wrap-around, return index beyond range */
+	return xas.xa_index + 1;
 }
 EXPORT_SYMBOL(page_cache_next_miss);
 
@@ -1796,7 +1799,9 @@ EXPORT_SYMBOL(page_cache_next_miss);
  *
  * Return: The index of the gap if found, otherwise an index outside the
  * range specified (in which case 'index - return >= max_scan' will be true).
- * In the rare case of wrap-around, ULONG_MAX will be returned.
+ * In the rare case of wrap-around, ULONG_MAX will be returned.  ULONG_MAX
+ * will also be returned if index == ULONG_MAX and there is a gap at the
+ * index.  We can not wrap-around if passed index == ULONG_MAX.
  */
 pgoff_t page_cache_prev_miss(struct address_space *mapping,
 			     pgoff_t index, unsigned long max_scan)
@@ -1806,12 +1811,13 @@ pgoff_t page_cache_prev_miss(struct addr
 	while (max_scan--) {
 		void *entry = xas_prev(&xas);
 		if (!entry || xa_is_value(entry))
-			break;
-		if (xas.xa_index == ULONG_MAX)
-			break;
+			return xas.xa_index;
+		if (xas.xa_index == ULONG_MAX && index != ULONG_MAX)
+			return xas.xa_index;
 	}
 
-	return xas.xa_index;
+	/* No gaps in range and no wrap-around, return index beyond range */
+	return xas.xa_index - 1;
 }
 EXPORT_SYMBOL(page_cache_prev_miss);
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are



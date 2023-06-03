Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3415CC7EE29
	for <mm-commits@archiver.kernel.org>; Sat,  3 Jun 2023 00:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236854AbjFCA7h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Jun 2023 20:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237058AbjFCA7c (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jun 2023 20:59:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE4C1A8
        for <mm-commits@vger.kernel.org>; Fri,  2 Jun 2023 17:59:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA46561FF9
        for <mm-commits@vger.kernel.org>; Sat,  3 Jun 2023 00:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC5DC4339B;
        Sat,  3 Jun 2023 00:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685753970;
        bh=9c/lazxp/xFMiwRDHi/LwUoDR6u63gbU7RuGFh+7+aI=;
        h=Date:To:From:Subject:From;
        b=c9CLNeQBClT2J5iBRRKPr9c1x0ig1zqbId1uazbEx7Lc+IuoCqzZfOuggdCgwU9vH
         NSEDz4kU94Q7fhqD64LbPdjfZZmYaPAu4aHnMGJGCNvVhzvr6let0m5jVXamqQM4XJ
         1U2sAtBrI20Y2vfOrL/ueNQOMiRO+sqlvVn9NFnw=
Date:   Fri, 02 Jun 2023 17:59:29 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vannapurve@google.com, songmuchun@bytedance.com,
        sidhartha.kumar@oracle.com, gregkh@linuxfoundation.org,
        erdemaktas@google.com, ackerleytng@google.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + page-cache-fix-page_cache_next-prev_miss-off-by-one.patch added to mm-hotfixes-unstable branch
Message-Id: <20230603005930.2FC5DC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: page cache: fix page_cache_next/prev_miss off by one
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     page-cache-fix-page_cache_next-prev_miss-off-by-one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/page-cache-fix-page_cache_next-prev_miss-off-by-one.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Ackerley Tng <ackerleytng@google.com>
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

page-cache-fix-page_cache_next-prev_miss-off-by-one.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A65F4EB64DC
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jun 2023 22:20:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbjFUWUm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jun 2023 18:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbjFUWUl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Jun 2023 18:20:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C713C19AC
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 15:20:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5608E616A4
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 22:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B648DC433C8;
        Wed, 21 Jun 2023 22:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687386038;
        bh=G6zEhkPsOLNkBPYdWkvvlq9Vtreo3Cq++c7mEIrWNxI=;
        h=Date:To:From:Subject:From;
        b=HWTUikXmAdVQMdBClxusLz9vqMVvMgGCh3PziR7rT41NjBqRIwD++jMhVud53OaD0
         swMQS5SPV2+urD9oLpZcM+idMvVzjBvEHiF91LN4C8iXBAl/sKx5/PHu8PUbUxX6ZR
         dT/3YoA9to8WfdDSV5ocUYIUXlQir3ltC1/0C7DA=
Date:   Wed, 21 Jun 2023 15:20:38 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vannapurve@google.com, songmuchun@bytedance.com,
        sidhartha.kumar@oracle.com, oliver.sang@intel.com,
        gregkh@linuxfoundation.org, erdemaktas@google.com,
        ackerleytng@google.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-page-cache-fix-page_cache_next-prev_miss-off-by-one.patch added to mm-unstable branch
Message-Id: <20230621222038.B648DC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "page cache: fix page_cache_next/prev_miss off by one"
has been added to the -mm mm-unstable branch.  Its filename is
     revert-page-cache-fix-page_cache_next-prev_miss-off-by-one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-page-cache-fix-page_cache_next-prev_miss-off-by-one.patch

This patch will later appear in the mm-unstable branch at
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
Subject: Revert "page cache: fix page_cache_next/prev_miss off by one"
Date: Wed, 21 Jun 2023 14:24:02 -0700

This reverts commit 9425c591e06a9ab27a145ba655fb50532cf0bcc9

The reverted commit fixed up routines primarily used by readahead code
such that they could also be used by hugetlb.  Unfortunately, this
caused a performance regression as pointed out by the Closes: tag.

The hugetlb code which uses page_cache_next_miss will be addressed in
a subsequent patch.

Link: https://lkml.kernel.org/r/20230621212403.174710-1-mike.kravetz@oracle.com
Fixes: 9425c591e06a ("page cache: fix page_cache_next/prev_miss off by one")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202306211346.1e9ff03e-oliver.sang@intel.com
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: Erdem Aktas <erdemaktas@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Reviewed-by Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

--- a/mm/filemap.c~revert-page-cache-fix-page_cache_next-prev_miss-off-by-one
+++ a/mm/filemap.c
@@ -1728,9 +1728,7 @@ bool __folio_lock_or_retry(struct folio
  *
  * Return: The index of the gap if found, otherwise an index outside the
  * range specified (in which case 'return - index >= max_scan' will be true).
- * In the rare case of index wrap-around, 0 will be returned.  0 will also
- * be returned if index == 0 and there is a gap at the index.  We can not
- * wrap-around if passed index == 0.
+ * In the rare case of index wrap-around, 0 will be returned.
  */
 pgoff_t page_cache_next_miss(struct address_space *mapping,
 			     pgoff_t index, unsigned long max_scan)
@@ -1740,13 +1738,12 @@ pgoff_t page_cache_next_miss(struct addr
 	while (max_scan--) {
 		void *entry = xas_next(&xas);
 		if (!entry || xa_is_value(entry))
-			return xas.xa_index;
-		if (xas.xa_index == 0 && index != 0)
-			return xas.xa_index;
+			break;
+		if (xas.xa_index == 0)
+			break;
 	}
 
-	/* No gaps in range and no wrap-around, return index beyond range */
-	return xas.xa_index + 1;
+	return xas.xa_index;
 }
 EXPORT_SYMBOL(page_cache_next_miss);
 
@@ -1767,9 +1764,7 @@ EXPORT_SYMBOL(page_cache_next_miss);
  *
  * Return: The index of the gap if found, otherwise an index outside the
  * range specified (in which case 'index - return >= max_scan' will be true).
- * In the rare case of wrap-around, ULONG_MAX will be returned.  ULONG_MAX
- * will also be returned if index == ULONG_MAX and there is a gap at the
- * index.  We can not wrap-around if passed index == ULONG_MAX.
+ * In the rare case of wrap-around, ULONG_MAX will be returned.
  */
 pgoff_t page_cache_prev_miss(struct address_space *mapping,
 			     pgoff_t index, unsigned long max_scan)
@@ -1779,13 +1774,12 @@ pgoff_t page_cache_prev_miss(struct addr
 	while (max_scan--) {
 		void *entry = xas_prev(&xas);
 		if (!entry || xa_is_value(entry))
-			return xas.xa_index;
-		if (xas.xa_index == ULONG_MAX && index != ULONG_MAX)
-			return xas.xa_index;
+			break;
+		if (xas.xa_index == ULONG_MAX)
+			break;
 	}
 
-	/* No gaps in range and no wrap-around, return index beyond range */
-	return xas.xa_index - 1;
+	return xas.xa_index;
 }
 EXPORT_SYMBOL(page_cache_prev_miss);
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

revert-page-cache-fix-page_cache_next-prev_miss-off-by-one.patch
hugetlb-revert-use-of-page_cache_next_miss.patch


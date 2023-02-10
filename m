Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AE1AC05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjBJA5r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:57:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbjBJA4L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:56:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6116A6F8F1
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:54:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F186861BA3
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:54:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A17DC433D2;
        Fri, 10 Feb 2023 00:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990483;
        bh=HdMNGN8h0PA1Oj0Adjo0D9IzdqdLv4ml8syi3DbztIM=;
        h=Date:To:From:Subject:From;
        b=kUA44ZZSFZVlsD9IyvxRf1ITceRONeGodzb/MaDQk5Vh3PuCVn2OzhnEAqWH2aeUm
         wBv2kE5CmfZGG2gWbpV2RHiTwerqqSQFafGG9o2cB1kCBoV9dtyfBLrGxHC8Bl//AT
         Ie1DM1RoA1jZ/MIspAVqRaG6ZkndYJdVq3Q3aWqY=
Date:   Thu, 09 Feb 2023 16:54:42 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org, jhubbard@nvidia.com,
        imbrenda@linux.ibm.com, hch@infradead.org, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, jgg@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-make-get_user_pages_fast_only-return-the-common-return-value.patch removed from -mm tree
Message-Id: <20230210005443.5A17DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: make get_user_pages_fast_only() return the common return value
has been removed from the -mm tree.  Its filename was
     mm-gup-make-get_user_pages_fast_only-return-the-common-return-value.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jason Gunthorpe <jgg@nvidia.com>
Subject: mm/gup: make get_user_pages_fast_only() return the common return value
Date: Tue, 24 Jan 2023 16:34:32 -0400

There are only two callers, both can handle the common return code:

- get_user_page_fast_only() checks == 1

- gfn_to_page_many_atomic() already returns -1, and the only caller
  checks for negative return values

Remove the restriction against returning negative values.

Link: https://lkml.kernel.org/r/11-v2-987e91b59705+36b-gup_tidy_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

--- a/mm/gup.c~mm-gup-make-get_user_pages_fast_only-return-the-common-return-value
+++ a/mm/gup.c
@@ -3005,8 +3005,6 @@ static int internal_get_user_pages_fast(
  *
  * Like get_user_pages_fast() except it's IRQ-safe in that it won't fall back to
  * the regular GUP.
- * Note a difference with get_user_pages_fast: this always returns the
- * number of pages pinned, 0 if no pages were pinned.
  *
  * If the architecture does not support this function, simply return with no
  * pages pinned.
@@ -3018,7 +3016,6 @@ static int internal_get_user_pages_fast(
 int get_user_pages_fast_only(unsigned long start, int nr_pages,
 			     unsigned int gup_flags, struct page **pages)
 {
-	int nr_pinned;
 	/*
 	 * Internally (within mm/gup.c), gup fast variants must set FOLL_GET,
 	 * because gup fast is always a "pin with a +1 page refcount" request.
@@ -3030,19 +3027,7 @@ int get_user_pages_fast_only(unsigned lo
 			       FOLL_GET | FOLL_FAST_ONLY))
 		return -EINVAL;
 
-	nr_pinned = internal_get_user_pages_fast(start, nr_pages, gup_flags,
-						 pages);
-
-	/*
-	 * As specified in the API description above, this routine is not
-	 * allowed to return negative values. However, the common core
-	 * routine internal_get_user_pages_fast() *can* return -errno.
-	 * Therefore, correct for that here:
-	 */
-	if (nr_pinned < 0)
-		nr_pinned = 0;
-
-	return nr_pinned;
+	return internal_get_user_pages_fast(start, nr_pages, gup_flags, pages);
 }
 EXPORT_SYMBOL_GPL(get_user_pages_fast_only);
 
_

Patches currently in -mm which might be from jgg@nvidia.com are



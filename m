Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35913C46467
	for <mm-commits@archiver.kernel.org>; Wed, 11 Jan 2023 20:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234628AbjAKU7v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 15:59:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbjAKU7b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 15:59:31 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87ACA1DF14
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 12:59:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D5F29CE1CFA
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 20:59:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1579BC433D2;
        Wed, 11 Jan 2023 20:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673470755;
        bh=FAAHbvoQHZe8gFnPA3A3NIFfzwgIFjiuki3gqWE6qVk=;
        h=Date:To:From:Subject:From;
        b=NPBoNVMM2I30wXRNyYzLROMxWz8hZU4Uyxk1aRhagiKe2oVKembuzYeo5gc3eOfDK
         XJd5FHLR7OHilkx7zuSc56d3ACGj3I4R7JcE5QLcRWN+LFVG3cXKHQTHxoDD9mqcrL
         PV2IwQUBy0syAzXwfMjwNmsTihxsqeoRvYYkcB3Q=
Date:   Wed, 11 Jan 2023 12:59:14 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-the-hugetlb-field-from-struct-page.patch added to mm-unstable branch
Message-Id: <20230111205915.1579BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove the hugetlb field from struct page
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-the-hugetlb-field-from-struct-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-the-hugetlb-field-from-struct-page.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm: remove the hugetlb field from struct page
Date: Wed, 11 Jan 2023 14:29:14 +0000

Patch series "Get rid of tail page fields".

Continue the shrinkage of the struct page definition by getting rid of the
'first tail page' and 'second tail page' fields.  I originally did this
patch set before Hugh's rewrite of the subpages_mapcount, so it needed
substantial updates; hope I didn't miss anything.


This patch (of 28):

commit dad6a5eb5556(mm,hugetlb: use folio fields in second tail page)
added a transitional hugetlb field to struct page and struct folio to make
room for another int in the first tail of a compound page.  Hugetlb folio
conversions have changed all page users of this field to use the fields
within the folio so struct page no longer needs this hugetlb specific
field.

Link: https://lkml.kernel.org/r/20230111142915.1001531-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20230111142915.1001531-29-willy@infradead.org
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   12 ------------
 1 file changed, 12 deletions(-)

--- a/include/linux/mm_types.h~mm-remove-the-hugetlb-field-from-struct-page
+++ a/include/linux/mm_types.h
@@ -141,14 +141,6 @@ struct page {
 		struct {	/* Tail pages of compound page */
 			unsigned long compound_head;	/* Bit zero is set */
 		};
-		struct {	/* Second tail page of hugetlb page */
-			unsigned long _hugetlb_pad_1;	/* compound_head */
-			void *hugetlb_subpool;
-			void *hugetlb_cgroup;
-			void *hugetlb_cgroup_rsvd;
-			void *hugetlb_hwpoison;
-			/* No more space on 32-bit: use third tail if more */
-		};
 		struct {	/* Page table pages */
 			unsigned long _pt_pad_1;	/* compound_head */
 			pgtable_t pmd_huge_pte; /* protected by page->ptl */
@@ -399,10 +391,6 @@ FOLIO_MATCH(compound_head, _head_1);
 			offsetof(struct page, pg) + 2 * sizeof(struct page))
 FOLIO_MATCH(flags, _flags_2);
 FOLIO_MATCH(compound_head, _head_2);
-FOLIO_MATCH(hugetlb_subpool, _hugetlb_subpool);
-FOLIO_MATCH(hugetlb_cgroup, _hugetlb_cgroup);
-FOLIO_MATCH(hugetlb_cgroup_rsvd, _hugetlb_cgroup_rsvd);
-FOLIO_MATCH(hugetlb_hwpoison, _hugetlb_hwpoison);
 #undef FOLIO_MATCH
 
 /*
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-move-folio_set_compound_order-to-mm-internalh.patch
mm-introduce-folio_is_pfmemalloc.patch
mm-remove-the-hugetlb-field-from-struct-page.patch


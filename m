Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7459EC61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbjBCGg7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:36:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbjBCGgE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:36:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5575A8C432
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4FA461D1D
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452ADC433D2;
        Fri,  3 Feb 2023 06:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406162;
        bh=r3gTKr5cWTUFpHDGlAYNAgg6yY40X4rTkIuq6GBf93E=;
        h=Date:To:From:Subject:From;
        b=FuqWO18LU/8rQg49667xRFAVIZDwrlz+W82GwU8w0VH2Vbv3DwUFkJALgCAh7HXPY
         RW4ii+WJq86lJVngHqFhxkvYTWx0fIi64NFBbFWVwb8OnMPm23VwdNZM6TkmRVRotM
         AKSmnlVCA0Qiim4LgvHqKRtcY8vEA1phVK2JA3ko=
Date:   Thu, 02 Feb 2023 22:36:01 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-the-hugetlb-field-from-struct-page.patch removed from -mm tree
Message-Id: <20230203063602.452ADC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove the hugetlb field from struct page
has been removed from the -mm tree.  Its filename was
     mm-remove-the-hugetlb-field-from-struct-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-hugetlb-convert-isolate_hugetlb-to-folios.patch
mm-hugetlb-convert-__update_and_free_page-to-folios.patch
mm-hugetlb-convert-dequeue_hugetlb_page-functions-to-folios.patch
mm-hugetlb-convert-alloc_surplus_huge_page-to-folios.patch
mm-hugetlb-increase-use-of-folios-in-alloc_huge_page.patch
mm-hugetlb-convert-alloc_migrate_huge_page-to-folios.patch
mm-hugetlb-convert-restore_reserve_on_error-to-folios.patch
mm-hugetlb-convert-demote_free_huge_page-to-folios.patch
mm-hugetlb-convert-hugetlb_install_page-to-folios.patch
mm-hugetlb-convert-hugetlbfs_pagecache_present-to-folios.patch
mm-hugetlb-convert-putback_active_hugepage-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb-fault-paths-to-use-alloc_hugetlb_folio.patch
mm-hugetlb-convert-restore_reserve_on_error-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb_add_to_page_cache-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb_wp-to-take-in-a-folio.patch
documentation-mm-update-hugetlbfs-documentation-to-mention-alloc_hugetlb_folio.patch


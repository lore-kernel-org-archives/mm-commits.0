Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3690C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:49:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6EC22086A
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596779368;
	bh=dgvJlWfKQugWLJ4y+pfFhG7FRpkavV5oXNyrRsCFhUU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=aNORm1GUJ161yhb1+yh5W5IQh6n1y0z0CkQZITjfRJ6FO5+mktNR6LFf4niwz/Zcb
	 q3lcUF31b8DItUtx5LjVYWsH0beK7W12a0cnDFbBzw8YFytHyOzKZt9hDhQi3bvxGw
	 J8/IlrvEn2WqQPxcg/ROjEYCnE179tCTln+OenRU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgHGFt2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 01:49:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725287AbgHGFt2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 01:49:28 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BDF020866;
        Fri,  7 Aug 2020 05:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596779367;
        bh=dgvJlWfKQugWLJ4y+pfFhG7FRpkavV5oXNyrRsCFhUU=;
        h=Date:From:To:Subject:From;
        b=EDF0n9RcM081eZk0s/0BhkH9A2LAU+AWoWfrBt0uzOw1iLcIeNlSPFdsi2umyEs1a
         qIylmg655umAN9NWe09fdmsqAkqGCAWGNuwMye1zjVtciFoVyQ5n8REW4MgL8yOzsi
         TcrdJwSeWDO6nCoTBaaixM9+xuFoQfsbKspWmBCQ=
Date:   Thu, 06 Aug 2020 22:49:26 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, jhubbard@nvidia.com,
        kirill@shutemov.name, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, vbabka@suse.cz, william.kucharski@oracle.com,
        willy@infradead.org
Subject:  [folded-merged]
 mm-handle-page-mapping-better-in-dump_page-fix.patch removed from -mm tree
Message-ID: <20200807054926.DjsdLaWjE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-handle-page-mapping-better-in-dump_page-fix
has been removed from the -mm tree.  Its filename was
     mm-handle-page-mapping-better-in-dump_page-fix.patch

This patch was dropped because it was folded into mm-handle-page-mapping-better-in-dump_page.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-handle-page-mapping-better-in-dump_page-fix

augmented code comment from John

Link: http://lkml.kernel.org/r/15cff11a-6762-8a6a-3f0e-dd227280cd6f@nvidia.com
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/debug.c~mm-handle-page-mapping-better-in-dump_page-fix
+++ a/mm/debug.c
@@ -69,7 +69,13 @@ void __dump_page(struct page *page, cons
 	}
 
 	if (page < head || (page >= head + MAX_ORDER_NR_PAGES)) {
-		/* Corrupt page, cannot call page_mapping */
+		/*
+		 * Corrupt page, so we cannot call page_mapping. Instead, do a
+		 * safe subset of the steps that page_mapping() does. Caution:
+		 * this will be misleading for tail pages, PageSwapCache pages,
+		 * and potentially other situations. (See the page_mapping()
+		 * implementation for what's missing here.)
+		 */
 		unsigned long tmp = (unsigned long)page->mapping;
 
 		if (tmp & PAGE_MAPPING_ANON)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-handle-page-mapping-better-in-dump_page.patch
mm-thp-replace-http-links-with-https-ones-fix.patch
mm.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-hugetlb-add-mempolicy-check-in-the-reservation-routine-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
mm-migrate-make-a-standard-migration-target-allocation-function-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch


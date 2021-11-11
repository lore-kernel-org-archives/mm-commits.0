Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDCCFC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D09BD61208
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234132AbhKKCsX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:48:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:53222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234361AbhKKCsL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:48:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1B4860F46;
        Thu, 11 Nov 2021 02:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598722;
        bh=Kxa08V78o3CV+x27kq7WwrRw+wX6TAauLzqfgb5fuXY=;
        h=Date:From:To:Subject:From;
        b=WnDkKzZ7wuYcc5TTwSDtVVNkHsOTsCW97xbBleNK5NAsrCIGYO0EayDDLjkpsY8Pm
         fMRSjWau/hJB+S5ThFCJB7RGsVoK8G1kFtRfOym4UHWwy9EwPW99t4ItWacas/rWJS
         ldJBDu7qHPrmvJMn+tBdv6R2kx+d09zoam+swVjU=
Date:   Wed, 10 Nov 2021 18:45:22 -0800
From:   akpm@linux-foundation.org
To:     mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, pasha.tatashin@soleen.com,
        songmuchun@bytedance.com, willy@infradead.org
Subject:  [merged]
 =?US-ASCII?Q?hugetlb-remove-unnecessary-set=5Fpage=5Fcount-in-prep=5Fcomp?=
 =?US-ASCII?Q?ound=5Fgigantic=5Fpage.patch?= removed from -mm tree
Message-ID: <20211111024522.2TzdFn2jK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: remove unnecessary set_page_count in prep_compound_gigantic_page
has been removed from the -mm tree.  Its filename was
     hugetlb-remove-unnecessary-set_page_count-in-prep_compound_gigantic_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: remove unnecessary set_page_count in prep_compound_gigantic_page

In commit 7118fc2906e29 ("hugetlb: address ref count racing in
prep_compound_gigantic_page"), page_ref_freeze is used to atomically zero
the ref count of tail pages iff they are 1.  The unconditional call to
set_page_count(0) was left in the code.  This call is after
page_ref_freeze so it is really a noop.

Remove redundant and unnecessary set_page_count call.

Link: https://lkml.kernel.org/r/20211026220635.35187-1-mike.kravetz@oracle.com
Fixes: 7118fc2906e29 ("hugetlb: address ref count racing in prep_compound_gigantic_page")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/hugetlb.c~hugetlb-remove-unnecessary-set_page_count-in-prep_compound_gigantic_page
+++ a/mm/hugetlb.c
@@ -1792,7 +1792,6 @@ static bool __prep_compound_gigantic_pag
 		} else {
 			VM_BUG_ON_PAGE(page_count(p), p);
 		}
-		set_page_count(p, 0);
 		set_compound_head(p, page);
 	}
 	atomic_set(compound_mapcount_ptr(page), -1);
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are



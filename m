Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C66E6C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9348E22CF6
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781577;
	bh=R/J9wYhkC2ROECBjlhXoxiqOfcsT0hjnDSt3+QsEc3Q=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Tw2PbkrZOMe3IImVz0pBWddSA2XpCpxLYYTKD9OFZ16GuxTjCwmtpa/DofZB7VU0r
	 DkcT5H60v4dLvEuXbDc7mln3QeJvvXBBGHzH26KUmO+C9om6ZV2fn6a7RBybzu+Cqw
	 9rQsUYrUaz/RcT2PXBpjVnDnTCEP3bPrMAxHtPi4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgHGG0R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:26:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:34822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgHGG0R (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:26:17 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0018222D2C;
        Fri,  7 Aug 2020 06:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781576;
        bh=R/J9wYhkC2ROECBjlhXoxiqOfcsT0hjnDSt3+QsEc3Q=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LmJFtiTLFGpWtnjMDkY/FcGBBIZC0Vm+T6XLdRC7IYBoTGQjANHx+Ag4Q0mGYRX59
         2LEUWapAdYZpVkFgFNoI9Z+OWIdT9IZwg6NOylgC/YXbOu8D6CY69GGOS77LEcVop2
         qw7oOgdBHXCMULZBYx5QyZWnnuyTVJLudlCEwP4A=
Date:   Thu, 06 Aug 2020 23:26:15 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        songliubraving@fb.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 158/163] khugepaged: collapse_pte_mapped_thp()
 flush the right range
Message-ID: <20200807062615.qiADx5DeQ%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Hugh Dickins <hughd@google.com>
Subject: khugepaged: collapse_pte_mapped_thp() flush the right range

pmdp_collapse_flush() should be given the start address at which the huge
page is mapped, haddr: it was given addr, which at that point has been
used as a local variable, incremented to the end address of the extent.

Found by source inspection while chasing a hugepage locking bug, which I
then could not explain by this.  At first I thought this was very bad;
then saw that all of the page translations that were not flushed would
actually still point to the right pages afterwards, so harmless; then
realized that I know nothing of how different architectures and models
cache intermediate paging structures, so maybe it matters after all -
particularly since the page table concerned is immediately freed.

Much easier to fix than to think about.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2008021204390.27773@eggly.anvils
Fixes: 27e1f8273113 ("khugepaged: enable collapse pmd for pte-mapped THP")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: <stable@vger.kernel.org>	[5.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c~khugepaged-collapse_pte_mapped_thp-flush-the-right-range
+++ a/mm/khugepaged.c
@@ -1502,7 +1502,7 @@ void collapse_pte_mapped_thp(struct mm_s
 
 	/* step 4: collapse pmd */
 	ptl = pmd_lock(vma->vm_mm, pmd);
-	_pmd = pmdp_collapse_flush(vma, addr, pmd);
+	_pmd = pmdp_collapse_flush(vma, haddr, pmd);
 	spin_unlock(ptl);
 	mm_dec_nr_ptes(mm);
 	pte_free(mm, pmd_pgtable(_pmd));
_

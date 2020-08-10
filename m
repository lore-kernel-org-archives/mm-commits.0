Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77647C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50B36206CD
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026965;
	bh=Mjk4iMVtL8jaRdcAHhS+bp5dY8slsW3AGpBTERtmSa4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=WZWV9d/tAbRRJXxNSptJf+6QVBVSTv0emv7IVgD6ih53mV4GSlyDeZZb4jdB++djf
	 nrLDHrmQ2DH3uyXcz3mytsKZzuhfFYZ8uuQAPYFCQXalUr9LsYf3/+4ovg52n08US9
	 A4a3A4pMh0xjbZdFF+rTK9GD7HSqQst++WNZafmw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgHJCgF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:36:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCgE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:36:04 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A69D2065D;
        Mon, 10 Aug 2020 02:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026964;
        bh=Mjk4iMVtL8jaRdcAHhS+bp5dY8slsW3AGpBTERtmSa4=;
        h=Date:From:To:Subject:From;
        b=M8sjZ9ATPLAh4bQ4yFcLYuLHZuzRBPmweiDohai9PoA4DOHwTa6niO2S6wR2qI012
         gJTxu8cH/q2VmoNrGW8HupEJCRruzaLv6CCVi5Xebj5i/xsclXfMw0DOILMTIl350p
         jLUT7uDEX1DWL0/peMVckYCMW4TuXxpxsD0JSYq4=
Date:   Sun, 09 Aug 2020 19:36:04 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, ira.weiny@intel.com,
        mm-commits@vger.kernel.org, tangyizhou@huawei.com
Subject:  [merged]
 mm-gupc-fix-the-comment-of-return-value-for-populate_vma_page_range.patch
 removed from -mm tree
Message-ID: <20200810023604.YnipH4kH1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup.c: fix the comment of return value for populate_vma_page_range()
has been removed from the -mm tree.  Its filename was
     mm-gupc-fix-the-comment-of-return-value-for-populate_vma_page_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Yizhou <tangyizhou@huawei.com>
Subject: mm/gup.c: fix the comment of return value for populate_vma_page_range()

The return value of populate_vma_page_range() is consistent with
__get_user_pages(), and so is the function comment of return value.

Link: http://lkml.kernel.org/r/20200720034303.29920-1-tangyizhou@huawei.com
Signed-off-by: Tang Yizhou <tangyizhou@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/gup.c~mm-gupc-fix-the-comment-of-return-value-for-populate_vma_page_range
+++ a/mm/gup.c
@@ -1404,7 +1404,8 @@ retry:
  *
  * This takes care of mlocking the pages too if VM_LOCKED is set.
  *
- * return 0 on success, negative error code on error.
+ * Return either number of pages pinned in the vma, or a negative error
+ * code on error.
  *
  * vma->vm_mm->mmap_lock must be held.
  *
_

Patches currently in -mm which might be from tangyizhou@huawei.com are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C1C2C4743C
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35D4522D73
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgLOX7e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:60888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729296AbgLOXZG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:25:06 -0500
Date:   Tue, 15 Dec 2020 15:22:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074548;
        bh=bomPxFfYYs3zDxGTB2Ox5FLwYl5R7kL45XyLA+TYKPU=;
        h=From:To:Subject:From;
        b=hDwexRCsdm/PEQ+OIYA06TFTREkxeTNDieRjMsn2S03SdAuO188i4NnbyPicv/tnS
         g/GCSqYJO+oFpweIOaN/mvZ0DuwRkh25tgpKpqObqp2LTbrCd/sg9UFHMJBnDvtVOs
         yz0+cNeSDHWxcLbsNLtFDWUb9GsPCYOEg/uDWcPk=
From:   akpm@linux-foundation.org
To:     mike.kravetz@oracle.com, mm-commits@vger.kernel.org, sh_def@163.com
Subject:  [merged]
 mm-hugetlbc-just-use-put_page_testzero-instead-of-page_count.patch removed
 from -mm tree
Message-ID: <20201215232228.rfi_KJehy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: just use put_page_testzero() instead of page_count()
has been removed from the -mm tree.  Its filename was
     mm-hugetlbc-just-use-put_page_testzero-instead-of-page_count.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hui Su <sh_def@163.com>
Subject: mm/hugetlb.c: just use put_page_testzero() instead of page_count()

We test the page reference count is zero or not here, it can be a bug here
if page refercence count is not zero.  So we can just use
put_page_testzero() instead of page_count().

Link: https://lkml.kernel.org/r/20201007170949.GA6416@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlbc-just-use-put_page_testzero-instead-of-page_count
+++ a/mm/hugetlb.c
@@ -2014,8 +2014,7 @@ retry:
 		 * This page is now managed by the hugetlb allocator and has
 		 * no users -- drop the buddy allocator's reference.
 		 */
-		put_page_testzero(page);
-		VM_BUG_ON_PAGE(page_count(page), page);
+		VM_BUG_ON_PAGE(!put_page_testzero(page), page);
 		enqueue_huge_page(h, page);
 	}
 free:
_

Patches currently in -mm which might be from sh_def@163.com are

fs-proc-make-pde_get-return-nothing.patch
acctc-use-elif-instead-of-end-and-elif.patch
mm-memcontrol-rewrite-mem_cgroup_page_lruvec.patch


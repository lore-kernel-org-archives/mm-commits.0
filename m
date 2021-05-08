Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 181B5C43460
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED7796101D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhEHWs2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:48:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229726AbhEHWsY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:48:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70B656100C;
        Sat,  8 May 2021 22:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514042;
        bh=/1/WmEaadBJfHJ1sRy1z3NkcQL4p+dUgpdAkKFh/9Ro=;
        h=Date:From:To:Subject:From;
        b=J9f8E5pIQ6yIcejrxfnBnPi2RtgAhJD1J0vRBHr7jDiGqzONTv3VIAt0UaIaNs8sK
         f5Z0p4xpPTXH5k2Nifc7NHpU3y8yIuL48MXiyP90rxt8chK70Ccfe6fNrTUwEQwrew
         fM0qfNS5Ao6LMJAeABIKV3SuFvtMCjo/tD6Z26j8=
Date:   Sat, 08 May 2021 15:47:22 -0700
From:   akpm@linux-foundation.org
To:     linfeilong@huawei.com, linmiaohe@huawei.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-hugeltb-clarify-chg-freed-wont-go-negative-in-hugetlb=5Fu?=
 =?US-ASCII?Q?nreserve=5Fpages.patch?= removed from -mm tree
Message-ID: <20210508224722.MMFRV1e3Q%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugeltb: clarify (chg - freed) won't go negative in hugetlb_unreserve_pages()
has been removed from the -mm tree.  Its filename was
     mm-hugeltb-clarify-chg-freed-wont-go-negative-in-hugetlb_unreserve_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugeltb: clarify (chg - freed) won't go negative in hugetlb_unreserve_pages()

The resv_map could be NULL since this routine can be called in the evict
inode path for all hugetlbfs inodes and we will have chg = 0 in this case.
But (chg - freed) won't go negative as Mike pointed out:

 "If resv_map is NULL, then no hugetlb pages can be allocated/associated
  with the file.  As a result, remove_inode_hugepages will never find any
  huge pages associated with the inode and the passed value 'freed' will
  always be zero."

Add a comment clarifying this to make it clear and also avoid confusion.

Link: https://lkml.kernel.org/r/20210410072348.20437-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Feilong Lin <linfeilong@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/hugetlb.c~mm-hugeltb-clarify-chg-freed-wont-go-negative-in-hugetlb_unreserve_pages
+++ a/mm/hugetlb.c
@@ -5267,6 +5267,9 @@ long hugetlb_unreserve_pages(struct inod
 	/*
 	 * If the subpool has a minimum size, the number of global
 	 * reservations to be released may be adjusted.
+	 *
+	 * Note that !resv_map implies freed == 0. So (chg - freed)
+	 * won't go negative.
 	 */
 	gbl_reserve = hugepage_subpool_put_pages(spool, (chg - freed));
 	hugetlb_acct_memory(h, -gbl_reserve);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are



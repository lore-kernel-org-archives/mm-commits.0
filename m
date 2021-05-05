Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE4CC43460
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B9B461410
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbhEEBfd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:35:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231204AbhEEBfc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:35:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38D276140E;
        Wed,  5 May 2021 01:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178476;
        bh=+kxJsZ3bUkrf1i/p3WMPwrvJzcXe4xUv631W5mLCy44=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jhr+LgmHjsEhh3t4RqIMcp9Z9eRL7gyV5vAnhHNATHma15sh8gY1AO5QkmS7CGSmH
         a7tJkSQErz3Cp5Jo/75lfr0dgZHS05Y4xfmTD+2dp+7TC5UE8el6hZK+NvXVeSHBEN
         cVcFhgOIytJkfDdE7LVptBlZHwib4yyiFtRGId3A=
Date:   Tue, 04 May 2021 18:34:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linfeilong@huawei.com,
        linmiaohe@huawei.com, linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 036/143] mm/hugeltb: clarify (chg - freed) won't
 go negative in hugetlb_unreserve_pages()
Message-ID: <20210505013435.BSlxlrD-G%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

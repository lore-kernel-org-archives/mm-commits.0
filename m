Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 576AEC43460
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:34:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A5F961410
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbhEEBfj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:35:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231204AbhEEBfi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:35:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B462613FE;
        Wed,  5 May 2021 01:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178482;
        bh=zEi9OOV5PPDPy4R4AfeMLga5nWsrPNegUa58a0qUyuE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZSLjsVI5jC8FI2OgC2TZdu298+ktR1LDt6aIRDhuSMlrdVtpBB+kxH1Oa1t0YfgaP
         ObAvCNOuPZoTItDWfOs2Subi2L2l40oxGsZm5FnNrCzwkEftpKyZfVv4D3ofYV15h5
         fq3aa1USheB47UJHAPk548nuG0yFQ+BOlgo7160Q=
Date:   Tue, 04 May 2021 18:34:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linfeilong@huawei.com,
        linmiaohe@huawei.com, linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 038/143] mm/hugetlb: remove unused variable
 pseudo_vma in remove_inode_hugepages()
Message-ID: <20210505013441.GTdaJx1OO%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: remove unused variable pseudo_vma in remove_inode_hugepages()

The local variable pseudo_vma is not used anymore.

Link: https://lkml.kernel.org/r/20210410072348.20437-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Feilong Lin <linfeilong@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/hugetlbfs/inode.c~mm-hugetlb-remove-unused-variable-pseudo_vma-in-remove_inode_hugepages
+++ a/fs/hugetlbfs/inode.c
@@ -463,14 +463,11 @@ static void remove_inode_hugepages(struc
 	struct address_space *mapping = &inode->i_data;
 	const pgoff_t start = lstart >> huge_page_shift(h);
 	const pgoff_t end = lend >> huge_page_shift(h);
-	struct vm_area_struct pseudo_vma;
 	struct pagevec pvec;
 	pgoff_t next, index;
 	int i, freed = 0;
 	bool truncate_op = (lend == LLONG_MAX);
 
-	vma_init(&pseudo_vma, current->mm);
-	pseudo_vma.vm_flags = (VM_HUGETLB | VM_MAYSHARE | VM_SHARED);
 	pagevec_init(&pvec);
 	next = start;
 	while (next < end) {
_

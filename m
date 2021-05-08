Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43A68C43460
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 264D661424
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhEHWsg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:48:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229699AbhEHWs1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:48:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7521B61456;
        Sat,  8 May 2021 22:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514045;
        bh=/kc1X4Gr/0nBMIUpnQstmm+ta9OECWO9qjZyaf4uVGs=;
        h=Date:From:To:Subject:From;
        b=BwfxnebJ/zgxtQe+tKZQR3hKRUCF0q6dDxOWTUwamD/NCo1A/dYbHTvhWn40uHmau
         7IY/iN6DWaIY0lprcZi7tqa9WblDJOnSy/muUMnHgB4egDZN9w7k6zuMyrlvIwGtfi
         KXOwqkomuXYQPhJosrzv70rdwX7cuCCaO96/EAgc=
Date:   Sat, 08 May 2021 15:47:25 -0700
From:   akpm@linux-foundation.org
To:     linfeilong@huawei.com, linmiaohe@huawei.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-hugetlb-remove-unused-variable-pseudo=5Fvma-in-remove=5Fi?=
 =?US-ASCII?Q?node=5Fhugepages.patch?= removed from -mm tree
Message-ID: <20210508224725.yftbVuXJH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: remove unused variable pseudo_vma in remove_inode_hugepages()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-remove-unused-variable-pseudo_vma-in-remove_inode_hugepages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are



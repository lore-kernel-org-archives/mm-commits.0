Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D447C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:46:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0852B6141E
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:46:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhEHWrj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:47:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhEHWrj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:47:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84519610D2;
        Sat,  8 May 2021 22:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513996;
        bh=b7HUxtQHyPl6Uf08V4AEuwlUOb3PNQmApLnvijnLcSw=;
        h=Date:From:To:Subject:From;
        b=dwcgtzDuhGWI+invlRQ+CRAn6TgTIX/N6gRNkVjx7ihDzhsiKlQI4mlOuX/qYfMMq
         LHRSy67zdmVpBVlszb4O1wyvrZbRoKjwCzJpaQkAC67wnPqxxTxqMvrlc+hEfDtWnc
         bPSWqCfopX4talGT1vI4egZBnwDg6Aeya3DZ3Ato=
Date:   Sat, 08 May 2021 15:46:36 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-hugetlb-avoid-calculating-fault_mutex_hash-in-truncate_op-case.patch
 removed from -mm tree
Message-ID: <20210508224636.E2d6rh4GF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: avoid calculating fault_mutex_hash in truncate_op case
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-avoid-calculating-fault_mutex_hash-in-truncate_op-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: avoid calculating fault_mutex_hash in truncate_op case

The fault_mutex hashing overhead can be avoided in truncate_op case
because page faults can not race with truncation in this routine.  So
calculate hash for fault_mutex only in !truncate_op case to save some cpu
cycles.

Link: https://lkml.kernel.org/r/20210308112809.26107-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/hugetlbfs/inode.c~mm-hugetlb-avoid-calculating-fault_mutex_hash-in-truncate_op-case
+++ a/fs/hugetlbfs/inode.c
@@ -482,10 +482,9 @@ static void remove_inode_hugepages(struc
 
 		for (i = 0; i < pagevec_count(&pvec); ++i) {
 			struct page *page = pvec.pages[i];
-			u32 hash;
+			u32 hash = 0;
 
 			index = page->index;
-			hash = hugetlb_fault_mutex_hash(mapping, index);
 			if (!truncate_op) {
 				/*
 				 * Only need to hold the fault mutex in the
@@ -493,6 +492,7 @@ static void remove_inode_hugepages(struc
 				 * page faults.  Races are not possible in the
 				 * case of truncation.
 				 */
+				hash = hugetlb_fault_mutex_hash(mapping, index);
 				mutex_lock(&hugetlb_fault_mutex_table[hash]);
 			}
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are



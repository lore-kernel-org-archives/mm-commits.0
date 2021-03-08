Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F3F9C433E9
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 20:03:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3A0765208
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 20:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhCHUCb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Mar 2021 15:02:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:55480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231424AbhCHUB7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Mar 2021 15:01:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E872165238;
        Mon,  8 Mar 2021 20:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615233719;
        bh=cUPRm7v1/ZVofpoLJilN8BLan5gCVolYJjCPCdkAFH4=;
        h=Date:From:To:Subject:From;
        b=Ligu1J8JKydWsWNlyYZPaQzPHLvcTbzq6jWHXA2CHVx6fhZbXE7HbFkLeJ8I7bGjk
         3mYqMmfY7yeGpEi7NRUq70Vx1Hp7j+7a5z6/qpdPaq953ctWFBxtLMcGzZKoKi+8r+
         hUJU+Zf1/9ZreNQXwq1wXMpzEpVZeQmtkpeX94M0=
Date:   Mon, 08 Mar 2021 12:01:58 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  +
 mm-hugetlb-avoid-calculating-fault_mutex_hash-in-truncate_op-case.patch
 added to -mm tree
Message-ID: <20210308200158.woXLxdeeV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: avoid calculating fault_mutex_hash in truncate_op case
has been added to the -mm tree.  Its filename is
     mm-hugetlb-avoid-calculating-fault_mutex_hash-in-truncate_op-case.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-avoid-calculating-fault_mutex_hash-in-truncate_op-case.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-avoid-calculating-fault_mutex_hash-in-truncate_op-case.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

hugetlb_cgroup-fix-imbalanced-css_get-and-css_put-pair-for-shared-mappings.patch
mm-hugetlb-remove-redundant-reservation-check-condition-in-alloc_huge_page.patch
mm-hugetlb-use-some-helper-functions-to-cleanup-code.patch
mm-hugetlb-optimize-the-surplus-state-transfer-code-in-move_hugetlb_state.patch
hugetlb_cgroup-remove-unnecessary-vm_bug_on_page-in-hugetlb_cgroup_migrate.patch
mm-hugetlb-simplify-the-code-when-alloc_huge_page-failed-in-hugetlb_no_page.patch
mm-hugetlb-avoid-calculating-fault_mutex_hash-in-truncate_op-case.patch


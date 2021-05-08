Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1B9CC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:46:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDD61613E8
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:46:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhEHWrq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:47:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229567AbhEHWrp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:47:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C5EC610D2;
        Sat,  8 May 2021 22:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514003;
        bh=rqmv9kjWJ+elIkY+mJRy5KMZtYjUuaZqdorNuXi99zw=;
        h=Date:From:To:Subject:From;
        b=lLEppO4naKvee7jhfOKZvuD2rqJ/DXHUiweQDOcp6soXQXInY1Y5K9+pC99zLMNZu
         eBMCivPUnkjaOUEp7Y79kGuj+8m//r/I7AdVO6ooX2MdSHF5tVpt1plqekPh2iLuWM
         Dqom7NJp9ubUe4PqSP0jf+JdDjNdWivN6WzNf7QM=
Date:   Sat, 08 May 2021 15:46:43 -0700
From:   akpm@linux-foundation.org
To:     dan.carpenter@oracle.com, ebru.akagunduz@gmail.com,
        kirill.shutemov@linux.intel.com, linmiaohe@huawei.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        riel@redhat.com
Subject:  [merged]
 khugepaged-use-helper-khugepaged_test_exit-in-__khugepaged_enter.patch
 removed from -mm tree
Message-ID: <20210508224643.7VIggcTC7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: khugepaged: use helper khugepaged_test_exit() in __khugepaged_enter()
has been removed from the -mm tree.  Its filename was
     khugepaged-use-helper-khugepaged_test_exit-in-__khugepaged_enter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: khugepaged: use helper khugepaged_test_exit() in __khugepaged_enter()

Commit 4d45e75a9955 ("mm: remove the now-unnecessary mmget_still_valid()
hack") have made khugepaged_test_exit() suitable for check mm->mm_users
against 0.  Use this helper here.

Link: https://lkml.kernel.org/r/20210306032947.35921-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c~khugepaged-use-helper-khugepaged_test_exit-in-__khugepaged_enter
+++ a/mm/khugepaged.c
@@ -481,7 +481,7 @@ int __khugepaged_enter(struct mm_struct
 		return -ENOMEM;
 
 	/* __khugepaged_exit() must not run from under us */
-	VM_BUG_ON_MM(atomic_read(&mm->mm_users) == 0, mm);
+	VM_BUG_ON_MM(khugepaged_test_exit(mm), mm);
 	if (unlikely(test_and_set_bit(MMF_VM_HUGEPAGE, &mm->flags))) {
 		free_mm_slot(mm_slot);
 		return 0;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are



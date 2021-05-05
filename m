Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC185C433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:33:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D38F0613E4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:33:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbhEEBej (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:34:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231946AbhEEBej (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:34:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB3D5613EC;
        Wed,  5 May 2021 01:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178424;
        bh=lVPXFdXpi8zgvG7yMlN1WZxsFB9nGfmSTj3riuxImpQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vQkbZcsJ9FuKBM4JCOnDa+aB3svFUb+BcQu3fEVqlomKtiParqNMiz0f1jB5gm8Yx
         MUPKlrjiG26XxmsXPaumKJwzMZZb4x4Qtq5MUzaKqcA9eldvc0dvxyofQuWI8s2bEK
         eYVqBdhOLvJwo2CrY1fC3Q5hLIQd9XsUFIAsnlQ0=
Date:   Tue, 04 May 2021 18:33:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.carpenter@oracle.com,
        ebru.akagunduz@gmail.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, riel@redhat.com,
        torvalds@linux-foundation.org
Subject:  [patch 019/143] khugepaged: use helper
 khugepaged_test_exit() in __khugepaged_enter()
Message-ID: <20210505013343.qetqCkfj-%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

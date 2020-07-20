Return-Path: <SRS0=eezP=A7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02EC5C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 20 Jul 2020 23:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C77A321702
	for <mm-commits@archiver.kernel.org>; Mon, 20 Jul 2020 23:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595287576;
	bh=IX1nKUJR1JQ0KPB/JaSMxZaPlg+TRJtLH7U5JcIa5Fg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=HH0qobEkpWZDPMrS4aY8tPf6iPpWEF3iQEn4k9HVw38IdkHkCe4xGkmYrpEPCKIOz
	 Jbj//7Go5ENOdzr1c6vD8lVSPW2GfPfgNcjSdeX2anaNTklh6cQK8u/kfj8th79jO1
	 gLMmzIT0srI3WrBOv1Ud3BQHIFndVoEQQ6+PrrcU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgGTX0Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Jul 2020 19:26:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726021AbgGTX0Q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Jul 2020 19:26:16 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E6B62080D;
        Mon, 20 Jul 2020 23:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595287575;
        bh=IX1nKUJR1JQ0KPB/JaSMxZaPlg+TRJtLH7U5JcIa5Fg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gPIodgEwMecmXs1STa6czpye1H6cjrZkwcC3r0XEdmCPuTP7rn2s54CUQ/1ptjqC2
         gGpLvVN9sgEs3zLZqA7zj3uHllMR0/wkZrFZ0CHZpeZHRX1lem9IgS/xup/yolAeAu
         DbCruvXArn01v7PZwKJ/NgbK6HZLbg/1pgwF5jIU=
Date:   Mon, 20 Jul 2020 16:26:15 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        tangyizhou@huawei.com
Subject:  +
 mm-gupc-fix-the-comment-of-return-value-for-populate_vma_page_range.patch
 added to -mm tree
Message-ID: <20200720232615.kH7FLWhXz%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup.c: Fix the comment of return value for populate_vma_page_range()
has been added to the -mm tree.  Its filename is
     mm-gupc-fix-the-comment-of-return-value-for-populate_vma_page_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gupc-fix-the-comment-of-return-value-for-populate_vma_page_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-gupc-fix-the-comment-of-return-value-for-populate_vma_page_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tang Yizhou <tangyizhou@huawei.com>
Subject: mm/gup.c: Fix the comment of return value for populate_vma_page_range()

The return value of populate_vma_page_range() is consistent with
__get_user_pages(), and so is the function comment of return value.

Link: http://lkml.kernel.org/r/20200720034303.29920-1-tangyizhou@huawei.com
Signed-off-by: Tang Yizhou <tangyizhou@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-gupc-fix-the-comment-of-return-value-for-populate_vma_page_range.patch


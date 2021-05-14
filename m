Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2B60C433ED
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 22:28:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C06661454
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 22:28:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232674AbhENW3l (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 May 2021 18:29:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231377AbhENW3l (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 May 2021 18:29:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C4B1613DE;
        Fri, 14 May 2021 22:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621031309;
        bh=qeW7ve/Vq7riOXjPyqR3bo3V+uxroJFv8IXI6Ynp3ZU=;
        h=Date:From:To:Subject:From;
        b=PTPY6OitOhOLD89E+bhNhUd989BAn1K+KhyIyf1gmAFuKktpaeCtQLWSQBRswEr7k
         9rFP7EWHd+E7/X21se0qUlf6I3EF8K/9CvsglnTx2pxb8jYjL56UYO2b0Tmrct4/YZ
         pQqgXXj7uz/kmLeOJZ+Bw+B/lEkmPjEVMpb38eRM=
Date:   Fri, 14 May 2021 15:28:29 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, pulehui@huawei.com, shy828301@gmail.com
Subject:  +
 mm-thp-check-total_mapcount-instead-of-page_mapcount-fix.patch added to -mm
 tree
Message-ID: <20210514222829.GT_vu2gvk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory.c: remove unused variable 'count'
has been added to the -mm tree.  Its filename is
     mm-thp-check-total_mapcount-instead-of-page_mapcount-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-check-total_mapcount-instead-of-page_mapcount-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-check-total_mapcount-instead-of-page_mapcount-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pu Lehui <pulehui@huawei.com>
Subject: mm/huge_memory.c: remove unused variable 'count'

mm/huge_memory.c:2663:6: warning:
 variable `count' set but not used [-Wunused-but-set-variable]
  2663 |  int count, mapcount, extra_pins, ret;
       |      ^~~~~

This variable is not used in function , this commit
remove it to fix the warning.

Link: https://lkml.kernel.org/r/20210514065912.71734-1-pulehui@huawei.com
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-thp-check-total_mapcount-instead-of-page_mapcount-fix
+++ a/mm/huge_memory.c
@@ -2660,7 +2660,7 @@ int split_huge_page_to_list(struct page
 	struct deferred_split *ds_queue = get_deferred_split_queue(head);
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
-	int count, mapcount, extra_pins, ret;
+	int mapcount, extra_pins, ret;
 	pgoff_t end;
 
 	VM_BUG_ON_PAGE(is_huge_zero_page(head), head);
@@ -2737,7 +2737,6 @@ int split_huge_page_to_list(struct page
 
 	/* Prevent deferred_split_scan() touching ->_refcount */
 	spin_lock(&ds_queue->split_queue_lock);
-	count = page_count(head);
 	mapcount = total_mapcount(head);
 	if (!mapcount && page_ref_freeze(head, 1 + extra_pins)) {
 		if (!list_empty(page_deferred_list(head))) {
_

Patches currently in -mm which might be from pulehui@huawei.com are

mm-thp-check-total_mapcount-instead-of-page_mapcount-fix.patch


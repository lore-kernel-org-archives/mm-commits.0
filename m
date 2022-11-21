Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89EC5C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 21 Nov 2022 21:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiKUVN7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Nov 2022 16:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiKUVN6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2022 16:13:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AEE11B7A6
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 13:13:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BB45B81258
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 21:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22DCC433D6;
        Mon, 21 Nov 2022 21:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669065234;
        bh=TT1HYCyevXOQW4p9nqkHkNCdRflFB5eeBSPCW3aR7CY=;
        h=Date:To:From:Subject:From;
        b=dCHF/sG8SVIEzjYphOrHe0SOXooQWjMa4vgIpbC1ax3X19AWRxjoJMAssFMNtZnPJ
         HdhEmm0BLqpp6xUtLLDfkrpUlF4D3ssBDAyWtnUgT8CV80ew7X9zpJIjIHQHTC/BRH
         zfZ6bGnnX9Olahsh2smpyvnWABIUFoJM5uUcJtEU=
Date:   Mon, 21 Nov 2022 13:13:53 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, david@redhat.com, abaci@linux.alibaba.com,
        yang.lee@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-stop-using-0-as-null-pointer.patch added to mm-unstable branch
Message-Id: <20221121211354.B22DCC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: stop using 0 as NULL pointer
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-stop-using-0-as-null-pointer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-stop-using-0-as-null-pointer.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: mm/hugetlb: stop using 0 as NULL pointer
Date: Mon, 21 Nov 2022 18:20:37 +0800

mm/hugetlb.c:1531:37: warning: Using plain integer as NULL pointer

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3224
Link: https://lkml.kernel.org/r/20221121102037.75307-1-yang.lee@linux.alibaba.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-stop-using-0-as-null-pointer
+++ a/mm/hugetlb.c
@@ -1528,7 +1528,7 @@ static void add_hugetlb_page(struct hsta
 	}
 
 	set_compound_page_dtor(page, HUGETLB_PAGE_DTOR);
-	set_page_private(page, 0);
+	set_page_private(page, NULL);
 	/*
 	 * We have to set HPageVmemmapOptimized again as above
 	 * set_page_private(page, 0) cleared it.
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are

migrate-stop-using-0-as-null-pointer.patch
mm-hugetlb-stop-using-0-as-null-pointer.patch
lib-objpool-added-ring-array-based-lockless-mpmc-queue-fix.patch


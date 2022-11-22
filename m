Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 828E5C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Nov 2022 20:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234298AbiKVU6J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Nov 2022 15:58:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232419AbiKVU56 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2022 15:57:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22DD21BE8D
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2022 12:57:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95A8EB81D99
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2022 20:57:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2FCC433C1;
        Tue, 22 Nov 2022 20:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669150669;
        bh=DtaF9NJoVLUAESTe684Cj/jR8zXQ8b1haeC1BfkmfOs=;
        h=Date:To:From:Subject:From;
        b=S5sfSq1bJzfkJ1WM9iBGy5MbQMafjhmU78xWf8OT3sSddWxmoWDQP0KJH1NGdSExl
         0wcTcV0REpG7izjguH4xGcymWeS/5gnHN1TnfFf2hTGO2nP0fM4ClnE2r3WDg1PM9r
         S9w26H+wiNCIlhy/gTZYKUYUwR+x0dDKtIccavyM=
Date:   Tue, 22 Nov 2022 12:57:48 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, david@redhat.com, abaci@linux.alibaba.com,
        yang.lee@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-hugetlb-stop-using-0-as-null-pointer.patch removed from -mm tree
Message-Id: <20221122205749.3C2FCC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: stop using 0 as NULL pointer
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-stop-using-0-as-null-pointer.patch

This patch was dropped because it is obsolete

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
@@ -1530,7 +1530,7 @@ static void add_hugetlb_page(struct hsta
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
lib-objpool-added-ring-array-based-lockless-mpmc-queue-fix.patch


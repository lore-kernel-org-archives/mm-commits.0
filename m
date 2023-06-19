Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7BCEEB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjFSXJ5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjFSXJ4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:09:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF79B124
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:09:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73DF060F14
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB7DC433C0;
        Mon, 19 Jun 2023 23:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216194;
        bh=TSIsjHaqd2F3S+wEgJKODV7sPmsyo8U8OGuiUbiGFSs=;
        h=Date:To:From:Subject:From;
        b=M5185c9cPdrZ0WxegHWImxDK6Vet+ar00MBAJfSM6KU9QT3jPvgkSxqCbiFwz7Pnw
         8Ka89Zp7bMwEsgx0R2/FIGNw/Mg6uzepeyy48luhxrAsP3R1FpH+/rCwolU733rOEh
         DcdMxEUGOtPgbL+ikmDRXr8MZWnZFIZBIeUkymtM=
Date:   Mon, 19 Jun 2023 16:09:54 -0700
To:     mm-commits@vger.kernel.org, zhangpeng362@huawei.com,
        willy@infradead.org, wangkefeng.wang@huawei.com,
        vishal.moola@gmail.com, sunnanyong@huawei.com,
        songmuchun@bytedance.com, sidhartha.kumar@oracle.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb-use-a-folio-in-hugetlb_fault-fix.patch removed from -mm tree
Message-Id: <20230619230954.CCB7DC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-hugetlb-use-a-folio-in-hugetlb_fault-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-use-a-folio-in-hugetlb_fault-fix.patch

This patch was dropped because it was folded into mm-hugetlb-use-a-folio-in-hugetlb_fault.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-use-a-folio-in-hugetlb_fault-fix
Date: Tue Jun  6 07:46:28 PM PDT 2023

update comment, per Sidhartha

Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: ZhangPeng <zhangpeng362@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-a-folio-in-hugetlb_fault-fix
+++ a/mm/hugetlb.c
@@ -6179,7 +6179,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	/*
 	 * hugetlb_wp() requires page locks of pte_page(entry) and
 	 * pagecache_folio, so here we need take the former one
-	 * when page != pagecache_folio or !pagecache_folio.
+	 * when folio != pagecache_folio or !pagecache_folio.
 	 */
 	folio = page_folio(pte_page(entry));
 	if (folio != pagecache_folio)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-hugetlb-use-a-folio-in-hugetlb_fault.patch


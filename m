Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC03C61DA4
	for <mm-commits@archiver.kernel.org>; Thu,  9 Feb 2023 23:49:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjBIXtc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 18:49:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBIXt2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 18:49:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60CCD392BC
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 15:49:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E487961C14
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 23:49:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41791C4339B;
        Thu,  9 Feb 2023 23:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675986566;
        bh=7N3O0GrH0e8sovhv5afnewxCk0mmy0yVxgckULFqQB0=;
        h=Date:To:From:Subject:From;
        b=t6DyhuVTsqp/ZsGnvN/6+JIzUPVR8YuFUDbCgpO0gjXfVukmi9JO79CPH/2p1yTxK
         vfVyifouK895rnmn1tVrEyvXKuc4nmdSpeFAmtT2dyy/302LPEV8EnmTZWFlFUsPku
         awRGZAWBHdfo7BuNeGC0OoQ5mzIgC+g2l2LaO1pM=
Date:   Thu, 09 Feb 2023 15:49:25 -0800
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v4.patch removed from -mm tree
Message-Id: <20230209234926.41791C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v4
has been removed from the -mm tree.  Its filename was
     mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v4.patch

This patch was dropped because it was folded into mm-hwposion-support-recovery-from-ksm_might_need_to_copy.patch

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v4
Date: Wed, 1 Feb 2023 15:44:33 +0800

- update changelog and directly return ERR_PTR(-EHWPOISON) in
  ksm_might_need_to_copy() suggested HORIGUCHI NAOYA
- add back unlikely in unuse_pte()

Link: https://lkml.kernel.org/r/20230201074433.96641-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/ksm.c~mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v4
+++ a/mm/ksm.c
@@ -2631,9 +2631,8 @@ struct page *ksm_might_need_to_copy(stru
 	if (new_page) {
 		if (copy_mc_user_highpage(new_page, page, address, vma)) {
 			put_page(new_page);
-			new_page = ERR_PTR(-EHWPOISON);
 			memory_failure_queue(page_to_pfn(page), 0);
-			return new_page;
+			return ERR_PTR(-EHWPOISON);
 		}
 		SetPageDirty(new_page);
 		__SetPageUptodate(new_page);
--- a/mm/swapfile.c~mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v4
+++ a/mm/swapfile.c
@@ -1780,7 +1780,7 @@ static int unuse_pte(struct vm_area_stru
 		goto out;
 	}
 
-	if (hwposioned || !PageUptodate(page)) {
+	if (unlikely(hwposioned || !PageUptodate(page))) {
 		swp_entry_t swp_entry;
 
 		dec_mm_counter(vma->vm_mm, MM_SWAPENTS);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hwposion-support-recovery-from-ksm_might_need_to_copy.patch


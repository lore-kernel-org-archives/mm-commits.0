Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E28CC636D3
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 00:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbjBCAGK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Feb 2023 19:06:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233488AbjBCAGC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2023 19:06:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E083987590
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 16:05:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61E1CB828BB
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 00:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE04FC433A0;
        Fri,  3 Feb 2023 00:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675382739;
        bh=RLLdvnsLtxG0kZEa9jhKQ6RyWHKKOSrKENNSQsmZdrM=;
        h=Date:To:From:Subject:From;
        b=D0f+WXpRhFzeuLLuJJ16bg5iFplzHn2wr3962CQYbSqhT2OZKfyM/WD1iZH4Wb09B
         vfN+Thp68IDPW6RhWdQuCzJTr17cQuWo+KzHzNeKyb7U+z+8Uls17N1lQl+GoK+jaJ
         K8x8KAHyn3JWp+1EkdyFT7mkCzLUPJB5Ms3tkbpU=
Date:   Thu, 02 Feb 2023 16:05:38 -0800
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v4.patch added to mm-hotfixes-unstable branch
Message-Id: <20230203000538.EE04FC433A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v4
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v4.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v3.patch
mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v4.patch
mm-madvise-use-vm_normal_folio-in-madvise_free_pte_range.patch


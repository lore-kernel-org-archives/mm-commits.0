Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77F9DC4332F
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiKIBbD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiKIBbC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:31:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A18606A2
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:31:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2410B81C38
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B62FC433D6;
        Wed,  9 Nov 2022 01:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957458;
        bh=PVZVer42wBJ9vxWpG2Wob/cNWdhcxhfq9aSf1trTGdg=;
        h=Date:To:From:Subject:From;
        b=xn3m3FB202v00YlVOUERBlINfg5z/vVV+fArPzhrp3AEDnos5gMwh5vL+dwtMCslD
         hWTgKtqQRhrPw0/WZcb9ZES1zIS25O0pVr5kMluiKfk0m3Jhaayw0Y8a8g2V5zC6Af
         XljcgfMewxEw+wZxgzbQ+lQzEXfLYvP+mz1yLKkI=
Date:   Tue, 08 Nov 2022 17:30:57 -0800
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memory-failure-make-action_result-return-int-v2.patch removed from -mm tree
Message-Id: <20221109013058.4B62FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-memory-failure-make-action_result-return-int-v2
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-make-action_result-return-int-v2.patch

This patch was dropped because it was folded into mm-memory-failure-make-action_result-return-int.patch

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm-memory-failure-make-action_result-return-int-v2
Date: Mon, 24 Oct 2022 11:51:38 +0800

- MF_DELAYED is considered as success, suggested by HORIGUCHI

- adjust order between unlock_page(head) and action_result()
  after !hwpoison_user_mappings() to clean code more in
  try_memory_failure_hugetlb()

Link: https://lkml.kernel.org/r/20221024035138.99119-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-make-action_result-return-int-v2
+++ a/mm/memory-failure.c
@@ -1191,7 +1191,7 @@ static int action_result(unsigned long p
 	pr_err("%#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);
 
-	return result == MF_RECOVERED ? 0 : -EBUSY;
+	return (result == MF_RECOVERED || result == MF_DELAYED) ? 0 : -EBUSY;
 }
 
 static int page_action(struct page_state *ps, struct page *p,
@@ -1202,14 +1202,12 @@ static int page_action(struct page_state
 	/* page p should be unlocked after returning from ps->action().  */
 	result = ps->action(ps, p);
 
-	action_result(pfn, ps->type, result);
-
 	/* Could do more checks here if page looks ok */
 	/*
 	 * Could adjust zone counters here to correct for the missing page.
 	 */
 
-	return (result == MF_RECOVERED || result == MF_DELAYED) ? 0 : -EBUSY;
+	return action_result(pfn, ps->type, result);
 }
 
 static inline bool PageHWPoisonTakenOff(struct page *page)
@@ -1890,9 +1888,8 @@ retry:
 	page_flags = head->flags;
 
 	if (!hwpoison_user_mappings(p, pfn, flags, head)) {
-		res = action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
 		unlock_page(head);
-		return res;
+		return action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
 	}
 
 	return identify_page_state(pfn, p, page_flags);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-rmap-rename-page_not_mapped-to-folio_not_mapped.patch
mm-remove-kern_addr_valid-completely.patch
nios2-remove-unused-init_mmap.patch
x86-sgx-use-vm_access_flags.patch
mm-mprotect-use-vm_access_flags.patch
mm-debug_vm_pgtable-use-vm_access_flags.patch
amdgpu-use-vm_access_flags.patch
mm-memory-failure-make-put_ref_page-more-useful.patch
mm-memory-failure-avoid-pfn_valid-twice-in-soft_offline_page.patch
mm-memory-failure-make-action_result-return-int.patch


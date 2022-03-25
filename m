Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C133C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357415AbiCYBe2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357553AbiCYBdS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71169BF01E
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07C1161929
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F79AC340ED;
        Fri, 25 Mar 2022 01:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171904;
        bh=EnQRxQjbbr9NBBynZxgZJn2QZFu2uT47ex3i0TOPYls=;
        h=Date:To:From:Subject:From;
        b=p9V9T9Rqt1svxniE8Ktq/oeb//8Ne7Gefa+LNqY/BJndUlCLBwCOL+i8jxnBo/hxl
         XKq3BekHM29OtbYpFPXXwTYGsnXkA0rs9o1JQFQDwW87A/r9e51fuCLrLi4kWszJmh
         u0ze4VRvNjOkiWTnPs9EH1Ol4hGRqNIkbGBH7jf4=
Date:   Thu, 24 Mar 2022 18:31:43 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-memory-failurec-rework-the-try_to_unmap-logic-in-hwpoison_user_mappings.patch removed from -mm tree
Message-Id: <20220325013144.5F79AC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: rework the try_to_unmap logic in hwpoison_user_mappings()
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-rework-the-try_to_unmap-logic-in-hwpoison_user_mappings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure.c: rework the try_to_unmap logic in hwpoison_user_mappings()

Only for hugetlb pages in shared mappings, try_to_unmap should take
semaphore in write mode here.  Rework the code to make it clear.

Link: https://lkml.kernel.org/r/20220218090118.1105-7-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failurec-rework-the-try_to_unmap-logic-in-hwpoison_user_mappings
+++ a/mm/memory-failure.c
@@ -1404,26 +1404,22 @@ static bool hwpoison_user_mappings(struc
 	if (kill)
 		collect_procs(hpage, &tokill, flags & MF_ACTION_REQUIRED);
 
-	if (!PageHuge(hpage)) {
-		try_to_unmap(hpage, ttu);
+	if (PageHuge(hpage) && !PageAnon(hpage)) {
+		/*
+		 * For hugetlb pages in shared mappings, try_to_unmap
+		 * could potentially call huge_pmd_unshare.  Because of
+		 * this, take semaphore in write mode here and set
+		 * TTU_RMAP_LOCKED to indicate we have taken the lock
+		 * at this higher level.
+		 */
+		mapping = hugetlb_page_mapping_lock_write(hpage);
+		if (mapping) {
+			try_to_unmap(hpage, ttu|TTU_RMAP_LOCKED);
+			i_mmap_unlock_write(mapping);
+		} else
+			pr_info("Memory failure: %#lx: could not lock mapping for mapped huge page\n", pfn);
 	} else {
-		if (!PageAnon(hpage)) {
-			/*
-			 * For hugetlb pages in shared mappings, try_to_unmap
-			 * could potentially call huge_pmd_unshare.  Because of
-			 * this, take semaphore in write mode here and set
-			 * TTU_RMAP_LOCKED to indicate we have taken the lock
-			 * at this higher level.
-			 */
-			mapping = hugetlb_page_mapping_lock_write(hpage);
-			if (mapping) {
-				try_to_unmap(hpage, ttu|TTU_RMAP_LOCKED);
-				i_mmap_unlock_write(mapping);
-			} else
-				pr_info("Memory failure: %#lx: could not lock mapping for mapped huge page\n", pfn);
-		} else {
-			try_to_unmap(hpage, ttu);
-		}
+		try_to_unmap(hpage, ttu);
 	}
 
 	unmap_success = !page_mapped(hpage);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch


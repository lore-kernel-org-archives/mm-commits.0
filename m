Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08613C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235724AbiCVVqT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236383AbiCVVp7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:45:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF6F45AD2
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:44:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47863B81DB8
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8BD8C340EC;
        Tue, 22 Mar 2022 21:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985467;
        bh=vOR0AWbeZ0W+/p8PKfNYSI+2VebxktM8MpUsSX/2EA0=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=RmXiSxIgUbDoNDYofhuj2yUWkr1X7nMiZEVqbPrLAJPMFb0MxiWrHaPDNtJDANv3w
         EDpHGcTi07IXZmG84KKuJcTsfhIFOQQXQfimqCcWac0m5f5hiKR33Tz4uvToaPSGw0
         BrrggZre6i4sMOUjWHbwZFyVtlEtqi2KvRUMV0rU=
Date:   Tue, 22 Mar 2022 14:44:27 -0700
To:     naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 117/227] mm/memory-failure.c: rework the try_to_unmap logic in hwpoison_user_mappings()
Message-Id: <20220322214427.D8BD8C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

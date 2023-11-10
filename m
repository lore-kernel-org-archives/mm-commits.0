Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B9A4C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 10 Nov 2023 19:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbjKJTqL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Nov 2023 14:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236072AbjKJTp2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Nov 2023 14:45:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BA5F9643
        for <mm-commits@vger.kernel.org>; Fri, 10 Nov 2023 10:21:22 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487C2C43140;
        Fri, 10 Nov 2023 18:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699640411;
        bh=Xnmk4OFfsKqw4+dEiYrdpRniiY/95gbngefzOeU4hWI=;
        h=Date:To:From:Subject:From;
        b=cQp5CZ50sTYsbDxiwXdaIVMCycTjO+GObrtKnC7QOWgGaBI9foM+Bf93lZE6T9bTi
         tE6w/Vohhud0UJOG/DoiPp499q2U9ObHm7d3LCaqkQQpMvMzAQcJ/1/6k2JiqUEDvr
         Y7vx+RwBZP/qzhGXsihvnjHB3V9oG3Z09LRVMG+k=
Date:   Fri, 10 Nov 2023 10:20:10 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        gregory.price@memverge.com, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-huge_memory-use-more-folio-api-in-__split_huge_page_tail.patch removed from -mm tree
Message-Id: <20231110182011.487C2C43140@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: huge_memory: use more folio api in __split_huge_page_tail()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-use-more-folio-api-in-__split_huge_page_tail.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: huge_memory: use more folio api in __split_huge_page_tail()
Date: Fri, 10 Nov 2023 11:33:21 +0800

Use more folio APIs to save six compound_head() calls in
__split_huge_page_tail().

Link: https://lkml.kernel.org/r/20231110033324.2455523-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gregory Price <gregory.price@memverge.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-use-more-folio-api-in-__split_huge_page_tail
+++ a/mm/huge_memory.c
@@ -2509,13 +2509,13 @@ static void __split_huge_page_tail(struc
 	clear_compound_head(page_tail);
 
 	/* Finally unfreeze refcount. Additional reference from page cache. */
-	page_ref_unfreeze(page_tail, 1 + (!PageAnon(head) ||
-					  PageSwapCache(head)));
+	page_ref_unfreeze(page_tail, 1 + (!folio_test_anon(folio) ||
+					  folio_test_swapcache(folio)));
 
-	if (page_is_young(head))
-		set_page_young(page_tail);
-	if (page_is_idle(head))
-		set_page_idle(page_tail);
+	if (folio_test_young(folio))
+		folio_set_young(new_folio);
+	if (folio_test_idle(folio))
+		folio_set_idle(new_folio);
 
 	folio_xchg_last_cpupid(new_folio, folio_last_cpupid(folio));
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-task_mmu-use-a-folio-in-smaps_account.patch
mm-task_mmu-use-a-folio-in-clear_refs_pte_range.patch
page_idle-kill-page-idle-and-young-wrapper.patch


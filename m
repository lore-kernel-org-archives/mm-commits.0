Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5CDBC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377893AbiATV21 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377889AbiATV20 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:28:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C62BC061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:28:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04E14B81E54
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4E3C340E0;
        Thu, 20 Jan 2022 21:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714103;
        bh=/dLM9wAEAJ8y7nEgNSgaJxJHJWsjTnL2ilhWBruCmEE=;
        h=Date:From:To:Subject:From;
        b=IOcb7ksBHdzQaq7W6WfADcSDPiF5kcpMJ9qiXjrWNQUTBXuk9/4oQRpqfIGNzOL9B
         kbTnteJV4YhNfwYMd71vilRwuWLNhiEneIZ1G6XF9CMhGL+h9oprdQKyyLIp6MOU5D
         yxEGNJHc1Dd5cuVnGQgFgax4i83l3gDQvONamkWE=
Date:   Thu, 20 Jan 2022 13:28:23 -0800
From:   akpm@linux-foundation.org
To:     hanyihao@vivo.com, mm-commits@vger.kernel.org, sj@kernel.org,
        songmuchun@bytedance.com
Subject:  [merged]
 mm-damon-vaddr-remove-swap_ranges-and-replace-it-with-swap.patch removed
 from -mm tree
Message-ID: <20220120212823.yCj0BHSZJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/vaddr: remove swap_ranges() and replace it with swap()
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-remove-swap_ranges-and-replace-it-with-swap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yihao Han <hanyihao@vivo.com>
Subject: mm/damon/vaddr: remove swap_ranges() and replace it with swap()

Remove 'swap_ranges()' and replace it with the macro 'swap()' defined in
'include/linux/minmax.h' to simplify code and improve efficiency

Link: https://lkml.kernel.org/r/20211111115355.2808-1-hanyihao@vivo.com
Signed-off-by: Yihao Han <hanyihao@vivo.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-remove-swap_ranges-and-replace-it-with-swap
+++ a/mm/damon/vaddr.c
@@ -98,16 +98,6 @@ static unsigned long sz_range(struct dam
 	return r->end - r->start;
 }
 
-static void swap_ranges(struct damon_addr_range *r1,
-			struct damon_addr_range *r2)
-{
-	struct damon_addr_range tmp;
-
-	tmp = *r1;
-	*r1 = *r2;
-	*r2 = tmp;
-}
-
 /*
  * Find three regions separated by two biggest unmapped regions
  *
@@ -146,9 +136,9 @@ static int __damon_va_three_regions(stru
 		gap.start = last_vma->vm_end;
 		gap.end = vma->vm_start;
 		if (sz_range(&gap) > sz_range(&second_gap)) {
-			swap_ranges(&gap, &second_gap);
+			swap(gap, second_gap);
 			if (sz_range(&second_gap) > sz_range(&first_gap))
-				swap_ranges(&second_gap, &first_gap);
+				swap(second_gap, first_gap);
 		}
 next:
 		last_vma = vma;
@@ -159,7 +149,7 @@ next:
 
 	/* Sort the two biggest gaps by address */
 	if (first_gap.start > second_gap.start)
-		swap_ranges(&first_gap, &second_gap);
+		swap(first_gap, second_gap);
 
 	/* Store the result */
 	regions[0].start = ALIGN(start, DAMON_MIN_REGION);
_

Patches currently in -mm which might be from hanyihao@vivo.com are



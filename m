Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F92EC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:09:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbiANWJu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:09:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiANWJu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:09:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF36C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:09:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C41EB8262F
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936EEC36AE9;
        Fri, 14 Jan 2022 22:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198187;
        bh=vc1hBj5TydsfWWItX3y4oi2NRvlqaxJOEeG4Ak3AMyE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZF/NUC5iIsaX+0YOAh/LLDjN0ySgpdvqj+TyXD0hjeY0YZX3VG4A7zK7vPwJcvAXr
         mySzKXSaqCHxAPyWpnVvLkDtQiX3iLuZR8kqI3jr+Biyf0JIyWeyzDVLhUo6Xm6lQJ
         yLookao6ObrxjXiNSBO5HbnsH37o7xTs896FW4S8=
Date:   Fri, 14 Jan 2022 14:09:47 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hanyihao@vivo.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj@kernel.org,
        songmuchun@bytedance.com, torvalds@linux-foundation.org
Subject:  [patch 125/146] mm/damon/vaddr: remove swap_ranges() and
 replace it with swap()
Message-ID: <20220114220947.nloFzSIKt%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

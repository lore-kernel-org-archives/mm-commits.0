Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 987EFC352A1
	for <mm-commits@archiver.kernel.org>; Mon,  4 Apr 2022 21:41:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383257AbiDDVlh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Apr 2022 17:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380705AbiDDVHD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2022 17:07:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD3F2E08B
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 14:05:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75A0AB819FD
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 21:05:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02815C340F3;
        Mon,  4 Apr 2022 21:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649106303;
        bh=gh7ZOxs0d4yRbRhNyQI6zkeBRkf2XSS412R78KxC1i8=;
        h=Date:To:From:Subject:From;
        b=vPb4OiHx+O7KeqDtGQSSJOyJQ1UE0WaaXAvpcWNbT1zcMo9brdsWV69SxjEU9nvlH
         MYcf/lzU6C5yFwFF2qgtmYG3bOkr9ewtePRZZRCS4UW2GDRHSXjONW1c4xSwAeY9cH
         0bqNxRlipkRXViTrMmBvw62k1YsN2kGuPSdTcwj0=
Date:   Mon, 04 Apr 2022 14:05:02 -0700
To:     mm-commits@vger.kernel.org, zhangshiming@oppo.com,
        michel@lespinasse.org, hughd@google.com, 21cnbao@gmail.com,
        lipeifeng@oppo.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-modify-the-method-to-search-addr-in-unmapped_area_topdown.patch added to -mm tree
Message-Id: <20220404210503.02815C340F3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: modify the method to search addr in unmapped_area_topdown
has been added to the -mm tree.  Its filename is
     mm-modify-the-method-to-search-addr-in-unmapped_area_topdown.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-modify-the-method-to-search-addr-in-unmapped_area_topdown.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-modify-the-method-to-search-addr-in-unmapped_area_topdown.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: lipeifeng <lipeifeng@oppo.com>
Subject: mm: modify the method to search addr in unmapped_area_topdown

The old method will firstly find the space in len(info->length +
info->align_mask), and get address at the desired alignment.

Sometime, addr would be failed if there are enough addr space in kernel by
above method, e.g., you can't get a addr sized in 1Mbytes, align_mask
1Mbytes successfully although there are still (2M-1)bytes space in kernel.

This patch would fix thr problem above by the new method: find the space
in info->length and judge if at the desired info->align_mask at the same
time.

Do a simple test in TIF_32BIT:
- Try to malloc (size:1M align:2M) until allocation fails;
- Try to malloc (size:1M align:1M) and account how to space can be
alloced successfully.

Before optimization: alloced 1.9G+ bytes.
After  optimization: alloced 0     bytes.

Link: https://lkml.kernel.org/r/20220402094550.129-1-lipeifeng@oppo.com
Signed-off-by: lipeifeng <lipeifeng@oppo.com>
Cc: Michel Lespinasse <michel@lespinasse.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: <zhangshiming@oppo.com>
Cc: Barry Song <21cnbao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/mm/mmap.c~mm-modify-the-method-to-search-addr-in-unmapped_area_topdown
+++ a/mm/mmap.c
@@ -2014,13 +2014,14 @@ static unsigned long unmapped_area_topdo
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
-	unsigned long length, low_limit, high_limit, gap_start, gap_end;
+	unsigned long length, low_limit, high_limit, gap_start, gap_end, gap_end_tmp;
 
 	/* Adjust search length to account for worst case alignment overhead */
 	length = info->length + info->align_mask;
 	if (length < info->length)
 		return -ENOMEM;
 
+	length = info->length;
 	/*
 	 * Adjust search limits by the desired length.
 	 * See implementation comment at top of unmapped_area().
@@ -2036,8 +2037,12 @@ static unsigned long unmapped_area_topdo
 
 	/* Check highest gap, which does not precede any rbtree node */
 	gap_start = mm->highest_vm_end;
-	if (gap_start <= high_limit)
-		goto found_highest;
+	if (gap_start <= high_limit) {
+		gap_end_tmp = gap_end - info->length;
+		gap_end_tmp -= (gap_end_tmp - info->align_offset) & info->align_mask;
+		if (gap_end_tmp >= gap_start)
+			goto found_highest;
+	}
 
 	/* Check if rbtree root looks promising */
 	if (RB_EMPTY_ROOT(&mm->mm_rb))
@@ -2065,8 +2070,13 @@ check_current:
 		if (gap_end < low_limit)
 			return -ENOMEM;
 		if (gap_start <= high_limit &&
-		    gap_end > gap_start && gap_end - gap_start >= length)
-			goto found;
+		    gap_end > gap_start && gap_end - gap_start >= length) {
+			gap_end_tmp = gap_end - info->length;
+			gap_end_tmp -= (gap_end_tmp - info->align_offset) & info->align_mask;
+			if (gap_end_tmp >= gap_start)
+				goto found;
+
+		}
 
 		/* Visit left subtree if it looks promising */
 		if (vma->vm_rb.rb_left) {
_

Patches currently in -mm which might be from lipeifeng@oppo.com are

mm-modify-the-method-to-search-addr-in-unmapped_area_topdown.patch


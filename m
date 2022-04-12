Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E786AC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 12 Apr 2022 23:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbiDLX0q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbiDLX0W (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Apr 2022 19:26:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3950E56C1D
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 15:42:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E10AB82021
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 21:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34BF9C385A1;
        Tue, 12 Apr 2022 21:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649798652;
        bh=AjLVFMcVWAyBPT3Vfm86LWVt1r0ssG0xKQV3flPDbPA=;
        h=Date:To:From:Subject:From;
        b=yRCi6JAP1UE7B+aOM5WhQYDmEZWWXZtQShebNV/tYd1SSjtVx3rABIGQGbj+5p9GM
         xSU5PRkooGQvAJ15UmwDHP8DlP7gOwmaxHVvfkqszuufb94lKlvsKYjvJLlQIg1egp
         0fu+XU43b5g/RUB6Y9c0TaM6jBm5U+/jxkNWrgSg=
Date:   Tue, 12 Apr 2022 14:24:11 -0700
To:     mm-commits@vger.kernel.org, michel@lespinasse.org,
        hughd@google.com, 21cnbao@gmail.com, lipeifeng@oppo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-align-error-when-get_addr-in-unmapped_area_topdown.patch added to -mm tree
Message-Id: <20220412212412.34BF9C385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: fix align-error when get_addr in unmapped_area_topdown
has been added to the -mm tree.  Its filename is
     mm-fix-align-error-when-get_addr-in-unmapped_area_topdown.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-align-error-when-get_addr-in-unmapped_area_topdown.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-align-error-when-get_addr-in-unmapped_area_topdown.patch

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
Subject: mm/mmap.c: fix align-error when get_addr in unmapped_area_topdown

When we found a suitable gap_end(> info->high_limit), gap_end must be set
to info->high_limit.  And we will get the gap_end after computing highest
gap address at the desired alignment.

2096 found:
2097         if (gap_end > info->high_limit)
2098                 gap_end = info->high_limit;
2099
2100 found_highest:
2101         gap_end -= info->length;
2102         gap_end -= (gap_end - info->align_offset) & info->align_mask;
2103
2104         VM_BUG_ON(gap_end < info->low_limit);
2105         VM_BUG_ON(gap_end < gap_start);
2106         return gap_end;

so we must promise: info->high_limit - info->low_limit >= info->length +
info->align_mask.

Otherwise in rare cases(info->high_limit - info->low_limit < info->length
+ info->align_mask) we will get the addr in align-error if found suitable
gap_end(> info->high_limit).

Link: https://lkml.kernel.org/r/20220412081014.399-1-lipeifeng@oppo.com
Signed-off-by: lipeifeng <lipeifeng@oppo.com>
Cc: Michel Lespinasse <michel@lespinasse.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Barry Song <21cnbao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mmap.c~mm-fix-align-error-when-get_addr-in-unmapped_area_topdown
+++ a/mm/mmap.c
@@ -2015,7 +2015,6 @@ static unsigned long unmapped_area_topdo
 	if (length < info->length)
 		return -ENOMEM;
 
-	length = info->length;
 	/*
 	 * Adjust search limits by the desired length.
 	 * See implementation comment at top of unmapped_area().
@@ -2027,6 +2026,8 @@ static unsigned long unmapped_area_topdo
 
 	if (info->low_limit > high_limit)
 		return -ENOMEM;
+
+	length = info->length;
 	low_limit = info->low_limit + length;
 
 	/* Check highest gap, which does not precede any rbtree node */
_

Patches currently in -mm which might be from lipeifeng@oppo.com are

mm-modify-the-method-to-search-addr-in-unmapped_area_topdown.patch
mm-fix-align-error-when-get_addr-in-unmapped_area_topdown.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73E4CC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 13 Apr 2022 21:29:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiDMVbb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Apr 2022 17:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiDMVba (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Apr 2022 17:31:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC5488B06
        for <mm-commits@vger.kernel.org>; Wed, 13 Apr 2022 14:29:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCBB8B818F1
        for <mm-commits@vger.kernel.org>; Wed, 13 Apr 2022 21:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8C2C385A3;
        Wed, 13 Apr 2022 21:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649885345;
        bh=BHcp78nf/JAh0u/oUpqJpK4hUsc5BR0nxL7Wlqf2+fw=;
        h=Date:To:From:Subject:From;
        b=BYYH357X+MqVJNyc4+3R5qs3ZpA02IWp9ywcuk6pYDX12e38BsrdrQJcK/P2kyGMX
         2w3OIzwCm0DNP0pQC3OszHfoAmUjLJPOJ41OIszeCrqTJwwmSjP+cepboleeLmKQn9
         igMv2LnW8LvFFfMUZMFc1HgcMA1LaAGnWlC4jVy8=
Date:   Wed, 13 Apr 2022 14:29:04 -0700
To:     mm-commits@vger.kernel.org, alex_y_xu@yahoo.ca,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-smaps_rollup-return-empty-file-for-kthreads-instead-of-esrch.patch added to -mm tree
Message-Id: <20220413212905.6A8C2C385A3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/smaps_rollup: return empty file for kthreads instead of ESRCH
has been added to the -mm tree.  Its filename is
     mm-smaps_rollup-return-empty-file-for-kthreads-instead-of-esrch.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-smaps_rollup-return-empty-file-for-kthreads-instead-of-esrch.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-smaps_rollup-return-empty-file-for-kthreads-instead-of-esrch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>
Subject: mm/smaps_rollup: return empty file for kthreads instead of ESRCH

This restores the behavior prior to 258f669e7e88 ("mm:
/proc/pid/smaps_rollup: convert to single value seq_file"), making it once
again consistent with maps and smaps, and allowing patterns like awk
'$1=="Anonymous:"{x+=$2}END{print x}' /proc/*/smaps_rollup to work. 
Searching all Debian packages for "smaps_rollup" did not find any programs
which would be affected by this change.

Link: https://lkml.kernel.org/r/20220413211357.26938-1-alex_y_xu@yahoo.ca
Fixes: 258f669e7e88 ("mm: /proc/pid/smaps_rollup: convert to single value seq_file")
Signed-off-by: Alex Xu (Hello71) <alex_y_xu@yahoo.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/proc/task_mmu.c~mm-smaps_rollup-return-empty-file-for-kthreads-instead-of-esrch
+++ a/fs/proc/task_mmu.c
@@ -883,10 +883,8 @@ static int show_smaps_rollup(struct seq_
 		return -ESRCH;
 
 	mm = priv->mm;
-	if (!mm || !mmget_not_zero(mm)) {
-		ret = -ESRCH;
+	if (!mm || !mmget_not_zero(mm))
 		goto out_put_task;
-	}
 
 	memset(&mss, 0, sizeof(mss));
 
_

Patches currently in -mm which might be from alex_y_xu@yahoo.ca are

mm-smaps_rollup-return-empty-file-for-kthreads-instead-of-esrch.patch


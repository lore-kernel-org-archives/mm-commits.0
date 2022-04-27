Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C027C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 20:35:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbiD0Uiv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 16:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237501AbiD0Uin (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 16:38:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722C8B1D8
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 13:35:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15A0161D1C
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 20:35:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C9EC385A7;
        Wed, 27 Apr 2022 20:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651091729;
        bh=e15HbF1xxj4sL8w0nobpze38VGRZhCaMrZ9RnnU59FE=;
        h=Date:To:From:Subject:From;
        b=AbfyiUsQHs1F/JTCIKVfU+5Lkrl0j6x/aA9dS9lJAzw76pfoNUU7vwepyCpltIciq
         NRdAsEUFNANLGYvqWXPGZF98dBZM1kB1J/cW15SgPStKON3NRtDtNvYncxcMF8f1Z3
         sYRu9eyHeFY0aZsIX+c/QajvGpJLBK+ZTGbwLCdM=
Date:   Wed, 27 Apr 2022 13:35:28 -0700
To:     mm-commits@vger.kernel.org, alex_y_xu@yahoo.ca,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [-] mm-smaps_rollup-return-empty-file-for-kthreads-instead-of-esrch.patch removed from -mm tree
Message-Id: <20220427203529.67C9EC385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/smaps_rollup: return empty file for kthreads instead of ESRCH
has been removed from the -mm tree.  Its filename was
     mm-smaps_rollup-return-empty-file-for-kthreads-instead-of-esrch.patch

This patch was dropped because of indecision

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

 fs/proc/task_mmu.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

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



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74DC1C32771
	for <mm-commits@archiver.kernel.org>; Fri, 19 Aug 2022 21:27:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352535AbiHSV1L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Aug 2022 17:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352516AbiHSV1K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 Aug 2022 17:27:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987BA10897B
        for <mm-commits@vger.kernel.org>; Fri, 19 Aug 2022 14:27:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 139EA61702
        for <mm-commits@vger.kernel.org>; Fri, 19 Aug 2022 21:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C823C433D6;
        Fri, 19 Aug 2022 21:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660944428;
        bh=3x0uFI015rSMLodq3mIZfWKFFioLYtmxa81o2p/qqfA=;
        h=Date:To:From:Subject:From;
        b=g3auPirDPb0o5Mgnbz3pBzKrYyQsACUfqiL24rZRPTtts9hRxZTghyMnmoqEKL7nL
         ofRi/MVOkBgIyeBx8sjjlpRVE6/RUf69mLvfYQIgR7mNJlCiFdRnzpecCqgHaiA+/R
         TSvwlxwLjG3EdZjugpJeEDuAdJPWd4jTSA93tab8=
Date:   Fri, 19 Aug 2022 14:27:07 -0700
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn, willy@infradead.org,
        tytso@mit.edu, songmuchun@bytedance.com, cgel.zte@gmail.com,
        chi.minghao@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-qnx6-delete-unnecessary-checks-before-brelse.patch added to mm-nonmm-unstable branch
Message-Id: <20220819212708.6C823C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/qnx6: delete unnecessary checks before brelse()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-qnx6-delete-unnecessary-checks-before-brelse.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-qnx6-delete-unnecessary-checks-before-brelse.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Minghao Chi <chi.minghao@zte.com.cn>
Subject: fs/qnx6: delete unnecessary checks before brelse()
Date: Fri, 19 Aug 2022 08:18:19 +0000

brelse() tests whether its argument is NULL and then returns immediately. 
Thus remove the tests which are not needed around the shown calls.

Link: https://lkml.kernel.org/r/20220819081819.96347-1-chi.minghao@zte.com.cn
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Cc: CGEL ZTE <cgel.zte@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Minghao Chi <chi.minghao@zte.com.cn>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/qnx6/inode.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/qnx6/inode.c~fs-qnx6-delete-unnecessary-checks-before-brelse
+++ a/fs/qnx6/inode.c
@@ -470,10 +470,8 @@ out2:
 out1:
 	iput(sbi->inodes);
 out:
-	if (bh1)
-		brelse(bh1);
-	if (bh2)
-		brelse(bh2);
+	brelse(bh1);
+	brelse(bh2);
 outnobh:
 	kfree(qs);
 	s->s_fs_info = NULL;
_

Patches currently in -mm which might be from chi.minghao@zte.com.cn are

fs-qnx6-delete-unnecessary-checks-before-brelse.patch


Return-Path: <SRS0=L/bp=EB=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F07CC4363A
	for <mm-commits@archiver.kernel.org>; Mon, 26 Oct 2020 19:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C53FE21D41
	for <mm-commits@archiver.kernel.org>; Mon, 26 Oct 2020 19:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603738937;
	bh=CGIR/GKTegZ+OgYlcBEbY5my8hBiE7TYnuZMR5Eh3GA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=GzUF8MPs2txdzilofTx5Z9lQurDD72zutpb13RYECMHw948WQjV3Un4mewkRb/ycx
	 gFXgPULty3dBDMI7UuLeH8a6ubGuxUryaOIPdnxeMlwhopJkJT6F5uA+IuLmZpPZEK
	 QWAgCrr7HHk8ZypkI2B+r3aT6i/RiOpPlrD8pdEw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1791415AbgJZTCQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Oct 2020 15:02:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1791414AbgJZTCP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 26 Oct 2020 15:02:15 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFC4C207E8;
        Mon, 26 Oct 2020 19:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603738935;
        bh=CGIR/GKTegZ+OgYlcBEbY5my8hBiE7TYnuZMR5Eh3GA=;
        h=Date:From:To:Subject:From;
        b=E1mKUs+d6lkBBnaDGikF3VRnxOAZ2dtsHwaUJHddlaWw6HZPZiD4a1tAgt45hrsIz
         LYky/CsnNO8+ZUgzh4wqUg0QJQCDiPWIw/24eyJmxqt/2rWIEWr2lYL2WG+xMlhxwi
         Wax7ADqOp369uxo76ZJAtZR7aoDxn1gx20epZHb4=
Date:   Mon, 26 Oct 2020 12:02:14 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        ndesaulniers@google.com, natechancellor@gmail.com, mhocko@suse.com,
        mgorman@techsingularity.net, lukas.bulwahn@gmail.com
Subject:  + mm-vmscan-drop-unneeded-assignment-in-kswapd.patch added
 to -mm tree
Message-ID: <20201026190214._-4CF%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: drop unneeded assignment in kswapd()
has been added to the -mm tree.  Its filename is
     mm-vmscan-drop-unneeded-assignment-in-kswapd.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-drop-unneeded-assignment-in-kswapd.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-drop-unneeded-assignment-in-kswapd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: mm/vmscan: drop unneeded assignment in kswapd()

The refactoring to kswapd() in commit e716f2eb24de ("mm, vmscan: prevent
kswapd sleeping prematurely due to mismatched classzone_idx") turned an
assignment to reclaim_order into a dead store, as in all further paths,
reclaim_order will be assigned again before it is used.

make clang-analyzer on x86_64 tinyconfig caught my attention with:

  mm/vmscan.c: warning: Although the value stored to 'reclaim_order' is
  used in the enclosing expression, the value is never actually read from
  'reclaim_order' [clang-analyzer-deadcode.DeadStores]

Compilers will detect this unneeded assignment and optimize this anyway. 
So, the resulting binary is identical before and after this change.

Simplify the code and remove unneeded assignment to make clang-analyzer
happy.

No functional change. No change in binary code.

Link: https://lkml.kernel.org/r/20201004125827.17679-1-lukas.bulwahn@gmail.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-drop-unneeded-assignment-in-kswapd
+++ a/mm/vmscan.c
@@ -3898,7 +3898,7 @@ kswapd_try_sleep:
 					highest_zoneidx);
 
 		/* Read the new order and highest_zoneidx */
-		alloc_order = reclaim_order = READ_ONCE(pgdat->kswapd_order);
+		alloc_order = READ_ONCE(pgdat->kswapd_order);
 		highest_zoneidx = kswapd_highest_zoneidx(pgdat,
 							highest_zoneidx);
 		WRITE_ONCE(pgdat->kswapd_order, 0);
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are

mm-vmscan-drop-unneeded-assignment-in-kswapd.patch


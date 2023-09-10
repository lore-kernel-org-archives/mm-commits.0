Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D0C8C71153
	for <mm-commits@archiver.kernel.org>; Sun, 10 Sep 2023 21:31:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjIJVbx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Sep 2023 17:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjIJVbx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 10 Sep 2023 17:31:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792EDB9
        for <mm-commits@vger.kernel.org>; Sun, 10 Sep 2023 14:31:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062C2C433C9;
        Sun, 10 Sep 2023 21:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694381508;
        bh=CGEWkSmo06QnJOCmUm5dl7oigYloQ1cYL9WoDlueit8=;
        h=Date:To:From:Subject:From;
        b=Fka4VigOMIxKMvdk4b5ctoXR35+L18jSVqIgZ1sQVYtF6QOc1fmn+yPB1W6A5B9mw
         QlccyuqIyi9goG2g3Q3FvQY2Dn66CPCK3KIVhWznAaD9oyui3sf+Y3ougdLYY87riY
         +KDXGQ+/wr9lXof/w9OHL0nDv3a0MPo9AI0s+urM=
Date:   Sun, 10 Sep 2023 14:31:47 -0700
To:     mm-commits@vger.kernel.org, angus.chen@jaguarmicro.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-print-err-before-panic.patch added to mm-unstable branch
Message-Id: <20230910213148.062C2C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: print err before panic
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-print-err-before-panic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-print-err-before-panic.patch

This patch will later appear in the mm-unstable branch at
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
From: Angus Chen <angus.chen@jaguarmicro.com>
Subject: mm/vmscan: print err before panic
Date: Wed, 6 Sep 2023 16:37:00 +0800

If panic is enable,the err information will not be printed before bugon,
So swap it.  Print the return value of PTR_ERR(pgdat->kswapd) also.

Link: https://lkml.kernel.org/r/20230906083700.181-1-angus.chen@jaguarmicro.com
Signed-off-by: Angus Chen <angus.chen@jaguarmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-print-err-before-panic
+++ a/mm/vmscan.c
@@ -7917,8 +7917,9 @@ void __meminit kswapd_run(int nid)
 		pgdat->kswapd = kthread_run(kswapd, pgdat, "kswapd%d", nid);
 		if (IS_ERR(pgdat->kswapd)) {
 			/* failure at boot is fatal */
+			pr_err("Failed to start kswapd on node %d，ret=%ld\n",
+				   nid, PTR_ERR(pgdat->kswapd));
 			BUG_ON(system_state < SYSTEM_RUNNING);
-			pr_err("Failed to start kswapd on node %d\n", nid);
 			pgdat->kswapd = NULL;
 		}
 	}
_

Patches currently in -mm which might be from angus.chen@jaguarmicro.com are

mm-vmscan-print-err-before-panic.patch


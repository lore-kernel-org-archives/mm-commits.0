Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64634E7C4F3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbjJDUSs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244031AbjJDUSo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:18:44 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF8E93
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:18:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505BAC433C7;
        Wed,  4 Oct 2023 20:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450721;
        bh=+tdfs0pJdeYrQbvRzY2BFhTd/0D3jKz7mvCxhcR2Dvw=;
        h=Date:To:From:Subject:From;
        b=BvhmqwZ5py4iLljQksbhq8wlxET/wEPaCFTDtOSPCjr2diirSiqffrejb3mCItojO
         7tBUs7lv+7EjmY8ftP+UMYT75xMjoW5PvP1JMOptvulvPG4cfwV20fivXEd+9mzKMf
         8t63Fxt4kLjqHFMvA7Gr63EJW0lqz7XuQgLWvHNs=
Date:   Wed, 04 Oct 2023 13:18:39 -0700
To:     mm-commits@vger.kernel.org, angus.chen@jaguarmicro.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-print-err-before-panic.patch removed from -mm tree
Message-Id: <20231004201841.505BAC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmscan: print err before panic
has been removed from the -mm tree.  Its filename was
     mm-vmscan-print-err-before-panic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -7892,8 +7892,9 @@ void __meminit kswapd_run(int nid)
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



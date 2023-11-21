Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 846A6C61D97
	for <mm-commits@archiver.kernel.org>; Tue, 21 Nov 2023 23:14:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjKUXO5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Nov 2023 18:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjKUXO4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Nov 2023 18:14:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D322191
        for <mm-commits@vger.kernel.org>; Tue, 21 Nov 2023 15:14:52 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05B8C433C7;
        Tue, 21 Nov 2023 23:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700608491;
        bh=ABpnUSnejW8RVWR7hkoGMAv/yUp53oVzoO0cdvubbNk=;
        h=Date:To:From:Subject:From;
        b=JbPpTStd7OPYL0mpbxLUzqIyq8KY+/ksWd+8Ml5/GGRuhV2ZFt3cdTiP8XyRNsHSR
         cxGy8aXYpC+T0QldXEkhCxxGueN6jMFH+rGLaKopo2WR4hq9UX5OFCFeLrXy1ap/pv
         y+DLbBR/JygVY3XL22wLz2Xm6E2PUdC82dTYKSdU=
Date:   Tue, 21 Nov 2023 15:14:51 -0800
To:     mm-commits@vger.kernel.org, avagin@google.com,
        colin.i.king@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-check-that-pagemap_scan-returns-correct-categories-fix-2.patch added to mm-unstable branch
Message-Id: <20231121231451.E05B8C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: fix spelling mistake "succedded" -> "succeeded"
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-check-that-pagemap_scan-returns-correct-categories-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-check-that-pagemap_scan-returns-correct-categories-fix-2.patch

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
From: Colin Ian King <colin.i.king@gmail.com>
Subject: selftests/mm: fix spelling mistake "succedded" -> "succeeded"
Date: Tue, 21 Nov 2023 09:31:04 +0000

There is a spelling mistake in a ksft_exit_fail_msg message. Fix it.

Link: https://lkml.kernel.org/r/20231121093104.1728332-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Cc: Andrei Vagin <avagin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-check-that-pagemap_scan-returns-correct-categories-fix-2
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -75,7 +75,7 @@ static bool pagemap_scan_supported(int f
 	/* Provide an invalid address in order to trigger EFAULT. */
 	ret = __pagemap_scan_get_categories(fd, start, (struct page_region *) ~0UL);
 	if (ret == 0)
-		ksft_exit_fail_msg("PAGEMAP_SCAN succedded unexpectedly\n");
+		ksft_exit_fail_msg("PAGEMAP_SCAN succeeded unexpectedly\n");
 
 	supported = errno == EFAULT;
 
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

selftests-mm-check-that-pagemap_scan-returns-correct-categories-fix-2.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6703EB64D9
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 17:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjGBRlC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 13:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjGBRlB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 13:41:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789AE183
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 10:41:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03FE160C04
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 17:41:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44325C433C7;
        Sun,  2 Jul 2023 17:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688319659;
        bh=EvpPIBqcrZu0VRpun9pExv2AWbwOtHwh/r0EagZJVZY=;
        h=Date:To:From:Subject:From;
        b=cZItJyqENHVCoJRIXq+T30awPp8BS2H1aEqXQUOEFrztuecsibIB7AH0ygVsqj/TH
         D04fpbAASfDrMkJqE4aTU1wDSjLCePbfX3CySUpWjb4qx7EPVMh8hnTmEoT6o/mBB2
         +227zSV/TIzs7FRMUdDPlfTLKK8nlAvpsuVmns1Y=
Date:   Sun, 02 Jul 2023 10:40:58 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch added to mm-unstable branch
Message-Id: <20230702174059.44325C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory-failure: fix potential page refcnt leak in memory_failure()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: memory-failure: fix potential page refcnt leak in memory_failure()
Date: Sat, 1 Jul 2023 15:28:37 +0800

put_ref_page() is not called to drop extra refcnt when comes from madvise
in the case pfn is valid but pgmap is NULL leading to page refcnt leak.

Link: https://lkml.kernel.org/r/20230701072837.1994253-1-linmiaohe@huawei.com
Fixes: 1e8aaedb182d ("mm,memory_failure: always pin the page in madvise_inject_error")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure
+++ a/mm/memory-failure.c
@@ -2080,8 +2080,6 @@ static int memory_failure_dev_pagemap(un
 {
 	int rc = -ENXIO;
 
-	put_ref_page(pfn, flags);
-
 	/* device metadata space is not recoverable */
 	if (!pgmap_pfn_valid(pgmap, pfn))
 		goto out;
@@ -2157,6 +2155,7 @@ int memory_failure(unsigned long pfn, in
 
 		if (pfn_valid(pfn)) {
 			pgmap = get_dev_pagemap(pfn, NULL);
+			put_ref_page(pfn, flags);
 			if (pgmap) {
 				res = memory_failure_dev_pagemap(pfn, flags,
 								 pgmap);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-mm_initc-update-obsolete-comment-in-get_pfn_range_for_nid.patch
mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch


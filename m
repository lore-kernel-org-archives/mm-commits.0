Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2FE4C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 06:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358832AbiAYGqp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jan 2022 01:46:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357959AbiAYGo0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jan 2022 01:44:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0B5C07E317
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 21:02:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A276615D9
        for <mm-commits@vger.kernel.org>; Tue, 25 Jan 2022 05:02:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46CEC340E0;
        Tue, 25 Jan 2022 05:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643086924;
        bh=vNRTnMvKB2jpuQTIm7IULQ0puWjWKNMT0F2mOh53fgE=;
        h=Date:From:To:Subject:From;
        b=JfnkE3iDnE3hHAjzzFcBycj90e2e9fjoi7/DQpyhI6vWUgxoQTGmsut8eKC+ZUFf1
         jagfIoG9cOyDvmC8vAYmFbzmtTMf82l6xzxBiJy8wo7/XOp51I5zQ7dR/9kAYHAdSU
         q11ut1hguLMe/SiBlVV4LLpIV0sQUp1MPjFQBWMA=
Date:   Mon, 24 Jan 2022 21:02:04 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com
Subject:  + mm-hwpoison-remove-obsolete-comment.patch added to -mm
 tree
Message-ID: <20220125050204.lfQuYSMGA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: remove obsolete comment
has been added to the -mm tree.  Its filename is
     mm-hwpoison-remove-obsolete-comment.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-remove-obsolete-comment.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-remove-obsolete-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm/memory-failure.c: remove obsolete comment

With the introduction of mf_mutex, most of memory error handling process
is mutually exclusive, so the in-line comment about subtlety about
double-checking PageHWPoison is no more correct.  So remove it.

Link: https://lkml.kernel.org/r/20220125025601.3054511-1-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Suggested-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-remove-obsolete-comment
+++ a/mm/memory-failure.c
@@ -2150,12 +2150,6 @@ static int __soft_offline_page(struct pa
 		.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
 	};
 
-	/*
-	 * Check PageHWPoison again inside page lock because PageHWPoison
-	 * is set by memory_failure() outside page lock. Note that
-	 * memory_failure() also double-checks PageHWPoison inside page lock,
-	 * so there's no race between soft_offline_page() and memory_failure().
-	 */
 	lock_page(page);
 	if (!PageHuge(page))
 		wait_on_page_writeback(page);
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mm-hwpoison-remove-obsolete-comment.patch


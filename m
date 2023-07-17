Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40458C001B0
	for <mm-commits@archiver.kernel.org>; Mon, 17 Jul 2023 19:01:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbjGQTB3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Jul 2023 15:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbjGQTB2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Jul 2023 15:01:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16CFE4C;
        Mon, 17 Jul 2023 12:01:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57830611FE;
        Mon, 17 Jul 2023 19:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4AEC433C7;
        Mon, 17 Jul 2023 19:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689620485;
        bh=0sXWPUFEwsFT/yw8IRhMLlLrUrqWFFRk2IBT4B9ZPqg=;
        h=Date:To:From:Subject:From;
        b=JksllIUhD4w+mAosU2PjMLIJl0FrBIYLbx2RJzYI6uTf9y+aAvR1QqoBJdb70RmIl
         ds6f+MFgxuj7h6FJBkVqFjfhJz28yPeumXlGtouwk2kvrv2fPf38FtlsPUHmS+Axyj
         uIOtDqyRAF5x/4U6C2RvOY+hHCoZCTSwj9WS1nTk=
Date:   Mon, 17 Jul 2023 12:01:25 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-fix-hardware-poison-check-in-unpoison_memory.patch added to mm-hotfixes-unstable branch
Message-Id: <20230717190125.AC4AEC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: fix hardware poison check in unpoison_memory()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory-failure-fix-hardware-poison-check-in-unpoison_memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-fix-hardware-poison-check-in-unpoison_memory.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/memory-failure: fix hardware poison check in unpoison_memory()
Date: Mon, 17 Jul 2023 11:18:12 -0700

It was pointed out[1] that using folio_test_hwpoison() is wrong as we need
to check the indiviual page that has poison.  folio_test_hwpoison() only
checks the head page so go back to using PageHWPoison().

[1]: https://lore.kernel.org/lkml/ZLIbZygG7LqSI9xe@casper.infradead.org/

Link: https://lkml.kernel.org/r/20230717181812.167757-1-sidhartha.kumar@oracle.com
Fixes: a6fddef49eef ("mm/memory-failure: convert unpoison_memory() to folios")
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reported-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory-failure-fix-hardware-poison-check-in-unpoison_memory
+++ a/mm/memory-failure.c
@@ -2487,7 +2487,7 @@ int unpoison_memory(unsigned long pfn)
 		goto unlock_mutex;
 	}
 
-	if (!folio_test_hwpoison(folio)) {
+	if (!PageHWPoison(p)) {
 		unpoison_pr_info("Unpoison: Page was already unpoisoned %#lx\n",
 				 pfn, &unpoison_rs);
 		goto unlock_mutex;
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-memory-failure-fix-hardware-poison-check-in-unpoison_memory.patch
mm-increase-usage-of-folio_next_index-helper.patch
mm-memory-convert-do_page_mkwrite-to-use-folios.patch
mm-memory-convert-wp_page_shared-to-use-folios.patch
mm-memory-convert-do_shared_fault-to-folios.patch
mm-memory-convert-do_read_fault-to-use-folios.patch
mm-memory-pass-folio-into-do_page_mkwrite.patch


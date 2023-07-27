Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAF0BC04FE1
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jul 2023 20:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbjG0UIH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jul 2023 16:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232654AbjG0UHz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2023 16:07:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753DB30D6;
        Thu, 27 Jul 2023 13:07:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55B2961F27;
        Thu, 27 Jul 2023 20:07:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6BBC433C7;
        Thu, 27 Jul 2023 20:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690488470;
        bh=8VvzBKpPu8h6+QO4Rl6XRaHkJxZCW+ZJuLhv2b+d+Cs=;
        h=Date:To:From:Subject:From;
        b=qbVkakEn9hJgzDH3t1yoXloJZKaWraoY1O8QQrEdRJ3v0zMIOZlFjok/0OKLYuaJi
         c6Hj2m/TnF1wqHKz9cwZy/DD3Z58jVH6V7Eh+1DcDdYJyDOoeng6UhBk3ImMwXDIei
         3ZrkVfG+/x05XphE8Ib0F9pHIfh9lSaxiwzIXvMk=
Date:   Thu, 27 Jul 2023 13:07:50 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memory-failure-fix-hardware-poison-check-in-unpoison_memory.patch removed from -mm tree
Message-Id: <20230727200750.AE6BBC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory-failure: fix hardware poison check in unpoison_memory()
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-fix-hardware-poison-check-in-unpoison_memory.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/memory-failure: fix hardware poison check in unpoison_memory()
Date: Mon, 17 Jul 2023 11:18:12 -0700

It was pointed out[1] that using folio_test_hwpoison() is wrong as we need
to check the indiviual page that has poison.  folio_test_hwpoison() only
checks the head page so go back to using PageHWPoison().

User-visible effects include existing hwpoison-inject tests possibly
failing as unpoisoning a single subpage could lead to unpoisoning an
entire folio.  Memory unpoisoning could also not work as expected as
the function will break early due to only checking the head page and
not the actually poisoned subpage.

[1]: https://lore.kernel.org/lkml/ZLIbZygG7LqSI9xe@casper.infradead.org/

Link: https://lkml.kernel.org/r/20230717181812.167757-1-sidhartha.kumar@oracle.com
Fixes: a6fddef49eef ("mm/memory-failure: convert unpoison_memory() to folios")
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reported-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
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

mm-increase-usage-of-folio_next_index-helper.patch
mm-memory-convert-do_page_mkwrite-to-use-folios.patch
mm-memory-convert-wp_page_shared-to-use-folios.patch
mm-memory-convert-do_shared_fault-to-folios.patch
mm-memory-convert-do_read_fault-to-use-folios.patch
mm-memory-pass-folio-into-do_page_mkwrite.patch
mm-hugetlb-get-rid-of-page_hstate.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A88A5EB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 20:20:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjFSUUV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 16:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjFSUUM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 16:20:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A6ED3
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 13:20:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49C3060EB0
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 20:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9EAC433C0;
        Mon, 19 Jun 2023 20:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687206009;
        bh=4/5rPh+FFRptgEV2fH1b4h10dJZCkO6IxixKY3d7RUQ=;
        h=Date:To:From:Subject:From;
        b=xG5FjmcVYIHuVZ0vPGXxewPrB4KrOdJsfa85PRW7TjVR7bdFQ9RQySBjJU0FHozn/
         qr2oIT5cvuKce77QSlDWwa+NERQwjYWJaQLHksnokqY9AgjYFEzOcb8WDMbnfRlyH8
         3N4P00HdfwdbZr3FOsw78oSwLmZ3iDAjS20Pcf+c=
Date:   Mon, 19 Jun 2023 13:20:09 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        shy828301@gmail.com, peterx@redhat.com, mike.kravetz@oracle.com,
        kirill@shutemov.name, jiaqiyan@google.com, hughd@google.com,
        david@redhat.com, stevensd@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-khugepaged-fix-iteration-in-collapse_file.patch removed from -mm tree
Message-Id: <20230619202009.9B9EAC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: fix iteration in collapse_file
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-fix-iteration-in-collapse_file.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Stevens <stevensd@chromium.org>
Subject: mm/khugepaged: fix iteration in collapse_file
Date: Wed, 7 Jun 2023 14:31:35 +0900

Remove an unnecessary call to xas_set(index) when iterating over the
target range in collapse_file.  The extra call to xas_set reset the xas
cursor to the top of the tree, causing the xas_next call on the next
iteration to walk the tree to index instead of advancing to index+1.  This
returned the same page again, which would cause collapse_file to fail
because the page is already locked.

This bug was hidden when CONFIG_DEBUG_VM was set.  When that config was
used, the xas_load in a subsequent VM_BUG_ON assert would walk xas from
the top of the tree to index, causing the xas_next call on the next loop
iteration to advance the cursor as expected.

Link: https://lkml.kernel.org/r/20230607053135.2087354-1-stevensd@google.com
Fixes: a2e17cc2efc7 ("mm/khugepaged: maintain page cache uptodate flag")
Signed-off-by: David Stevens <stevensd@chromium.org>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Kirill A . Shutemov <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-fix-iteration-in-collapse_file
+++ a/mm/khugepaged.c
@@ -2070,7 +2070,6 @@ static int collapse_file(struct mm_struc
 					TTU_IGNORE_MLOCK | TTU_BATCH_FLUSH);
 
 		xas_lock_irq(&xas);
-		xas_set(&xas, index);
 
 		VM_BUG_ON_PAGE(page != xas_load(&xas), page);
 
_

Patches currently in -mm which might be from stevensd@chromium.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp.patch


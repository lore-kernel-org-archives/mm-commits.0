Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F5A2C77B7A
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 17:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbjFGRt0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jun 2023 13:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbjFGRtZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jun 2023 13:49:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA46E196
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 10:49:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E03164239
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 17:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C1CC433EF;
        Wed,  7 Jun 2023 17:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686160163;
        bh=WIbBHz8WgHl1EzfoLZjvV+vV39RKvW1iTffsmXrABN4=;
        h=Date:To:From:Subject:From;
        b=15vE3IyicLOBHbnJ+mVw+97wm0zm78YH47kMtxqX4hrSRFvMH7Bzd2VDBbqjC2Ftt
         EBr1I5n1Emxh8wo7BHgcnZx0OQW8ejB2RaL4/dpmvXXogYXZIWPoWj6lYWe1TzVicP
         lNhVYD6zCXl708MMujx8Ue07F0wKoLI3JSF/nl8Y=
Date:   Wed, 07 Jun 2023 10:49:22 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        shy828301@gmail.com, peterx@redhat.com, mike.kravetz@oracle.com,
        kirill@shutemov.name, jiaqiyan@google.com, hughd@google.com,
        david@redhat.com, stevensd@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-fix-iteration-in-collapse_file.patch added to mm-hotfixes-unstable branch
Message-Id: <20230607174923.90C1CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: fix iteration in collapse_file
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-khugepaged-fix-iteration-in-collapse_file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-fix-iteration-in-collapse_file.patch

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
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Kirill A . Shutemov <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
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
mm-khugepaged-fix-iteration-in-collapse_file.patch


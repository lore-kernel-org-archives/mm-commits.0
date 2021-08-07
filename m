Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE3F8C4320A
	for <mm-commits@archiver.kernel.org>; Sat,  7 Aug 2021 18:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B8F861058
	for <mm-commits@archiver.kernel.org>; Sat,  7 Aug 2021 18:43:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbhHGSnz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 Aug 2021 14:43:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhHGSnz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Aug 2021 14:43:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8330A61078;
        Sat,  7 Aug 2021 18:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628361817;
        bh=cWOv6InJ7/R7m5y2+ulDR7J5zdUl9pZkhX2yu0RY30o=;
        h=Date:From:To:Subject:From;
        b=Gk9ouWX22d7ytX0x92quLtDDfqzTPkei0Bo40IBON4tmknyzGVI8qK5zLwR514b4J
         WpW0vaHxd8fjmC/1I9cBF1h0/BF0sDd2AlEoHjLtWOb3EjHmCxbACIsal+g1WSf/Ys
         K1CZXhf+vtwIHwZixePSN/cWC4sakGBv9+QwQv5g=
Date:   Sat, 07 Aug 2021 11:43:37 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, jhubbard@nvidia.com, jack@suse.cz,
        imbrenda@linux.ibm.com, akpm@linux-foundation.org
Subject:  +
 mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix.patch added
 to -mm tree
Message-ID: <20210807184337.muBq7%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix
has been added to the -mm tree.  Its filename is
     mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix

simplify, cleanup

Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/gup.c~mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix
+++ a/mm/gup.c
@@ -2247,14 +2247,13 @@ static int __gup_device_huge(unsigned lo
 		pgmap = get_dev_pagemap(pfn, pgmap);
 		if (unlikely(!pgmap)) {
 			undo_dev_pagemap(nr, nr_start, flags, pages);
-			return 0;
+			break;
 		}
 		SetPageReferenced(page);
 		pages[*nr] = page;
 		if (unlikely(!try_grab_page(page, flags))) {
 			undo_dev_pagemap(nr, nr_start, flags, pages);
-			put_dev_pagemap(pgmap);
-			return 0;
+			break;
 		}
 		(*nr)++;
 		pfn++;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-compaction-optimize-proactive-compaction-deferrals-fix.patch
mm-compaction-support-triggering-of-proactive-compaction-by-user-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-damon-implement-primitives-for-the-virtual-memory-address-spaces-fix.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix-fix.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix-fix.patch
log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch


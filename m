Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BC15C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:12:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32B9D6102A
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:12:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344283AbhIBVNy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:13:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232087AbhIBVNy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:13:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAA5960FDA;
        Thu,  2 Sep 2021 21:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630617175;
        bh=FULAQ3Vq2LDCaAgyCE8qCiQNR9B9drCIr2due7k//IU=;
        h=Date:From:To:Subject:From;
        b=XsVBV29juPU7LmeXSgy/x+U/EQF0kcfmEfWPlgYTT6EfFK7FcNB7LLPQW7ovPToqP
         Jw6HSJm1QjqSRsEviQrxzvi+2Y+xzO12DqdoD4i3Q1v4qh6aZCxISSOqE08kM07xPi
         YJnhDrCLi0Zt2qrHitf76oKPsLs6+/giKN7tSH04=
Date:   Thu, 02 Sep 2021 14:12:54 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, imbrenda@linux.ibm.com, jack@suse.cz,
        jhubbard@nvidia.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix.patch
 removed from -mm tree
Message-ID: <20210902211254.LhAIsfymD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix
has been removed from the -mm tree.  Its filename was
     mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix.patch

This patch was dropped because it was folded into mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge.patch

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

mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge.patch
mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix-fix.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-compaction-optimize-proactive-compaction-deferrals-fix.patch
mm-compaction-support-triggering-of-proactive-compaction-by-user-fix.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-idle_page_tracking-make-pg_idle-reusable-fix-fix.patch
mm-damon-implement-primitives-for-the-virtual-memory-address-spaces-fix.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix-fix.patch
checkpatch-improve-git_commit_id-test-fix.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix-fix.patch
log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch


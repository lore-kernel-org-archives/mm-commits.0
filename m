Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFD79C4708F
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 23:49:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBF56613F6
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 23:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235206AbhFAXvQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Jun 2021 19:51:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235137AbhFAXvO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 1 Jun 2021 19:51:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0B9E613F3;
        Tue,  1 Jun 2021 23:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622591371;
        bh=Eljs6Cmz9RtY5ZKh/1VhS4C7UgW9+ixlijF5vBAIRyY=;
        h=Date:From:To:Subject:From;
        b=Rlp9dGlN3RPZdDXtdin8/+RP0SapVpCqiqsht4sDzdIavgBb6/jfusfOuV+X/Wsj/
         qadbQOFyG2/ADIGtd3aBG7eZhJzN4foeDnRfkQs9GyiGRYiOYghPlnW55tDHzdy8NI
         MhVKrEoH5Tmulh4Qaf1ivQ7uZuUoskJvCVE+cE+I=
Date:   Tue, 01 Jun 2021 16:49:30 -0700
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, dan.carpenter@oracle.com,
        gerald.schaefer@linux.ibm.com, gor@linux.ibm.com,
        hca@linux.ibm.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        ying.huang@intel.com, ziy@nvidia.com
Subject:  + mm-thp-refactor-numa-fault-handling-fix.patch added to
 -mm tree
Message-ID: <20210601234930.SC3m0ZdKA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: fix a double unlock bug
has been added to the -mm tree.  Its filename is
     mm-thp-refactor-numa-fault-handling-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-refactor-numa-fault-handling-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-refactor-numa-fault-handling-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: mm: thp: fix a double unlock bug

We're supposed to be holding the "vmf->ptl" spin_lock when we goto
out_map.  The lock is dropped after if finishes cleaning up.

Link: https://lkml.kernel.org/r/YLX8uYN01JmfLnlK@mwanda
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Yang Shi <shy828301@gmail.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/huge_memory.c~mm-thp-refactor-numa-fault-handling-fix
+++ a/mm/huge_memory.c
@@ -1465,10 +1465,8 @@ vm_fault_t do_huge_pmd_numa_page(struct
 
 	pmd = pmd_modify(oldpmd, vma->vm_page_prot);
 	page = vm_normal_page_pmd(vma, haddr, pmd);
-	if (!page) {
-		spin_unlock(vmf->ptl);
+	if (!page)
 		goto out_map;
-	}
 
 	/* See similar comment in do_numa_page for explanation */
 	if (!was_writable)
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

ocfs2-fix-snprintf-checking.patch
mm-thp-refactor-numa-fault-handling-fix.patch


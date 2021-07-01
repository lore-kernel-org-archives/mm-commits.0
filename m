Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC749C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7B44610A7
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235609AbhGAA74 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 20:59:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232066AbhGAA74 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 20:59:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6113B6146D;
        Thu,  1 Jul 2021 00:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625101046;
        bh=bZ+W92kg0MIr+hqmXSTcgpkzU3n0S58f29f+Pu20R9c=;
        h=Date:From:To:Subject:From;
        b=ryX1rwds0yf3vfFGc3lyExQu7BDTsB3pYvdtQzv8T3VttrMG9fDO5iLMP7zg8llDZ
         oGoehP/hMDbMIu9L4/X4Qy+RZzja4CY/dSJCdZ9ufnsdZgZ0iWUW5gIzMWwdMKLiY1
         FU4+cpFpkwQbmNpUnDpbxInCraEvjmiB+lYKqlNk=
Date:   Wed, 30 Jun 2021 17:57:26 -0700
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, dan.carpenter@oracle.com,
        gerald.schaefer@linux.ibm.com, gor@linux.ibm.com,
        hca@linux.ibm.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        ying.huang@intel.com, ziy@nvidia.com
Subject:  [folded-merged]
 mm-thp-refactor-numa-fault-handling-fix.patch removed from -mm tree
Message-ID: <20210701005726.h6NyEcvAC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: fix a double unlock bug
has been removed from the -mm tree.  Its filename was
     mm-thp-refactor-numa-fault-handling-fix.patch

This patch was dropped because it was folded into mm-thp-refactor-numa-fault-handling.patch

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
@@ -1467,10 +1467,8 @@ vm_fault_t do_huge_pmd_numa_page(struct
 
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
mm-thp-refactor-numa-fault-handling.patch
mm-device-exclusive-memory-access-fix.patch


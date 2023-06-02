Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ADD2C7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jun 2023 20:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236326AbjFBUzU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Jun 2023 16:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236158AbjFBUzQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jun 2023 16:55:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797ADE43
        for <mm-commits@vger.kernel.org>; Fri,  2 Jun 2023 13:55:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F377761EA7
        for <mm-commits@vger.kernel.org>; Fri,  2 Jun 2023 20:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D93C433D2;
        Fri,  2 Jun 2023 20:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685739314;
        bh=Ls5yhqSRfv1sOqv+qPeBOAUwFbGMUKIrcQ7eZmsp9Ec=;
        h=Date:To:From:Subject:From;
        b=19EJcAeIYAJzOibQWvipYVIDsKVj9wo8OvT95hDLPNe5juZHxa35YueWLe/aP22Uw
         /UcwyMCGvC10/JCpLjvlEep318Rna0sU7LKRpe80Ajq3cBRc0l8bINcJeWV6clVwDd
         Hi0WFpAuYup2mzrhGMINS4QqNlozJWe+qDT6Sw40=
Date:   Fri, 02 Jun 2023 13:55:13 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
        willy@infradead.org, urezki@gmail.com, sj@kernel.org,
        rppt@kernel.org, lstoakes@gmail.com,
        kirill.shutemov@linux.intel.com, hch@lst.de, hch@infradead.org,
        ryan.roberts@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-failure-to-unmap-pte-on-highmem-systems.patch added to mm-unstable branch
Message-Id: <20230602205514.48D93C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix failure to unmap pte on highmem systems
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-failure-to-unmap-pte-on-highmem-systems.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-failure-to-unmap-pte-on-highmem-systems.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: fix failure to unmap pte on highmem systems
Date: Fri, 2 Jun 2023 10:29:49 +0100

The loser of a race to service a pte for a device private entry in the
swap path previously unlocked the ptl, but failed to unmap the pte.  This
only affects highmem systems since unmapping a pte is a noop on
non-highmem systems.

Link: https://lkml.kernel.org/r/20230602092949.545577-5-ryan.roberts@arm.com
Fixes: 16ce101db85d ("mm/memory.c: fix race when faulting a device private page")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-fix-failure-to-unmap-pte-on-highmem-systems
+++ a/mm/memory.c
@@ -3729,10 +3729,8 @@ vm_fault_t do_swap_page(struct vm_fault
 			vmf->page = pfn_swap_entry_to_page(entry);
 			vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
 					vmf->address, &vmf->ptl);
-			if (unlikely(!pte_same(*vmf->pte, vmf->orig_pte))) {
-				spin_unlock(vmf->ptl);
-				goto out;
-			}
+			if (unlikely(!pte_same(*vmf->pte, vmf->orig_pte)))
+				goto unlock;
 
 			/*
 			 * Get a page reference while we know the page can't be
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-vmalloc-must-set-pte-via-arch-code.patch
mm-damon-ops-common-atomically-test-and-clear-young-on-ptes-and-pmds.patch
mm-damon-ops-common-refactor-to-use-ptepmdp_clear_young_notify.patch
mm-fix-failure-to-unmap-pte-on-highmem-systems.patch


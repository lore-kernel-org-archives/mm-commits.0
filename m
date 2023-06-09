Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17961C7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbjFIXfD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbjFIXdZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:33:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972114212
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:30:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34F716169F
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:30:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D623C433D2;
        Fri,  9 Jun 2023 23:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353428;
        bh=L1w2/wZVi8R8VTciLYPJJ5VagM0MQuvyotBzy1coDos=;
        h=Date:To:From:Subject:From;
        b=ZeHj5drlsqtIoDSuhy9WLZBvYyZpwAdWTWZmNxYIgGOr1zuutBjF1g/O6Dv54x5UT
         9KGH7cZSGllDwswA4TlFuhCmI9QKKg1juacg18HETb/HJwGN1/7ROh1HKs2LivIDBt
         WEdGt5u/y3qWCfSAsDcXC2zYy/gFDPnZjJyhXMv4=
Date:   Fri, 09 Jun 2023 16:30:28 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
        willy@infradead.org, urezki@gmail.com, sj@kernel.org,
        rppt@kernel.org, lstoakes@gmail.com,
        kirill.shutemov@linux.intel.com, hch@lst.de, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-failure-to-unmap-pte-on-highmem-systems.patch removed from -mm tree
Message-Id: <20230609233028.8D623C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fix failure to unmap pte on highmem systems
has been removed from the -mm tree.  Its filename was
     mm-fix-failure-to-unmap-pte-on-highmem-systems.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Christoph Hellwig <hch@lst.de>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-fix-failure-to-unmap-pte-on-highmem-systems
+++ a/mm/memory.c
@@ -3728,10 +3728,8 @@ vm_fault_t do_swap_page(struct vm_fault
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



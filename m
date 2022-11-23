Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AFB4C43219
	for <mm-commits@archiver.kernel.org>; Wed, 23 Nov 2022 02:53:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235613AbiKWCxT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Nov 2022 21:53:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235518AbiKWCxQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2022 21:53:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DDD88DA42
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2022 18:53:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEA4DB81E56
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 02:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8ECC433C1;
        Wed, 23 Nov 2022 02:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669171993;
        bh=c0bj21UigpL0y7JSJ6tDUmLtTtsgcqZgAmyBnYTQ72s=;
        h=Date:To:From:Subject:From;
        b=m5z3dzikvVDzTllasg6yqjkJ5jfYXQXN4+sRZEJ+UMgBKHYBmyi/hHW2feeGILDff
         dzLCZIIoFy65mL+7bGc2gCm79aWZTgA3TSrQ5pVaCltcKOwctnZrCriI9WZp/Oki4R
         dzs5Ix7rUsrwonCy3BsIN2PpWFKc6NpAiVyEvmrU=
Date:   Tue, 22 Nov 2022 18:53:12 -0800
To:     mm-commits@vger.kernel.org, rcampbell@nvidia.com,
        mpe@ellerman.id.au, lyude@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, Felix.Kuehling@amd.com, david@redhat.com,
        bskeggs@redhat.com, alex.sierra@amd.com, apopple@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memory-return-vm_fault_t-result-from-migrate_to_ram-callback.patch removed from -mm tree
Message-Id: <20221123025313.4A8ECC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory: return vm_fault_t result from migrate_to_ram() callback
has been removed from the -mm tree.  Its filename was
     mm-memory-return-vm_fault_t-result-from-migrate_to_ram-callback.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/memory: return vm_fault_t result from migrate_to_ram() callback
Date: Mon, 14 Nov 2022 22:55:37 +1100

The migrate_to_ram() callback should always succeed, but in rare cases can
fail usually returning VM_FAULT_SIGBUS.  Commit 16ce101db85d
("mm/memory.c: fix race when faulting a device private page") incorrectly
stopped passing the return code up the stack.  Fix this by setting the ret
variable, restoring the previous behaviour on migrate_to_ram() failure.

Link: https://lkml.kernel.org/r/20221114115537.727371-1-apopple@nvidia.com
Fixes: 16ce101db85d ("mm/memory.c: fix race when faulting a device private page")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memory-return-vm_fault_t-result-from-migrate_to_ram-callback
+++ a/mm/memory.c
@@ -3763,7 +3763,7 @@ vm_fault_t do_swap_page(struct vm_fault
 			 */
 			get_page(vmf->page);
 			pte_unmap_unlock(vmf->pte, vmf->ptl);
-			vmf->page->pgmap->ops->migrate_to_ram(vmf);
+			ret = vmf->page->pgmap->ops->migrate_to_ram(vmf);
 			put_page(vmf->page);
 		} else if (is_hwpoison_entry(entry)) {
 			ret = VM_FAULT_HWPOISON;
_

Patches currently in -mm which might be from apopple@nvidia.com are



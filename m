Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D4CCC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 00:10:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiKOAKJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Nov 2022 19:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236735AbiKOAKG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2022 19:10:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D875C13E32
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2022 16:10:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95C9DB810A8
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 00:10:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2662AC433D6;
        Tue, 15 Nov 2022 00:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668471002;
        bh=IDKrR5yyzZlxmH1dT0cky/9iLjeV4AkCsEehCWkioBk=;
        h=Date:To:From:Subject:From;
        b=v0ofSyZIdPfSvh51beQyFshCcz+rQ7fpNaP1uaYVLDPFqc4pBeyfBSUVUPZfKXLz6
         QtWx64u0+DmG+lSXt4KKFnkzOm8SJTlu+bHal3B/hs/K1mbdEk8ZchX3e9/0vHJuTj
         hxVQVRdpBTB0VWavO948Wl/lgIMIjnNBvX7RjfPw=
Date:   Mon, 14 Nov 2022 16:10:01 -0800
To:     mm-commits@vger.kernel.org, rcampbell@nvidia.com,
        mpe@ellerman.id.au, lyude@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, Felix.Kuehling@amd.com, david@redhat.com,
        bskeggs@redhat.com, alex.sierra@amd.com, apopple@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-return-vm_fault_t-result-from-migrate_to_ram-callback.patch added to mm-hotfixes-unstable branch
Message-Id: <20221115001002.2662AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory: return vm_fault_t result from migrate_to_ram() callback
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory-return-vm_fault_t-result-from-migrate_to_ram-callback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-return-vm_fault_t-result-from-migrate_to_ram-callback.patch

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
@@ -3762,7 +3762,7 @@ vm_fault_t do_swap_page(struct vm_fault
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

mm-memory-return-vm_fault_t-result-from-migrate_to_ram-callback.patch
mm-khugepaged-refactor-mm_khugepaged_scan_file-tracepoint-to-remove-filename-from-function-call-fix.patch


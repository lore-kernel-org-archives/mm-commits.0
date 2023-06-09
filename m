Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53DE9C7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:16:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjFIXQg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjFIXQf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:16:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4311D2D52
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:16:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D427E61006
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D56CC4339B;
        Fri,  9 Jun 2023 23:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686352593;
        bh=ye8HtmAuAengrABvawPGPT4u9OY0e0vd9IAk2ZGWtA4=;
        h=Date:To:From:Subject:From;
        b=BQTqOXGMn3brGWYxyux1tPyyOheBHF5GG2GZn0HRG1NC9cLOHECGjKKOr1lJaHII4
         nDqM9pZ/vtbxiNNIXo5AWTf7SykNBY4Or+JckHiicMXGiOE0rjU7bO/ynEJ6PBgZAR
         2plBMb4YXad+e/e3WnuYAOuhzeoYUjeeJ93diefk=
Date:   Fri, 09 Jun 2023 16:16:32 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, seanjc@google.com,
        sakari.ailus@linux.intel.com, lstoakes@gmail.com, lkp@intel.com,
        jgg@nvidia.com, jarkko@kernel.org, hch@lst.de,
        gregkh@linuxfoundation.org, frankja@linux.ibm.com,
        dennis.dalessandro@cornelisnetworks.com, david@redhat.com,
        christian.koenig@amd.com, catalin.marinas@arm.com, axboe@kernel.dk,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-gup-remove-vmas-parameter-from-get_user_pages_remote-fix.patch removed from -mm tree
Message-Id: <20230609231633.2D56CC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-gup-remove-vmas-parameter-from-get_user_pages_remote-fix
has been removed from the -mm tree.  Its filename was
     mm-gup-remove-vmas-parameter-from-get_user_pages_remote-fix.patch

This patch was dropped because it was folded into mm-gup-remove-vmas-parameter-from-get_user_pages_remote.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-gup-remove-vmas-parameter-from-get_user_pages_remote-fix
Date: Fri Jun  9 10:40:05 AM PDT 2023

avoid passing NULL to PTR_ERR

Reported-by: kernel test robot <lkp@intel.com>
  Link: https://lkml.kernel.org/r/202306100045.iM5qbyCz-lkp@intel.com
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/uprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/events/uprobes.c~mm-gup-remove-vmas-parameter-from-get_user_pages_remote-fix
+++ a/kernel/events/uprobes.c
@@ -475,7 +475,7 @@ retry:
 	/* Read the page with vaddr into memory */
 	old_page = get_user_page_vma_remote(mm, vaddr, gup_flags, &vma);
 	if (IS_ERR_OR_NULL(old_page))
-		return PTR_ERR(old_page);
+		return old_page ? PTR_ERR(old_page) : 0;
 
 	ret = verify_opcode(old_page, vaddr, &opcode);
 	if (ret <= 0)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-gup-remove-vmas-parameter-from-get_user_pages_remote.patch
selftests-mm-gup_longterm-new-functional-test-for-foll_longterm-fix.patch
mm-mlock-rename-mlock_future_check-to-mlock_future_ok.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix.patch
mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch
mm-page_isolation-write-proper-kerneldoc-fix.patch
mm-hugetlb-use-a-folio-in-hugetlb_fault-fix.patch
fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch
squashfs-cache-partial-compressed-blocks-fix.patch
squashfs-cache-partial-compressed-blocks-fix-3-fix.patch
init-add-bdev-fs-printk-if-mount_block_root-failed-fix.patch
kexec-add-helper-__crash_shrink_memory-fix.patch


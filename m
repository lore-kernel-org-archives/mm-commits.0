Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF1D2C43217
	for <mm-commits@archiver.kernel.org>; Wed, 16 Nov 2022 22:45:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238722AbiKPWpQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Nov 2022 17:45:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238704AbiKPWoW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Nov 2022 17:44:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26576626B
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 14:44:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B75EF62003
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 22:44:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA42C433C1;
        Wed, 16 Nov 2022 22:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668638661;
        bh=4eJ3h10AkW4zLMdVicMkZlGxLSFXzmHLYE48um5q2zk=;
        h=Date:To:From:Subject:From;
        b=a3WNuTJYgPZfJgD1usjcb9j/M6jUlfHUZ6u8wu59rGA6gkEC3gW2PA3or1Ce1Q/RN
         FYIiOG4CVmEBCfhzitzjAlx1FAssg1IqsOn/zLpcHcH9o5IJxvt7D5z3U7qivf38wa
         nXulvnxyQ6E1AebARDeZ3WBwxU1ni85H96RsfLN8=
Date:   Wed, 16 Nov 2022 14:44:20 -0800
To:     mm-commits@vger.kernel.org, leon@kernel.org, jgg@ziepe.ca,
        dennis.dalessandro@cornelisnetworks.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + rdma-hw-qib-qib_user_pages-remove-foll_force-usage.patch added to mm-unstable branch
Message-Id: <20221116224421.1AA42C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: RDMA/hw/qib/qib_user_pages: remove FOLL_FORCE usage
has been added to the -mm mm-unstable branch.  Its filename is
     rdma-hw-qib-qib_user_pages-remove-foll_force-usage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rdma-hw-qib-qib_user_pages-remove-foll_force-usage.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: RDMA/hw/qib/qib_user_pages: remove FOLL_FORCE usage
Date: Wed, 16 Nov 2022 11:26:57 +0100

FOLL_FORCE is really only for ptrace access. As we unpin the pinned pages
using unpin_user_pages_dirty_lock(true), the assumption is that all these
pages are writable.

FOLL_FORCE in this case seems to be a legacy leftover. Let's just remove
it.

Link: https://lkml.kernel.org/r/20221116102659.70287-19-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/qib/qib_user_pages.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/qib/qib_user_pages.c~rdma-hw-qib-qib_user_pages-remove-foll_force-usage
+++ a/drivers/infiniband/hw/qib/qib_user_pages.c
@@ -110,7 +110,7 @@ int qib_get_user_pages(unsigned long sta
 	for (got = 0; got < num_pages; got += ret) {
 		ret = pin_user_pages(start_page + got * PAGE_SIZE,
 				     num_pages - got,
-				     FOLL_LONGTERM | FOLL_WRITE | FOLL_FORCE,
+				     FOLL_LONGTERM | FOLL_WRITE,
 				     p + got, NULL);
 		if (ret < 0) {
 			mmap_read_unlock(current->mm);
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch
mm-mprotect-minor-can_change_pte_writable-cleanups.patch
mm-huge_memory-try-avoiding-write-faults-when-changing-pmd-protection.patch
mm-mprotect-factor-out-check-whether-manual-pte-write-upgrades-are-required.patch
mm-autonuma-use-can_change_ptepmd_writable-to-replace-savedwrite.patch
mm-remove-unused-savedwrite-infrastructure.patch
selftests-vm-anon_cow-add-mprotect-optimization-tests.patch
selftests-vm-anon_cow-prepare-for-non-anonymous-cow-tests.patch
selftests-vm-cow-basic-cow-tests-for-non-anonymous-pages.patch
selftests-vm-cow-r-o-long-term-pinning-reliability-tests-for-non-anon-pages.patch
mm-add-early-fault_flag_unshare-consistency-checks.patch
mm-add-early-fault_flag_write-consistency-checks.patch
mm-rework-handling-in-do_wp_page-based-on-private-vs-shared-mappings.patch
mm-dont-call-vm_ops-huge_fault-in-wp_huge_pmd-wp_huge_pud-for-private-mappings.patch
mm-extend-fault_flag_unshare-support-to-anything-in-a-cow-mapping.patch
mm-gup-reliable-r-o-long-term-pinning-in-cow-mappings.patch
rdma-umem-remove-foll_force-usage.patch
rdma-usnic-remove-foll_force-usage.patch
rdma-siw-remove-foll_force-usage.patch
media-videobuf-dma-sg-remove-foll_force-usage.patch
drm-etnaviv-remove-foll_force-usage.patch
media-pci-ivtv-remove-foll_force-usage.patch
mm-frame-vector-remove-foll_force-usage.patch
drm-exynos-remove-foll_force-usage.patch
rdma-hw-qib-qib_user_pages-remove-foll_force-usage.patch
habanalabs-remove-foll_force-usage.patch


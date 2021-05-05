Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85035C433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 00:55:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59FA3613CD
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 00:55:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhEEA4S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 20:56:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229586AbhEEA4R (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 20:56:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF313613CB;
        Wed,  5 May 2021 00:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620176122;
        bh=Vu0bzqcvlqKSP6WZkzrHRS2q/l3r2nzMPAx7ot2Glp0=;
        h=Date:From:To:Subject:From;
        b=zT2UXlFdQfCQmimUpoM2cz7yW/dfh50Y1g9X9hNN/Jh83/9fdrCaARhYQBYq8eVut
         ACzrMgwIxeo3KDFpZx77eCV63Q6EVyKpkHr4C6x6GLW7LBX3+C3vfpP+aqJwkP+Wg1
         Y+zxmLLgZE0fo0ZkKGrJI9QRpvmPXDEQk7DzBxGw=
Date:   Tue, 04 May 2021 17:55:21 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, axelrasmussen@google.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, rppt@linux.vnet.ibm.com
Subject:  [folded-merged]
 userfaultfd-add-minor-fault-registration-mode-fix.patch removed from -mm
 tree
Message-ID: <20210505005521.SYDfuHP4H%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/hugetlbfs: fix minor fault page leak
has been removed from the -mm tree.  Its filename was
     userfaultfd-add-minor-fault-registration-mode-fix.patch

This patch was dropped because it was folded into userfaultfd-add-minor-fault-registration-mode.patch

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: userfaultfd/hugetlbfs: fix minor fault page leak

When uffd-minor enabled, we need to put the page cache before handling the
userfault in hugetlb_no_page(), otherwise the page refcount got leaked.

This can be reproduced by running userfaultfd selftest with hugetlb_shared
mode, then cat /proc/meminfo.

Link: https://lkml.kernel.org/r/20210322175132.36659-1-peterx@redhat.com
Fixes: f2bf15fb0969 ("userfaultfd: add minor fault registration mode")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c~userfaultfd-add-minor-fault-registration-mode-fix
+++ a/mm/hugetlb.c
@@ -4609,6 +4609,7 @@ retry:
 		/* Check for page in userfault range. */
 		if (userfaultfd_minor(vma)) {
 			unlock_page(page);
+			put_page(page);
 			ret = hugetlb_handle_userfault(vma, mapping, idx,
 						       flags, haddr,
 						       VM_UFFD_MINOR);
_

Patches currently in -mm which might be from peterx@redhat.com are

hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share.patch
hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled.patch
mm-hugetlb-move-flush_hugetlb_tlb_range-into-hugetlbh.patch
hugetlb-userfaultfd-unshare-all-pmds-for-hugetlbfs-when-register-wp.patch
userfaultfd-add-minor-fault-registration-mode.patch
mm-hugetlb-fix-f_seal_future_write.patch
mm-hugetlb-fix-cow-where-page-writtable-in-child.patch


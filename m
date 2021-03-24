Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12328C433C1
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 23:34:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3869619DC
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 23:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbhCXXdY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Mar 2021 19:33:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235320AbhCXXcy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Mar 2021 19:32:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E099061A17;
        Wed, 24 Mar 2021 23:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616628774;
        bh=RhZ+4utZ9DjC0Vqr4Bwud302GqJW9w8q2GdCxWIcipM=;
        h=Date:From:To:Subject:From;
        b=R5X4TmOBuY60aqRxqVgNPZE+zyTyHBJuY7XP34Hl9h1Uknu7/bCCUbIfzBrEgInFt
         DhQFpHweH7dHTGOYBg+X3EJu8sdLU8lUq2ptBG8uHDV1mJ474wE2NSZy4deLz3kXNh
         OcTtew2FcvdR4U8ISdaetEDz2rWKN49DFvnvD3Bg=
Date:   Wed, 24 Mar 2021 16:32:53 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com,
        mike.kravetz@oracle.com, axelrasmussen@google.com,
        aarcange@redhat.com, peterx@redhat.com
Subject:  + userfaultfd-add-minor-fault-registration-mode-fix.patch
 added to -mm tree
Message-ID: <20210324233253.vC-7i%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/hugetlbfs: fix minor fault page leak
has been added to the -mm tree.  Its filename is
     userfaultfd-add-minor-fault-registration-mode-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-add-minor-fault-registration-mode-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-add-minor-fault-registration-mode-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -4565,6 +4565,7 @@ retry:
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
hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share-fix.patch
hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled.patch
hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled-fix.patch
mm-hugetlb-move-flush_hugetlb_tlb_range-into-hugetlbh.patch
hugetlb-userfaultfd-unshare-all-pmds-for-hugetlbfs-when-register-wp.patch
userfaultfd-add-minor-fault-registration-mode-fix.patch
userfaultfd-selftests-use-user-mode-only.patch
userfaultfd-selftests-remove-the-time-check-on-delayed-uffd.patch
userfaultfd-selftests-dropping-verify-check-in-locking_thread.patch
userfaultfd-selftests-only-dump-counts-if-mode-enabled.patch
userfaultfd-selftests-unify-error-handling.patch


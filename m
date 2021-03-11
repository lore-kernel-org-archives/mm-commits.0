Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CCA9C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 00:44:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 123A264FCA
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 00:44:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbhCKAoJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Mar 2021 19:44:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:53296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229599AbhCKAnh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Mar 2021 19:43:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4E3A64FC4;
        Thu, 11 Mar 2021 00:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615423417;
        bh=o5tOXYOjrTvZd0NSy3TdqCZnE2isFQwX+4g907uqcbg=;
        h=Date:From:To:Subject:From;
        b=OC3dlzTGhySpO8wABu92q/CX3OZxW6HAfKyq6qkuOUtk7z0N/zkR3jE2VJ8KVuPh1
         tEVKfdeVqnKoFsivGeg7ORRPnUF7wpD5gE1o1WshgfyUpJ+3MW/ecjDWim6zMdP+VX
         x69alcawiadm8KRvMMAtgrH7VuzVvLElVYG8oCfY=
Date:   Wed, 10 Mar 2021 16:43:36 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, axelrasmussen@google.com,
        mm-commits@vger.kernel.org, nadav.amit@gmail.com, peterx@redhat.com
Subject:  + userfaultfd-selftests-use-user-mode-only.patch added to
 -mm tree
Message-ID: <20210311004336.kziMRhUUS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/selftests: use user mode only
has been added to the -mm tree.  Its filename is
     userfaultfd-selftests-use-user-mode-only.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-selftests-use-user-mode-only.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-selftests-use-user-mode-only.patch

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
Subject: userfaultfd/selftests: use user mode only

Patch series "userfaultfd/selftests: A few cleanups".

I wanted to cleanup userfaultfd.c fault handling for a long time.  If it's
not cleaned, when the new code grows the file it'll also grow the size
that needs to be cleaned...  This is my attempt to cleanup the userfaultfd
selftest on fault handling, to use an err() macro instead of either
fprintf() or perror() then another exit() call.

The huge cleanup is done in the last patch.  The first 4 patches are some
other standalone cleanups for the same file, so I put them together.


This patch (of 5):

Userfaultfd selftest does not need to handle kernel initiated fault.  Set
user mode so it can be run even if unprivileged_userfaultfd=0 (which is
the default).

Link: https://lkml.kernel.org/r/20210310004511.51996-2-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-use-user-mode-only
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -381,7 +381,7 @@ static int userfaultfd_open(uint64_t *fe
 {
 	struct uffdio_api uffdio_api;
 
-	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
+	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK | UFFD_USER_MODE_ONLY);
 	if (uffd < 0) {
 		fprintf(stderr,
 			"userfaultfd syscall not available in this kernel\n");
_

Patches currently in -mm which might be from peterx@redhat.com are

hugetlb-dedup-the-code-to-add-a-new-file_region.patch
hugetlg-break-earlier-in-add_reservation_in_range-when-we-can.patch
mm-introduce-page_needs_cow_for_dma-for-deciding-whether-cow.patch
mm-use-is_cow_mapping-across-tree-where-proper.patch
hugetlb-do-early-cow-when-page-pinned-on-src-mm.patch
hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share.patch
hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share-fix.patch
hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled.patch
hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled-fix.patch
mm-hugetlb-move-flush_hugetlb_tlb_range-into-hugetlbh.patch
hugetlb-userfaultfd-unshare-all-pmds-for-hugetlbfs-when-register-wp.patch
userfaultfd-selftests-use-user-mode-only.patch
userfaultfd-selftests-remove-the-time-check-on-delayed-uffd.patch
userfaultfd-selftests-dropping-verify-check-in-locking_thread.patch
userfaultfd-selftests-only-dump-counts-if-mode-enabled.patch
userfaultfd-selftests-unify-error-handling.patch


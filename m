Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49ED3C433B4
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 05:07:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A0C261184
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 05:07:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233287AbhDIFHW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 01:07:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233267AbhDIFHJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 01:07:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AC21610A2;
        Fri,  9 Apr 2021 05:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617944817;
        bh=/t+nzGVny+gkbNBS/aq8/pBxxRrmEpBcVk2ChdTSZ4g=;
        h=Date:From:To:Subject:From;
        b=yuwWH160FWh8f2GpBJVjiOL+WBR53x70jgrHvTpzpuz+ACStNYEubuKKhD3CsiDw5
         PvZHJ+1wi1bwN87zuCLnHqO2IjLfTkGQE9gopI0Y0weyKFPrvn49mt34ah7CNd4O19
         8h+RoEPwvrgz2xxkYnq6dk1hkgNcpAtMQ45fh9XI=
Date:   Thu, 08 Apr 2021 22:06:56 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, axelrasmussen@google.com,
        mm-commits@vger.kernel.org, nadav.amit@gmail.com, peterx@redhat.com
Subject:  [to-be-updated]
 userfaultfd-selftests-use-user-mode-only.patch removed from -mm tree
Message-ID: <20210409050656.yeloqp8Bv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/selftests: use user mode only
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftests-use-user-mode-only.patch

This patch was dropped because an updated version will be merged

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

hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share.patch
hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share-fix.patch
hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled.patch
hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled-fix.patch
mm-hugetlb-move-flush_hugetlb_tlb_range-into-hugetlbh.patch
hugetlb-userfaultfd-unshare-all-pmds-for-hugetlbfs-when-register-wp.patch
userfaultfd-add-minor-fault-registration-mode-fix.patch
userfaultfd-selftests-remove-the-time-check-on-delayed-uffd.patch
userfaultfd-selftests-dropping-verify-check-in-locking_thread.patch
userfaultfd-selftests-only-dump-counts-if-mode-enabled.patch
userfaultfd-selftests-unify-error-handling.patch


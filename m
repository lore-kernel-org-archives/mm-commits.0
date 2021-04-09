Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF6FC433B4
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 02:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13E29610C9
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 02:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbhDICi0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 8 Apr 2021 22:38:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232616AbhDICiZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 8 Apr 2021 22:38:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54F5261074;
        Fri,  9 Apr 2021 02:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617935892;
        bh=ZVc/pGf3zuUmoADLTkARUQbmxgE+OThZb27oA4waawo=;
        h=Date:From:To:Subject:From;
        b=U/ytBAFbKrILbxkessjzQYG6NTdvLzlXzxXKWm5As9sGAHrvoQrN6wSg2+GcBeqnp
         zuiDaWPGXFrGYum55QHI6pfk8hNDTSusvhT6ssYSjDDOAI1Dzawry7MTlGDyGebVzJ
         d1TEupD3kESpE7HZxC5Zb6sVBNwDgXnoqetT9nRk=
Date:   Thu, 08 Apr 2021 19:38:11 -0700
From:   akpm@linux-foundation.org
To:     axelrasmussen@google.com, mm-commits@vger.kernel.org,
        peterx@redhat.com
Subject:  [folded-merged]
 userfaultfd-support-minor-fault-handling-for-shmem-fix-2.patch removed from
 -mm tree
Message-ID: <20210409023811.ZGLtHc7Gh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/shmem: fix minor fault page leak
has been removed from the -mm tree.  Its filename was
     userfaultfd-support-minor-fault-handling-for-shmem-fix-2.patch

This patch was dropped because it was folded into userfaultfd-support-minor-fault-handling-for-shmem.patch

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd/shmem: fix minor fault page leak

This fix is analogous to Peter Xu's fix for hugetlb [0].  If we don't
put_page() after getting the page out of the page cache, we leak the
reference.

The fix can be verified by checking /proc/meminfo and running the
userfaultfd selftest in shmem mode.  Without the fix, we see MemFree /
MemAvailable steadily decreasing with each run of the test.  With the fix,
memory is correctly freed after the test program exits.

Link: https://lkml.kernel.org/r/20210322204836.1650221-1-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/shmem.c~userfaultfd-support-minor-fault-handling-for-shmem-fix-2
+++ a/mm/shmem.c
@@ -1831,6 +1831,7 @@ repeat:
 
 	if (page && vma && userfaultfd_minor(vma)) {
 		unlock_page(page);
+		put_page(page);
 		*fault_type = handle_userfault(vmf, VM_UFFD_MINOR);
 		return 0;
 	}
_

Patches currently in -mm which might be from axelrasmussen@google.com are

userfaultfd-add-minor-fault-registration-mode.patch
userfaultfd-disable-huge-pmd-sharing-for-minor-registered-vmas.patch
userfaultfd-hugetlbfs-only-compile-uffd-helpers-if-config-enabled.patch
userfaultfd-add-uffdio_continue-ioctl.patch
userfaultfd-update-documentation-to-describe-minor-fault-handling.patch
userfaultfd-selftests-add-test-exercising-minor-fault-handling.patch
userfaultfd-support-minor-fault-handling-for-shmem.patch
userfaultfd-support-minor-fault-handling-for-shmem-fix-3.patch
userfaultfd-support-minor-fault-handling-for-shmem-fix-4.patch
userfaultfd-selftests-use-memfd_create-for-shmem-test-type.patch
userfaultfd-selftests-create-alias-mappings-in-the-shmem-test.patch
userfaultfd-selftests-reinitialize-test-context-in-each-test.patch
userfaultfd-selftests-exercise-minor-fault-handling-shmem-support.patch


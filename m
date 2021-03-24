Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08D76C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 23:21:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BACE361A1E
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 23:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233977AbhCXXUl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Mar 2021 19:20:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229670AbhCXXUi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Mar 2021 19:20:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84E1261A0F;
        Wed, 24 Mar 2021 23:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616628038;
        bh=/VYsOELOGmcJSLECsWjzh6UA4dOnyD6GYhxrP/RFnwc=;
        h=Date:From:To:Subject:From;
        b=tzUEmzKPsAWSCu9qYIJ65fpBqbuMdDoFxY+1goEpVYyCaDJbIy3YF/k5TGpJcCZRh
         g2XbEOtyCzrpwoLN7c+h3PF2Ji5NWZHvB66r2u5o3mXg5yRl9zlto+bKamiL+F65tS
         ArEIeexWLEPZHt9EGfmUIztn0H90wY6yHsiaUJk4=
Date:   Wed, 24 Mar 2021 16:20:38 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        axelrasmussen@google.com
Subject:  +
 userfaultfd-support-minor-fault-handling-for-shmem-fix-2.patch added to -mm
 tree
Message-ID: <20210324232038.4V15z%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/shmem: fix minor fault page leak
has been added to the -mm tree.  Its filename is
     userfaultfd-support-minor-fault-handling-for-shmem-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-support-minor-fault-handling-for-shmem-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-support-minor-fault-handling-for-shmem-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Fixes: 00da60b9d0a0 ("userfaultfd: support minor fault handling for shmem")
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
userfaultfd-support-minor-fault-handling-for-shmem-fix.patch
userfaultfd-support-minor-fault-handling-for-shmem-fix-2.patch
userfaultfd-selftests-use-memfd_create-for-shmem-test-type.patch
userfaultfd-selftests-create-alias-mappings-in-the-shmem-test.patch
userfaultfd-selftests-reinitialize-test-context-in-each-test.patch
userfaultfd-selftests-exercise-minor-fault-handling-shmem-support.patch


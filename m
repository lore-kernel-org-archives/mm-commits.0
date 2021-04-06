Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91524C433ED
	for <mm-commits@archiver.kernel.org>; Tue,  6 Apr 2021 02:16:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C278613AF
	for <mm-commits@archiver.kernel.org>; Tue,  6 Apr 2021 02:16:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238891AbhDFCRD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Apr 2021 22:17:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232976AbhDFCRB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 5 Apr 2021 22:17:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA40D6135D;
        Tue,  6 Apr 2021 02:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617675414;
        bh=Dr4CJs4vBAErIzMkty7aURw9pfhiBm69G06RIFFIp/s=;
        h=Date:From:To:Subject:From;
        b=Jrn0QGq9avIrpFXSGOTs3i3kCIIv1kfU3Ml2EirOPcFHDuDcDoQY4pkkvGx74MMEc
         FoT/3T9D2/NO3ZlhNsa83UBNMIK1GDPAlNLJrVuFpGCFXOLGpMNr3tkVSNbxSviRoc
         o29SzRoq/JJZqfqe0oQ+x6Zm1a7NbNPcquu9g8b0=
Date:   Mon, 05 Apr 2021 19:16:54 -0700
From:   akpm@linux-foundation.org
To:     axelrasmussen@google.com, mm-commits@vger.kernel.org
Subject:  +
 userfaultfd-support-minor-fault-handling-for-shmem-fix-4.patch added to -mm
 tree
Message-ID: <20210406021654.LeLZqyBPM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/shmem: fix MCOPY_ATOMIC_CONTINUE behavior
has been added to the -mm tree.  Its filename is
     userfaultfd-support-minor-fault-handling-for-shmem-fix-4.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-support-minor-fault-handling-for-shmem-fix-4.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-support-minor-fault-handling-for-shmem-fix-4.patch

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
Subject: userfaultfd/shmem: fix MCOPY_ATOMIC_CONTINUE behavior

- Added back the userfaultfd.c selftest changes from v3; this file was
  mistakenly reverted in v4.

Link: https://lkml.kernel.org/r/20210405171917.2423068-1-axelrasmussen@google.com
Fixes: 00da60b9d0a0 ("userfaultfd: support minor fault handling for shmem")
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-support-minor-fault-handling-for-shmem-fix-4
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -368,11 +368,24 @@ static void wp_range(int ufd, __u64 star
 			(uint64_t)start);
 		exit(1);
 	}
+
+	/*
+	 * Error handling within the kernel for continue is subtly different
+	 * from copy or zeropage, so it may be a source of bugs. Trigger an
+	 * error (-EEXIST) on purpose, to verify doing so doesn't cause a BUG.
+	 */
+	req.mapped = 0;
+	ret = ioctl(ufd, UFFDIO_CONTINUE, &req);
+	if (ret >= 0 || req.mapped != -EEXIST) {
+		fprintf(stderr, "failed to exercise UFFDIO_CONTINUE error handling, ret=%d, mapped=%" PRId64, ret, req.mapped);
+		exit(1);
+	}
 }
 
 static void continue_range(int ufd, __u64 start, __u64 len)
 {
 	struct uffdio_continue req;
+	int ret;
 
 	req.range.start = start;
 	req.range.len = len;
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
userfaultfd-support-minor-fault-handling-for-shmem-fix-3.patch
userfaultfd-support-minor-fault-handling-for-shmem-fix-4.patch
userfaultfd-selftests-use-memfd_create-for-shmem-test-type.patch
userfaultfd-selftests-create-alias-mappings-in-the-shmem-test.patch
userfaultfd-selftests-reinitialize-test-context-in-each-test.patch
userfaultfd-selftests-exercise-minor-fault-handling-shmem-support.patch


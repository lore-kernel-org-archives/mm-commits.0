Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42801C433ED
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 02:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CA39610F7
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 02:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbhDICid (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 8 Apr 2021 22:38:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232673AbhDICid (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 8 Apr 2021 22:38:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DCF6610C8;
        Fri,  9 Apr 2021 02:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617935901;
        bh=E9RdX88qp1e//EzeL2zreRrk5rBPGtTutmuK54HrGRA=;
        h=Date:From:To:Subject:From;
        b=nCrab16wYW3EnHLaA2ic4Qei4nrGMLQO+FLylVokA9/epP3O6akQkJ+4wzRkewi4e
         SaPC9vIDElqI+EH4dGMuTwPRN4sicfb+ks2T4SZN4yMovjm86WJ/GyaLDyVfbBAyVd
         p5cweSjLfjevou2hNhGySXPOiLVU3WHNSsQXkdk4=
Date:   Thu, 08 Apr 2021 19:38:20 -0700
From:   akpm@linux-foundation.org
To:     axelrasmussen@google.com, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 userfaultfd-support-minor-fault-handling-for-shmem-fix-4.patch removed from
 -mm tree
Message-ID: <20210409023820.Fm15tuZD2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/shmem: fix MCOPY_ATOMIC_CONTINUE behavior
has been removed from the -mm tree.  Its filename was
     userfaultfd-support-minor-fault-handling-for-shmem-fix-4.patch

This patch was dropped because it was folded into userfaultfd-support-minor-fault-handling-for-shmem.patch

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
userfaultfd-selftests-use-memfd_create-for-shmem-test-type.patch
userfaultfd-selftests-create-alias-mappings-in-the-shmem-test.patch
userfaultfd-selftests-reinitialize-test-context-in-each-test.patch
userfaultfd-selftests-exercise-minor-fault-handling-shmem-support.patch


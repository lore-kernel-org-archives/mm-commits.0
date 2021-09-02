Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AAA2C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:59:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 348F660F12
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347550AbhIBWAD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:00:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347967AbhIBWAC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 18:00:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41B87603E9;
        Thu,  2 Sep 2021 21:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619943;
        bh=VsM0YmMB7tBgJsXGLa90MLXy0gYiz+CmbmrClc9gyxg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xlbUXam8oInqnG0eePxXZBNi9Pi15H12txGVj2zBUwdE/fCVURMIEleMOwohgDSri
         pNIdZabpEas+PRpGUmExa/+ht+0uRi+2B2dMXrgWrD7JaSkGOyxmra0Ghg4JJRIAa3
         O/IDw2MwcK3sDBw85Y0ErfSRFWkvV4dLlj1krqYM=
Date:   Thu, 02 Sep 2021 14:59:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org, axboe@kernel.dk,
        axelrasmussen@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, namit@vmware.com, peterx@redhat.com,
        rppt@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 172/212] selftests/vm/userfaultfd: wake after copy
 failure
Message-ID: <20210902215902.iKGAE35zB%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Nadav Amit <namit@vmware.com>
Subject: selftests/vm/userfaultfd: wake after copy failure

When userfaultfd copy-ioctl fails since the PTE already exists, an -EEXIST
error is returned and the faulting thread is not woken.  The current
userfaultfd test does not wake the faulting thread in such case.  The
assumption is presumably that another thread set the PTE through copy/wp
ioctl and would wake the faulting thread or that alternatively the fault
handler would realize there is no need to "must_wait" and continue.  This
is not necessarily true.

There is an assumption that the "must_wait" tests in handle_userfault()
are sufficient to provide definitive answer whether the offending PTE is
populated or not.  However, userfaultfd_must_wait() test is lockless. 
Consequently, concurrent calls to ptep_modify_prot_start(), for instance,
can clear the PTE and can cause userfaultfd_must_wait() to wrongly assume
it is not populated and a wait is needed.

There are therefore 3 options:
(1) Change the tests to wake on copy failure.
(2) Wake faulting thread unconditionally on zero/copy ioctls before
    returning -EEXIST.
(3) Change the userfaultfd_must_wait() to hold locks.

This patch took the first approach, but the others are valid solutions
with different tradeoffs.

Link: https://lkml.kernel.org/r/20210808020724.1022515-4-namit@vmware.com
Signed-off-by: Nadav Amit <namit@vmware.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/tools/testing/selftests/vm/userfaultfd.c~selftests-vm-userfaultfd-wake-after-copy-failure
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -566,6 +566,18 @@ static void retry_copy_page(int ufd, str
 	}
 }
 
+static void wake_range(int ufd, unsigned long addr, unsigned long len)
+{
+	struct uffdio_range uffdio_wake;
+
+	uffdio_wake.start = addr;
+	uffdio_wake.len = len;
+
+	if (ioctl(ufd, UFFDIO_WAKE, &uffdio_wake))
+		fprintf(stderr, "error waking %lu\n",
+			addr), exit(1);
+}
+
 static int __copy_page(int ufd, unsigned long offset, bool retry)
 {
 	struct uffdio_copy uffdio_copy;
@@ -585,6 +597,7 @@ static int __copy_page(int ufd, unsigned
 		if (uffdio_copy.copy != -EEXIST)
 			err("UFFDIO_COPY error: %"PRId64,
 			    (int64_t)uffdio_copy.copy);
+		wake_range(ufd, uffdio_copy.dst, page_size);
 	} else if (uffdio_copy.copy != page_size) {
 		err("UFFDIO_COPY error: %"PRId64, (int64_t)uffdio_copy.copy);
 	} else {
_

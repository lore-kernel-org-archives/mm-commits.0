Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F29CC4320A
	for <mm-commits@archiver.kernel.org>; Mon,  9 Aug 2021 19:26:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4290C60C51
	for <mm-commits@archiver.kernel.org>; Mon,  9 Aug 2021 19:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbhHIT0t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Aug 2021 15:26:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236016AbhHIT0n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 9 Aug 2021 15:26:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95CF560D07;
        Mon,  9 Aug 2021 19:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628537182;
        bh=0rMZ2ksfs4cOsFNKd9DC5P9yjHm9ju0gcFLQaEFlFoI=;
        h=Date:From:To:Subject:From;
        b=Lg3LewClQQQLW+iS7Jr5B/J+ULy6NJLcWrnaZtDxEMbrw9PIj6QRoyC19wWPiGhbD
         erDQR8hG8QhkwDUTO24aMVSmlH5WqHj5Oq7YtZuveilxyX/9T/F0PQZiRdY5TvecDl
         AWPIZB9XJ+ukwIyA1r73QWoJRcFKCiRLdPTfYs04=
Date:   Mon, 09 Aug 2021 12:26:22 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, xemul@parallels.com,
        viro@zeniv.linux.org.uk, rppt@linux.vnet.ibm.com,
        peterx@redhat.com, axelrasmussen@google.com, axboe@kernel.dk,
        aarcange@redhat.com, namit@vmware.com
Subject:  + selftests-vm-userfaultfd-wake-after-copy-failure.patch
 added to -mm tree
Message-ID: <20210809192622.FkSip%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm/userfaultfd: wake after copy failure
has been added to the -mm tree.  Its filename is
     selftests-vm-userfaultfd-wake-after-copy-failure.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-userfaultfd-wake-after-copy-failure.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-userfaultfd-wake-after-copy-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Pavel Emelyanov <xemul@parallels.com>
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

Patches currently in -mm which might be from namit@vmware.com are

userfaultfd-change-mmap_changing-to-atomic.patch
userfaultfd-prevent-concurrent-api-initialization.patch
selftests-vm-userfaultfd-wake-after-copy-failure.patch


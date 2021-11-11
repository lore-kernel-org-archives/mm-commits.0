Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C968CC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:47:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B76A561260
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:47:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbhKKCt4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:49:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:54528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234393AbhKKCtx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:49:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F6A261108;
        Thu, 11 Nov 2021 02:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598825;
        bh=l451VpBBzJ8oEnq4mFlUayhdY699kXNfNwaaNmcX9Ys=;
        h=Date:From:To:Subject:From;
        b=ocb4pKUUVpt4QEx5XGd5an7RsSMVV1IdxuijseJlG10tA9ejeTMUk5glNem1vOQFj
         tgiX8SQDDyEGf/Zn3qPgwhNRKdbWP2ervZIMtLypVSKqBu1+QjM8sh43w6R+SNcynX
         aMSOEbijSu07Zk0rrRX3OQ2172Gn7EyddWeNOzQ8=
Date:   Wed, 10 Nov 2021 18:47:05 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org,
        skhan@linuxfoundation.org
Subject:  [merged]
 selftests-vm-make-madv_populate_readwrite-use-in-tree-headers.patch removed
 from -mm tree
Message-ID: <20211111024705.ah6p9ihPJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: make MADV_POPULATE_(READ|WRITE) use in-tree headers
has been removed from the -mm tree.  Its filename was
     selftests-vm-make-madv_populate_readwrite-use-in-tree-headers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: selftests/vm: make MADV_POPULATE_(READ|WRITE) use in-tree headers

The madv_populate selftest currently builds with a warning when the local
installed headers (via the distribution) don't include MADV_POPULATE_READ
and MADV_POPULATE_WRITE.  The warning is correct, because the test cannot
locate the necessary header.

Reason is that the in-tree installed headers (usr/include) have a "linux"
instead of a "sys" subdirectory.

Including "linux/mman.h" instead of "sys/mman.h" doesn't work (e.g.,
mmap() and madvise() are not defined that way).  The only thing that seems
to work is including "linux/mman.h" in addition to "sys/mman.h".

We can get rid of our availability check and simplify.

Link: https://lkml.kernel.org/r/20211015165758.41374-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/madv_populate.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

--- a/tools/testing/selftests/vm/madv_populate.c~selftests-vm-make-madv_populate_readwrite-use-in-tree-headers
+++ a/tools/testing/selftests/vm/madv_populate.c
@@ -14,12 +14,11 @@
 #include <unistd.h>
 #include <errno.h>
 #include <fcntl.h>
+#include <linux/mman.h>
 #include <sys/mman.h>
 
 #include "../kselftest.h"
 
-#if defined(MADV_POPULATE_READ) && defined(MADV_POPULATE_WRITE)
-
 /*
  * For now, we're using 2 MiB of private anonymous memory for all tests.
  */
@@ -328,15 +327,3 @@ int main(int argc, char **argv)
 				   err, ksft_test_num());
 	return ksft_exit_pass();
 }
-
-#else /* defined(MADV_POPULATE_READ) && defined(MADV_POPULATE_WRITE) */
-
-#warning "missing MADV_POPULATE_READ or MADV_POPULATE_WRITE definition"
-
-int main(int argc, char **argv)
-{
-	ksft_print_header();
-	ksft_exit_skip("MADV_POPULATE_READ or MADV_POPULATE_WRITE not defined\n");
-}
-
-#endif /* defined(MADV_POPULATE_READ) && defined(MADV_POPULATE_WRITE) */
_

Patches currently in -mm which might be from david@redhat.com are



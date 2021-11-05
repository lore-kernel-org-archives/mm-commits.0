Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C39B1C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:44:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD9D56126A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:44:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbhKEUqq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:46:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233055AbhKEUqq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:46:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6EAA61288;
        Fri,  5 Nov 2021 20:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145046;
        bh=t6FLKMCloq5z7jo7GCHVsIdIemkBh7Nvclx1jJpApUw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=mvM7+VObqP9KaUxOW7ULUSXaABczcqrJOHgLo8J2kFTGbYHDlwDZMu4FrrI2eW4iT
         3kp6RkQX/0ro2saed6RI4FCk62RLMXKqih1IKdhdCcY24mEApsZXWQlyEuY0UIivfc
         c4zDutDS1etYvZc27yp8ZNRfWelrWIFsvj6c9P64=
Date:   Fri, 05 Nov 2021 13:44:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        torvalds@linux-foundation.org
Subject:  [patch 181/262] selftests/vm: make
 MADV_POPULATE_(READ|WRITE) use in-tree headers
Message-ID: <20211105204405.ezVAWOhIi%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

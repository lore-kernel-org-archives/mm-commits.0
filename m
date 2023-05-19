Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEC9AC77B7A
	for <mm-commits@archiver.kernel.org>; Fri, 19 May 2023 21:45:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjESVpH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 May 2023 17:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjESVpC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 May 2023 17:45:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DFA99
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 14:45:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98E36615D2
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 21:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EBEC433D2;
        Fri, 19 May 2023 21:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684532700;
        bh=QyZ/W8mFg9jtrYoG26g0ldCeytMfg9tMlqd4Hw1Oxnc=;
        h=Date:To:From:Subject:From;
        b=OfCg35USHfdV3WqK04FQs8l5UD08SH5YJwqp/BD84g19oYm4y8AYw7YPnMck3NSue
         n3BLlKQ46iz+lpKiXKUL54aGRh9IpcQt17SgQoMOORHku0126n8H4AyLkLE/wpC9Nv
         hTzzai/xpyRVc9A/goOxwJgAItvrmCSAB5LFmw/g=
Date:   Fri, 19 May 2023 14:44:59 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, peterx@redhat.com,
        lstoakes@gmail.com, jhubbard@nvidia.com, jgg@nvidia.com,
        jack@suse.cz, axboe@kernel.dk, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-gup_longterm-add-liburing-tests.patch added to mm-unstable branch
Message-Id: <20230519214459.F1EBEC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: gup_longterm: add liburing tests
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-gup_longterm-add-liburing-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-gup_longterm-add-liburing-tests.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: selftests/mm: gup_longterm: add liburing tests
Date: Fri, 19 May 2023 12:27:23 +0200

Similar to the COW selftests, also use io_uring fixed buffers to test if
long-term page pinning works as expected.

Link: https://lkml.kernel.org/r/20230519102723.185721-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/gup_longterm.c |   73 ++++++++++++++++++++
 1 file changed, 73 insertions(+)

--- a/tools/testing/selftests/mm/gup_longterm.c~selftests-mm-gup_longterm-add-liburing-tests
+++ a/tools/testing/selftests/mm/gup_longterm.c
@@ -22,6 +22,9 @@
 #include <linux/memfd.h>
 
 #include "local_config.h"
+#ifdef LOCAL_CONFIG_HAVE_LIBURING
+#include <liburing.h>
+#endif /* LOCAL_CONFIG_HAVE_LIBURING */
 
 #include "../../../../mm/gup_test.h"
 #include "../kselftest.h"
@@ -80,6 +83,9 @@ enum test_type {
 	TEST_TYPE_RO_FAST,
 	TEST_TYPE_RW,
 	TEST_TYPE_RW_FAST,
+#ifdef LOCAL_CONFIG_HAVE_LIBURING
+	TEST_TYPE_IOURING,
+#endif /* LOCAL_CONFIG_HAVE_LIBURING */
 };
 
 static void do_test(int fd, size_t size, enum test_type type, bool shared)
@@ -173,6 +179,51 @@ static void do_test(int fd, size_t size,
 		ksft_test_result(should_work, "Should have worked\n");
 		break;
 	}
+#ifdef LOCAL_CONFIG_HAVE_LIBURING
+	case TEST_TYPE_IOURING: {
+		struct io_uring ring;
+		struct iovec iov;
+
+		/* io_uring always pins pages writable. */
+		if (shared && fs_is_unknown(fs_type)) {
+			ksft_test_result_skip("Unknown filesystem\n");
+			return;
+		}
+		should_work = !shared ||
+			      fs_supports_writable_longterm_pinning(fs_type);
+
+		/* Skip on errors, as we might just lack kernel support. */
+		ret = io_uring_queue_init(1, &ring, 0);
+		if (ret < 0) {
+			ksft_test_result_skip("io_uring_queue_init() failed\n");
+			break;
+		}
+		/*
+		 * Register the range as a fixed buffer. This will FOLL_WRITE |
+		 * FOLL_PIN | FOLL_LONGTERM the range.
+		 */
+		iov.iov_base = mem;
+		iov.iov_len = size;
+		ret = io_uring_register_buffers(&ring, &iov, 1);
+		/* Only new kernels return EFAULT. */
+		if (ret && (errno == ENOSPC || errno == EOPNOTSUPP ||
+			    errno == EFAULT)) {
+			ksft_test_result(!should_work, "Should have failed\n");
+		} else if (ret) {
+			/*
+			 * We might just lack support or have insufficient
+			 * MEMLOCK limits.
+			 */
+			ksft_test_result_skip("io_uring_register_buffers() failed\n");
+		} else {
+			ksft_test_result(should_work, "Should have worked\n");
+			io_uring_unregister_buffers(&ring);
+		}
+
+		io_uring_queue_exit(&ring);
+		break;
+	}
+#endif /* LOCAL_CONFIG_HAVE_LIBURING */
 	default:
 		assert(false);
 	}
@@ -310,6 +361,18 @@ static void test_private_ro_fast_pin(int
 	do_test(fd, size, TEST_TYPE_RO_FAST, false);
 }
 
+#ifdef LOCAL_CONFIG_HAVE_LIBURING
+static void test_shared_iouring(int fd, size_t size)
+{
+	do_test(fd, size, TEST_TYPE_IOURING, true);
+}
+
+static void test_private_iouring(int fd, size_t size)
+{
+	do_test(fd, size, TEST_TYPE_IOURING, false);
+}
+#endif /* LOCAL_CONFIG_HAVE_LIBURING */
+
 static const struct test_case test_cases[] = {
 	{
 		"R/W longterm GUP pin in MAP_SHARED file mapping",
@@ -343,6 +406,16 @@ static const struct test_case test_cases
 		"R/O longterm GUP-fast pin in MAP_PRIVATE file mapping",
 		test_private_ro_fast_pin,
 	},
+#ifdef LOCAL_CONFIG_HAVE_LIBURING
+	{
+		"io_uring fixed buffer with MAP_SHARED file mapping",
+		test_shared_iouring,
+	},
+	{
+		"io_uring fixed buffer with MAP_PRIVATE file mapping",
+		test_private_iouring,
+	},
+#endif /* LOCAL_CONFIG_HAVE_LIBURING */
 };
 
 static void run_test_case(struct test_case const *test_case)
_

Patches currently in -mm which might be from david@redhat.com are

selftests-mm-factor-out-detection-of-hugetlb-page-sizes-into-vm_util.patch
selftests-mm-gup_longterm-new-functional-test-for-foll_longterm.patch
selftests-mm-gup_longterm-add-liburing-tests.patch


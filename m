Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46DDAC7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbjFIXbk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232799AbjFIXbA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3C444A3
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41B5C63EB7
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964ABC433EF;
        Fri,  9 Jun 2023 23:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353340;
        bh=sLpXzmv1oziuKZQSficDqkp9XntXLZ2gm3J2xsM+y+k=;
        h=Date:To:From:Subject:From;
        b=a2XhU7J+RIe8GLOOSeCONouQdaySghLYxpK7bUgWwOBatYsAyW5aHHbOf4qEfU7nO
         Y+72NR1x+YVx3X+gtnGc+1qcKonXKUsG1VEgMPYXyWshW0anZldBmfKROPUMVdqGQ/
         ndl9a5JkH6nKnhxCOYDSXs+t3cld45aWDeo0kKkw=
Date:   Fri, 09 Jun 2023 16:29:00 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, peterx@redhat.com,
        lstoakes@gmail.com, jhubbard@nvidia.com, jgg@nvidia.com,
        jack@suse.cz, axboe@kernel.dk, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-gup_longterm-add-liburing-tests.patch removed from -mm tree
Message-Id: <20230609232900.964ABC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: gup_longterm: add liburing tests
has been removed from the -mm tree.  Its filename was
     selftests-mm-gup_longterm-add-liburing-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: selftests/mm: gup_longterm: add liburing tests
Date: Fri, 19 May 2023 12:27:23 +0200

Similar to the COW selftests, also use io_uring fixed buffers to test if
long-term page pinning works as expected.

Link: https://lkml.kernel.org/r/20230519102723.185721-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: John Hubbard <jhubbard@nvidia.com>
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



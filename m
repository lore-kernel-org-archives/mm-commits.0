Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38E010A3E
	for <mm-commits@vger.kernel.org>; Tue, 28 May 2024 20:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716926902; cv=none; b=fPhzDeWt+9tGHMPG9f7ECM7yT6GJwkFIh8Gt9zaZ1uhNyQnMyvXj/+6Ml+OIZYrCD9kJby6AgLe57U1x0koPqOdVqodA7WRLjSqsKIv0o+Ptcn6NAZZv8IUGVfS+bdpCr2BEhhBA+e7YWabaySuEYF9cutUsgM4OX2Vi4eA/N48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716926902; c=relaxed/simple;
	bh=Ttt15ZXNpk2uiiQuXLZ99dvfuVu2NveBhLJkSWNWwM0=;
	h=Date:To:From:Subject:Message-Id; b=Mj8USgejlZ5xt96UvXiArLB+Mb8mvRTKZYnFhN/HS+jh0qgiT2eifgU18SlwIZQzC91nCR2DUYPg6vzQ5BGSP1jwzS88mqaCYhFYvLWD3VGxCzA+wCk/gQxnCeyAhpuXDx4YxxDq31/XVgeAoKqUolDk27x+2W8szR0jQiFU8BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0XiaidMK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0XiaidMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732A9C3277B;
	Tue, 28 May 2024 20:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716926901;
	bh=Ttt15ZXNpk2uiiQuXLZ99dvfuVu2NveBhLJkSWNWwM0=;
	h=Date:To:From:Subject:From;
	b=0XiaidMK+oIo4XiTKpRSn2FxOkNbVLmTscyFbprj+1XN4IKUBvH+TGurSaofAdJm2
	 dEakJ/ba6LVMC8qyQatQrBPqG8zCvnhg3CvMba7KqnQXnjmif3W2/CVSoZOmdv+9/c
	 zDR5t/oYbR0R4RaFVtU/bwMvr6PKx+Krd2yM3vP0=
Date: Tue, 28 May 2024 13:08:20 -0700
To: mm-commits@vger.kernel.org,keescook@chromium.org,glider@google.com,elver@google.com,dvyukov@google.com,bjohannesmeyer@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kmsan-introduce-test_unpoison_memory.patch added to mm-unstable branch
Message-Id: <20240528200821.732A9C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kmsan: introduce test_unpoison_memory()
has been added to the -mm mm-unstable branch.  Its filename is
     kmsan-introduce-test_unpoison_memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-introduce-test_unpoison_memory.patch

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
From: Brian Johannesmeyer <bjohannesmeyer@gmail.com>
Subject: kmsan: introduce test_unpoison_memory()
Date: Tue, 28 May 2024 12:48:07 +0200

Add a regression test to ensure that kmsan_unpoison_memory() works the
same as an unpoisoning operation added by the instrumentation.

The test has two subtests: one that checks the instrumentation, and one
that checks kmsan_unpoison_memory().  Each subtest initializes the first
byte of a 4-byte buffer, then checks that the other 3 bytes are
uninitialized.

[glider@google.com: change description, remove comment about failing test case]
Link: https://lkml.kernel.org/r/20240528104807.738758-2-glider@google.com
Signed-off-by: Brian Johannesmeyer <bjohannesmeyer@gmail.com>
Link: https://lore.kernel.org/lkml/20240524232804.1984355-1-bjohannesmeyer@gmail.com/T/
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/kmsan_test.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/mm/kmsan/kmsan_test.c~kmsan-introduce-test_unpoison_memory
+++ a/mm/kmsan/kmsan_test.c
@@ -614,6 +614,32 @@ static void test_stackdepot_roundtrip(st
 	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
 }
 
+/*
+ * Test case: ensure that kmsan_unpoison_memory() and the instrumentation work
+ * the same.
+ */
+static void test_unpoison_memory(struct kunit *test)
+{
+	EXPECTATION_UNINIT_VALUE_FN(expect, "test_unpoison_memory");
+	volatile char a[4], b[4];
+
+	kunit_info(
+		test,
+		"unpoisoning via the instrumentation vs. kmsan_unpoison_memory() (2 UMR reports)\n");
+
+	/* Initialize a[0] and check a[1]--a[3]. */
+	a[0] = 0;
+	kmsan_check_memory((char *)&a[1], 3);
+	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
+
+	report_reset();
+
+	/* Initialize b[0] and check b[1]--b[3]. */
+	kmsan_unpoison_memory((char *)&b[0], 1);
+	kmsan_check_memory((char *)&b[1], 3);
+	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
+}
+
 static struct kunit_case kmsan_test_cases[] = {
 	KUNIT_CASE(test_uninit_kmalloc),
 	KUNIT_CASE(test_init_kmalloc),
@@ -637,6 +663,7 @@ static struct kunit_case kmsan_test_case
 	KUNIT_CASE(test_memset64),
 	KUNIT_CASE(test_long_origin_chain),
 	KUNIT_CASE(test_stackdepot_roundtrip),
+	KUNIT_CASE(test_unpoison_memory),
 	{},
 };
 
_

Patches currently in -mm which might be from bjohannesmeyer@gmail.com are

kmsan-introduce-test_unpoison_memory.patch


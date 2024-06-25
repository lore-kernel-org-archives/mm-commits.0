Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BDF49635
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291620; cv=none; b=YTjTDjOcvLqqkH8MELgBjlK78iOeMCBFtarXlpkDl0AErdHbyW2w4kmPykR4R6GH90LHBFXXWXIOf32qvXACLoIZoGN/1niEIT7bjMJg0gObLR1KyiCh+2wLow17Pe4K5y9M0zo2FXbb2wGirSLUZP3AVBMMHRC7uJBiLPibTb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291620; c=relaxed/simple;
	bh=Ruu4X8zcdk4LYi84+/DCtIYkEk8kY1eoiPIOp/ybGXU=;
	h=Date:To:From:Subject:Message-Id; b=uWa3tQitZuejY/UUBUQldoNk1t60e/0MxPu8BSmSELxS0OQ6cJLpXCr9JF+PkxiaqTyKsJSXkw8mSt/Bo3QHksms0qHI+4jC8s4lfxdSIbWLSK3lm1bvZxiN9kGPrnbxBi2961XAbSDGTazfSzpjiPlX4WDChcvUOUFSn1sxuHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Si8OCeM7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Si8OCeM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B11C32782;
	Tue, 25 Jun 2024 05:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291620;
	bh=Ruu4X8zcdk4LYi84+/DCtIYkEk8kY1eoiPIOp/ybGXU=;
	h=Date:To:From:Subject:From;
	b=Si8OCeM7tgnGa+2CsRB0Mw3xGvGEt030E29E8Qcehk+pB8pHAgj26kxgFAApijwp2
	 n8Xopme2q9lqMxsVTCKNntH9xfgrkHxLCmpHExMliSMAyiedZ+QzOyiTk2r6duHySz
	 JckbBmVrD66rLGYK7VchbztDV8udqQObJBOVqi5Q=
Date: Mon, 24 Jun 2024 22:00:19 -0700
To: mm-commits@vger.kernel.org,keescook@chromium.org,glider@google.com,elver@google.com,dvyukov@google.com,bjohannesmeyer@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-introduce-test_unpoison_memory.patch removed from -mm tree
Message-Id: <20240625050020.18B11C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmsan: introduce test_unpoison_memory()
has been removed from the -mm tree.  Its filename was
     kmsan-introduce-test_unpoison_memory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA71A396D19
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 21:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779138881; cv=none; b=ggxShk1TUNb6PnLwehhnEWcO/FPdYeOpp1ux7nYGKStkCDEIWZRVJoJpy072+Kg+CLHHuUATYH/WrrTT7KXoHI3eWwektqYje6dVZpat9egnH/T+ZDApOrHz9aDQPclIyowrDbr1nQetvUtJwOUTWxwBmg8zdrRPcnLYic93XdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779138881; c=relaxed/simple;
	bh=uQ2KSU3QgPPxLw38ijziiNo7rhCRXRiaZqpJKMa13YE=;
	h=Date:To:From:Subject:Message-Id; b=YMWbeyGUEChD49iLMFh/yy/bs13y4e/opXIapv20WUTNfqjD1xRZlKeZCfumFXcG3AIK0bWzdF3pxSRQnP/isxOz7e0c4+tT1672UeUk7h8Ki/uXmvXBCz+01Sg0QAd3FQL7bbTVpQGzbBumWFWGf0f/FxXKyI9HF/2Q/Ca2chw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dzUbvnHb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dzUbvnHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492B8C2BCB7;
	Mon, 18 May 2026 21:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779138881;
	bh=uQ2KSU3QgPPxLw38ijziiNo7rhCRXRiaZqpJKMa13YE=;
	h=Date:To:From:Subject:From;
	b=dzUbvnHbUONytfbRQsvcRseKtc1O9IIHiiDOLR0tP1T93NShBXglhF59mRrVUb3zJ
	 pBHvwwjxJRcrho0vrsXkS/FerMFGZSTFG8HsZ6rse3CDT0UnMRT6LQBmxZ8LA38yDT
	 O/tBHqkNWgtmmkk45rx2ciQF/ZYjqEKnZyjW0W2U=
Date: Mon, 18 May 2026 14:14:40 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + raid6_kunit-randomize-parameters-and-increase-limits.patch added to mm-nonmm-unstable branch
Message-Id: <20260518211441.492B8C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: raid6_kunit: randomize parameters and increase limits
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     raid6_kunit-randomize-parameters-and-increase-limits.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/raid6_kunit-randomize-parameters-and-increase-limits.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: raid6_kunit: randomize parameters and increase limits
Date: Mon, 18 May 2026 07:18:00 +0200

The current test has double-quadratic behavior in the selection for the
updated ("XORed") disks, and in the selection of updated pointers, which
makes scaling it to more tests difficult.  At the same time it only ever
tests with the maximum number of disks, which leaves a coverage hole for
smaller ones.

Fix this by randomizing the total number, failed disks and regions to
update, and increasing the upper number of tests disks.

Link: https://lore.kernel.org/20260518051804.462141-18-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Ard Biesheuvel <ardb@kernel.org> # kunit only on arm64
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Li Nan <linan122@huawei.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Song Liu <song@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/raid/raid6/tests/raid6_kunit.c |  189 ++++++++++++++++++---------
 1 file changed, 131 insertions(+), 58 deletions(-)

--- a/lib/raid/raid6/tests/raid6_kunit.c~raid6_kunit-randomize-parameters-and-increase-limits
+++ a/lib/raid/raid6/tests/raid6_kunit.c
@@ -8,18 +8,21 @@
 #include <kunit/test.h>
 #include <linux/prandom.h>
 #include <linux/vmalloc.h>
+#include <linux/raid/pq.h>
 #include "../algos.h"
 
 MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
 
 #define RAID6_KUNIT_SEED		42
+#define RAID6_KUNIT_NUM_TEST_ITERS	10
+#define RAID6_KUNIT_MAX_BUFFERS		64 /* Including P and Q */
 #define RAID6_KUNIT_MAX_FAILURES	2
-
-#define NDISKS		16	/* Including P and Q */
+#define RAID6_KUNIT_MAX_BYTES		PAGE_SIZE
 
 static struct rnd_state rng;
-static void *test_buffers[NDISKS];
+static void *test_buffers[RAID6_KUNIT_MAX_BUFFERS];
 static void *test_recov_buffers[RAID6_KUNIT_MAX_FAILURES];
+static size_t test_buflen;
 
 struct test_args {
 	unsigned int recov_idx;
@@ -30,102 +33,171 @@ struct test_args {
 
 static struct test_args args;
 
+static u32 rand32(void)
+{
+	return prandom_u32_state(&rng);
+}
+
+/* Generate a random length that is a multiple of 512. */
+static unsigned int random_length(unsigned int max_length)
+{
+	return round_up((rand32() % max_length) + 1, 512);
+}
+
+static unsigned int random_nr_buffers(void)
+{
+	return (rand32() % (RAID6_KUNIT_MAX_BUFFERS - (RAID6_MIN_DISKS - 1))) +
+			RAID6_MIN_DISKS;
+}
+
 static void makedata(int start, int stop)
 {
 	int i;
 
 	for (i = start; i <= stop; i++)
-		prandom_bytes_state(&rng, test_buffers[i], PAGE_SIZE);
+		prandom_bytes_state(&rng, test_buffers[i], test_buflen);
 }
 
-static char member_type(int d)
+static char member_type(unsigned int nr_buffers, int d)
 {
-	switch (d) {
-	case NDISKS-2:
+	if (d == nr_buffers - 2)
 		return 'P';
-	case NDISKS-1:
+	if (d == nr_buffers - 1)
 		return 'Q';
-	default:
-		return 'D';
-	}
+	return 'D';
 }
 
-static void test_recover(struct kunit *test, int faila, int failb)
+static void test_recover_one(struct kunit *test, unsigned int nr_buffers,
+		unsigned int len, int faila, int failb)
 {
 	const struct test_args *ta = test->param_value;
-	void *dataptrs[NDISKS];
+	void *dataptrs[RAID6_KUNIT_MAX_BUFFERS];
 	int i;
 
+	if (faila > failb)
+		swap(faila, failb);
+
 	for (i = 0; i < RAID6_KUNIT_MAX_FAILURES; i++)
-		memset(test_recov_buffers[i], 0xf0, PAGE_SIZE);
+		memset(test_recov_buffers[i], 0xf0, test_buflen);
 
 	memcpy(dataptrs, test_buffers, sizeof(dataptrs));
 	dataptrs[faila] = test_recov_buffers[0];
 	dataptrs[failb] = test_recov_buffers[1];
 
-	if (failb == NDISKS - 1) {
+	if (failb == nr_buffers - 1) {
 		/*
 		 * We don't implement the data+Q failure scenario, since it
 		 * is equivalent to a RAID-5 failure (XOR, then recompute Q).
 		 */
-		if (faila != NDISKS - 2)
+		if (WARN_ON_ONCE(faila != nr_buffers - 2))
 			return;
 
 		/* P+Q failure.  Just rebuild the syndrome. */
-		ta->gen->gen_syndrome(NDISKS, PAGE_SIZE, dataptrs);
-	} else if (failb == NDISKS - 2) {
+		ta->gen->gen_syndrome(nr_buffers, len, dataptrs);
+	} else if (failb == nr_buffers - 2) {
 		/* data+P failure. */
-		ta->recov->datap(NDISKS, PAGE_SIZE, faila, dataptrs);
+		ta->recov->datap(nr_buffers, len, faila, dataptrs);
 	} else {
 		/* data+data failure. */
-		ta->recov->data2(NDISKS, PAGE_SIZE, faila, failb, dataptrs);
+		ta->recov->data2(nr_buffers, len, faila, failb, dataptrs);
 	}
 
 	KUNIT_EXPECT_MEMEQ_MSG(test, test_buffers[faila], test_recov_buffers[0],
-			PAGE_SIZE,
-			"faila miscompared: %3d[%c] (failb=%3d[%c])\n",
-			faila, member_type(faila),
-			failb, member_type(failb));
+			len,
+			"faila miscompared: %3d[%c] buffers %u len %u (failb=%3d[%c])\n",
+			faila, member_type(nr_buffers, faila),
+			nr_buffers, len,
+			failb, member_type(nr_buffers, failb));
 	KUNIT_EXPECT_MEMEQ_MSG(test, test_buffers[failb], test_recov_buffers[1],
-			PAGE_SIZE,
-			"failb miscompared: %3d[%c] (faila=%3d[%c])\n",
-			failb, member_type(failb),
-			faila, member_type(faila));
+			len,
+			"failb miscompared: %3d[%c] buffers %u len %u (faila=%3d[%c])\n",
+			failb, member_type(nr_buffers, failb),
+			nr_buffers, len,
+			faila, member_type(nr_buffers, faila));
 }
 
-static void raid6_test(struct kunit *test)
+static void test_recover(struct kunit *test, unsigned int nr_buffers,
+		unsigned int len)
+{
+	unsigned int nr_data = nr_buffers - 2;
+	int iterations, i;
+
+	/* Test P+Q recovery */
+	test_recover_one(test, nr_buffers, len, nr_data, nr_buffers - 1);
+
+	/* Test data+P recovery */
+	for (i = 0; i < nr_buffers - 2; i++)
+		test_recover_one(test, nr_buffers, len, i, nr_data);
+
+	/* Double data failure is impossible with a single data disk */
+	if (nr_data == 1)
+		return;
+
+	/* Test data+data recovery using random sampling */
+	iterations = nr_buffers * 2; /* should provide good enough coverage */
+	for (i = 0; i < iterations; i++) {
+		int faila = rand32() % nr_data, failb;
+
+		do {
+			failb = rand32() % nr_data;
+		} while (failb == faila);
+
+		test_recover_one(test, nr_buffers, len, faila, failb);
+	}
+}
+
+/* Simulate rmw run */
+static void test_rmw_one(struct kunit *test, unsigned int nr_buffers,
+		unsigned int len, int p1, int p2)
+{
+	const struct test_args *ta = test->param_value;
+
+	ta->gen->xor_syndrome(nr_buffers, p1, p2, len, test_buffers);
+	makedata(p1, p2);
+	ta->gen->xor_syndrome(nr_buffers, p1, p2, len, test_buffers);
+	test_recover(test, nr_buffers, len);
+}
+
+static void test_rmw(struct kunit *test, unsigned int nr_buffers,
+		unsigned int len)
+{
+	int iterations = nr_buffers / 2, i;
+
+	for (i = 0; i < iterations; i++) {
+		int p1 = rand32() % (nr_buffers - 2);
+		int p2 = rand32() % (nr_buffers - 2);
+
+		if (p2 < p1)
+			swap(p1, p2);
+		test_rmw_one(test, nr_buffers, len, p1, p2);
+	}
+}
+
+static void raid6_test_one(struct kunit *test)
 {
 	const struct test_args *ta = test->param_value;
-	int i, j, p1, p2;
+	unsigned int nr_buffers = random_nr_buffers();
+	unsigned int len = random_length(RAID6_KUNIT_MAX_BYTES);
 
 	/* Nuke syndromes */
-	memset(test_buffers[NDISKS - 2], 0xee, PAGE_SIZE);
-	memset(test_buffers[NDISKS - 1], 0xee, PAGE_SIZE);
+	memset(test_buffers[nr_buffers - 2], 0xee, test_buflen);
+	memset(test_buffers[nr_buffers - 1], 0xee, test_buflen);
 
 	/* Generate assumed good syndrome */
-	ta->gen->gen_syndrome(NDISKS, PAGE_SIZE, test_buffers);
+	ta->gen->gen_syndrome(nr_buffers, len, test_buffers);
 
-	for (i = 0; i < NDISKS - 1; i++)
-		for (j = i + 1; j < NDISKS; j++)
-			test_recover(test, i, j);
+	test_recover(test, nr_buffers, len);
 
-	if (!ta->gen->xor_syndrome)
-		return;
+	if (ta->gen->xor_syndrome)
+		test_rmw(test, nr_buffers, len);
+}
 
-	for (p1 = 0; p1 < NDISKS - 2; p1++) {
-		for (p2 = p1; p2 < NDISKS - 2; p2++) {
-			/* Simulate rmw run */
-			ta->gen->xor_syndrome(NDISKS, p1, p2, PAGE_SIZE,
-					test_buffers);
-			makedata(p1, p2);
-			ta->gen->xor_syndrome(NDISKS, p1, p2, PAGE_SIZE,
-					test_buffers);
-
-			for (i = 0; i < NDISKS - 1; i++)
-				for (j = i + 1; j < NDISKS; j++)
-					test_recover(test, i, j);
-		}
-	}
+static void raid6_test(struct kunit *test)
+{
+	int i;
+
+	for (i = 0; i < RAID6_KUNIT_NUM_TEST_ITERS; i++)
+		raid6_test_one(test);
 }
 
 static const void *raid6_gen_params(struct kunit *test, const void *prev,
@@ -169,23 +241,24 @@ static int raid6_suite_init(struct kunit
 	 * so that it is immediately followed by a guard page.  This allows
 	 * buffer overreads to be detected, even in assembly code.
 	 */
+	test_buflen = round_up(RAID6_KUNIT_MAX_BYTES, PAGE_SIZE);
 	for (i = 0; i < RAID6_KUNIT_MAX_FAILURES; i++) {
-		test_recov_buffers[i] = vmalloc(PAGE_SIZE);
+		test_recov_buffers[i] = vmalloc(test_buflen);
 		if (!test_recov_buffers[i])
 			goto out_free_recov_buffers;
 	}
-	for (i = 0; i < NDISKS; i++) {
-		test_buffers[i] = vmalloc(PAGE_SIZE);
+	for (i = 0; i < RAID6_KUNIT_MAX_BUFFERS; i++) {
+		test_buffers[i] = vmalloc(test_buflen);
 		if (!test_buffers[i])
 			goto out_free_buffers;
 	}
 
-	makedata(0, NDISKS - 1);
+	makedata(0, RAID6_KUNIT_MAX_BUFFERS - 1);
 
 	return 0;
 
 out_free_buffers:
-	for (i = 0; i < NDISKS; i++)
+	for (i = 0; i < RAID6_KUNIT_MAX_BUFFERS; i++)
 		vfree(test_buffers[i]);
 	memset(test_buffers, 0, sizeof(test_buffers));
 out_free_recov_buffers:
@@ -199,7 +272,7 @@ static void raid6_suite_exit(struct kuni
 {
 	int i;
 
-	for (i = 0; i < NDISKS; i++)
+	for (i = 0; i < RAID6_KUNIT_MAX_BUFFERS; i++)
 		vfree(test_buffers[i]);
 	memset(test_buffers, 0, sizeof(test_buffers));
 	for (i = 0; i < RAID6_KUNIT_MAX_FAILURES; i++)
_

Patches currently in -mm which might be from hch@lst.de are

raid6-turn-the-userspace-test-harness-into-a-kunit-test.patch
raid6-remove-__kernel__-ifdefs.patch
raid6-move-to-lib-raid.patch
raid6-remove-unused-defines-in-pqh.patch
raid6-remove-raid6_get_zero_page.patch
raid6-use-named-initializers-for-struct-raid6_calls.patch
raid6-improve-the-public-interface.patch
raid6-warn-when-using-less-than-four-devices.patch
raid6-hide-internals.patch
raid6-rework-registration-of-optimized-algorithms.patch
raid6-use-static_call-for-gen_syndrom-and-xor_syndrom.patch
raid6-use-static_call-for-raid6_recov_2data-and-raid6_recov_datap.patch
raid6-update-top-of-file-comments.patch
raid6_kunit-use-kunit_case_param.patch
raid6_kunit-dynamically-allocate-data-buffers-using-vmalloc.patch
raid6_kunit-cleanup-dataptr-handling.patch
raid6_kunit-randomize-parameters-and-increase-limits.patch
raid6_kunit-randomize-buffer-alignment.patch


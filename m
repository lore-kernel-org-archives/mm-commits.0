Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3813A372B59
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028828; cv=none; b=WcZp6AygpRS8jja0JLWDEscmo0OrC3XLww5tEObE+1GaSc5GgthIQ/JxZk1CIfO9LT1CGa2i1O46vtwEwfwaBe8Y5l1orvp0X2VCsINpA2twp8al164g/JC/LVOn1JBUIO+bFX7We9C9cj9j1gcmueasGd+w7sYMAZ9qfGO+KVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028828; c=relaxed/simple;
	bh=5tmrx59IYuqcUGSpdQZ3kOltejPUDOvxAkQByGM3dKA=;
	h=Date:To:From:Subject:Message-Id; b=aMEYcN/XyHKCj04GyC4DWSpTYsLC2/eiBUECKeGe6SkdRkXtw/GEvngkhEgFCQnT12m4QN5206zJQ86TiGNFRbqju0zdtKftU2U/MgexHZl0xwSBZvFhWcdec6Pcv6Z8MLwBfs7mOY33d1OSTlBerewloyAU5WhQTfnfJPQLl2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0UvUazDn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0UvUazDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064851F00898;
	Fri, 29 May 2026 04:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028825;
	bh=NS479fVoLhTmG+ySUJMfkmG2d/3u7FfghKi2zjgugQI=;
	h=Date:To:From:Subject;
	b=0UvUazDneY9V7FoRBPVYBZo5K3cQEOWcojD9+xIIUAf2XoNouo7+UdgHEb31ARlkS
	 IxqypWxzb280Kaz67OhtWZagj06PkChcL5RX0IPv4xcknIYJXly0y+PiMz5osy5x6+
	 THkRwm9tB9kqzgZkukv9WFemN14WcMUnk8gpxS0U=
Date: Thu, 28 May 2026 21:27:04 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,svens@linux.ibm.com,song@kernel.org,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,maddy@linux.ibm.com,linan122@huawei.com,kernel@xen0n.name,hpa@zytor.com,herbert@gondor.apana.org.au,hca@linux.ibm.com,gor@linux.ibm.com,dsterba@suse.com,dan.j.williams@intel.com,clm@fb.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,arnd@arndb.de,ardb@kernel.org,aou@eecs.berkeley.edu,alex@ghiti.fr,agordeev@linux.ibm.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] raid6_kunit-dynamically-allocate-data-buffers-using-vmalloc.patch removed from -mm tree
Message-Id: <20260529042705.064851F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: raid6_kunit: dynamically allocate data buffers using vmalloc
has been removed from the -mm tree.  Its filename was
     raid6_kunit-dynamically-allocate-data-buffers-using-vmalloc.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: raid6_kunit: dynamically allocate data buffers using vmalloc
Date: Mon, 18 May 2026 07:17:58 +0200

Use vmalloc for the data buffers instead of using static .data
allocations.  This provides for better out of bounds checking and avoids
wasting kernel memory after the test has run.  vmalloc is used instead of
kmalloc to provide for better out of bounds access checking as in other
kunit tests.

Link: https://lore.kernel.org/20260518051804.462141-16-hch@lst.de
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

 lib/raid/raid6/tests/raid6_kunit.c |   77 +++++++++++++++++++++------
 1 file changed, 62 insertions(+), 15 deletions(-)

--- a/lib/raid/raid6/tests/raid6_kunit.c~raid6_kunit-dynamically-allocate-data-buffers-using-vmalloc
+++ a/lib/raid/raid6/tests/raid6_kunit.c
@@ -7,19 +7,20 @@
 
 #include <kunit/test.h>
 #include <linux/prandom.h>
+#include <linux/vmalloc.h>
 #include "../algos.h"
 
 MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
 
 #define RAID6_KUNIT_SEED		42
+#define RAID6_KUNIT_MAX_FAILURES	2
 
 #define NDISKS		16	/* Including P and Q */
 
 static struct rnd_state rng;
 static void *dataptrs[NDISKS];
-static char data[NDISKS][PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
-static char recovi[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
-static char recovj[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
+static void *test_buffers[NDISKS];
+static void *test_recov_buffers[RAID6_KUNIT_MAX_FAILURES];
 
 struct test_args {
 	unsigned int recov_idx;
@@ -35,8 +36,8 @@ static void makedata(int start, int stop
 	int i;
 
 	for (i = start; i <= stop; i++) {
-		prandom_bytes_state(&rng, data[i], PAGE_SIZE);
-		dataptrs[i] = data[i];
+		prandom_bytes_state(&rng, test_buffers[i], PAGE_SIZE);
+		dataptrs[i] = test_buffers[i];
 	}
 }
 
@@ -55,12 +56,13 @@ static char member_type(int d)
 static void test_recover(struct kunit *test, int faila, int failb)
 {
 	const struct test_args *ta = test->param_value;
+	int i;
 
-	memset(recovi, 0xf0, PAGE_SIZE);
-	memset(recovj, 0xba, PAGE_SIZE);
+	for (i = 0; i < RAID6_KUNIT_MAX_FAILURES; i++)
+		memset(test_recov_buffers[i], 0xf0, PAGE_SIZE);
 
-	dataptrs[faila] = recovi;
-	dataptrs[failb] = recovj;
+	dataptrs[faila] = test_recov_buffers[0];
+	dataptrs[failb] = test_recov_buffers[1];
 
 	if (failb == NDISKS - 1) {
 		/*
@@ -80,18 +82,20 @@ static void test_recover(struct kunit *t
 		ta->recov->data2(NDISKS, PAGE_SIZE, faila, failb, dataptrs);
 	}
 
-	KUNIT_EXPECT_MEMEQ_MSG(test, data[faila], recovi, PAGE_SIZE,
+	KUNIT_EXPECT_MEMEQ_MSG(test, test_buffers[faila], test_recov_buffers[0],
+			PAGE_SIZE,
 			"faila miscompared: %3d[%c] (failb=%3d[%c])\n",
 			faila, member_type(faila),
 			failb, member_type(failb));
-	KUNIT_EXPECT_MEMEQ_MSG(test, data[failb], recovj, PAGE_SIZE,
+	KUNIT_EXPECT_MEMEQ_MSG(test, test_buffers[failb], test_recov_buffers[1],
+			PAGE_SIZE,
 			"failb miscompared: %3d[%c] (faila=%3d[%c])\n",
 			failb, member_type(failb),
 			faila, member_type(faila));
 
 skip:
-	dataptrs[faila] = data[faila];
-	dataptrs[failb] = data[failb];
+	dataptrs[faila] = test_buffers[faila];
+	dataptrs[failb] = test_buffers[failb];
 }
 
 static void raid6_test(struct kunit *test)
@@ -100,8 +104,8 @@ static void raid6_test(struct kunit *tes
 	int i, j, p1, p2;
 
 	/* Nuke syndromes */
-	memset(data[NDISKS - 2], 0xee, PAGE_SIZE);
-	memset(data[NDISKS - 1], 0xee, PAGE_SIZE);
+	memset(test_buffers[NDISKS - 2], 0xee, PAGE_SIZE);
+	memset(test_buffers[NDISKS - 1], 0xee, PAGE_SIZE);
 
 	/* Generate assumed good syndrome */
 	ta->gen->gen_syndrome(NDISKS, PAGE_SIZE, (void **)&dataptrs);
@@ -161,15 +165,58 @@ static struct kunit_case raid6_test_case
 
 static int raid6_suite_init(struct kunit_suite *suite)
 {
+	int i;
+
 	prandom_seed_state(&rng, RAID6_KUNIT_SEED);
+
+	/*
+	 * Allocate the test buffer using vmalloc() with a page-aligned length
+	 * so that it is immediately followed by a guard page.  This allows
+	 * buffer overreads to be detected, even in assembly code.
+	 */
+	for (i = 0; i < RAID6_KUNIT_MAX_FAILURES; i++) {
+		test_recov_buffers[i] = vmalloc(PAGE_SIZE);
+		if (!test_recov_buffers[i])
+			goto out_free_recov_buffers;
+	}
+	for (i = 0; i < NDISKS; i++) {
+		test_buffers[i] = vmalloc(PAGE_SIZE);
+		if (!test_buffers[i])
+			goto out_free_buffers;
+	}
+
 	makedata(0, NDISKS - 1);
+
 	return 0;
+
+out_free_buffers:
+	for (i = 0; i < NDISKS; i++)
+		vfree(test_buffers[i]);
+	memset(test_buffers, 0, sizeof(test_buffers));
+out_free_recov_buffers:
+	for (i = 0; i < RAID6_KUNIT_MAX_FAILURES; i++)
+		vfree(test_recov_buffers[i]);
+	memset(test_recov_buffers, 0, sizeof(test_recov_buffers));
+	return -ENOMEM;
+}
+
+static void raid6_suite_exit(struct kunit_suite *suite)
+{
+	int i;
+
+	for (i = 0; i < NDISKS; i++)
+		vfree(test_buffers[i]);
+	memset(test_buffers, 0, sizeof(test_buffers));
+	for (i = 0; i < RAID6_KUNIT_MAX_FAILURES; i++)
+		vfree(test_recov_buffers[i]);
+	memset(test_recov_buffers, 0, sizeof(test_recov_buffers));
 }
 
 static struct kunit_suite raid6_test_suite = {
 	.name		= "raid6",
 	.test_cases	= raid6_test_cases,
 	.suite_init	= raid6_suite_init,
+	.suite_exit	= raid6_suite_exit,
 };
 kunit_test_suite(raid6_test_suite);
 
_

Patches currently in -mm which might be from hch@lst.de are



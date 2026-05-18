Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8A74A3E
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 21:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779138874; cv=none; b=g+UQcNd/YvHinkHRLMR2fVV+8XegP5imYoxTYKXEbrKfBUppvF9vYq0PTAbn2oL6RYCH7boxfIplJepYfc8z88VtLrc62Danz1DHfuTuvtCIk17khpu6FNzAoQfoPM3KymKvYMqbPhg1696mY/tbyiGaRsJx14pAx034eUofQII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779138874; c=relaxed/simple;
	bh=t/jpzJkMepVu6NsIDbviuBqJsm4u3c3MtXmnBsu5HmY=;
	h=Date:To:From:Subject:Message-Id; b=JWbtCBd3V7IbyptfNwOd/Ob6OJii/uJFBcGR7lpDLcAWVMKJ0V9STUmQD/cSVhbuNpB7ThzdHZ36gv7/bs8N8QLOR/bN/0UEbDawzYJT5kL0kymTV4ruTFU/j+qBWbgYKvuZds48+h33HbpoIlhV32FMWd7r77gkY8IX0FYxU0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I06RqkP3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I06RqkP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C574C2BCB7;
	Mon, 18 May 2026 21:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779138874;
	bh=t/jpzJkMepVu6NsIDbviuBqJsm4u3c3MtXmnBsu5HmY=;
	h=Date:To:From:Subject:From;
	b=I06RqkP3UqGPSlmZCdKlnsqy+hHP+JWEPSBcHLYht9PGRWFVWUnGtKr4EDusKuHgZ
	 DOMqWu4COM9b4rFmsAJ6PD6DNSx9szIEb5szZI5MZMl7nOUKeqx6/TyTD1S7VcnvM2
	 jjSh6R6QRyWGYsfFfIK1eplx+bPip72p7ICrmwqE=
Date: Mon, 18 May 2026 14:14:33 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + raid6_kunit-use-kunit_case_param.patch added to mm-nonmm-unstable branch
Message-Id: <20260518211434.1C574C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: raid6_kunit: use KUNIT_CASE_PARAM
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     raid6_kunit-use-kunit_case_param.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/raid6_kunit-use-kunit_case_param.patch

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
Subject: raid6_kunit: use KUNIT_CASE_PARAM
Date: Mon, 18 May 2026 07:17:57 +0200

The raid6 test combines various generation and recovery algorithms.  Use
KUNIT_CASE_PARAM and provide a generator that iterates over the possible
combinations instead of looping inside a single test instance.

Link: https://lore.kernel.org/20260518051804.462141-15-hch@lst.de
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

 lib/raid/raid6/tests/raid6_kunit.c |  130 +++++++++++++++------------
 1 file changed, 73 insertions(+), 57 deletions(-)

--- a/lib/raid/raid6/tests/raid6_kunit.c~raid6_kunit-use-kunit_case_param
+++ a/lib/raid/raid6/tests/raid6_kunit.c
@@ -21,6 +21,15 @@ static char data[NDISKS][PAGE_SIZE] __at
 static char recovi[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
 static char recovj[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
 
+struct test_args {
+	unsigned int recov_idx;
+	const struct raid6_recov_calls *recov;
+	unsigned int gen_idx;
+	const struct raid6_calls *gen;
+};
+
+static struct test_args args;
+
 static void makedata(int start, int stop)
 {
 	int i;
@@ -43,9 +52,10 @@ static char member_type(int d)
 	}
 }
 
-static void test_disks(struct kunit *test, const struct raid6_calls *calls,
-		const struct raid6_recov_calls *ra, int faila, int failb)
+static void test_recover(struct kunit *test, int faila, int failb)
 {
+	const struct test_args *ta = test->param_value;
+
 	memset(recovi, 0xf0, PAGE_SIZE);
 	memset(recovj, 0xba, PAGE_SIZE);
 
@@ -61,25 +71,23 @@ static void test_disks(struct kunit *tes
 			goto skip;
 
 		/* P+Q failure.  Just rebuild the syndrome. */
-		calls->gen_syndrome(NDISKS, PAGE_SIZE, dataptrs);
+		ta->gen->gen_syndrome(NDISKS, PAGE_SIZE, dataptrs);
 	} else if (failb == NDISKS - 2) {
 		/* data+P failure. */
-		ra->datap(NDISKS, PAGE_SIZE, faila, dataptrs);
+		ta->recov->datap(NDISKS, PAGE_SIZE, faila, dataptrs);
 	} else {
 		/* data+data failure. */
-		ra->data2(NDISKS, PAGE_SIZE, faila, failb, dataptrs);
+		ta->recov->data2(NDISKS, PAGE_SIZE, faila, failb, dataptrs);
 	}
 
 	KUNIT_EXPECT_MEMEQ_MSG(test, data[faila], recovi, PAGE_SIZE,
-		"algo=%-8s/%-8s faila miscompared: %3d[%c] (failb=%3d[%c])\n",
-	       calls->name, ra->name,
-	       faila, member_type(faila),
-	       failb, member_type(failb));
+			"faila miscompared: %3d[%c] (failb=%3d[%c])\n",
+			faila, member_type(faila),
+			failb, member_type(failb));
 	KUNIT_EXPECT_MEMEQ_MSG(test, data[failb], recovj, PAGE_SIZE,
-		"algo=%-8s/%-8s failb miscompared: %3d[%c] (faila=%3d[%c])\n",
-	       calls->name, ra->name,
-	       failb, member_type(failb),
-	       faila, member_type(faila));
+			"failb miscompared: %3d[%c] (faila=%3d[%c])\n",
+			failb, member_type(failb),
+			faila, member_type(faila));
 
 skip:
 	dataptrs[faila] = data[faila];
@@ -88,58 +96,66 @@ skip:
 
 static void raid6_test(struct kunit *test)
 {
+	const struct test_args *ta = test->param_value;
 	int i, j, p1, p2;
-	unsigned int r, g;
-
-	for (r = 0; ; r++) {
-		const struct raid6_recov_calls *ra = raid6_recov_algo_find(r);
 
-		if (!ra)
-			break;
+	/* Nuke syndromes */
+	memset(data[NDISKS - 2], 0xee, PAGE_SIZE);
+	memset(data[NDISKS - 1], 0xee, PAGE_SIZE);
+
+	/* Generate assumed good syndrome */
+	ta->gen->gen_syndrome(NDISKS, PAGE_SIZE, (void **)&dataptrs);
+
+	for (i = 0; i < NDISKS - 1; i++)
+		for (j = i + 1; j < NDISKS; j++)
+			test_recover(test, i, j);
+
+	if (!ta->gen->xor_syndrome)
+		return;
+
+	for (p1 = 0; p1 < NDISKS - 2; p1++) {
+		for (p2 = p1; p2 < NDISKS - 2; p2++) {
+			/* Simulate rmw run */
+			ta->gen->xor_syndrome(NDISKS, p1, p2, PAGE_SIZE,
+					(void **)&dataptrs);
+			makedata(p1, p2);
+			ta->gen->xor_syndrome(NDISKS, p1, p2, PAGE_SIZE,
+					(void **)&dataptrs);
+
+			for (i = 0; i < NDISKS - 1; i++)
+				for (j = i + 1; j < NDISKS; j++)
+					test_recover(test, i, j);
+		}
+	}
+}
 
-		for (g = 0; ; g++) {
-			const struct raid6_calls *calls = raid6_algo_find(g);
-
-			if (!calls)
-				break;
-
-			/* Nuke syndromes */
-			memset(data[NDISKS - 2], 0xee, PAGE_SIZE);
-			memset(data[NDISKS - 1], 0xee, PAGE_SIZE);
-
-			/* Generate assumed good syndrome */
-			calls->gen_syndrome(NDISKS, PAGE_SIZE,
-						(void **)&dataptrs);
-
-			for (i = 0; i < NDISKS-1; i++)
-				for (j = i+1; j < NDISKS; j++)
-					test_disks(test, calls, ra, i, j);
-
-			if (!calls->xor_syndrome)
-				continue;
-
-			for (p1 = 0; p1 < NDISKS-2; p1++)
-				for (p2 = p1; p2 < NDISKS-2; p2++) {
-
-					/* Simulate rmw run */
-					calls->xor_syndrome(NDISKS, p1, p2, PAGE_SIZE,
-								(void **)&dataptrs);
-					makedata(p1, p2);
-					calls->xor_syndrome(NDISKS, p1, p2, PAGE_SIZE,
-                                                                (void **)&dataptrs);
-
-					for (i = 0; i < NDISKS-1; i++)
-						for (j = i+1; j < NDISKS; j++)
-							test_disks(test, calls,
-									ra, i, j);
-				}
+static const void *raid6_gen_params(struct kunit *test, const void *prev,
+		char *desc)
+{
+	if (!prev) {
+		memset(&args, 0, sizeof(args));
+next_algo:
+		args.recov_idx = 0;
+		args.gen = raid6_algo_find(args.gen_idx);
+		if (!args.gen)
+			return NULL;
+	}
 
-		}
+	if (args.recov)
+		args.recov_idx++;
+	args.recov = raid6_recov_algo_find(args.recov_idx);
+	if (!args.recov) {
+		args.gen_idx++;
+		goto next_algo;
 	}
+
+	snprintf(desc, KUNIT_PARAM_DESC_SIZE, "gen=%s recov=%s",
+			args.gen->name, args.recov->name);
+	return &args;
 }
 
 static struct kunit_case raid6_test_cases[] = {
-	KUNIT_CASE(raid6_test),
+	KUNIT_CASE_PARAM(raid6_test, raid6_gen_params),
 	{},
 };
 
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


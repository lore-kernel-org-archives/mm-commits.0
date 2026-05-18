Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABAB397695
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 21:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779138879; cv=none; b=dCq22O4pCyKTLvp+y7B12v/bjMlHqmhi/9FK3Y3dUHxiAckEDhcR/YAvjU6rc9B5SKHJu/gCjM/rgnWr1ZhAv1ISaxrm7heJYncK4T3okZo0k+m0HPyG7r31oTI6JHqCeWU/pgVju35+J83K/21L6305wNcc31UNiIb2UxhqrLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779138879; c=relaxed/simple;
	bh=Ca7TiKv40RYiWRQ3/qOSXSoYdK1DHmrzBI3zLYoOyKk=;
	h=Date:To:From:Subject:Message-Id; b=CEMKvoGBf2AcleShPMIm7KBE2ncjERzT0zZp9Jom/j/pCTSWMsiZMc0Z6Zk2iCfBA31yLUIWz2CYmXMTx8Vt3Z7vNQSnzGUAqsZGFu02iDVGEZEnI45eO/VhcXvIXFSqC2eNMjG++uhvpDidp72FB3d2e1HlXL8NieVkRNdfGhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uDWQRLtm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uDWQRLtm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A8FC2BCB7;
	Mon, 18 May 2026 21:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779138879;
	bh=Ca7TiKv40RYiWRQ3/qOSXSoYdK1DHmrzBI3zLYoOyKk=;
	h=Date:To:From:Subject:From;
	b=uDWQRLtmtk4RcqxVu2z5ooLHu9EfK1ydSLhzLG8yD0XVx4TDh5RTHePt435Ucbz69
	 HlvB4lRVHtpU6BAKmAKhXmNStDIL2laV3gWpgGmBtqc4DKiSXpuKHKZra4H9mcXdRw
	 syLj3vgsUvtOToGmd4+1edn1saEvQAmnEIkVCypg=
Date: Mon, 18 May 2026 14:14:38 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + raid6_kunit-cleanup-dataptr-handling.patch added to mm-nonmm-unstable branch
Message-Id: <20260518211439.02A8FC2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: raid6_kunit: cleanup dataptr handling
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     raid6_kunit-cleanup-dataptr-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/raid6_kunit-cleanup-dataptr-handling.patch

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
Subject: raid6_kunit: cleanup dataptr handling
Date: Mon, 18 May 2026 07:17:59 +0200

Move the global dataptr array into test_recover() as all sites that fill
data or parity can use test_buffers directly, and this localized the
override for the failed slots to the recovery testing routine.

Link: https://lore.kernel.org/20260518051804.462141-17-hch@lst.de
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

 lib/raid/raid6/tests/raid6_kunit.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/lib/raid/raid6/tests/raid6_kunit.c~raid6_kunit-cleanup-dataptr-handling
+++ a/lib/raid/raid6/tests/raid6_kunit.c
@@ -18,7 +18,6 @@ MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TES
 #define NDISKS		16	/* Including P and Q */
 
 static struct rnd_state rng;
-static void *dataptrs[NDISKS];
 static void *test_buffers[NDISKS];
 static void *test_recov_buffers[RAID6_KUNIT_MAX_FAILURES];
 
@@ -35,10 +34,8 @@ static void makedata(int start, int stop
 {
 	int i;
 
-	for (i = start; i <= stop; i++) {
+	for (i = start; i <= stop; i++)
 		prandom_bytes_state(&rng, test_buffers[i], PAGE_SIZE);
-		dataptrs[i] = test_buffers[i];
-	}
 }
 
 static char member_type(int d)
@@ -56,11 +53,13 @@ static char member_type(int d)
 static void test_recover(struct kunit *test, int faila, int failb)
 {
 	const struct test_args *ta = test->param_value;
+	void *dataptrs[NDISKS];
 	int i;
 
 	for (i = 0; i < RAID6_KUNIT_MAX_FAILURES; i++)
 		memset(test_recov_buffers[i], 0xf0, PAGE_SIZE);
 
+	memcpy(dataptrs, test_buffers, sizeof(dataptrs));
 	dataptrs[faila] = test_recov_buffers[0];
 	dataptrs[failb] = test_recov_buffers[1];
 
@@ -70,7 +69,7 @@ static void test_recover(struct kunit *t
 		 * is equivalent to a RAID-5 failure (XOR, then recompute Q).
 		 */
 		if (faila != NDISKS - 2)
-			goto skip;
+			return;
 
 		/* P+Q failure.  Just rebuild the syndrome. */
 		ta->gen->gen_syndrome(NDISKS, PAGE_SIZE, dataptrs);
@@ -92,10 +91,6 @@ static void test_recover(struct kunit *t
 			"failb miscompared: %3d[%c] (faila=%3d[%c])\n",
 			failb, member_type(failb),
 			faila, member_type(faila));
-
-skip:
-	dataptrs[faila] = test_buffers[faila];
-	dataptrs[failb] = test_buffers[failb];
 }
 
 static void raid6_test(struct kunit *test)
@@ -108,7 +103,7 @@ static void raid6_test(struct kunit *tes
 	memset(test_buffers[NDISKS - 1], 0xee, PAGE_SIZE);
 
 	/* Generate assumed good syndrome */
-	ta->gen->gen_syndrome(NDISKS, PAGE_SIZE, (void **)&dataptrs);
+	ta->gen->gen_syndrome(NDISKS, PAGE_SIZE, test_buffers);
 
 	for (i = 0; i < NDISKS - 1; i++)
 		for (j = i + 1; j < NDISKS; j++)
@@ -121,10 +116,10 @@ static void raid6_test(struct kunit *tes
 		for (p2 = p1; p2 < NDISKS - 2; p2++) {
 			/* Simulate rmw run */
 			ta->gen->xor_syndrome(NDISKS, p1, p2, PAGE_SIZE,
-					(void **)&dataptrs);
+					test_buffers);
 			makedata(p1, p2);
 			ta->gen->xor_syndrome(NDISKS, p1, p2, PAGE_SIZE,
-					(void **)&dataptrs);
+					test_buffers);
 
 			for (i = 0; i < NDISKS - 1; i++)
 				for (j = i + 1; j < NDISKS; j++)
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


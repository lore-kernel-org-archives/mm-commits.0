Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D11397338
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 21:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779138884; cv=none; b=ERiG5LTetc+t7mPMx5QDbC4aXo7OoeYzg/iqRUJhFCPhJ6cSCTZtgEv1S1HRbgrJCgV/PEqcvoEEy39VV2SJxve+YqQI+weboS1uiitWEgnb/RbYw9/NvCQiVuHiw66inGrKjY3disMjSVc0QyZCJiFITazSHKmgIAP3ZbIs+Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779138884; c=relaxed/simple;
	bh=B3Rn3SpFWxJeMawOgYNGKxI8p1uAcoQbgDjI/gDBEzg=;
	h=Date:To:From:Subject:Message-Id; b=NX6HynVVjFLVetZikQAPUgSE8qsRbOqBampFtaqr2NEhMvabLHgBy0ec7iF9VSmGayQULHvTXpEMYGQYUqiuE5TxR3Vy/LrzuiBEZE8592Evw0eZ0+0Dun4SEA1QOxN8ZTx58Rn4V/oDGvAz2OFmII/8jKiQ6snRD/jOAwO0c6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tkFqsHrb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tkFqsHrb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD742C2BCC6;
	Mon, 18 May 2026 21:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779138883;
	bh=B3Rn3SpFWxJeMawOgYNGKxI8p1uAcoQbgDjI/gDBEzg=;
	h=Date:To:From:Subject:From;
	b=tkFqsHrb0KKhOZcVHuaYEoENyDxHm/SpTAinJVWhDj8xbS30vBldRxUrrZJweAKZ9
	 WqxS+L71rnwTqgzS7FqgGOLTao2hKWo3cpjVpBsSrazSTlQwDmofFrEQG528pbFjnT
	 nB0ltRcHd32vWAzs6YxxFapbuebP3Ty10mWWjFXs=
Date: Mon, 18 May 2026 14:14:43 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + raid6_kunit-randomize-buffer-alignment.patch added to mm-nonmm-unstable branch
Message-Id: <20260518211443.CD742C2BCC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: raid6_kunit: randomize buffer alignment
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     raid6_kunit-randomize-buffer-alignment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/raid6_kunit-randomize-buffer-alignment.patch

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
Subject: raid6_kunit: randomize buffer alignment
Date: Mon, 18 May 2026 07:18:01 +0200

Add code to add random alignment to the buffers to test the case where
they are not page aligned, and to move the buffers to the end of the
allocation so that they are next to the vmalloc guard page.

This does not include the recovery buffers as the recovery requires page
alignment.

Link: https://lore.kernel.org/20260518051804.462141-19-hch@lst.de
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

 lib/raid/raid6/tests/raid6_kunit.c |   41 +++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 6 deletions(-)

--- a/lib/raid/raid6/tests/raid6_kunit.c~raid6_kunit-randomize-buffer-alignment
+++ a/lib/raid/raid6/tests/raid6_kunit.c
@@ -21,6 +21,7 @@ MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TES
 
 static struct rnd_state rng;
 static void *test_buffers[RAID6_KUNIT_MAX_BUFFERS];
+static void *aligned_buffers[RAID6_KUNIT_MAX_BUFFERS];
 static void *test_recov_buffers[RAID6_KUNIT_MAX_FAILURES];
 static size_t test_buflen;
 
@@ -50,6 +51,14 @@ static unsigned int random_nr_buffers(vo
 			RAID6_MIN_DISKS;
 }
 
+/* Generate a random alignment that is a multiple of 64. */
+static unsigned int random_alignment(unsigned int max_alignment)
+{
+	if (max_alignment == 0)
+		return 0;
+	return (rand32() % (max_alignment + 1)) & ~63;
+}
+
 static void makedata(int start, int stop)
 {
 	int i;
@@ -80,7 +89,7 @@ static void test_recover_one(struct kuni
 	for (i = 0; i < RAID6_KUNIT_MAX_FAILURES; i++)
 		memset(test_recov_buffers[i], 0xf0, test_buflen);
 
-	memcpy(dataptrs, test_buffers, sizeof(dataptrs));
+	memcpy(dataptrs, aligned_buffers, sizeof(dataptrs));
 	dataptrs[faila] = test_recov_buffers[0];
 	dataptrs[failb] = test_recov_buffers[1];
 
@@ -102,13 +111,13 @@ static void test_recover_one(struct kuni
 		ta->recov->data2(nr_buffers, len, faila, failb, dataptrs);
 	}
 
-	KUNIT_EXPECT_MEMEQ_MSG(test, test_buffers[faila], test_recov_buffers[0],
+	KUNIT_EXPECT_MEMEQ_MSG(test, aligned_buffers[faila], dataptrs[faila],
 			len,
 			"faila miscompared: %3d[%c] buffers %u len %u (failb=%3d[%c])\n",
 			faila, member_type(nr_buffers, faila),
 			nr_buffers, len,
 			failb, member_type(nr_buffers, failb));
-	KUNIT_EXPECT_MEMEQ_MSG(test, test_buffers[failb], test_recov_buffers[1],
+	KUNIT_EXPECT_MEMEQ_MSG(test, aligned_buffers[failb], dataptrs[failb],
 			len,
 			"failb miscompared: %3d[%c] buffers %u len %u (faila=%3d[%c])\n",
 			failb, member_type(nr_buffers, failb),
@@ -152,9 +161,9 @@ static void test_rmw_one(struct kunit *t
 {
 	const struct test_args *ta = test->param_value;
 
-	ta->gen->xor_syndrome(nr_buffers, p1, p2, len, test_buffers);
+	ta->gen->xor_syndrome(nr_buffers, p1, p2, len, aligned_buffers);
 	makedata(p1, p2);
-	ta->gen->xor_syndrome(nr_buffers, p1, p2, len, test_buffers);
+	ta->gen->xor_syndrome(nr_buffers, p1, p2, len, aligned_buffers);
 	test_recover(test, nr_buffers, len);
 }
 
@@ -178,13 +187,33 @@ static void raid6_test_one(struct kunit
 	const struct test_args *ta = test->param_value;
 	unsigned int nr_buffers = random_nr_buffers();
 	unsigned int len = random_length(RAID6_KUNIT_MAX_BYTES);
+	unsigned int max_alignment;
+	int i;
 
 	/* Nuke syndromes */
 	memset(test_buffers[nr_buffers - 2], 0xee, test_buflen);
 	memset(test_buffers[nr_buffers - 1], 0xee, test_buflen);
 
+	/*
+	 * If we're not using the entire buffer size, inject randomize alignment
+	 * into the buffer.
+	 */
+	max_alignment = RAID6_KUNIT_MAX_BYTES - len;
+	if (rand32() % 2 == 0) {
+		/* Use random alignments mod 64 */
+		for (i = 0; i < nr_buffers; i++)
+			aligned_buffers[i] = test_buffers[i] +
+				random_alignment(max_alignment);
+	} else {
+		/* Go up to the guard page, to catch buffer overreads */
+		unsigned int align = test_buflen - len;
+
+		for (i = 0; i < nr_buffers; i++)
+			aligned_buffers[i] = test_buffers[i] + align;
+	}
+
 	/* Generate assumed good syndrome */
-	ta->gen->gen_syndrome(nr_buffers, len, test_buffers);
+	ta->gen->gen_syndrome(nr_buffers, len, aligned_buffers);
 
 	test_recover(test, nr_buffers, len);
 
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


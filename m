Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49192372B59
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028830; cv=none; b=JLBOS+u5YH/MFDXWjWMM0Kg+e3ChEZpUyZTsWKYAiqPreP+NF+2ocNHmhUfw+lmgC11DTXbbsd/4yo3gq7UpUsjnqDEqcfVr0hG4W8a2Bcxr4ZXASuYzf8l+WASpRVL78GGv/YDbiq9PDjLCwURZOExGDc7yItXQCj1+fTQbkfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028830; c=relaxed/simple;
	bh=AsJW73C+6ZsXlUoR2xC7cPz7MoF2OYCeMABCKRBWbdg=;
	h=Date:To:From:Subject:Message-Id; b=LlAtOu4daLCaWi7r32dQbfoEXzN+frSPXR9aUA36VYwaCiml+KX1Ktb1prRwDOTVKG4XqpIjt0xJKWgIh0bKUbRPiQFoyXQhS2yd216LBMAatTWJ6J1p6YhoONjEqgG/0m/KAryyG7Ogs2lbJ/tzNSXMgx8CcFmkqBCMZS61PK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FjS1S3I1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FjS1S3I1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ACD91F00893;
	Fri, 29 May 2026 04:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028829;
	bh=Gy37LOAs05X9CLDtYVIpGzdaYQ26OcCQZSyQSg1ApHI=;
	h=Date:To:From:Subject;
	b=FjS1S3I126U4O99Kh016b77oEK8iJVdbr94FbamBsfCv+LUCYGiKXSOlJtwnh5SVm
	 DhB1G9rQynxkK/O0MxQKFox6Hr5dmZL7q1EXBKK6ifLNehhC5H2woqoLd3q2IKdkNh
	 qWhCqp6XWjt2ZIQS59RJyzSc0Kmbe6Eq2GCjCs/8=
Date: Thu, 28 May 2026 21:27:08 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,svens@linux.ibm.com,song@kernel.org,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,maddy@linux.ibm.com,linan122@huawei.com,kernel@xen0n.name,hpa@zytor.com,herbert@gondor.apana.org.au,hca@linux.ibm.com,gor@linux.ibm.com,dsterba@suse.com,dan.j.williams@intel.com,clm@fb.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,arnd@arndb.de,ardb@kernel.org,aou@eecs.berkeley.edu,alex@ghiti.fr,agordeev@linux.ibm.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] raid6_kunit-randomize-buffer-alignment.patch removed from -mm tree
Message-Id: <20260529042709.1ACD91F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: raid6_kunit: randomize buffer alignment
has been removed from the -mm tree.  Its filename was
     raid6_kunit-randomize-buffer-alignment.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



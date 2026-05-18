Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354DF39768F
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 21:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779138804; cv=none; b=RqCkxhm2jsyidR/Bze0uwWRWBE7WyyELq/N6LLmXMKwAs1T0zWwDQe40CNTMrvATm37FIh/HsBiEyVXtTq2HiCGjLH3MdT7NtM6t+TKeMn1ASV6ygkyk3Qjd7aiDVYlAMLI7KaD9nYlgX6bhox+dsC52dVUPpyNenqf70/1EYa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779138804; c=relaxed/simple;
	bh=C/vXWt0wY8TgCQ0d9Qz4bCJDY30pOUWdbxtjYvDo5eQ=;
	h=Date:To:From:Subject:Message-Id; b=Xsd0JgwmvDNZj5GAhRxJoWAvR8Ev2GlA0DhkkS1Hl9Ckm6ynA5PfKSxL5um7rncmKjmuGNq1+NhoNHM0SK0NsTLypYMooQSQW6jptV4xS0MLvYXiYSx/qwMOcN6ysNmgzvlaoSIKQ2vhgiMEwMDYgf6wnOaLQkvQ+iRKx/CTfHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D4LrSzH5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D4LrSzH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC48DC2BCF5;
	Mon, 18 May 2026 21:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779138803;
	bh=C/vXWt0wY8TgCQ0d9Qz4bCJDY30pOUWdbxtjYvDo5eQ=;
	h=Date:To:From:Subject:From;
	b=D4LrSzH5F0yh6qcJQ5w4W25J3eln4IOz1p4agEtdL6lkV0/gWVAH5vbZTmHZCOaMW
	 kansdwPoArzKLYerpjjrkLpLwk3z7h4Bt+FwzaTnuE8IckJTCDU77XVda6rOnNWWbw
	 mkJ4chB4q7esPXKxflEnMr8/YzyDtb/0uHED7Cr8=
Date: Mon, 18 May 2026 14:13:23 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + raid6-remove-raid6_get_zero_page.patch added to mm-nonmm-unstable branch
Message-Id: <20260518211323.CC48DC2BCF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: raid6: remove raid6_get_zero_page
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     raid6-remove-raid6_get_zero_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/raid6-remove-raid6_get_zero_page.patch

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
Subject: raid6: remove raid6_get_zero_page
Date: Mon, 18 May 2026 07:17:48 +0200

Just open code it as in other places in the kernel.

Link: https://lore.kernel.org/20260518051804.462141-6-hch@lst.de
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

 crypto/async_tx/async_pq.c                      |    2 +-
 crypto/async_tx/async_raid6_recov.c             |    4 ++--
 include/linux/raid/pq.h                         |    6 ------
 lib/raid/raid6/arm/recov_neon.c                 |    6 +++---
 lib/raid/raid6/loongarch/recov_loongarch_simd.c |   12 ++++++------
 lib/raid/raid6/recov.c                          |    6 +++---
 lib/raid/raid6/riscv/recov_rvv.c                |    6 +++---
 lib/raid/raid6/s390/recov_s390xc.c              |    6 +++---
 lib/raid/raid6/x86/recov_avx2.c                 |    6 +++---
 lib/raid/raid6/x86/recov_avx512.c               |    6 +++---
 lib/raid/raid6/x86/recov_ssse3.c                |    6 +++---
 11 files changed, 30 insertions(+), 36 deletions(-)

--- a/crypto/async_tx/async_pq.c~raid6-remove-raid6_get_zero_page
+++ a/crypto/async_tx/async_pq.c
@@ -119,7 +119,7 @@ do_sync_gen_syndrome(struct page **block
 	for (i = 0; i < disks; i++) {
 		if (blocks[i] == NULL) {
 			BUG_ON(i > disks - 3); /* P or Q can't be zero */
-			srcs[i] = raid6_get_zero_page();
+			srcs[i] = page_address(ZERO_PAGE(0));
 		} else {
 			srcs[i] = page_address(blocks[i]) + offsets[i];
 
--- a/crypto/async_tx/async_raid6_recov.c~raid6-remove-raid6_get_zero_page
+++ a/crypto/async_tx/async_raid6_recov.c
@@ -414,7 +414,7 @@ async_raid6_2data_recov(int disks, size_
 		async_tx_quiesce(&submit->depend_tx);
 		for (i = 0; i < disks; i++)
 			if (blocks[i] == NULL)
-				ptrs[i] = raid6_get_zero_page();
+				ptrs[i] = page_address(ZERO_PAGE(0));
 			else
 				ptrs[i] = page_address(blocks[i]) + offs[i];
 
@@ -497,7 +497,7 @@ async_raid6_datap_recov(int disks, size_
 		async_tx_quiesce(&submit->depend_tx);
 		for (i = 0; i < disks; i++)
 			if (blocks[i] == NULL)
-				ptrs[i] = raid6_get_zero_page();
+				ptrs[i] = page_address(ZERO_PAGE(0));
 			else
 				ptrs[i] = page_address(blocks[i]) + offs[i];
 
--- a/include/linux/raid/pq.h~raid6-remove-raid6_get_zero_page
+++ a/include/linux/raid/pq.h
@@ -11,12 +11,6 @@
 #include <linux/blkdev.h>
 #include <linux/mm.h>
 
-/* This should be const but the raid6 code is too convoluted for that. */
-static inline void *raid6_get_zero_page(void)
-{
-	return page_address(ZERO_PAGE(0));
-}
-
 /* Routine choices */
 struct raid6_calls {
 	void (*gen_syndrome)(int, size_t, void **);
--- a/lib/raid/raid6/arm/recov_neon.c~raid6-remove-raid6_get_zero_page
+++ a/lib/raid/raid6/arm/recov_neon.c
@@ -29,10 +29,10 @@ static void raid6_2data_recov_neon(int d
 	 * delta p and delta q
 	 */
 	dp = (u8 *)ptrs[faila];
-	ptrs[faila] = raid6_get_zero_page();
+	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks - 2] = dp;
 	dq = (u8 *)ptrs[failb];
-	ptrs[failb] = raid6_get_zero_page();
+	ptrs[failb] = page_address(ZERO_PAGE(0));
 	ptrs[disks - 1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
@@ -66,7 +66,7 @@ static void raid6_datap_recov_neon(int d
 	 * Use the dead data page as temporary storage for delta q
 	 */
 	dq = (u8 *)ptrs[faila];
-	ptrs[faila] = raid6_get_zero_page();
+	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks - 1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
--- a/lib/raid/raid6/loongarch/recov_loongarch_simd.c~raid6-remove-raid6_get_zero_page
+++ a/lib/raid/raid6/loongarch/recov_loongarch_simd.c
@@ -43,10 +43,10 @@ static void raid6_2data_recov_lsx(int di
 	 * delta p and delta q
 	 */
 	dp = (u8 *)ptrs[faila];
-	ptrs[faila] = raid6_get_zero_page();
+	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks - 2] = dp;
 	dq = (u8 *)ptrs[failb];
-	ptrs[failb] = raid6_get_zero_page();
+	ptrs[failb] = page_address(ZERO_PAGE(0));
 	ptrs[disks - 1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
@@ -198,7 +198,7 @@ static void raid6_datap_recov_lsx(int di
 	 * Use the dead data page as temporary storage for delta q
 	 */
 	dq = (u8 *)ptrs[faila];
-	ptrs[faila] = raid6_get_zero_page();
+	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks - 1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
@@ -317,10 +317,10 @@ static void raid6_2data_recov_lasx(int d
 	 * delta p and delta q
 	 */
 	dp = (u8 *)ptrs[faila];
-	ptrs[faila] = raid6_get_zero_page();
+	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks - 2] = dp;
 	dq = (u8 *)ptrs[failb];
-	ptrs[failb] = raid6_get_zero_page();
+	ptrs[failb] = page_address(ZERO_PAGE(0));
 	ptrs[disks - 1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
@@ -437,7 +437,7 @@ static void raid6_datap_recov_lasx(int d
 	 * Use the dead data page as temporary storage for delta q
 	 */
 	dq = (u8 *)ptrs[faila];
-	ptrs[faila] = raid6_get_zero_page();
+	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks - 1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
--- a/lib/raid/raid6/recov.c~raid6-remove-raid6_get_zero_page
+++ a/lib/raid/raid6/recov.c
@@ -31,10 +31,10 @@ static void raid6_2data_recov_intx1(int
 	   Use the dead data pages as temporary storage for
 	   delta p and delta q */
 	dp = (u8 *)ptrs[faila];
-	ptrs[faila] = raid6_get_zero_page();
+	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks-2] = dp;
 	dq = (u8 *)ptrs[failb];
-	ptrs[failb] = raid6_get_zero_page();
+	ptrs[failb] = page_address(ZERO_PAGE(0));
 	ptrs[disks-1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
@@ -72,7 +72,7 @@ static void raid6_datap_recov_intx1(int
 	/* Compute syndrome with zero for the missing data page
 	   Use the dead data page as temporary storage for delta q */
 	dq = (u8 *)ptrs[faila];
-	ptrs[faila] = raid6_get_zero_page();
+	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks-1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
--- a/lib/raid/raid6/riscv/recov_rvv.c~raid6-remove-raid6_get_zero_page
+++ a/lib/raid/raid6/riscv/recov_rvv.c
@@ -158,10 +158,10 @@ static void raid6_2data_recov_rvv(int di
 	 * delta p and delta q
 	 */
 	dp = (u8 *)ptrs[faila];
-	ptrs[faila] = raid6_get_zero_page();
+	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks - 2] = dp;
 	dq = (u8 *)ptrs[failb];
-	ptrs[failb] = raid6_get_zero_page();
+	ptrs[failb] = page_address(ZERO_PAGE(0));
 	ptrs[disks - 1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
@@ -196,7 +196,7 @@ static void raid6_datap_recov_rvv(int di
 	 * Use the dead data page as temporary storage for delta q
 	 */
 	dq = (u8 *)ptrs[faila];
-	ptrs[faila] = raid6_get_zero_page();
+	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks - 1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
--- a/lib/raid/raid6/s390/recov_s390xc.c~raid6-remove-raid6_get_zero_page
+++ a/lib/raid/raid6/s390/recov_s390xc.c
@@ -34,10 +34,10 @@ static void raid6_2data_recov_s390xc(int
 	   Use the dead data pages as temporary storage for
 	   delta p and delta q */
 	dp = (u8 *)ptrs[faila];
-	ptrs[faila] = raid6_get_zero_page();
+	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks-2] = dp;
 	dq = (u8 *)ptrs[failb];
-	ptrs[failb] = raid6_get_zero_page();
+	ptrs[failb] = page_address(ZERO_PAGE(0));
 	ptrs[disks-1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
@@ -81,7 +81,7 @@ static void raid6_datap_recov_s390xc(int
 	/* Compute syndrome with zero for the missing data page
 	   Use the dead data page as temporary storage for delta q */
 	dq = (u8 *)ptrs[faila];
-	ptrs[faila] = raid6_get_zero_page();
+	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks-1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
--- a/lib/raid/raid6/x86/recov_avx2.c~raid6-remove-raid6_get_zero_page
+++ a/lib/raid/raid6/x86/recov_avx2.c
@@ -28,10 +28,10 @@ static void raid6_2data_recov_avx2(int d
 	   Use the dead data pages as temporary storage for
 	   delta p and delta q */
 	dp = (u8 *)ptrs[faila];
-	ptrs[faila] = raid6_get_zero_page();
+	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks-2] = dp;
 	dq = (u8 *)ptrs[failb];
-	ptrs[failb] = raid6_get_zero_page();
+	ptrs[failb] = page_address(ZERO_PAGE(0));
 	ptrs[disks-1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
@@ -196,7 +196,7 @@ static void raid6_datap_recov_avx2(int d
 	/* Compute syndrome with zero for the missing data page
 	   Use the dead data page as temporary storage for delta q */
 	dq = (u8 *)ptrs[faila];
-	ptrs[faila] = raid6_get_zero_page();
+	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks-1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
--- a/lib/raid/raid6/x86/recov_avx512.c~raid6-remove-raid6_get_zero_page
+++ a/lib/raid/raid6/x86/recov_avx512.c
@@ -37,10 +37,10 @@ static void raid6_2data_recov_avx512(int
 	 */
 
 	dp = (u8 *)ptrs[faila];
-	ptrs[faila] = raid6_get_zero_page();
+	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks-2] = dp;
 	dq = (u8 *)ptrs[failb];
-	ptrs[failb] = raid6_get_zero_page();
+	ptrs[failb] = page_address(ZERO_PAGE(0));
 	ptrs[disks-1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
@@ -238,7 +238,7 @@ static void raid6_datap_recov_avx512(int
 	 */
 
 	dq = (u8 *)ptrs[faila];
-	ptrs[faila] = raid6_get_zero_page();
+	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks-1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
--- a/lib/raid/raid6/x86/recov_ssse3.c~raid6-remove-raid6_get_zero_page
+++ a/lib/raid/raid6/x86/recov_ssse3.c
@@ -30,10 +30,10 @@ static void raid6_2data_recov_ssse3(int
 	   Use the dead data pages as temporary storage for
 	   delta p and delta q */
 	dp = (u8 *)ptrs[faila];
-	ptrs[faila] = raid6_get_zero_page();
+	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks-2] = dp;
 	dq = (u8 *)ptrs[failb];
-	ptrs[failb] = raid6_get_zero_page();
+	ptrs[failb] = page_address(ZERO_PAGE(0));
 	ptrs[disks-1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
@@ -203,7 +203,7 @@ static void raid6_datap_recov_ssse3(int
 	/* Compute syndrome with zero for the missing data page
 	   Use the dead data page as temporary storage for delta q */
 	dq = (u8 *)ptrs[faila];
-	ptrs[faila] = raid6_get_zero_page();
+	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks-1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07BA3921DC
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 21:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779138818; cv=none; b=mabfdA61fcmUtYONS4hNH+VCiBGO9fRHQcYGaBtAeT7yuOlpZS36d4TDwsE+0fQbttPfxKcHR29XDVAoj/bkbkICJwFPjedkLCyCTBc3WPiz1sEAtadSubqjorBAku4GLcVaemIVLTrYy2VYFP13cwtgG3DvYi3XwKQcIkEDYeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779138818; c=relaxed/simple;
	bh=NNC86xc9Gppoz3d9Qd4zBj8WwORknuTWpIKcoOtdDP8=;
	h=Date:To:From:Subject:Message-Id; b=t5f9skX6bw/h2fjBYZR4KGIi+qFEdtzJrNitidQlGePPK/pKxdqELbADGAcUgj3jxisezpzLrmQKKWIz7QYw5ckul5wiOUpXv0v9YH8MK98RW1Jqv+tct28TZXOi6qv5Obb25Ay4smL9Ljq7TLhLP+TRCrXvO6ohrWJtgEYpxTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bXtR/aXM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bXtR/aXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322CBC2BCB7;
	Mon, 18 May 2026 21:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779138818;
	bh=NNC86xc9Gppoz3d9Qd4zBj8WwORknuTWpIKcoOtdDP8=;
	h=Date:To:From:Subject:From;
	b=bXtR/aXMkmUE3MQgk/cVMl7k3yUfmI1L5VUuREmjZgYCILeMcQmrROM5QpKHG27/7
	 nF9UkFFWNc9Vt/nTRifrXDAB/Mt9+HxPMLsKUjZv2mHg3Db7tgryO8ZyTa8dnSJ9ko
	 piKvomARC0aZ0MeQXjKhwcmS4S73d57xe9+8Aeds=
Date: Mon, 18 May 2026 14:13:37 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + raid6-improve-the-public-interface.patch added to mm-nonmm-unstable branch
Message-Id: <20260518211338.322CBC2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: raid6: improve the public interface
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     raid6-improve-the-public-interface.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/raid6-improve-the-public-interface.patch

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
Subject: raid6: improve the public interface
Date: Mon, 18 May 2026 07:17:50 +0200

Stop directly calling into function pointers from users of the RAID6 PQ
API, and provide exported functions with proper documentation and API
guarantees asserts where applicable instead.

Link: https://lore.kernel.org/20260518051804.462141-8-hch@lst.de
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

 Documentation/crypto/async-tx-api.rst           |    4 
 crypto/async_tx/async_pq.c                      |    6 
 crypto/async_tx/async_raid6_recov.c             |    4 
 drivers/md/raid5.c                              |    4 
 fs/btrfs/raid56.c                               |    8 
 include/linux/raid/pq.h                         |   19 +
 lib/raid/raid6/algos.c                          |  139 +++++++++++++-
 lib/raid/raid6/arm/recov_neon.c                 |    4 
 lib/raid/raid6/loongarch/recov_loongarch_simd.c |    8 
 lib/raid/raid6/recov.c                          |    4 
 lib/raid/raid6/riscv/recov_rvv.c                |    4 
 lib/raid/raid6/s390/recov_s390xc.c              |    4 
 lib/raid/raid6/x86/recov_avx2.c                 |    4 
 lib/raid/raid6/x86/recov_avx512.c               |    4 
 lib/raid/raid6/x86/recov_ssse3.c                |    4 
 15 files changed, 171 insertions(+), 49 deletions(-)

--- a/crypto/async_tx/async_pq.c~raid6-improve-the-public-interface
+++ a/crypto/async_tx/async_pq.c
@@ -131,11 +131,11 @@ do_sync_gen_syndrome(struct page **block
 		}
 	}
 	if (submit->flags & ASYNC_TX_PQ_XOR_DST) {
-		BUG_ON(!raid6_call.xor_syndrome);
+		BUG_ON(!raid6_can_xor_syndrome());
 		if (start >= 0)
-			raid6_call.xor_syndrome(disks, start, stop, len, srcs);
+			raid6_xor_syndrome(disks, start, stop, len, srcs);
 	} else
-		raid6_call.gen_syndrome(disks, len, srcs);
+		raid6_gen_syndrome(disks, len, srcs);
 	async_tx_sync_epilog(submit);
 }
 
--- a/crypto/async_tx/async_raid6_recov.c~raid6-improve-the-public-interface
+++ a/crypto/async_tx/async_raid6_recov.c
@@ -418,7 +418,7 @@ async_raid6_2data_recov(int disks, size_
 			else
 				ptrs[i] = page_address(blocks[i]) + offs[i];
 
-		raid6_2data_recov(disks, bytes, faila, failb, ptrs);
+		raid6_recov_2data(disks, bytes, faila, failb, ptrs);
 
 		async_tx_sync_epilog(submit);
 
@@ -501,7 +501,7 @@ async_raid6_datap_recov(int disks, size_
 			else
 				ptrs[i] = page_address(blocks[i]) + offs[i];
 
-		raid6_datap_recov(disks, bytes, faila, ptrs);
+		raid6_recov_datap(disks, bytes, faila, ptrs);
 
 		async_tx_sync_epilog(submit);
 
--- a/Documentation/crypto/async-tx-api.rst~raid6-improve-the-public-interface
+++ a/Documentation/crypto/async-tx-api.rst
@@ -82,9 +82,9 @@ xor_val   xor a series of source buffers
 pq	  generate the p+q (raid6 syndrome) from a series of source buffers
 pq_val    validate that a p and or q buffer are in sync with a given series of
 	  sources
-datap	  (raid6_datap_recov) recover a raid6 data block and the p block
+datap	  (raid6_recov_datap) recover a raid6 data block and the p block
 	  from the given sources
-2data	  (raid6_2data_recov) recover 2 raid6 data blocks from the given
+2data	  (raid6_recov_2data) recover 2 raid6 data blocks from the given
 	  sources
 ========  ====================================================================
 
--- a/drivers/md/raid5.c~raid6-improve-the-public-interface
+++ a/drivers/md/raid5.c
@@ -6955,7 +6955,7 @@ raid5_store_rmw_level(struct mddev  *mdd
 	if (kstrtoul(page, 10, &new))
 		return -EINVAL;
 
-	if (new != PARITY_DISABLE_RMW && !raid6_call.xor_syndrome)
+	if (new != PARITY_DISABLE_RMW && !raid6_can_xor_syndrome())
 		return -EINVAL;
 
 	if (new != PARITY_DISABLE_RMW &&
@@ -7646,7 +7646,7 @@ static struct r5conf *setup_conf(struct
 	conf->level = mddev->new_level;
 	if (conf->level == 6) {
 		conf->max_degraded = 2;
-		if (raid6_call.xor_syndrome)
+		if (raid6_can_xor_syndrome())
 			conf->rmw_level = PARITY_ENABLE_RMW;
 		else
 			conf->rmw_level = PARITY_DISABLE_RMW;
--- a/fs/btrfs/raid56.c~raid6-improve-the-public-interface
+++ a/fs/btrfs/raid56.c
@@ -1410,7 +1410,7 @@ static void generate_pq_vertical_step(st
 				rbio_qstripe_paddr(rbio, sector_nr, step_nr));
 
 		assert_rbio(rbio);
-		raid6_call.gen_syndrome(rbio->real_stripes, step, pointers);
+		raid6_gen_syndrome(rbio->real_stripes, step, pointers);
 	} else {
 		/* raid5 */
 		memcpy(pointers[rbio->nr_data], pointers[0], step);
@@ -1987,10 +1987,10 @@ static void recover_vertical_step(struct
 		}
 
 		if (failb == rbio->real_stripes - 2) {
-			raid6_datap_recov(rbio->real_stripes, step,
+			raid6_recov_datap(rbio->real_stripes, step,
 					  faila, pointers);
 		} else {
-			raid6_2data_recov(rbio->real_stripes, step,
+			raid6_recov_2data(rbio->real_stripes, step,
 					  faila, failb, pointers);
 		}
 	} else {
@@ -2644,7 +2644,7 @@ static bool verify_one_parity_step(struc
 	if (has_qstripe) {
 		assert_rbio(rbio);
 		/* RAID6, call the library function to fill in our P/Q. */
-		raid6_call.gen_syndrome(rbio->real_stripes, step, pointers);
+		raid6_gen_syndrome(rbio->real_stripes, step, pointers);
 	} else {
 		/* RAID5. */
 		memcpy(pointers[nr_data], pointers[0], step);
--- a/include/linux/raid/pq.h~raid6-improve-the-public-interface
+++ a/include/linux/raid/pq.h
@@ -11,6 +11,16 @@
 #include <linux/blkdev.h>
 #include <linux/mm.h>
 
+void raid6_gen_syndrome(int disks, size_t bytes, void **ptrs);
+void raid6_xor_syndrome(int disks, int start, int stop, size_t bytes,
+		void **ptrs);
+bool raid6_can_xor_syndrome(void);
+
+void raid6_recov_2data(int disks, size_t bytes, int faila, int failb,
+		void **ptrs);
+void raid6_recov_datap(int disks, size_t bytes, int faila,
+		void **ptrs);
+
 /* Routine choices */
 struct raid6_calls {
 	void (*gen_syndrome)(int, size_t, void **);
@@ -20,9 +30,6 @@ struct raid6_calls {
 	int priority;		/* Relative priority ranking if non-zero */
 };
 
-/* Selected algorithm */
-extern struct raid6_calls raid6_call;
-
 /* Various routine sets */
 extern const struct raid6_calls raid6_intx1;
 extern const struct raid6_calls raid6_intx2;
@@ -92,10 +99,4 @@ extern const u8 raid6_gflog[256]      __
 extern const u8 raid6_gfinv[256]      __attribute__((aligned(256)));
 extern const u8 raid6_gfexi[256]      __attribute__((aligned(256)));
 
-/* Recovery routines */
-extern void (*raid6_2data_recov)(int disks, size_t bytes, int faila, int failb,
-		       void **ptrs);
-extern void (*raid6_datap_recov)(int disks, size_t bytes, int faila,
-			void **ptrs);
-
 #endif /* LINUX_RAID_RAID6_H */
--- a/lib/raid/raid6/algos.c~raid6-improve-the-public-interface
+++ a/lib/raid/raid6/algos.c
@@ -16,8 +16,83 @@
 #include <linux/gfp.h>
 #include <kunit/visibility.h>
 
-struct raid6_calls raid6_call;
-EXPORT_SYMBOL_GPL(raid6_call);
+static const struct raid6_recov_calls *raid6_recov_algo;
+
+/* Selected algorithm */
+static struct raid6_calls raid6_call;
+
+/**
+ * raid6_gen_syndrome - generate RAID6 P/Q parity
+ * @disks:	number of "disks" to operate on including parity
+ * @bytes:	length in bytes of each vector
+ * @ptrs:	@disks size array of memory pointers
+ *
+ * Generate @bytes worth of RAID6 P and Q parity in @ptrs[@disks - 2] and
+ * @ptrs[@disks - 1] respectively from the memory pointed to by @ptrs[0] to
+ * @ptrs[@disks - 3].
+ *
+ * @disks must be at least 4, and the memory pointed to by each member of @ptrs
+ * must be at least 64-byte aligned.  @bytes must be non-zero and a multiple of
+ * 512.
+ *
+ * See https://kernel.org/pub/linux/kernel/people/hpa/raid6.pdf for underlying
+ * algorithm.
+ */
+void raid6_gen_syndrome(int disks, size_t bytes, void **ptrs)
+{
+	WARN_ON_ONCE(!in_task() || irqs_disabled() || softirq_count());
+	WARN_ON_ONCE(bytes & 511);
+
+	raid6_call.gen_syndrome(disks, bytes, ptrs);
+}
+EXPORT_SYMBOL_GPL(raid6_gen_syndrome);
+
+/**
+ * raid6_xor_syndrome - update RAID6 P/Q parity
+ * @disks:	number of "disks" to operate on including parity
+ * @start:	first index into @disk to update
+ * @stop:	last index into @disk to update
+ * @bytes:	length in bytes of each vector
+ * @ptrs:	@disks size array of memory pointers
+ *
+ * Update @bytes worth of RAID6 P and Q parity in @ptrs[@disks - 2] and
+ * @ptrs[@disks - 1] respectively for the memory pointed to by
+ * @ptrs[@start..@stop].
+ *
+ * This is used to update parity in place using the following sequence:
+ *
+ * 1) call raid6_xor_syndrome(disk, start, stop, ...) for the existing data.
+ * 2) update the the data in @ptrs[@start..@stop].
+ * 3) call raid6_xor_syndrome(disk, start, stop, ...) for the new data.
+ *
+ * Data between @start and @stop that is not changed should be filled
+ * with a pointer to the kernel zero page.
+ *
+ * @disks must be at least 4, and the memory pointed to by each member of @ptrs
+ * must be at least 64-byte aligned.  @bytes must be non-zero and a multiple of
+ * 512.  @stop must be larger or equal to @start.
+ */
+void raid6_xor_syndrome(int disks, int start, int stop, size_t bytes,
+		void **ptrs)
+{
+	WARN_ON_ONCE(!in_task() || irqs_disabled() || softirq_count());
+	WARN_ON_ONCE(bytes & 511);
+	WARN_ON_ONCE(stop < start);
+
+	raid6_call.xor_syndrome(disks, start, stop, bytes, ptrs);
+}
+EXPORT_SYMBOL_GPL(raid6_xor_syndrome);
+
+/*
+ * raid6_can_xor_syndrome - check if raid6_xor_syndrome() can be used
+ *
+ * Returns %true if raid6_can_xor_syndrome() can be used, else %false.
+ */
+bool raid6_can_xor_syndrome(void)
+{
+	return !!raid6_call.xor_syndrome;
+}
+EXPORT_SYMBOL_GPL(raid6_can_xor_syndrome);
 
 const struct raid6_calls * const raid6_algos[] = {
 #if defined(__i386__) && !defined(__arch_um__)
@@ -84,11 +159,58 @@ const struct raid6_calls * const raid6_a
 };
 EXPORT_SYMBOL_IF_KUNIT(raid6_algos);
 
-void (*raid6_2data_recov)(int, size_t, int, int, void **);
-EXPORT_SYMBOL_GPL(raid6_2data_recov);
-
-void (*raid6_datap_recov)(int, size_t, int, void **);
-EXPORT_SYMBOL_GPL(raid6_datap_recov);
+/**
+ * raid6_recov_2data - recover two missing data disks
+ * @disks:	number of "disks" to operate on including parity
+ * @bytes:	length in bytes of each vector
+ * @faila:	first failed data disk index
+ * @failb:	second failed data disk index
+ * @ptrs:	@disks size array of memory pointers
+ *
+ * Rebuild @bytes of missing data in @ptrs[@faila] and @ptrs[@failb] from the
+ * data in the remaining disks and the two parities pointed to by the other
+ * indices between 0 and @disks - 1 in @ptrs.  @disks includes the data disks
+ * and the two parities.  @faila must be smaller than @failb.
+ *
+ * Memory pointed to by each pointer in @ptrs must be page aligned and is
+ * limited to %PAGE_SIZE.
+ */
+void raid6_recov_2data(int disks, size_t bytes, int faila, int failb,
+		void **ptrs)
+{
+	WARN_ON_ONCE(!in_task() || irqs_disabled() || softirq_count());
+	WARN_ON_ONCE(bytes & 511);
+	WARN_ON_ONCE(bytes > PAGE_SIZE);
+	WARN_ON_ONCE(failb <= faila);
+
+	raid6_recov_algo->data2(disks, bytes, faila, failb, ptrs);
+}
+EXPORT_SYMBOL_GPL(raid6_recov_2data);
+
+/**
+ * raid6_recov_datap - recover a missing data disk and missing P-parity
+ * @disks:	number of "disks" to operate on including parity
+ * @bytes:	length in bytes of each vector
+ * @faila:	failed data disk index
+ * @ptrs:	@disks size array of memory pointers
+ *
+ * Rebuild @bytes of missing data in @ptrs[@faila] and the missing P-parity in
+ * @ptrs[@disks - 2] from the data in the remaining disks and the Q-parity
+ * pointed to by the other indices between 0 and @disks - 1 in @ptrs.  @disks
+ * includes the data disks and the two parities.
+ *
+ * Memory pointed to by each pointer in @ptrs must be page aligned and is
+ * limited to %PAGE_SIZE.
+ */
+void raid6_recov_datap(int disks, size_t bytes, int faila, void **ptrs)
+{
+	WARN_ON_ONCE(!in_task() || irqs_disabled() || softirq_count());
+	WARN_ON_ONCE(bytes & 511);
+	WARN_ON_ONCE(bytes > PAGE_SIZE);
+
+	raid6_recov_algo->datap(disks, bytes, faila, ptrs);
+}
+EXPORT_SYMBOL_GPL(raid6_recov_datap);
 
 const struct raid6_recov_calls *const raid6_recov_algos[] = {
 #ifdef CONFIG_X86
@@ -133,8 +255,7 @@ static inline const struct raid6_recov_c
 				best = *algo;
 
 	if (best) {
-		raid6_2data_recov = best->data2;
-		raid6_datap_recov = best->datap;
+		raid6_recov_algo = best;
 
 		pr_info("raid6: using %s recovery algorithm\n", best->name);
 	} else
--- a/lib/raid/raid6/arm/recov_neon.c~raid6-improve-the-public-interface
+++ a/lib/raid/raid6/arm/recov_neon.c
@@ -35,7 +35,7 @@ static void raid6_2data_recov_neon(int d
 	ptrs[failb] = page_address(ZERO_PAGE(0));
 	ptrs[disks - 1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila]     = dp;
@@ -69,7 +69,7 @@ static void raid6_datap_recov_neon(int d
 	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks - 1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila]     = dq;
--- a/lib/raid/raid6/loongarch/recov_loongarch_simd.c~raid6-improve-the-public-interface
+++ a/lib/raid/raid6/loongarch/recov_loongarch_simd.c
@@ -49,7 +49,7 @@ static void raid6_2data_recov_lsx(int di
 	ptrs[failb] = page_address(ZERO_PAGE(0));
 	ptrs[disks - 1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila] = dp;
@@ -201,7 +201,7 @@ static void raid6_datap_recov_lsx(int di
 	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks - 1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila] = dq;
@@ -323,7 +323,7 @@ static void raid6_2data_recov_lasx(int d
 	ptrs[failb] = page_address(ZERO_PAGE(0));
 	ptrs[disks - 1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila] = dp;
@@ -440,7 +440,7 @@ static void raid6_datap_recov_lasx(int d
 	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks - 1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila] = dq;
--- a/lib/raid/raid6/recov.c~raid6-improve-the-public-interface
+++ a/lib/raid/raid6/recov.c
@@ -37,7 +37,7 @@ static void raid6_2data_recov_intx1(int
 	ptrs[failb] = page_address(ZERO_PAGE(0));
 	ptrs[disks-1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila]   = dp;
@@ -75,7 +75,7 @@ static void raid6_datap_recov_intx1(int
 	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks-1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila]   = dq;
--- a/lib/raid/raid6/riscv/recov_rvv.c~raid6-improve-the-public-interface
+++ a/lib/raid/raid6/riscv/recov_rvv.c
@@ -164,7 +164,7 @@ static void raid6_2data_recov_rvv(int di
 	ptrs[failb] = page_address(ZERO_PAGE(0));
 	ptrs[disks - 1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila]     = dp;
@@ -199,7 +199,7 @@ static void raid6_datap_recov_rvv(int di
 	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks - 1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila]     = dq;
--- a/lib/raid/raid6/s390/recov_s390xc.c~raid6-improve-the-public-interface
+++ a/lib/raid/raid6/s390/recov_s390xc.c
@@ -40,7 +40,7 @@ static void raid6_2data_recov_s390xc(int
 	ptrs[failb] = page_address(ZERO_PAGE(0));
 	ptrs[disks-1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila]   = dp;
@@ -84,7 +84,7 @@ static void raid6_datap_recov_s390xc(int
 	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks-1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila]   = dq;
--- a/lib/raid/raid6/x86/recov_avx2.c~raid6-improve-the-public-interface
+++ a/lib/raid/raid6/x86/recov_avx2.c
@@ -34,7 +34,7 @@ static void raid6_2data_recov_avx2(int d
 	ptrs[failb] = page_address(ZERO_PAGE(0));
 	ptrs[disks-1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila]   = dp;
@@ -199,7 +199,7 @@ static void raid6_datap_recov_avx2(int d
 	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks-1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila]   = dq;
--- a/lib/raid/raid6/x86/recov_avx512.c~raid6-improve-the-public-interface
+++ a/lib/raid/raid6/x86/recov_avx512.c
@@ -43,7 +43,7 @@ static void raid6_2data_recov_avx512(int
 	ptrs[failb] = page_address(ZERO_PAGE(0));
 	ptrs[disks-1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila]   = dp;
@@ -241,7 +241,7 @@ static void raid6_datap_recov_avx512(int
 	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks-1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila]   = dq;
--- a/lib/raid/raid6/x86/recov_ssse3.c~raid6-improve-the-public-interface
+++ a/lib/raid/raid6/x86/recov_ssse3.c
@@ -36,7 +36,7 @@ static void raid6_2data_recov_ssse3(int
 	ptrs[failb] = page_address(ZERO_PAGE(0));
 	ptrs[disks-1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila]   = dp;
@@ -206,7 +206,7 @@ static void raid6_datap_recov_ssse3(int
 	ptrs[faila] = page_address(ZERO_PAGE(0));
 	ptrs[disks-1] = dq;
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	raid6_gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila]   = dq;
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


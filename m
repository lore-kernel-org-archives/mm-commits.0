From: akpm@osdl.org
Subject: - log2-implement-a-general-integer-log2-facility-in-the-kernel.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:05:31 -0800
Message-ID: <200612082005.kB8K5Vij002314@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57689 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426341AbWLHUG2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:06:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, benh@kernel.crashing.org, herbert@gondor.apana.org.au, paulus@samba.org, wojtekka@toxygen.net, mm-commits@vger.kernel.org


The patch titled
     LOG2: Implement a general integer log2 facility in the kernel
has been removed from the -mm tree.  Its filename was
     log2-implement-a-general-integer-log2-facility-in-the-kernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: LOG2: Implement a general integer log2 facility in the kernel
From: David Howells <dhowells@redhat.com>

This facility provides three entry points:

	ilog2()		Log base 2 of unsigned long
	ilog2_u32()	Log base 2 of u32
	ilog2_u64()	Log base 2 of u64

These facilities can either be used inside functions on dynamic data:

	int do_something(long q)
	{
		...;
		y = ilog2(x)
		...;
	}

Or can be used to statically initialise global variables with constant values:

	unsigned n = ilog2(27);

When performing static initialisation, the compiler will report "error:
initializer element is not constant" if asked to take a log of zero or of
something not reducible to a constant.  They treat negative numbers as
unsigned.

When not dealing with a constant, they fall back to using fls() which permits
them to use arch-specific log calculation instructions - such as BSR on
x86/x86_64 or SCAN on FRV - if available.

[akpm@osdl.org: MMC fix]
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Howells <dhowells@redhat.com>
Cc: Wojtek Kaniewski <wojtekka@toxygen.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/alpha/Kconfig                           |    8 +
 arch/arm/Kconfig                             |    8 +
 arch/arm26/Kconfig                           |    8 +
 arch/avr32/Kconfig                           |    8 +
 arch/cris/Kconfig                            |    8 +
 arch/frv/Kconfig                             |    8 +
 arch/h8300/Kconfig                           |    8 +
 arch/i386/Kconfig.cpu                        |    8 +
 arch/ia64/Kconfig                            |    8 +
 arch/m32r/Kconfig                            |    8 +
 arch/m68k/Kconfig                            |    8 +
 arch/m68knommu/Kconfig                       |    8 +
 arch/mips/Kconfig                            |    8 +
 arch/parisc/Kconfig                          |    8 +
 arch/powerpc/Kconfig                         |    8 +
 arch/ppc/Kconfig                             |    8 +
 arch/s390/Kconfig                            |    8 +
 arch/sh/Kconfig                              |    8 +
 arch/sh64/Kconfig                            |    8 +
 arch/sparc/Kconfig                           |    8 +
 arch/sparc64/Kconfig                         |    8 +
 arch/v850/Kconfig                            |    8 +
 arch/x86_64/Kconfig                          |    8 +
 arch/xtensa/Kconfig                          |    8 +
 drivers/infiniband/hw/mthca/mthca_provider.c |    4 
 drivers/infiniband/hw/mthca/mthca_qp.c       |    4 
 drivers/infiniband/hw/mthca/mthca_srq.c      |    4 
 drivers/infiniband/ulp/iser/iser_memory.c    |    4 
 drivers/md/dm-crypt.c                        |    2 
 drivers/mmc/tifm_sd.c                        |    2 
 fs/ext2/super.c                              |    6 
 fs/ext3/super.c                              |    6 
 include/asm-frv/bitops.h                     |   44 +++++
 include/linux/kernel.h                       |    9 -
 include/linux/log2.h                         |  131 +++++++++++++++++
 mm/page_alloc.c                              |    4 
 36 files changed, 384 insertions(+), 28 deletions(-)

diff -puN arch/alpha/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/arch/alpha/Kconfig
@@ -25,6 +25,14 @@ config RWSEM_XCHGADD_ALGORITHM
 	bool
 	default y
 
+config ARCH_HAS_ILOG2_U32
+	bool
+	default n
+
+config ARCH_HAS_ILOG2_U64
+	bool
+	default n
+
 config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
diff -puN arch/arm/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel arch/arm/Kconfig
--- a/arch/arm/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/arch/arm/Kconfig
@@ -74,6 +74,14 @@ config RWSEM_GENERIC_SPINLOCK
 config RWSEM_XCHGADD_ALGORITHM
 	bool
 
+config ARCH_HAS_ILOG2_U32
+	bool
+	default n
+
+config ARCH_HAS_ILOG2_U64
+	bool
+	default n
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff -puN arch/arm26/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel arch/arm26/Kconfig
--- a/arch/arm26/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/arch/arm26/Kconfig
@@ -41,6 +41,14 @@ config RWSEM_GENERIC_SPINLOCK
 config RWSEM_XCHGADD_ALGORITHM
 	bool
 
+config ARCH_HAS_ILOG2_U32
+	bool
+	default n
+
+config ARCH_HAS_ILOG2_U64
+	bool
+	default n
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff -puN arch/avr32/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel arch/avr32/Kconfig
--- a/arch/avr32/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/arch/avr32/Kconfig
@@ -45,6 +45,14 @@ config GENERIC_TIME
 config RWSEM_XCHGADD_ALGORITHM
 	bool
 
+config ARCH_HAS_ILOG2_U32
+	bool
+	default n
+
+config ARCH_HAS_ILOG2_U64
+	bool
+	default n
+
 config GENERIC_BUST_SPINLOCK
 	bool
 
diff -puN arch/cris/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel arch/cris/Kconfig
--- a/arch/cris/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/arch/cris/Kconfig
@@ -16,6 +16,14 @@ config RWSEM_GENERIC_SPINLOCK
 config RWSEM_XCHGADD_ALGORITHM
 	bool
 
+config ARCH_HAS_ILOG2_U32
+	bool
+	default n
+
+config ARCH_HAS_ILOG2_U64
+	bool
+	default n
+
 config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
diff -puN arch/frv/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel arch/frv/Kconfig
--- a/arch/frv/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/arch/frv/Kconfig
@@ -41,6 +41,14 @@ config TIME_LOW_RES
 	bool
 	default y
 
+config ARCH_HAS_ILOG2_U32
+	bool
+	default y
+
+config ARCH_HAS_ILOG2_U64
+	bool
+	default y
+
 mainmenu "Fujitsu FR-V Kernel Configuration"
 
 source "init/Kconfig"
diff -puN arch/h8300/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel arch/h8300/Kconfig
--- a/arch/h8300/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/arch/h8300/Kconfig
@@ -29,6 +29,14 @@ config RWSEM_XCHGADD_ALGORITHM
 	bool
 	default n
 
+config ARCH_HAS_ILOG2_U32
+	bool
+	default n
+
+config ARCH_HAS_ILOG2_U64
+	bool
+	default n
+
 config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
diff -puN arch/i386/Kconfig.cpu~log2-implement-a-general-integer-log2-facility-in-the-kernel arch/i386/Kconfig.cpu
--- a/arch/i386/Kconfig.cpu~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/arch/i386/Kconfig.cpu
@@ -248,6 +248,14 @@ config RWSEM_XCHGADD_ALGORITHM
 	depends on !M386
 	default y
 
+config ARCH_HAS_ILOG2_U32
+	bool
+	default n
+
+config ARCH_HAS_ILOG2_U64
+	bool
+	default n
+
 config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
diff -puN arch/ia64/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/arch/ia64/Kconfig
@@ -34,6 +34,14 @@ config RWSEM_XCHGADD_ALGORITHM
 	bool
 	default y
 
+config ARCH_HAS_ILOG2_U32
+	bool
+	default n
+
+config ARCH_HAS_ILOG2_U64
+	bool
+	default n
+
 config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
diff -puN arch/m32r/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/arch/m32r/Kconfig
@@ -214,6 +214,14 @@ config RWSEM_XCHGADD_ALGORITHM
 	bool
 	default n
 
+config ARCH_HAS_ILOG2_U32
+	bool
+	default n
+
+config ARCH_HAS_ILOG2_U64
+	bool
+	default n
+
 config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
diff -puN arch/m68k/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/arch/m68k/Kconfig
@@ -17,6 +17,14 @@ config RWSEM_GENERIC_SPINLOCK
 config RWSEM_XCHGADD_ALGORITHM
 	bool
 
+config ARCH_HAS_ILOG2_U32
+	bool
+	default n
+
+config ARCH_HAS_ILOG2_U64
+	bool
+	default n
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff -puN arch/m68knommu/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel arch/m68knommu/Kconfig
--- a/arch/m68knommu/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/arch/m68knommu/Kconfig
@@ -25,6 +25,14 @@ config RWSEM_XCHGADD_ALGORITHM
 	bool
 	default n
 
+config ARCH_HAS_ILOG2_U32
+	bool
+	default n
+
+config ARCH_HAS_ILOG2_U64
+	bool
+	default n
+
 config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
diff -puN arch/mips/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel arch/mips/Kconfig
--- a/arch/mips/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/arch/mips/Kconfig
@@ -819,6 +819,14 @@ config RWSEM_GENERIC_SPINLOCK
 config RWSEM_XCHGADD_ALGORITHM
 	bool
 
+config ARCH_HAS_ILOG2_U32
+	bool
+	default n
+
+config ARCH_HAS_ILOG2_U64
+	bool
+	default n
+
 config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
diff -puN arch/parisc/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/arch/parisc/Kconfig
@@ -25,6 +25,14 @@ config RWSEM_GENERIC_SPINLOCK
 config RWSEM_XCHGADD_ALGORITHM
 	bool
 
+config ARCH_HAS_ILOG2_U32
+	bool
+	default n
+
+config ARCH_HAS_ILOG2_U64
+	bool
+	default n
+
 config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
diff -puN arch/powerpc/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/arch/powerpc/Kconfig
@@ -41,6 +41,14 @@ config RWSEM_XCHGADD_ALGORITHM
 	bool
 	default y
 
+config ARCH_HAS_ILOG2_U32
+	bool
+	default n
+
+config ARCH_HAS_ILOG2_U64
+	bool
+	default n
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff -puN arch/ppc/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel arch/ppc/Kconfig
--- a/arch/ppc/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/arch/ppc/Kconfig
@@ -19,6 +19,14 @@ config RWSEM_XCHGADD_ALGORITHM
 	bool
 	default y
 
+config ARCH_HAS_ILOG2_U32
+	bool
+	default y
+
+config ARCH_HAS_ILOG2_U64
+	bool
+	default n
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff -puN arch/s390/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel arch/s390/Kconfig
--- a/arch/s390/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/arch/s390/Kconfig
@@ -22,6 +22,14 @@ config RWSEM_XCHGADD_ALGORITHM
 	bool
 	default y
 
+config ARCH_HAS_ILOG2_U32
+	bool
+	default n
+
+config ARCH_HAS_ILOG2_U64
+	bool
+	default n
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff -puN arch/sh/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel arch/sh/Kconfig
--- a/arch/sh/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/arch/sh/Kconfig
@@ -59,6 +59,14 @@ config LOCKDEP_SUPPORT
 	bool
 	default y
 
+config ARCH_HAS_ILOG2_U32
+	bool
+	default n
+
+config ARCH_HAS_ILOG2_U64
+	bool
+	default n
+
 source "init/Kconfig"
 
 menu "System type"
diff -puN arch/sh64/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel arch/sh64/Kconfig
--- a/arch/sh64/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/arch/sh64/Kconfig
@@ -39,6 +39,14 @@ config RWSEM_XCHGADD_ALGORITHM
 config GENERIC_ISA_DMA
 	bool
 
+config ARCH_HAS_ILOG2_U32
+	bool
+	default n
+
+config ARCH_HAS_ILOG2_U64
+	bool
+	default n
+
 source init/Kconfig
 
 menu "System type"
diff -puN arch/sparc/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/arch/sparc/Kconfig
@@ -166,6 +166,14 @@ config ARCH_MAY_HAVE_PC_FDC
 	bool
 	default y
 
+config ARCH_HAS_ILOG2_U32
+	bool
+	default n
+
+config ARCH_HAS_ILOG2_U64
+	bool
+	default n
+
 config SUN_PM
 	bool
 	default y
diff -puN arch/sparc64/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel arch/sparc64/Kconfig
--- a/arch/sparc64/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/arch/sparc64/Kconfig
@@ -34,6 +34,14 @@ config ARCH_MAY_HAVE_PC_FDC
 	bool
 	default y
 
+config ARCH_HAS_ILOG2_U32
+	bool
+	default n
+
+config ARCH_HAS_ILOG2_U64
+	bool
+	default n
+
 config AUDIT_ARCH
 	bool
 	default y
diff -puN arch/v850/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel arch/v850/Kconfig
--- a/arch/v850/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/arch/v850/Kconfig
@@ -38,6 +38,14 @@ config TIME_LOW_RES
 	bool
 	default y
 
+config ARCH_HAS_ILOG2_U32
+	bool
+	default n
+
+config ARCH_HAS_ILOG2_U64
+	bool
+	default n
+
 # Turn off some random 386 crap that can affect device config
 config ISA
 	bool
diff -puN arch/x86_64/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/arch/x86_64/Kconfig
@@ -101,6 +101,14 @@ config GENERIC_BUG
 	default y
 	depends on BUG
 
+config ARCH_HAS_ILOG2_U32
+	bool
+	default n
+
+config ARCH_HAS_ILOG2_U64
+	bool
+	default n
+
 source "init/Kconfig"
 
 
diff -puN arch/xtensa/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel arch/xtensa/Kconfig
--- a/arch/xtensa/Kconfig~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/arch/xtensa/Kconfig
@@ -34,6 +34,14 @@ config GENERIC_HARDIRQS
 	bool
 	default y
 
+config ARCH_HAS_ILOG2_U32
+	bool
+	default n
+
+config ARCH_HAS_ILOG2_U64
+	bool
+	default n
+
 source "init/Kconfig"
 
 menu "Processor type and features"
diff -puN drivers/infiniband/hw/mthca/mthca_provider.c~log2-implement-a-general-integer-log2-facility-in-the-kernel drivers/infiniband/hw/mthca/mthca_provider.c
--- a/drivers/infiniband/hw/mthca/mthca_provider.c~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -124,7 +124,7 @@ static int mthca_query_device(struct ib_
 		props->max_map_per_fmr = 255;
 	else
 		props->max_map_per_fmr =
-			(1 << (32 - long_log2(mdev->limits.num_mpts))) - 1;
+			(1 << (32 - ilog2(mdev->limits.num_mpts))) - 1;
 
 	err = 0;
  out:
@@ -816,7 +816,7 @@ static int mthca_resize_cq(struct ib_cq 
 		lkey = ucmd.lkey;
 	}
 
-	ret = mthca_RESIZE_CQ(dev, cq->cqn, lkey, long_log2(entries), &status);
+	ret = mthca_RESIZE_CQ(dev, cq->cqn, lkey, ilog2(entries), &status);
 	if (status)
 		ret = -EINVAL;
 
diff -puN drivers/infiniband/hw/mthca/mthca_qp.c~log2-implement-a-general-integer-log2-facility-in-the-kernel drivers/infiniband/hw/mthca/mthca_qp.c
--- a/drivers/infiniband/hw/mthca/mthca_qp.c~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/drivers/infiniband/hw/mthca/mthca_qp.c
@@ -636,11 +636,11 @@ int mthca_modify_qp(struct ib_qp *ibqp, 
 
 	if (mthca_is_memfree(dev)) {
 		if (qp->rq.max)
-			qp_context->rq_size_stride = long_log2(qp->rq.max) << 3;
+			qp_context->rq_size_stride = ilog2(qp->rq.max) << 3;
 		qp_context->rq_size_stride |= qp->rq.wqe_shift - 4;
 
 		if (qp->sq.max)
-			qp_context->sq_size_stride = long_log2(qp->sq.max) << 3;
+			qp_context->sq_size_stride = ilog2(qp->sq.max) << 3;
 		qp_context->sq_size_stride |= qp->sq.wqe_shift - 4;
 	}
 
diff -puN drivers/infiniband/hw/mthca/mthca_srq.c~log2-implement-a-general-integer-log2-facility-in-the-kernel drivers/infiniband/hw/mthca/mthca_srq.c
--- a/drivers/infiniband/hw/mthca/mthca_srq.c~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/drivers/infiniband/hw/mthca/mthca_srq.c
@@ -120,7 +120,7 @@ static void mthca_arbel_init_srq_context
 
 	memset(context, 0, sizeof *context);
 
-	logsize = long_log2(srq->max);
+	logsize = ilog2(srq->max);
 	context->state_logsize_srqn = cpu_to_be32(logsize << 24 | srq->srqn);
 	context->lkey = cpu_to_be32(srq->mr.ibmr.lkey);
 	context->db_index = cpu_to_be32(srq->db_index);
@@ -213,7 +213,7 @@ int mthca_alloc_srq(struct mthca_dev *de
 	if (!mthca_is_memfree(dev) && (ds > dev->limits.max_desc_sz))
 		return -EINVAL;
 
-	srq->wqe_shift = long_log2(ds);
+	srq->wqe_shift = ilog2(ds);
 
 	srq->srqn = mthca_alloc(&dev->srq_table.alloc);
 	if (srq->srqn == -1)
diff -puN drivers/infiniband/ulp/iser/iser_memory.c~log2-implement-a-general-integer-log2-facility-in-the-kernel drivers/infiniband/ulp/iser/iser_memory.c
--- a/drivers/infiniband/ulp/iser/iser_memory.c~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/drivers/infiniband/ulp/iser/iser_memory.c
@@ -114,7 +114,7 @@ int iser_start_rdma_unaligned_sg(struct 
 
 	if (cmd_data_len > ISER_KMALLOC_THRESHOLD)
 		mem = (void *)__get_free_pages(GFP_NOIO,
-		      long_log2(roundup_pow_of_two(cmd_data_len)) - PAGE_SHIFT);
+		      ilog2(roundup_pow_of_two(cmd_data_len)) - PAGE_SHIFT);
 	else
 		mem = kmalloc(cmd_data_len, GFP_NOIO);
 
@@ -211,7 +211,7 @@ void iser_finalize_rdma_unaligned_sg(str
 
 	if (cmd_data_len > ISER_KMALLOC_THRESHOLD)
 		free_pages((unsigned long)mem_copy->copy_buf,
-			   long_log2(roundup_pow_of_two(cmd_data_len)) - PAGE_SHIFT);
+			   ilog2(roundup_pow_of_two(cmd_data_len)) - PAGE_SHIFT);
 	else
 		kfree(mem_copy->copy_buf);
 
diff -puN drivers/md/dm-crypt.c~log2-implement-a-general-integer-log2-facility-in-the-kernel drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/drivers/md/dm-crypt.c
@@ -220,7 +220,7 @@ static int crypt_iv_benbi_ctr(struct cry
 			      const char *opts)
 {
 	unsigned int bs = crypto_blkcipher_blocksize(cc->tfm);
-	int log = long_log2(bs);
+	int log = ilog2(bs);
 
 	/* we need to calculate how far we must shift the sector count
 	 * to get the cipher block count, we use this shift in _gen */
diff -puN drivers/mmc/tifm_sd.c~log2-implement-a-general-integer-log2-facility-in-the-kernel drivers/mmc/tifm_sd.c
--- a/drivers/mmc/tifm_sd.c~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/drivers/mmc/tifm_sd.c
@@ -387,7 +387,7 @@ static void tifm_sd_prepare_data(struct 
 
 	writel(TIFM_FIFO_INT_SETALL,
 		sock->addr + SOCK_DMA_FIFO_INT_ENABLE_CLEAR);
-	writel(long_log2(cmd->data->blksz) - 2,
+	writel(ilog2(cmd->data->blksz) - 2,
 			sock->addr + SOCK_FIFO_PAGE_SIZE);
 	writel(TIFM_FIFO_ENABLE, sock->addr + SOCK_FIFO_CONTROL);
 	writel(TIFM_FIFO_INTMASK, sock->addr + SOCK_DMA_FIFO_INT_ENABLE_SET);
diff -puN fs/ext2/super.c~log2-implement-a-general-integer-log2-facility-in-the-kernel fs/ext2/super.c
--- a/fs/ext2/super.c~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/fs/ext2/super.c
@@ -597,8 +597,6 @@ static int ext2_check_descriptors (struc
 	return 1;
 }
 
-#define log2(n) ffz(~(n))
- 
 /*
  * Maximal file size.  There is a direct, and {,double-,triple-}indirect
  * block limit, and also a limit of (2^32 - 1) 512-byte sectors in i_blocks.
@@ -834,9 +832,9 @@ static int ext2_fill_super(struct super_
 	sbi->s_sbh = bh;
 	sbi->s_mount_state = le16_to_cpu(es->s_state);
 	sbi->s_addr_per_block_bits =
-		log2 (EXT2_ADDR_PER_BLOCK(sb));
+		ilog2 (EXT2_ADDR_PER_BLOCK(sb));
 	sbi->s_desc_per_block_bits =
-		log2 (EXT2_DESC_PER_BLOCK(sb));
+		ilog2 (EXT2_DESC_PER_BLOCK(sb));
 
 	if (sb->s_magic != EXT2_SUPER_MAGIC)
 		goto cantfind_ext2;
diff -puN fs/ext3/super.c~log2-implement-a-general-integer-log2-facility-in-the-kernel fs/ext3/super.c
--- a/fs/ext3/super.c~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/fs/ext3/super.c
@@ -1347,8 +1347,6 @@ static void ext3_orphan_cleanup (struct 
 	sb->s_flags = s_flags; /* Restore MS_RDONLY status */
 }
 
-#define log2(n) ffz(~(n))
-
 /*
  * Maximal file size.  There is a direct, and {,double-,triple-}indirect
  * block limit, and also a limit of (2^32 - 1) 512-byte sectors in i_blocks.
@@ -1597,8 +1595,8 @@ static int ext3_fill_super (struct super
 	sbi->s_desc_per_block = blocksize / sizeof(struct ext3_group_desc);
 	sbi->s_sbh = bh;
 	sbi->s_mount_state = le16_to_cpu(es->s_state);
-	sbi->s_addr_per_block_bits = log2(EXT3_ADDR_PER_BLOCK(sb));
-	sbi->s_desc_per_block_bits = log2(EXT3_DESC_PER_BLOCK(sb));
+	sbi->s_addr_per_block_bits = ilog2(EXT3_ADDR_PER_BLOCK(sb));
+	sbi->s_desc_per_block_bits = ilog2(EXT3_DESC_PER_BLOCK(sb));
 	for (i=0; i < 4; i++)
 		sbi->s_hash_seed[i] = le32_to_cpu(es->s_hash_seed[i]);
 	sbi->s_def_hash_version = es->s_def_hash_version;
diff -puN include/asm-frv/bitops.h~log2-implement-a-general-integer-log2-facility-in-the-kernel include/asm-frv/bitops.h
--- a/include/asm-frv/bitops.h~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/include/asm-frv/bitops.h
@@ -256,6 +256,50 @@ int __ffs(unsigned long x)
 	return 31 - bit;
 }
 
+/*
+ * special slimline version of fls() for calculating ilog2_u32()
+ * - note: no protection against n == 0
+ */
+#define ARCH_HAS_ILOG2_U32
+static inline __attribute__((const))
+int __ilog2_u32(u32 n)
+{
+	int bit;
+	asm("scan %1,gr0,%0" : "=r"(bit) : "r"(n));
+	return 31 - bit;
+}
+
+/*
+ * special slimline version of fls64() for calculating ilog2_u64()
+ * - note: no protection against n == 0
+ */
+#define ARCH_HAS_ILOG2_U64
+static inline __attribute__((const))
+int __ilog2_u64(u64 n)
+{
+	union {
+		u64 ll;
+		struct { u32 h, l; };
+	} _;
+	int bit, x, y;
+
+	_.ll = n;
+
+	asm("	subcc		%3,gr0,gr0,icc0		\n"
+	    "	ckeq		icc0,cc4		\n"
+	    "	cscan.p		%3,gr0,%0	,cc4,0	\n"
+	    "   setlos		#63,%1			\n"
+	    "	cscan.p		%4,gr0,%0	,cc4,1	\n"
+	    "   setlos		#31,%2			\n"
+	    "	csub.p		%1,%0,%0	,cc4,0	\n"
+	    "	csub		%2,%0,%0	,cc4,1	\n"
+	    : "=&r"(bit), "=r"(x), "=r"(y)
+	    : "0r"(_.h), "r"(_.l)
+	    : "icc0", "cc4"
+	    );
+	return bit;
+}
+
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/hweight.h>
 
diff -puN include/linux/kernel.h~log2-implement-a-general-integer-log2-facility-in-the-kernel include/linux/kernel.h
--- a/include/linux/kernel.h~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/include/linux/kernel.h
@@ -13,6 +13,7 @@
 #include <linux/types.h>
 #include <linux/compiler.h>
 #include <linux/bitops.h>
+#include <linux/log2.h>
 #include <asm/byteorder.h>
 #include <asm/bug.h>
 
@@ -157,14 +158,6 @@ static inline int printk(const char *s, 
 
 unsigned long int_sqrt(unsigned long);
 
-static inline int __attribute_pure__ long_log2(unsigned long x)
-{
-	int r = 0;
-	for (x >>= 1; x > 0; x >>= 1)
-		r++;
-	return r;
-}
-
 static inline unsigned long
 __attribute_const__ roundup_pow_of_two(unsigned long x)
 {
diff -puN /dev/null include/linux/log2.h
--- /dev/null
+++ a/include/linux/log2.h
@@ -0,0 +1,131 @@
+/* Integer base 2 logarithm calculation
+ *
+ * Copyright (C) 2006 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _LINUX_LOG2_H
+#define _LINUX_LOG2_H
+
+#include <linux/types.h>
+#include <linux/bitops.h>
+
+/*
+ * deal with unrepresentable constant logarithms
+ */
+extern __attribute__((const, noreturn))
+int ____ilog2_NaN(void);
+
+/*
+ * non-constant log of base 2 calculators
+ * - the arch may override these in asm/bitops.h if they can be implemented
+ *   more efficiently than using fls() and fls64()
+ * - the arch is not required to handle n==0 if implementing the fallback
+ */
+#ifndef CONFIG_ARCH_HAS_ILOG2_U32
+static inline __attribute__((const))
+int __ilog2_u32(u32 n)
+{
+	return fls(n) - 1;
+}
+#endif
+
+#ifndef CONFIG_ARCH_HAS_ILOG2_U64
+static inline __attribute__((const))
+int __ilog2_u64(u64 n)
+{
+	return fls64(n) - 1;
+}
+#endif
+
+/**
+ * ilog2 - log of base 2 of 32-bit or a 64-bit unsigned value
+ * @n - parameter
+ *
+ * constant-capable log of base 2 calculation
+ * - this can be used to initialise global variables from constant data, hence
+ *   the massive ternary operator construction
+ *
+ * selects the appropriately-sized optimised version depending on sizeof(n)
+ */
+#define ilog2(n)				\
+(						\
+	__builtin_constant_p(n) ? (		\
+		(n) < 1 ? ____ilog2_NaN() :	\
+		(n) & (1ULL << 63) ? 63 :	\
+		(n) & (1ULL << 62) ? 62 :	\
+		(n) & (1ULL << 61) ? 61 :	\
+		(n) & (1ULL << 60) ? 60 :	\
+		(n) & (1ULL << 59) ? 59 :	\
+		(n) & (1ULL << 58) ? 58 :	\
+		(n) & (1ULL << 57) ? 57 :	\
+		(n) & (1ULL << 56) ? 56 :	\
+		(n) & (1ULL << 55) ? 55 :	\
+		(n) & (1ULL << 54) ? 54 :	\
+		(n) & (1ULL << 53) ? 53 :	\
+		(n) & (1ULL << 52) ? 52 :	\
+		(n) & (1ULL << 51) ? 51 :	\
+		(n) & (1ULL << 50) ? 50 :	\
+		(n) & (1ULL << 49) ? 49 :	\
+		(n) & (1ULL << 48) ? 48 :	\
+		(n) & (1ULL << 47) ? 47 :	\
+		(n) & (1ULL << 46) ? 46 :	\
+		(n) & (1ULL << 45) ? 45 :	\
+		(n) & (1ULL << 44) ? 44 :	\
+		(n) & (1ULL << 43) ? 43 :	\
+		(n) & (1ULL << 42) ? 42 :	\
+		(n) & (1ULL << 41) ? 41 :	\
+		(n) & (1ULL << 40) ? 40 :	\
+		(n) & (1ULL << 39) ? 39 :	\
+		(n) & (1ULL << 38) ? 38 :	\
+		(n) & (1ULL << 37) ? 37 :	\
+		(n) & (1ULL << 36) ? 36 :	\
+		(n) & (1ULL << 35) ? 35 :	\
+		(n) & (1ULL << 34) ? 34 :	\
+		(n) & (1ULL << 33) ? 33 :	\
+		(n) & (1ULL << 32) ? 32 :	\
+		(n) & (1ULL << 31) ? 31 :	\
+		(n) & (1ULL << 30) ? 30 :	\
+		(n) & (1ULL << 29) ? 29 :	\
+		(n) & (1ULL << 28) ? 28 :	\
+		(n) & (1ULL << 27) ? 27 :	\
+		(n) & (1ULL << 26) ? 26 :	\
+		(n) & (1ULL << 25) ? 25 :	\
+		(n) & (1ULL << 24) ? 24 :	\
+		(n) & (1ULL << 23) ? 23 :	\
+		(n) & (1ULL << 22) ? 22 :	\
+		(n) & (1ULL << 21) ? 21 :	\
+		(n) & (1ULL << 20) ? 20 :	\
+		(n) & (1ULL << 19) ? 19 :	\
+		(n) & (1ULL << 18) ? 18 :	\
+		(n) & (1ULL << 17) ? 17 :	\
+		(n) & (1ULL << 16) ? 16 :	\
+		(n) & (1ULL << 15) ? 15 :	\
+		(n) & (1ULL << 14) ? 14 :	\
+		(n) & (1ULL << 13) ? 13 :	\
+		(n) & (1ULL << 12) ? 12 :	\
+		(n) & (1ULL << 11) ? 11 :	\
+		(n) & (1ULL << 10) ? 10 :	\
+		(n) & (1ULL <<  9) ?  9 :	\
+		(n) & (1ULL <<  8) ?  8 :	\
+		(n) & (1ULL <<  7) ?  7 :	\
+		(n) & (1ULL <<  6) ?  6 :	\
+		(n) & (1ULL <<  5) ?  5 :	\
+		(n) & (1ULL <<  4) ?  4 :	\
+		(n) & (1ULL <<  3) ?  3 :	\
+		(n) & (1ULL <<  2) ?  2 :	\
+		(n) & (1ULL <<  1) ?  1 :	\
+		(n) & (1ULL <<  0) ?  0 :	\
+		____ilog2_NaN()			\
+				   ) :		\
+	(sizeof(n) <= 4) ?			\
+	__ilog2_u32(n) :			\
+	__ilog2_u64(n)				\
+ )
+
+#endif /* _LINUX_LOG2_H */
diff -puN mm/page_alloc.c~log2-implement-a-general-integer-log2-facility-in-the-kernel mm/page_alloc.c
--- a/mm/page_alloc.c~log2-implement-a-general-integer-log2-facility-in-the-kernel
+++ a/mm/page_alloc.c
@@ -3244,7 +3244,7 @@ void *__init alloc_large_system_hash(con
 	if (numentries > max)
 		numentries = max;
 
-	log2qty = long_log2(numentries);
+	log2qty = ilog2(numentries);
 
 	do {
 		size = bucketsize << log2qty;
@@ -3266,7 +3266,7 @@ void *__init alloc_large_system_hash(con
 	printk("%s hash table entries: %d (order: %d, %lu bytes)\n",
 	       tablename,
 	       (1U << log2qty),
-	       long_log2(size) - PAGE_SHIFT,
+	       ilog2(size) - PAGE_SHIFT,
 	       size);
 
 	if (_hash_shift)
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel.patch
log2-alter-roundup_pow_of_two-so-that-it-can-use-a-ilog2-on-a-constant.patch
log2-alter-get_order-so-that-it-can-make-use-of-ilog2-on-a-constant.patch
log2-provide-ilog2-fallbacks-for-powerpc.patch
alsa-workqueue-fixes.patch
nfs-represent-64-bit-fileids-as-64-bit-inode-numbers-on-32-bit-systems.patch
s390-workqueue-fixes.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
ecryptfs-public-key-transport-mechanism.patch
ecryptfs-public-key-packet-management.patch
workstruct-implement-generic-up-cmpxchg-where-an-arch-doesnt-support-it.patch
workqueue-tweaks.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
reiser4-get_sb_dev-fix.patch
mutex-subsystem-synchro-test-module.patch


From: akpm@linux-foundation.org
Subject: [withdrawn]
 scatterlist-enable-sg-chaining-for-all-architectures.patch removed from -mm tree
Date: Tue, 28 Apr 2015 18:51:59 -0700
Message-ID: <5540393f.+oWjGfYccrq51rM6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37942 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031315AbbD2Bp3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Apr 2015 21:45:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, JBottomley@odin.com, arnd@arndb.de, hch@lst.de, linux-arch@vger.kernel.org, nab@linux-iscsi.org, target-devel@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: scatterlist: enable sg chaining for all architectures
has been removed from the -mm tree.  Its filename was
     scatterlist-enable-sg-chaining-for-all-architectures.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: scatterlist: enable sg chaining for all architectures

Some architectures enable the sg chaining option while others do not.

The requirement to enable sg chaining is that pages must be aligned at a
32-bit boundary in order to overload the LSB of the pointer.  Regardless
of whether ARCH_HAS_SG_CHAIN is defined or not, the above requirement is
always checked by a BUG_ON() in sg_assign_page.  So all architectures can
enable sg chaining.

As you can see from the changes in drivers/target/target_core_rd.c,
enabling SG chaining for all architectures allows us to allocate
discontiguous scatterlist tables which can be traversed throughout by
sg_next() without special handling for some architectures.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Nicholas A. Bellinger <nab@linux-iscsi.org>
Cc: <linux-arch@vger.kernel.org>
Cc: <target-devel@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig                |    6 ----
 arch/arm64/Kconfig              |    1 
 arch/ia64/Kconfig               |    1 
 arch/powerpc/Kconfig            |    1 
 arch/s390/Kconfig               |    1 
 arch/sparc/Kconfig              |    1 
 arch/x86/Kconfig                |    1 
 drivers/target/target_core_rd.c |   45 ------------------------------
 include/linux/scatterlist.h     |    4 --
 include/scsi/scsi.h             |    8 +----
 lib/Kconfig                     |    7 ----
 lib/scatterlist.c               |    8 -----
 12 files changed, 2 insertions(+), 82 deletions(-)

diff -puN arch/arm/Kconfig~scatterlist-enable-sg-chaining-for-all-architectures arch/arm/Kconfig
--- a/arch/arm/Kconfig~scatterlist-enable-sg-chaining-for-all-architectures
+++ a/arch/arm/Kconfig
@@ -89,16 +89,11 @@ config ARM
 	  Europe.  There is an ARM Linux project with a web page at
 	  <http://www.arm.linux.org.uk/>.
 
-config ARM_HAS_SG_CHAIN
-	select ARCH_HAS_SG_CHAIN
-	bool
-
 config NEED_SG_DMA_LENGTH
 	bool
 
 config ARM_DMA_USE_IOMMU
 	bool
-	select ARM_HAS_SG_CHAIN
 	select NEED_SG_DMA_LENGTH
 
 if ARM_DMA_USE_IOMMU
@@ -318,7 +313,6 @@ config ARCH_MULTIPLATFORM
 	bool "Allow multiple platforms to be selected"
 	depends on MMU
 	select ARCH_WANT_OPTIONAL_GPIOLIB
-	select ARM_HAS_SG_CHAIN
 	select ARM_PATCH_PHYS_VIRT
 	select AUTO_ZRELADDR
 	select CLKSRC_OF
diff -puN arch/arm64/Kconfig~scatterlist-enable-sg-chaining-for-all-architectures arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~scatterlist-enable-sg-chaining-for-all-architectures
+++ a/arch/arm64/Kconfig
@@ -5,7 +5,6 @@ config ARM64
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_GCOV_PROFILE_ALL
-	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select ARCH_SUPPORTS_ATOMIC_RMW
diff -puN arch/ia64/Kconfig~scatterlist-enable-sg-chaining-for-all-architectures arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~scatterlist-enable-sg-chaining-for-all-architectures
+++ a/arch/ia64/Kconfig
@@ -32,7 +32,6 @@ config IA64
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_VIRT_CPU_ACCOUNTING
-	select ARCH_HAS_SG_CHAIN
 	select VIRT_TO_BUS
 	select ARCH_DISCARD_MEMBLOCK
 	select GENERIC_IRQ_PROBE
diff -puN arch/powerpc/Kconfig~scatterlist-enable-sg-chaining-for-all-architectures arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~scatterlist-enable-sg-chaining-for-all-architectures
+++ a/arch/powerpc/Kconfig
@@ -112,7 +112,6 @@ config PPC
 	select HAVE_DMA_API_DEBUG
 	select HAVE_OPROFILE
 	select HAVE_DEBUG_KMEMLEAK
-	select ARCH_HAS_SG_CHAIN
 	select GENERIC_ATOMIC64 if PPC32
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select HAVE_PERF_EVENTS
diff -puN arch/s390/Kconfig~scatterlist-enable-sg-chaining-for-all-architectures arch/s390/Kconfig
--- a/arch/s390/Kconfig~scatterlist-enable-sg-chaining-for-all-architectures
+++ a/arch/s390/Kconfig
@@ -67,7 +67,6 @@ config S390
 	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_GCOV_PROFILE_ALL
-	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select ARCH_INLINE_READ_LOCK
 	select ARCH_INLINE_READ_LOCK_BH
diff -puN arch/sparc/Kconfig~scatterlist-enable-sg-chaining-for-all-architectures arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~scatterlist-enable-sg-chaining-for-all-architectures
+++ a/arch/sparc/Kconfig
@@ -42,7 +42,6 @@ config SPARC
 	select MODULES_USE_ELF_RELA
 	select ODD_RT_SIGACTION
 	select OLD_SIGSUSPEND
-	select ARCH_HAS_SG_CHAIN
 
 config SPARC32
 	def_bool !64BIT
diff -puN arch/x86/Kconfig~scatterlist-enable-sg-chaining-for-all-architectures arch/x86/Kconfig
--- a/arch/x86/Kconfig~scatterlist-enable-sg-chaining-for-all-architectures
+++ a/arch/x86/Kconfig
@@ -102,7 +102,6 @@ config X86
 	select HAVE_BPF_JIT if X86_64
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select HAVE_ARCH_HUGE_VMAP if X86_64 || X86_PAE
-	select ARCH_HAS_SG_CHAIN
 	select CLKEVT_I8253
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_IOMAP
diff -puN drivers/target/target_core_rd.c~scatterlist-enable-sg-chaining-for-all-architectures drivers/target/target_core_rd.c
--- a/drivers/target/target_core_rd.c~scatterlist-enable-sg-chaining-for-all-architectures
+++ a/drivers/target/target_core_rd.c
@@ -144,16 +144,12 @@ static int rd_allocate_sgl_table(struct
 		sg_per_table = (total_sg_needed > max_sg_per_table) ?
 			max_sg_per_table : total_sg_needed;
 
-#ifdef CONFIG_ARCH_HAS_SG_CHAIN
-
 		/*
 		 * Reserve extra element for chain entry
 		 */
 		if (sg_per_table < total_sg_needed)
 			chain_entry = 1;
 
-#endif /* CONFIG_ARCH_HAS_SG_CHAIN */
-
 		sg = kcalloc(sg_per_table + chain_entry, sizeof(*sg),
 				GFP_KERNEL);
 		if (!sg) {
@@ -164,15 +160,11 @@ static int rd_allocate_sgl_table(struct
 
 		sg_init_table(sg, sg_per_table + chain_entry);
 
-#ifdef CONFIG_ARCH_HAS_SG_CHAIN
-
 		if (i > 0) {
 			sg_chain(sg_table[i - 1].sg_table,
 				 max_sg_per_table + 1, sg);
 		}
 
-#endif /* CONFIG_ARCH_HAS_SG_CHAIN */
-
 		sg_table[i].sg_table = sg;
 		sg_table[i].rd_sg_count = sg_per_table;
 		sg_table[i].page_start_offset = page_offset;
@@ -415,7 +407,6 @@ static sense_reason_t rd_do_prot_rw(stru
 	struct scatterlist *prot_sg;
 	u32 sectors = cmd->data_length / se_dev->dev_attrib.block_size;
 	u32 prot_offset, prot_page;
-	u32 prot_npages __maybe_unused;
 	u64 tmp;
 	sense_reason_t rc = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
@@ -430,42 +421,6 @@ static sense_reason_t rd_do_prot_rw(stru
 	prot_sg = &prot_table->sg_table[prot_page -
 					prot_table->page_start_offset];
 
-#ifndef CONFIG_ARCH_HAS_SG_CHAIN
-
-	prot_npages = DIV_ROUND_UP(prot_offset + sectors * se_dev->prot_length,
-				   PAGE_SIZE);
-
-	/*
-	 * Allocate temporaly contiguous scatterlist entries if prot pages
-	 * straddles multiple scatterlist tables.
-	 */
-	if (prot_table->page_end_offset < prot_page + prot_npages - 1) {
-		int i;
-
-		prot_sg = kcalloc(prot_npages, sizeof(*prot_sg), GFP_KERNEL);
-		if (!prot_sg)
-			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-
-		need_to_release = true;
-		sg_init_table(prot_sg, prot_npages);
-
-		for (i = 0; i < prot_npages; i++) {
-			if (prot_page + i > prot_table->page_end_offset) {
-				prot_table = rd_get_prot_table(dev,
-								prot_page + i);
-				if (!prot_table) {
-					kfree(prot_sg);
-					return rc;
-				}
-				sg_unmark_end(&prot_sg[i - 1]);
-			}
-			prot_sg[i] = prot_table->sg_table[prot_page + i -
-						prot_table->page_start_offset];
-		}
-	}
-
-#endif /* !CONFIG_ARCH_HAS_SG_CHAIN */
-
 	rc = dif_verify(cmd, cmd->t_task_lba, sectors, 0, prot_sg, prot_offset);
 	if (need_to_release)
 		kfree(prot_sg);
diff -puN include/linux/scatterlist.h~scatterlist-enable-sg-chaining-for-all-architectures include/linux/scatterlist.h
--- a/include/linux/scatterlist.h~scatterlist-enable-sg-chaining-for-all-architectures
+++ a/include/linux/scatterlist.h
@@ -136,10 +136,6 @@ static inline void sg_set_buf(struct sca
 static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
 			    struct scatterlist *sgl)
 {
-#ifndef CONFIG_ARCH_HAS_SG_CHAIN
-	BUG();
-#endif
-
 	/*
 	 * offset and length are unused for chain entry.  Clear them.
 	 */
diff -puN include/scsi/scsi.h~scatterlist-enable-sg-chaining-for-all-architectures include/scsi/scsi.h
--- a/include/scsi/scsi.h~scatterlist-enable-sg-chaining-for-all-architectures
+++ a/include/scsi/scsi.h
@@ -28,14 +28,10 @@ enum scsi_timeouts {
 #define SCSI_MAX_SG_SEGMENTS	128
 
 /*
- * Like SCSI_MAX_SG_SEGMENTS, but for archs that have sg chaining. This limit
- * is totally arbitrary, a setting of 2048 will get you at least 8mb ios.
+ * This limit is totally arbitrary, a setting of 2048 will get you at least
+ * 8mb ios.
  */
-#ifdef CONFIG_ARCH_HAS_SG_CHAIN
 #define SCSI_MAX_SG_CHAIN_SEGMENTS	2048
-#else
-#define SCSI_MAX_SG_CHAIN_SEGMENTS	SCSI_MAX_SG_SEGMENTS
-#endif
 
 /*
  * DIX-capable adapters effectively support infinite chaining for the
diff -puN lib/Kconfig~scatterlist-enable-sg-chaining-for-all-architectures lib/Kconfig
--- a/lib/Kconfig~scatterlist-enable-sg-chaining-for-all-architectures
+++ a/lib/Kconfig
@@ -522,11 +522,4 @@ config UCS2_STRING
 
 source "lib/fonts/Kconfig"
 
-#
-# sg chaining option
-#
-
-config ARCH_HAS_SG_CHAIN
-	def_bool n
-
 endmenu
diff -puN lib/scatterlist.c~scatterlist-enable-sg-chaining-for-all-architectures lib/scatterlist.c
--- a/lib/scatterlist.c~scatterlist-enable-sg-chaining-for-all-architectures
+++ a/lib/scatterlist.c
@@ -73,16 +73,12 @@ EXPORT_SYMBOL(sg_nents);
  **/
 struct scatterlist *sg_last(struct scatterlist *sgl, unsigned int nents)
 {
-#ifndef CONFIG_ARCH_HAS_SG_CHAIN
-	struct scatterlist *ret = &sgl[nents - 1];
-#else
 	struct scatterlist *sg, *ret = NULL;
 	unsigned int i;
 
 	for_each_sg(sgl, sg, nents, i)
 		ret = sg;
 
-#endif
 #ifdef CONFIG_DEBUG_SG
 	BUG_ON(sgl[0].sg_magic != SG_MAGIC);
 	BUG_ON(!sg_is_last(ret));
@@ -255,10 +251,6 @@ int __sg_alloc_table(struct sg_table *ta
 
 	if (nents == 0)
 		return -EINVAL;
-#ifndef CONFIG_ARCH_HAS_SG_CHAIN
-	if (WARN_ON_ONCE(nents > max_ents))
-		return -EINVAL;
-#endif
 
 	left = nents;
 	prv = NULL;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

lib-scatterlist-fix-kerneldoc-for-sg_pcopy_tofrom_buffer.patch


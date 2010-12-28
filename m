From: akpm@linux-foundation.org
Subject: [to-be-updated] percpu-add-new-macros-to-make-percpu-readmostly-section-correctly-align.patch removed from -mm tree
Date: Tue, 28 Dec 2010 13:59:11 -0800
Message-ID: <201012282159.oBSLxCTZ019481@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751788Ab0L1WAD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Dec 2010 17:00:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, eric.dumazet@gmail.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     percpu: add new macros to make percpu readmostly section correctly align
has been removed from the -mm tree.  Its filename was
     percpu-add-new-macros-to-make-percpu-readmostly-section-correctly-align.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: percpu: add new macros to make percpu readmostly section correctly align
From: Shaohua Li <shaohua.li@intel.com>

The percpu readmostly section should start and end at a cacheline aligned
address.  Idealy we should change PERCPU_VADDR/PERCPU, but I can't change
all arch code, so I add new macros for x86.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/vmlinux.lds.h |   66 ++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff -puN include/asm-generic/vmlinux.lds.h~percpu-add-new-macros-to-make-percpu-readmostly-section-correctly-align include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~percpu-add-new-macros-to-make-percpu-readmostly-section-correctly-align
+++ a/include/asm-generic/vmlinux.lds.h
@@ -726,6 +726,72 @@
 		VMLINUX_SYMBOL(__per_cpu_end) = .;			\
 	}
 
+/**
+ * PERCPU_VADDR_CACHEALIGNED - define output section for percpu area
+ * @vaddr: explicit base address (optional)
+ * @phdr: destination PHDR (optional)
+ * @cacheline: cachline size required by readmostly percpu data
+ *
+ * Macro which expands to output section for percpu area.  If @vaddr
+ * is not blank, it specifies explicit base address and all percpu
+ * symbols will be offset from the given address.  If blank, @vaddr
+ * always equals @laddr + LOAD_OFFSET.
+ *
+ * @phdr defines the output PHDR to use if not blank.  Be warned that
+ * output PHDR is sticky.  If @phdr is specified, the next output
+ * section in the linker script will go there too.  @phdr should have
+ * a leading colon.
+ *
+ * Note that this macros defines __per_cpu_load as an absolute symbol.
+ * If there is no need to put the percpu section at a predetermined
+ * address, use PERCPU_CACHEALIGNED().
+ */
+#define PERCPU_VADDR_CACHEALIGNED(vaddr, phdr, cacheline)		\
+	VMLINUX_SYMBOL(__per_cpu_load) = .;				\
+	.data..percpu vaddr : AT(VMLINUX_SYMBOL(__per_cpu_load)		\
+				- LOAD_OFFSET) {			\
+		VMLINUX_SYMBOL(__per_cpu_start) = .;			\
+		*(.data..percpu..first)					\
+		. = ALIGN(PAGE_SIZE);					\
+		*(.data..percpu..page_aligned)				\
+		. = ALIGN(cacheline);					\
+		*(.data..percpu..readmostly)				\
+		. = ALIGN(cacheline);					\
+		*(.data..percpu)					\
+		*(.data..percpu..shared_aligned)			\
+		VMLINUX_SYMBOL(__per_cpu_end) = .;			\
+	} phdr								\
+	. = VMLINUX_SYMBOL(__per_cpu_load) + SIZEOF(.data..percpu);
+
+/**
+ * PERCPU_CACHEALIGNED - define output section for percpu area, simple version
+ * @align: required alignment
+ * @cacheline: cachline size required by readmostly percpu data
+ *
+ * Align to @align and outputs output section for percpu area.  This
+ * macro doesn't maniuplate @vaddr or @phdr and __per_cpu_load and
+ * __per_cpu_start will be identical.
+ *
+ * This macro is equivalent to ALIGN(align); PERCPU_VADDR_CACHEALIGNED( , ) except
+ * that __per_cpu_load is defined as a relative symbol against
+ * .data..percpu which is required for relocatable x86_32
+ * configuration.
+ */
+#define PERCPU_CACHEALIGNED(align, cacheline)				\
+	. = ALIGN(align);						\
+	.data..percpu	: AT(ADDR(.data..percpu) - LOAD_OFFSET) {	\
+		VMLINUX_SYMBOL(__per_cpu_load) = .;			\
+		VMLINUX_SYMBOL(__per_cpu_start) = .;			\
+		*(.data..percpu..first)					\
+		. = ALIGN(PAGE_SIZE);					\
+		*(.data..percpu..page_aligned)				\
+		. = ALIGN(cacheline);					\
+		*(.data..percpu..readmostly)				\
+		. = ALIGN(cacheline);					\
+		*(.data..percpu)					\
+		*(.data..percpu..shared_aligned)			\
+		VMLINUX_SYMBOL(__per_cpu_end) = .;			\
+	}
 
 /*
  * Definition of the high level *_SECTION macros
_

Patches currently in -mm which might be from shaohua.li@intel.com are

linux-next.patch
mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low.patch
writeback-io-less-balance_dirty_pages.patch
writeback-consolidate-variable-names-in-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages-fix.patch
writeback-prevent-duplicate-balance_dirty_pages_ratelimited-calls.patch
writeback-account-per-bdi-accumulated-written-pages.patch
writeback-bdi-write-bandwidth-estimation.patch
writeback-bdi-write-bandwidth-estimation-fix.patch
writeback-show-bdi-write-bandwidth-in-debugfs.patch
writeback-quit-throttling-when-bdi-dirty-pages-dropped-low.patch
writeback-reduce-per-bdi-dirty-threshold-ramp-up-time.patch
writeback-make-reasonable-gap-between-the-dirty-background-thresholds.patch
writeback-scale-down-max-throttle-bandwidth-on-concurrent-dirtiers.patch
writeback-add-trace-event-for-balance_dirty_pages.patch
writeback-make-nr_to_write-a-per-file-limit.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
mm-kswapd-stop-high-order-balancing-when-any-suitable-zone-is-balanced.patch
mm-kswapd-keep-kswapd-awake-for-high-order-allocations-until-a-percentage-of-the-node-is-balanced.patch
mm-kswapd-use-the-order-that-kswapd-was-reclaiming-at-for-sleeping_prematurely.patch
mm-kswapd-reset-kswapd_max_order-and-classzone_idx-after-reading.patch
mm-kswapd-treat-zone-all_unreclaimable-in-sleeping_prematurely-similar-to-balance_pgdat.patch
mm-kswapd-use-the-classzone-idx-that-kswapd-was-using-for-sleeping_prematurely.patch
include-asm-generic-vmlinuxldsh-make-readmostly-section-correctly-align.patch


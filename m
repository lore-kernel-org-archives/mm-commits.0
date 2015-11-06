From: akpm@linux-foundation.org
Subject: [merged]
 uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:07:15 -0800
Message-ID: <563d0873.HIqknrsZqcStaUrT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48634 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757598AbbKFUHQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:07:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, deller@gmx.de, jdike@addtoit.com, jejb@parisc-linux.org, mingo@elte.hu, realmz6@gmail.com, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     Subject: uaccess: reimplement probe_kernel_address() using probe_kernel_read()
has been removed from the -mm tree.  Its filename was
     uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: uaccess: reimplement probe_kernel_address() using probe_kernel_read()

probe_kernel_address() is basically the same as the (later added)
probe_kernel_read().

The return value on EFAULT is a bit different: probe_kernel_address()
returns number-of-bytes-not-copied whereas probe_kernel_read() returns
-EFAULT.  All callers have been checked, none cared.

probe_kernel_read() can be overridden by the architecture whereas
probe_kernel_address() cannot.  parisc, blackfin and um do this, to insert
additional checking.  Hence this patch possibly fixes obscure bugs,
although there are only two probe_kernel_address() callsites outside
arch/.

My first attempt involved removing probe_kernel_address() entirely and
converting all callsites to use probe_kernel_read() directly, but that got
tiresome.

This patch shrinks mm/slab_common.o by 218 bytes.  For a single
probe_kernel_address() callsite.

Cc: Steven Miao <realmz6@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/alignment.c       |    2 -
 arch/powerpc/sysdev/fsl_pci.c |    2 -
 include/linux/uaccess.h       |   40 ++++++++------------------------
 mm/maccess.c                  |    5 ++++
 4 files changed, 17 insertions(+), 32 deletions(-)

diff -puN arch/arm/mm/alignment.c~uaccess-reimplement-probe_kernel_address-using-probe_kernel_read arch/arm/mm/alignment.c
--- a/arch/arm/mm/alignment.c~uaccess-reimplement-probe_kernel_address-using-probe_kernel_read
+++ a/arch/arm/mm/alignment.c
@@ -803,7 +803,7 @@ do_alignment(unsigned long addr, unsigne
 			}
 		}
 	} else {
-		fault = probe_kernel_address(instrptr, instr);
+		fault = probe_kernel_address((void *)instrptr, instr);
 		instr = __mem_to_opcode_arm(instr);
 	}
 
diff -puN arch/powerpc/sysdev/fsl_pci.c~uaccess-reimplement-probe_kernel_address-using-probe_kernel_read arch/powerpc/sysdev/fsl_pci.c
--- a/arch/powerpc/sysdev/fsl_pci.c~uaccess-reimplement-probe_kernel_address-using-probe_kernel_read
+++ a/arch/powerpc/sysdev/fsl_pci.c
@@ -999,7 +999,7 @@ int fsl_pci_mcheck_exception(struct pt_r
 			ret = get_user(regs->nip, &inst);
 			pagefault_enable();
 		} else {
-			ret = probe_kernel_address(regs->nip, inst);
+			ret = probe_kernel_address((void *)regs->nip, inst);
 		}
 
 		if (mcheck_handle_load(regs, inst)) {
diff -puN include/linux/uaccess.h~uaccess-reimplement-probe_kernel_address-using-probe_kernel_read include/linux/uaccess.h
--- a/include/linux/uaccess.h~uaccess-reimplement-probe_kernel_address-using-probe_kernel_read
+++ a/include/linux/uaccess.h
@@ -75,36 +75,6 @@ static inline unsigned long __copy_from_
 
 #endif		/* ARCH_HAS_NOCACHE_UACCESS */
 
-/**
- * probe_kernel_address(): safely attempt to read from a location
- * @addr: address to read from - its type is type typeof(retval)*
- * @retval: read into this variable
- *
- * Safely read from address @addr into variable @revtal.  If a kernel fault
- * happens, handle that and return -EFAULT.
- * We ensure that the __get_user() is executed in atomic context so that
- * do_page_fault() doesn't attempt to take mmap_sem.  This makes
- * probe_kernel_address() suitable for use within regions where the caller
- * already holds mmap_sem, or other locks which nest inside mmap_sem.
- * This must be a macro because __get_user() needs to know the types of the
- * args.
- *
- * We don't include enough header files to be able to do the set_fs().  We
- * require that the probe_kernel_address() caller will do that.
- */
-#define probe_kernel_address(addr, retval)		\
-	({						\
-		long ret;				\
-		mm_segment_t old_fs = get_fs();		\
-							\
-		set_fs(KERNEL_DS);			\
-		pagefault_disable();			\
-		ret = __copy_from_user_inatomic(&(retval), (__force typeof(retval) __user *)(addr), sizeof(retval));		\
-		pagefault_enable();			\
-		set_fs(old_fs);				\
-		ret;					\
-	})
-
 /*
  * probe_kernel_read(): safely attempt to read from a location
  * @dst: pointer to the buffer that shall take the data
@@ -131,4 +101,14 @@ extern long notrace __probe_kernel_write
 
 extern long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
 
+/**
+ * probe_kernel_address(): safely attempt to read from a location
+ * @addr: address to read from
+ * @retval: read into this variable
+ *
+ * Returns 0 on success, or -EFAULT.
+ */
+#define probe_kernel_address(addr, retval)		\
+	probe_kernel_read(&retval, addr, sizeof(retval))
+
 #endif		/* __LINUX_UACCESS_H__ */
diff -puN mm/maccess.c~uaccess-reimplement-probe_kernel_address-using-probe_kernel_read mm/maccess.c
--- a/mm/maccess.c~uaccess-reimplement-probe_kernel_address-using-probe_kernel_read
+++ a/mm/maccess.c
@@ -13,6 +13,11 @@
  *
  * Safely read from address @src to the buffer at @dst.  If a kernel fault
  * happens, handle that and return -EFAULT.
+ *
+ * We ensure that the copy_from_user is executed in atomic context so that
+ * do_page_fault() doesn't attempt to take mmap_sem.  This makes
+ * probe_kernel_read() suitable for use within regions where the caller
+ * already holds mmap_sem, or other locks which nest inside mmap_sem.
  */
 
 long __weak probe_kernel_read(void *dst, const void *src, size_t size)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmstatc-uninline-node_page_state.patch
mm-cmac-suppress-warning.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix-99.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix-fix.patch
include-linux-mmzoneh-reflow-comment.patch
mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes.patch
zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-hack.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
lib-documentation-synchronize-%p-formatting-documentation-fix-fix.patch
rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix.patch
dma-mapping-tidy-up-dma_parms-default-handling-fix.patch
panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix.patch
linux-next-rejects.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-arm-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-arm-fix-fix.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
remove-abs64-fix-fix.patch
remove-abs64-fix-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


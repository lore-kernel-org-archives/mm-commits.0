From: akpm@linux-foundation.org
Subject: +
 uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
 added to -mm tree
Date: Fri, 21 Aug 2015 13:57:14 -0700
Message-ID: <55d790aa.omnyGPsrGhmOUqSH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39796 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbbHUU5P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Aug 2015 16:57:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, deller@gmx.de, jdike@addtoit.com, jejb@parisc-linux.org, mingo@elte.hu, realmz6@gmail.com, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     Subject: uaccess: reimplement probe_kernel_address() using probe_kernel_read()
has been added to the -mm tree.  Its filename is
     uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 include/linux/uaccess.h |   40 +++++++++-----------------------------
 mm/maccess.c            |    5 ++++
 2 files changed, 15 insertions(+), 30 deletions(-)

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
@@ -129,4 +99,14 @@ extern long __probe_kernel_read(void *ds
 extern long notrace probe_kernel_write(void *dst, const void *src, size_t size);
 extern long notrace __probe_kernel_write(void *dst, const void *src, size_t size);
 
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

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
mm-make-page-pfmemalloc-check-more-robust-fix.patch
kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
ocfs2-sysfile-interfaces-for-online-file-check-fix.patch
fs-create-and-use-seq_show_option-for-escaping-fix.patch
watchdog-introduce-watchdog_suspend-and-watchdog_resume-fix.patch
watchdog-use-suspend-resume-interface-in-fixup_ht_bug-fix.patch
mm.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
genalloc-add-support-of-multiple-gen_pools-per-device-fix.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch
dax-revert-userfaultfd-change.patch
thp-prepare-for-dax-huge-pages-fix.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix.patch
pagemap-update-documentation-fix.patch
mm-show-proportional-swap-share-of-the-mapping-fix.patch
mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patch
mm-srcu-ify-shrinkers-fix-fix.patch
x86-use-generic-early-mem-copy-fix.patch
mm-mmap-simplify-the-failure-return-working-flow-fix.patch
memory-hot-addedthe-memory-can-not-been-added-to-movable-zone-fix.patch
zswap-dynamic-pool-creation-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
proc-add-kpageidle-file-fix-6-fix.patch
proc-add-kpageidle-file-fix-6-fix-2-fix.patch
proc-export-idle-flag-via-kpageflags-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix-fix.patch
kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.patch
align-crash_notes-allocation-to-make-it-be-inside-one-physical-page-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixes.patch
schedh-dont-include-mm_typesh.patch
schedh-dont-include-mm_typesh-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


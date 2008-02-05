From: akpm@linux-foundation.org
Subject: - i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:29:37 -0800
Message-ID: <200802052229.m15MTI3p011968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49286 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761264AbYBEWnh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     i386: Resolve dependency of asm-i386/pgtable.h on highmem.h
has been removed from the -mm tree.  Its filename was
     i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i386: Resolve dependency of asm-i386/pgtable.h on highmem.h
From: Christoph Lameter <clameter@sgi.com>

pgtable.h does not include highmem.h but uses various constants from
highmem.h.  We cannot include highmem.h because highmem.h will in turn include
many other include files that also depend on pgtable.h

So move the definitions from highmem.h into pgtable.h.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/highmem.h    |    6 ------
 include/asm-x86/pgtable_32.h |    8 ++++++++
 2 files changed, 8 insertions(+), 6 deletions(-)

diff -puN include/asm-x86/highmem.h~i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh include/asm-x86/highmem.h
--- a/include/asm-x86/highmem.h~i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh
+++ a/include/asm-x86/highmem.h
@@ -38,11 +38,6 @@ extern pte_t *pkmap_page_table;
  * easily, subsequent pte tables have to be allocated in one physical
  * chunk of RAM.
  */
-#ifdef CONFIG_X86_PAE
-#define LAST_PKMAP 512
-#else
-#define LAST_PKMAP 1024
-#endif
 /*
  * Ordering is:
  *
@@ -58,7 +53,6 @@ extern pte_t *pkmap_page_table;
  * VMALLOC_START
  * high_memory
  */
-#define PKMAP_BASE ( (FIXADDR_BOOT_START - PAGE_SIZE*(LAST_PKMAP + 1)) & PMD_MASK )
 #define LAST_PKMAP_MASK (LAST_PKMAP-1)
 #define PKMAP_NR(virt)  ((virt-PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
diff -puN include/asm-x86/pgtable_32.h~i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh include/asm-x86/pgtable_32.h
--- a/include/asm-x86/pgtable_32.h~i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh
+++ a/include/asm-x86/pgtable_32.h
@@ -66,6 +66,14 @@ void paging_init(void);
 #define VMALLOC_OFFSET	(8*1024*1024)
 #define VMALLOC_START	(((unsigned long) high_memory + \
 			2*VMALLOC_OFFSET-1) & ~(VMALLOC_OFFSET-1))
+#ifdef CONFIG_X86_PAE
+#define LAST_PKMAP 512
+#else
+#define LAST_PKMAP 1024
+#endif
+
+#define PKMAP_BASE ((FIXADDR_BOOT_START - PAGE_SIZE*(LAST_PKMAP + 1)) & PMD_MASK)
+
 #ifdef CONFIG_HIGHMEM
 # define VMALLOC_END	(PKMAP_BASE-2*PAGE_SIZE)
 #else
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
gregkh-driver-kset-move-sys-slab-to-sys-kernel-slab-slabinfo-fallback-from-sys-kernel-slab-to-sys-slab.patch
git-unionfs.patch
git-slub.patch
percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
dentries-extract-common-code-to-remove-dentry-from-lru-fix.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-include-sectionsh-to-avoid-defining-linker-variables.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

From: akpm@linux-foundation.org
Subject: - kmemleak-enable-the-building-of-the-memory-leak-detector.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:46:16 -0800
Message-ID: <200901082246.n08MkGb2025780@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44159 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763106AbZAHWun (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:50:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, mm-commits@vger.kernel.org


The patch titled
     kmemleak: enable the building of the memory leak detector
has been removed from the -mm tree.  Its filename was
     kmemleak-enable-the-building-of-the-memory-leak-detector.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kmemleak: enable the building of the memory leak detector
From: Catalin Marinas <catalin.marinas@arm.com>

Add the Kconfig.debug and Makefile entries needed for building kmemleak
into the kernel.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |   22 ++++++++++++++++++++++
 mm/Makefile       |    1 +
 2 files changed, 23 insertions(+)

diff -puN lib/Kconfig.debug~kmemleak-enable-the-building-of-the-memory-leak-detector lib/Kconfig.debug
--- a/lib/Kconfig.debug~kmemleak-enable-the-building-of-the-memory-leak-detector
+++ a/lib/Kconfig.debug
@@ -298,6 +298,28 @@ config SLUB_STATS
 	  out which slabs are relevant to a particular load.
 	  Try running: slabinfo -DA
 
+config DEBUG_KMEMLEAK
+	bool "Kernel memory leak detector"
+	default n
+	depends on EXPERIMENTAL
+	select DEBUG_SLAB if SLAB
+	select SLUB_DEBUG if SLUB
+	select DEBUG_FS if SYSFS
+	select STACKTRACE if STACKTRACE_SUPPORT
+	select KALLSYMS
+	help
+	  Say Y here if you want to enable the memory leak
+	  detector. The memory allocation/freeing is traced in a way
+	  similar to the Boehm's conservative garbage collector, the
+	  difference being that the orphan objects are not freed but
+	  only shown in /sys/kernel/debug/kmemleak. Enabling this
+	  feature will introduce an overhead to memory
+	  allocations. See Documentation/kmemleak.txt for more
+	  details.
+
+	  In order to access the kmemleak file, debugfs needs to be
+	  mounted (usually at /sys/kernel/debug).
+
 config DEBUG_PREEMPT
 	bool "Debug preemptible kernel"
 	depends on DEBUG_KERNEL && PREEMPT && (TRACE_IRQFLAGS_SUPPORT || PPC64)
diff -puN mm/Makefile~kmemleak-enable-the-building-of-the-memory-leak-detector mm/Makefile
--- a/mm/Makefile~kmemleak-enable-the-building-of-the-memory-leak-detector
+++ a/mm/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_NUMA) 	+= mempolicy.o
 obj-$(CONFIG_SPARSEMEM)	+= sparse.o
 obj-$(CONFIG_SPARSEMEM_VMEMMAP) += sparse-vmemmap.o
 obj-$(CONFIG_TMPFS_POSIX_ACL) += shmem_acl.o
+obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
 obj-$(CONFIG_SLOB) += slob.o
 obj-$(CONFIG_MMU_NOTIFIER) += mmu_notifier.o
 obj-$(CONFIG_SLAB) += slab.o
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
kmemleak-enable-the-building-of-the-memory-leak-detector.patch
kmemleak-simple-testing-module-for-kmemleak.patch
kmemleak-add-the-corresponding-maintainers-entry.patch


From: akpm@linux-foundation.org
Subject: + add-arch-specific-walk_memory_remove-for-ppc64.patch added to -mm tree
Date: Wed, 31 Oct 2007 15:33:59 -0700
Message-ID: <200710312233.l9VMXx39032462@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45615 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752940AbXJaWfV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Oct 2007 18:35:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pbadari@us.ibm.com, benh@kernel.crashing.org, galak@gate.crashing.org, haveblue@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, paulus@samba.org


The patch titled
     Add arch-specific walk_memory_remove() for ppc64
has been added to the -mm tree.  Its filename is
     add-arch-specific-walk_memory_remove-for-ppc64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add arch-specific walk_memory_remove() for ppc64
From: Badari Pulavarty <pbadari@us.ibm.com>

walk_memory_resource() verifies if there are holes in a given memory range, by
checking against /proc/iomem.  On x86/ia64 system memory is represented in
/proc/iomem.  On PPC64, we don't show system memory as IO resource in
/proc/iomem - instead its maintained in /proc/device-tree.

This patch provides a way for an architecture to provide its own
walk_memory_resource() function.  On PPC64, the memory region is small (16MB),
contiguous and non-overlapping.  So extra checking, against device-tree is not
needed.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig  |    3 +++
 arch/powerpc/mm/mem.c |   16 ++++++++++++++++
 kernel/resource.c     |    2 +-
 3 files changed, 20 insertions(+), 1 deletion(-)

diff -puN arch/powerpc/Kconfig~add-arch-specific-walk_memory_remove-for-ppc64 arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~add-arch-specific-walk_memory_remove-for-ppc64
+++ a/arch/powerpc/Kconfig
@@ -236,6 +236,9 @@ config HOTPLUG_CPU
 config ARCH_ENABLE_MEMORY_HOTPLUG
 	def_bool y
 
+config ARCH_HAS_WALK_MEMORY
+	def_bool y
+
 config ARCH_ENABLE_MEMORY_HOTREMOVE
 	def_bool y
 
diff -puN arch/powerpc/mm/mem.c~add-arch-specific-walk_memory_remove-for-ppc64 arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~add-arch-specific-walk_memory_remove-for-ppc64
+++ a/arch/powerpc/mm/mem.c
@@ -129,6 +129,22 @@ int __devinit arch_add_memory(int nid, u
 	return __add_pages(zone, start_pfn, nr_pages);
 }
 
+/*
+ * walk_memory_resource() needs to make sure there is no holes in a given
+ * memory range. On PPC64, since this range comes from /sysfs, the range
+ * is guaranteed to be valid, non-overlapping and can not contain any
+ * holes. By the time we get here (memory add or remove), /proc/device-tree
+ * is updated and correct. Only reason we need to check against device-tree
+ * would be if we allow user-land to specify a memory range through a
+ * system call/ioctl etc.. (instead of doing offline/online through /sysfs.
+ */
+int
+walk_memory_resource(unsigned long start_pfn, unsigned long nr_pages, void *arg,
+			int (*func)(unsigned long, unsigned long, void *))
+{
+	return  (*func)(start_pfn, nr_pages, arg);
+}
+
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
diff -puN kernel/resource.c~add-arch-specific-walk_memory_remove-for-ppc64 kernel/resource.c
--- a/kernel/resource.c~add-arch-specific-walk_memory_remove-for-ppc64
+++ a/kernel/resource.c
@@ -228,7 +228,7 @@ int release_resource(struct resource *ol
 
 EXPORT_SYMBOL(release_resource);
 
-#ifdef CONFIG_MEMORY_HOTPLUG
+#if defined(CONFIG_MEMORY_HOTPLUG) && !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
 /*
  * Finds the lowest memory reosurce exists within [res->start.res->end)
  * the caller must specify res->start, res->end, res->flags.
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

powerpc-move-_rtc_time-routines-under-config_adb_cuda.patch
hugetlb-allow-sticky-directory-mount-option.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
add-remove_memory-for-ppc64.patch
add-remove_memory-for-ppc64-fix.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
mem-controller-gfp-mask-fix.patch

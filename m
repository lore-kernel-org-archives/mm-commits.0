From: akpm@linux-foundation.org
Subject: - add-remove_memory-for-ppc64.patch removed from -mm tree
Date: Wed, 31 Oct 2007 15:56:17 -0700
Message-ID: <20071031225617.C7F6B432BF5@localhost>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:29312 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761086AbXJaW7o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 31 Oct 2007 18:59:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbadari@us.ibm.com, benh@kernel.crashing.org, galak@gate.crashing.org, haveblue@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Add remove_memory() for ppc64
has been removed from the -mm tree.  Its filename was
     add-remove_memory-for-ppc64.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Add remove_memory() for ppc64
From: Badari Pulavarty <pbadari@us.ibm.com>

Supply arch specific remove_memory() for PPC64.  There is nothing ppc specific
code here and its exactly same as ia64 version.  For now, lets keep it arch
specific - so each arch can add its own special things if needed.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/mem.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN arch/powerpc/mm/mem.c~add-remove_memory-for-ppc64 arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~add-remove_memory-for-ppc64
+++ a/arch/powerpc/mm/mem.c
@@ -131,6 +131,20 @@ int __devinit arch_add_memory(int nid, u
 
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
+int remove_memory(u64 start, u64 size)
+{
+	unsigned long start_pfn, end_pfn;
+	unsigned long timeout = 120 * HZ;
+	int ret;
+	start_pfn = start >> PAGE_SHIFT;
+	end_pfn = start_pfn + (size >> PAGE_SHIFT);
+	ret = offline_pages(start_pfn, end_pfn, timeout);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(remove_memory);
+#endif /* CONFIG_MEMORY_HOTREMOVE */
+
 void show_mem(void)
 {
 	unsigned long total = 0, reserved = 0;
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

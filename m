From: akpm@linux-foundation.org
Subject: - add-remove_memory-for-ppc64-2.patch removed from -mm tree
Date: Wed, 30 Jan 2008 17:13:37 -0800
Message-ID: <200801310113.m0V1DbZI001723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47267 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751061AbYAaBNt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jan 2008 20:13:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbadari@us.ibm.com, benh@kernel.crashing.org, galak@gate.crashing.org, haveblue@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, paulus@samba.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     add remove_memory() for ppc64
has been removed from the -mm tree.  Its filename was
     add-remove_memory-for-ppc64-2.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: add remove_memory() for ppc64
From: Badari Pulavarty <pbadari@us.ibm.com>

remove_memory() is common across ia64, ppc64.  There is no point in
providing exactly same arch-specific routines.  Make this generic and add
arch-specific hooks if needed by any other archs.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c |   17 -----------------
 mm/memory_hotplug.c |   16 ++++++++++++++++
 2 files changed, 16 insertions(+), 17 deletions(-)

diff -puN arch/ia64/mm/init.c~add-remove_memory-for-ppc64-2 arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~add-remove_memory-for-ppc64-2
+++ a/arch/ia64/mm/init.c
@@ -718,21 +718,4 @@ int arch_add_memory(int nid, u64 start, 
 
 	return ret;
 }
-#ifdef CONFIG_MEMORY_HOTREMOVE
-int remove_memory(u64 start, u64 size)
-{
-	unsigned long start_pfn, end_pfn;
-	unsigned long timeout = 120 * HZ;
-	int ret;
-	start_pfn = start >> PAGE_SHIFT;
-	end_pfn = start_pfn + (size >> PAGE_SHIFT);
-	ret = offline_pages(start_pfn, end_pfn, timeout);
-	if (ret)
-		goto out;
-	/* we can free mem_map at this point */
-out:
-	return ret;
-}
-EXPORT_SYMBOL_GPL(remove_memory);
-#endif /* CONFIG_MEMORY_HOTREMOVE */
 #endif
diff -puN mm/memory_hotplug.c~add-remove_memory-for-ppc64-2 mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~add-remove_memory-for-ppc64-2
+++ a/mm/memory_hotplug.c
@@ -653,6 +653,22 @@ failed_removal:
 
 	return ret;
 }
+
+int remove_memory(u64 start, u64 size)
+{
+	unsigned long start_pfn, end_pfn;
+	int ret;
+
+	start_pfn = start >> PAGE_SHIFT;
+	end_pfn = start_pfn + (size >> PAGE_SHIFT);
+	ret = offline_pages(start_pfn, end_pfn, 120 * HZ);
+	if (ret)
+		goto out;
+	/* we can free mem_map at this point */
+out:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(remove_memory);
 #else
 int remove_memory(u64 start, u64 size)
 {
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

hugetlb-allow-sticky-directory-mount-option.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
add-remove_memory-for-ppc64-2.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
mem-controller-gfp-mask-fix.patch
mount-options-fix-hugetlbfs.patch

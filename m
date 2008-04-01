From: akpm@linux-foundation.org
Subject: - powerpc-htab_remove_mapping-error-handling.patch removed from -mm tree
Date: Tue, 01 Apr 2008 14:37:55 -0700
Message-ID: <200804012137.m31LbtKP014873@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761594AbYDAVij (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 17:38:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbadari@us.ibm.com, benh@kernel.crashing.org, paulus@samba.org, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     powerpc: htab_remove_mapping() error handling
has been removed from the -mm tree.  Its filename was
     powerpc-htab_remove_mapping-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: htab_remove_mapping() error handling
From: Badari Pulavarty <pbadari@us.ibm.com>

If the sub-arch doesn't support hpte_removebolted(), gracefully return failure
rather than success.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/hash_utils_64.c |   14 +++++++++-----
 include/asm-powerpc/sparsemem.h |    2 +-
 2 files changed, 10 insertions(+), 6 deletions(-)

diff -puN arch/powerpc/mm/hash_utils_64.c~powerpc-htab_remove_mapping-error-handling arch/powerpc/mm/hash_utils_64.c
--- a/arch/powerpc/mm/hash_utils_64.c~powerpc-htab_remove_mapping-error-handling
+++ a/arch/powerpc/mm/hash_utils_64.c
@@ -192,7 +192,7 @@ int htab_bolt_mapping(unsigned long vsta
 	return ret < 0 ? ret : 0;
 }
 
-static void htab_remove_mapping(unsigned long vstart, unsigned long vend,
+static int htab_remove_mapping(unsigned long vstart, unsigned long vend,
 		      int psize, int ssize)
 {
 	unsigned long vaddr;
@@ -202,12 +202,15 @@ static void htab_remove_mapping(unsigned
 	step = 1 << shift;
 
 	if (!ppc_md.hpte_removebolted) {
-		printk("Sub-arch doesn't implement hpte_removebolted\n");
-		return;
+		printk(KERN_WARNING "Sub-arch doesn't implement "
+				"hpte_removebolted\n");
+		return -EINVAL;
 	}
 
 	for (vaddr = vstart; vaddr < vend; vaddr += step)
 		ppc_md.hpte_removebolted(vaddr, psize, ssize);
+
+	return 0;
 }
 
 static int __init htab_dt_scan_seg_sizes(unsigned long node,
@@ -454,9 +457,10 @@ void create_section_mapping(unsigned lon
 			mmu_linear_psize, mmu_kernel_ssize));
 }
 
-void remove_section_mapping(unsigned long start, unsigned long end)
+int remove_section_mapping(unsigned long start, unsigned long end)
 {
-	htab_remove_mapping(start, end, mmu_linear_psize, mmu_kernel_ssize);
+	return htab_remove_mapping(start, end, mmu_linear_psize,
+			mmu_kernel_ssize);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
diff -puN include/asm-powerpc/sparsemem.h~powerpc-htab_remove_mapping-error-handling include/asm-powerpc/sparsemem.h
--- a/include/asm-powerpc/sparsemem.h~powerpc-htab_remove_mapping-error-handling
+++ a/include/asm-powerpc/sparsemem.h
@@ -15,7 +15,7 @@
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 extern void create_section_mapping(unsigned long start, unsigned long end);
-extern void remove_section_mapping(unsigned long start, unsigned long end);
+extern int remove_section_mapping(unsigned long start, unsigned long end);
 #ifdef CONFIG_NUMA
 extern int hot_add_scn_to_nid(unsigned long scn_addr);
 #else
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

hotplug-memory-remove-generic-__remove_pages-support.patch
git-powerpc.patch
powerpc-hotplug-memory-notifications-for-ppc.patch
powerpc-update-lmb-for-hotplug-memory-add-remove.patch
powerpc-provide-walk_memory_resource-for-ppc.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
fs-aioc-make-3-functions-static.patch


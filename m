From: akpm@linux-foundation.org
Subject: - add-remove_memory-for-ppc64-3.patch removed from -mm tree
Date: Fri, 15 Feb 2008 21:54:56 -0700
Message-ID: <200802160454.m1G4svsJ009173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45191 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754640AbYBPEzc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 23:55:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbadari@us.ibm.com, benh@kernel.crashing.org, paulus@samba.org, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     ppc64: add remove_memory()
has been removed from the -mm tree.  Its filename was
     add-remove_memory-for-ppc64-3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ppc64: add remove_memory()
From: Badari Pulavarty <pbadari@us.ibm.com>

Supply ppc64 remove_memory() function.  Arch specific is still being
reviewed by Paul Mackerras.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/mem.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN arch/powerpc/mm/mem.c~add-remove_memory-for-ppc64-3 arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~add-remove_memory-for-ppc64-3
+++ a/arch/powerpc/mm/mem.c
@@ -162,6 +162,22 @@ walk_memory_resource(unsigned long start
 	return  (*func)(start_pfn, nr_pages, arg);
 }
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
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
+	/* Arch-specific calls go here - next patch */
+out:
+	return ret;
+}
+#endif /* CONFIG_MEMORY_HOTREMOVE */
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
 void show_mem(void)
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

add-remove_memory-for-ppc64-3.patch
enable-hotplug-memory-remove-for-ppc64.patch
register_memory-unregister_memory-fix-use-after-free-and-refcounting.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch

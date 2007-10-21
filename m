From: akpm@linux-foundation.org
Subject: - memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic-fix.patch removed from -mm tree
Date: Sun, 21 Oct 2007 16:37:10 -0700
Message-ID: <200710212337.l9LNbAeX032608@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43527 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751054AbXJUXhO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 19:37:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic-fix
has been removed from the -mm tree.  Its filename was
     memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic-fix.patch

This patch was dropped because it was folded into memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic.patch

------------------------------------------------------
Subject: memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic-fix
From: Andrew Morton <akpm@linux-foundation.org>

mm/slub.c: In function 'kmem_cache_init':
mm/slub.c:2835: error: 'slab_memory_callback' undeclared (first use in this function)
mm/slub.c:2835: error: (Each undeclared identifier is reported only once
mm/slub.c:2835: error: for each function it appears in.)

Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/linux/memory.h~memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic-fix include/linux/memory.h
--- a/include/linux/memory.h~memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic-fix
+++ a/include/linux/memory.h
@@ -83,10 +83,14 @@ extern int memory_notify(unsigned long v
 
 #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
 
+#ifdef CONFIG_MEMORY_HOTPLUG
 #define hotplug_memory_notifier(fn, pri) {			\
 	static struct notifier_block fn##_mem_nb =		\
 		{ .notifier_call = fn, .priority = pri };	\
 	register_memory_notifier(&fn##_mem_nb);			\
 }
+#else
+#define hotplug_memory_notifier(fn, pri) do { } while (0)
+#endif
 
 #endif /* _LINUX_MEMORY_H_ */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic.patch
memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic-fix.patch
capabilities-clean-up-file-capability-reading.patch
ext2-avoid-rec_len-overflow-with-64kb-block-size.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
kexec-add-bss-to-resource-tree.patch

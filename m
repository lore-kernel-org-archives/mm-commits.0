From: akpm@linux-foundation.org
Subject: [merged]
 memory-hotplug-move-alternative-function-definitions-to-header.patch
 removed from -mm tree
Date: Mon, 03 Jun 2013 13:30:01 -0700
Message-ID: <51acfcc9.WVnLcWBvj2lERMiv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39981 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab3FCUaC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jun 2013 16:30:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rafael.j.wysocki@intel.com

Subject: [merged] memory-hotplug-move-alternative-function-definitions-to-header.patch removed from -mm tree
To: rafael.j.wysocki@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 03 Jun 2013 13:30:01 -0700


The patch titled
     Subject: memory hotplug: move alternative function definitions to header
has been removed from the -mm tree.  Its filename was
     memory-hotplug-move-alternative-function-definitions-to-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: memory hotplug: move alternative function definitions to header

Move the definitions of offline_pages() and remove_memory() for
CONFIG_MEMORY_HOTREMOVE to memory_hotplug.h, where they belong, and make
them static inline.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    9 +++++++++
 mm/memory_hotplug.c            |    8 +-------
 2 files changed, 10 insertions(+), 7 deletions(-)

diff -puN include/linux/memory_hotplug.h~memory-hotplug-move-alternative-function-definitions-to-header include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~memory-hotplug-move-alternative-function-definitions-to-header
+++ a/include/linux/memory_hotplug.h
@@ -234,6 +234,8 @@ static inline void unlock_memory_hotplug
 
 extern int is_mem_section_removable(unsigned long pfn, unsigned long nr_pages);
 extern void try_offline_node(int nid);
+extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
+extern void remove_memory(int nid, u64 start, u64 size);
 
 #else
 static inline int is_mem_section_removable(unsigned long pfn,
@@ -243,6 +245,13 @@ static inline int is_mem_section_removab
 }
 
 static inline void try_offline_node(int nid) {}
+
+static inline int offline_pages(unsigned long start_pfn, unsigned long nr_pages)
+{
+	return -EINVAL;
+}
+
+static inline void remove_memory(int nid, u64 start, u64 size) {}
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
 extern int walk_memory_range(unsigned long start_pfn, unsigned long end_pfn,
diff -puN mm/memory_hotplug.c~memory-hotplug-move-alternative-function-definitions-to-header mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-move-alternative-function-definitions-to-header
+++ a/mm/memory_hotplug.c
@@ -1813,11 +1813,5 @@ void __ref remove_memory(int nid, u64 st
 
 	unlock_memory_hotplug();
 }
-#else
-int offline_pages(unsigned long start_pfn, unsigned long nr_pages)
-{
-	return -EINVAL;
-}
-void remove_memory(int nid, u64 start, u64 size) {}
-#endif /* CONFIG_MEMORY_HOTREMOVE */
 EXPORT_SYMBOL_GPL(remove_memory);
+#endif /* CONFIG_MEMORY_HOTREMOVE */
_

Patches currently in -mm which might be from rafael.j.wysocki@intel.com are

origin.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: [merged] mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:52:27 -0700
Message-ID: <201107260751.p6Q7pUKb002954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752561Ab1GZHwJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:52:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dkiper@net-space.pl, ian.campbell@citrix.com, jeremy@goop.org, konrad.wilk@oracle.com, mm-commits@vger.kernel.org


The patch titled
     mm: extend memory hotplug API to allow memory hotplug in virtual machines
has been removed from the -mm tree.  Its filename was
     mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: extend memory hotplug API to allow memory hotplug in virtual machines
From: Daniel Kiper <dkiper@net-space.pl>

This patch contains online_page_callback and apropriate functions for
registering/unregistering online page callbacks.  It allows to do some
machine specific tasks during online page stage which is required to
implement memory hotplug in virtual machines.  Currently this patch is
required by latest memory hotplug support for Xen balloon driver patch
which will be posted soon.

Additionally, originial online_page() function was splited into
following functions doing "atomic" operations:

  - __online_page_set_limits() - set new limits for memory management code,
  - __online_page_increment_counters() - increment totalram_pages and totalhigh_pages,
  - __online_page_free() - free page to allocator.

It was done to:
  - not duplicate existing code,
  - ease hotplug code devolpment by usage of well defined interface,
  - avoid stupid bugs which are unavoidable when the same code
    (by design) is developed in many places.

[akpm@linux-foundation.org: use explicit indirect-call syntax]
Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org> 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |   11 ++++-
 mm/memory_hotplug.c            |   68 +++++++++++++++++++++++++++++--
 2 files changed, 74 insertions(+), 5 deletions(-)

diff -puN include/linux/memory_hotplug.h~mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines
+++ a/include/linux/memory_hotplug.h
@@ -68,12 +68,19 @@ static inline void zone_seqlock_init(str
 extern int zone_grow_free_lists(struct zone *zone, unsigned long new_nr_pages);
 extern int zone_grow_waitqueues(struct zone *zone, unsigned long nr_pages);
 extern int add_one_highpage(struct page *page, int pfn, int bad_ppro);
-/* need some defines for these for archs that don't support it */
-extern void online_page(struct page *page);
 /* VM interface that may be used by firmware interface */
 extern int online_pages(unsigned long, unsigned long);
 extern void __offline_isolated_pages(unsigned long, unsigned long);
 
+typedef void (*online_page_callback_t)(struct page *page);
+
+extern int set_online_page_callback(online_page_callback_t callback);
+extern int restore_online_page_callback(online_page_callback_t callback);
+
+extern void __online_page_set_limits(struct page *page);
+extern void __online_page_increment_counters(struct page *page);
+extern void __online_page_free(struct page *page);
+
 #ifdef CONFIG_MEMORY_HOTREMOVE
 extern bool is_pageblock_removable_nolock(struct page *page);
 #endif /* CONFIG_MEMORY_HOTREMOVE */
diff -puN mm/memory_hotplug.c~mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines
+++ a/mm/memory_hotplug.c
@@ -34,6 +34,17 @@
 
 #include "internal.h"
 
+/*
+ * online_page_callback contains pointer to current page onlining function.
+ * Initially it is generic_online_page(). If it is required it could be
+ * changed by calling set_online_page_callback() for callback registration
+ * and restore_online_page_callback() for generic callback restore.
+ */
+
+static void generic_online_page(struct page *page);
+
+static online_page_callback_t online_page_callback = generic_online_page;
+
 DEFINE_MUTEX(mem_hotplug_mutex);
 
 void lock_memory_hotplug(void)
@@ -361,23 +372,74 @@ int __remove_pages(struct zone *zone, un
 }
 EXPORT_SYMBOL_GPL(__remove_pages);
 
-void online_page(struct page *page)
+int set_online_page_callback(online_page_callback_t callback)
+{
+	int rc = -EINVAL;
+
+	lock_memory_hotplug();
+
+	if (online_page_callback == generic_online_page) {
+		online_page_callback = callback;
+		rc = 0;
+	}
+
+	unlock_memory_hotplug();
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(set_online_page_callback);
+
+int restore_online_page_callback(online_page_callback_t callback)
+{
+	int rc = -EINVAL;
+
+	lock_memory_hotplug();
+
+	if (online_page_callback == callback) {
+		online_page_callback = generic_online_page;
+		rc = 0;
+	}
+
+	unlock_memory_hotplug();
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(restore_online_page_callback);
+
+void __online_page_set_limits(struct page *page)
 {
 	unsigned long pfn = page_to_pfn(page);
 
-	totalram_pages++;
 	if (pfn >= num_physpages)
 		num_physpages = pfn + 1;
+}
+EXPORT_SYMBOL_GPL(__online_page_set_limits);
+
+void __online_page_increment_counters(struct page *page)
+{
+	totalram_pages++;
 
 #ifdef CONFIG_HIGHMEM
 	if (PageHighMem(page))
 		totalhigh_pages++;
 #endif
+}
+EXPORT_SYMBOL_GPL(__online_page_increment_counters);
 
+void __online_page_free(struct page *page)
+{
 	ClearPageReserved(page);
 	init_page_count(page);
 	__free_page(page);
 }
+EXPORT_SYMBOL_GPL(__online_page_free);
+
+static void generic_online_page(struct page *page)
+{
+	__online_page_set_limits(page);
+	__online_page_increment_counters(page);
+	__online_page_free(page);
+}
 
 static int online_pages_range(unsigned long start_pfn, unsigned long nr_pages,
 			void *arg)
@@ -388,7 +450,7 @@ static int online_pages_range(unsigned l
 	if (PageReserved(pfn_to_page(start_pfn)))
 		for (i = 0; i < nr_pages; i++) {
 			page = pfn_to_page(start_pfn + i);
-			online_page(page);
+			(*online_page_callback)(page);
 			onlined_pages++;
 		}
 	*(unsigned long *)arg = onlined_pages;
_

Patches currently in -mm which might be from dkiper@net-space.pl are

origin.patch


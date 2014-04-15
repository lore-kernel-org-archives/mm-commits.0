From: akpm@linux-foundation.org
Subject: + mmvmacache-add-debug-data.patch added to -mm tree
Date: Tue, 15 Apr 2014 13:52:20 -0700
Message-ID: <534d9c04.DzIH5kzGDCAFZlMS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34172 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaDOUwV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Apr 2014 16:52:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, aswin@hp.com, davidlohr@hp.com

Subject: + mmvmacache-add-debug-data.patch added to -mm tree
To: davidlohr@hp.com,aswin@hp.com
From: akpm@linux-foundation.org
Date: Tue, 15 Apr 2014 13:52:20 -0700


The patch titled
     Subject: mm,vmacache: add debug data
has been added to the -mm tree.  Its filename is
     mmvmacache-add-debug-data.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmvmacache-add-debug-data.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmvmacache-add-debug-data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: mm,vmacache: add debug data

Introduce a CONFIG_DEBUG_VM_VMACACHE option to enable counting the cache
hit rate -- exported in /proc/vmstat.

Any updates to the caching scheme needs this kind of data, thus it can
save some work re-implementing the counting all the time.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    4 ++++
 include/linux/vmstat.h        |    6 ++++++
 lib/Kconfig.debug             |   10 ++++++++++
 mm/vmacache.c                 |    9 ++++++++-
 mm/vmstat.c                   |    4 ++++
 5 files changed, 32 insertions(+), 1 deletion(-)

diff -puN include/linux/vm_event_item.h~mmvmacache-add-debug-data include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mmvmacache-add-debug-data
+++ a/include/linux/vm_event_item.h
@@ -80,6 +80,10 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		NR_TLB_LOCAL_FLUSH_ALL,
 		NR_TLB_LOCAL_FLUSH_ONE,
 #endif /* CONFIG_DEBUG_TLBFLUSH */
+#ifdef CONFIG_DEBUG_VM_VMACACHE
+		VMACACHE_FIND_CALLS,
+		VMACACHE_FIND_HITS,
+#endif
 		NR_VM_EVENT_ITEMS
 };
 
diff -puN include/linux/vmstat.h~mmvmacache-add-debug-data include/linux/vmstat.h
--- a/include/linux/vmstat.h~mmvmacache-add-debug-data
+++ a/include/linux/vmstat.h
@@ -95,6 +95,12 @@ static inline void vm_events_fold_cpu(in
 #define count_vm_tlb_events(x, y) do { (void)(y); } while (0)
 #endif
 
+#ifdef CONFIG_DEBUG_VM_VMACACHE
+#define count_vm_vmacache_event(x) count_vm_event(x)
+#else
+#define count_vm_vmacache_event(x) do {} while (0)
+#endif
+
 #define __count_zone_vm_events(item, zone, delta) \
 		__count_vm_events(item##_NORMAL - ZONE_NORMAL + \
 		zone_idx(zone), delta)
diff -puN lib/Kconfig.debug~mmvmacache-add-debug-data lib/Kconfig.debug
--- a/lib/Kconfig.debug~mmvmacache-add-debug-data
+++ a/lib/Kconfig.debug
@@ -501,6 +501,16 @@ config DEBUG_VM
 
 	  If unsure, say N.
 
+config DEBUG_VM_VMACACHE
+	bool "Debug VMA caching"
+	depends on DEBUG_VM
+	help
+	  Enable this to turn on VMA caching debug information. Doing so
+	  can cause significant overhead, so only enable it in non-production
+	  environments.
+
+	  If unsure, say N.
+
 config DEBUG_VM_RB
 	bool "Debug VM red-black trees"
 	depends on DEBUG_VM
diff -puN mm/vmacache.c~mmvmacache-add-debug-data mm/vmacache.c
--- a/mm/vmacache.c~mmvmacache-add-debug-data
+++ a/mm/vmacache.c
@@ -78,11 +78,14 @@ struct vm_area_struct *vmacache_find(str
 	if (!vmacache_valid(mm))
 		return NULL;
 
+	count_vm_vmacache_event(VMACACHE_FIND_CALLS);
+
 	for (i = 0; i < VMACACHE_SIZE; i++) {
 		struct vm_area_struct *vma = current->vmacache[i];
 
 		if (vma && vma->vm_start <= addr && vma->vm_end > addr) {
 			BUG_ON(vma->vm_mm != mm);
+			count_vm_vmacache_event(VMACACHE_FIND_HITS);
 			return vma;
 		}
 	}
@@ -100,11 +103,15 @@ struct vm_area_struct *vmacache_find_exa
 	if (!vmacache_valid(mm))
 		return NULL;
 
+	count_vm_vmacache_event(VMACACHE_FIND_CALLS);
+
 	for (i = 0; i < VMACACHE_SIZE; i++) {
 		struct vm_area_struct *vma = current->vmacache[i];
 
-		if (vma && vma->vm_start == start && vma->vm_end == end)
+		if (vma && vma->vm_start == start && vma->vm_end == end) {
+			count_vm_vmacache_event(VMACACHE_FIND_HITS);
 			return vma;
+		}
 	}
 
 	return NULL;
diff -puN mm/vmstat.c~mmvmacache-add-debug-data mm/vmstat.c
--- a/mm/vmstat.c~mmvmacache-add-debug-data
+++ a/mm/vmstat.c
@@ -866,6 +866,10 @@ const char * const vmstat_text[] = {
 	"nr_tlb_local_flush_one",
 #endif /* CONFIG_DEBUG_TLBFLUSH */
 
+#ifdef CONFIG_DEBUG_VM_VMACACHE
+	"vmacache_find_calls",
+	"vmacache_find_hits",
+#endif
 #endif /* CONFIG_VM_EVENTS_COUNTERS */
 };
 #endif /* CONFIG_PROC_FS || CONFIG_SYSFS || CONFIG_NUMA */
_

Patches currently in -mm which might be from davidlohr@hp.com are

mm-fix-config_debug_vm_rb-description.patch
mmvmacache-add-debug-data.patch
mmvmacache-optimize-overflow-system-wide-flushing.patch
ipc-constify-ipc_ops.patch


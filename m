From: akpm@linux-foundation.org
Subject: [merged] mm-export-a-function-to-get-vm-committed-memory.patch removed from -mm tree
Date: Mon, 26 Nov 2012 14:21:25 -0800
Message-ID: <20121126222126.35354200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:43181 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321Ab2KZWV3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Nov 2012 17:21:29 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so675079bkc.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Nov 2012 14:21:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kys@microsoft.com, dan.magenheimer@oracle.com, greg@kroah.com, jeremy@goop.org, konrad.wilk@oracle.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: export a function to get vm committed memory
has been removed from the -mm tree.  Its filename was
     mm-export-a-function-to-get-vm-committed-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: mm: export a function to get vm committed memory

It will be useful to be able to access global memory commitment from
device drivers.  On the Hyper-V platform, the host has a policy engine to
balance the available physical memory amongst all competing virtual
machines hosted on a given node.  This policy engine is driven by a number
of metrics including the memory commitment reported by the guests.  The
balloon driver for Linux on Hyper-V will use this function to retrieve
guest memory commitment.  This function is also used in Xen self
ballooning code.

[akpm@linux-foundation.org: coding-style tweak]
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: Greg KH <greg@kroah.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/xen/xen-selfballoon.c |    2 +-
 include/linux/mman.h          |    2 ++
 mm/mmap.c                     |   14 ++++++++++++++
 mm/nommu.c                    |   15 +++++++++++++++
 4 files changed, 32 insertions(+), 1 deletion(-)

diff -puN drivers/xen/xen-selfballoon.c~mm-export-a-function-to-get-vm-committed-memory drivers/xen/xen-selfballoon.c
--- a/drivers/xen/xen-selfballoon.c~mm-export-a-function-to-get-vm-committed-memory
+++ a/drivers/xen/xen-selfballoon.c
@@ -222,7 +222,7 @@ static void selfballoon_process(struct w
 	if (xen_selfballooning_enabled) {
 		cur_pages = totalram_pages;
 		tgt_pages = cur_pages; /* default is no change */
-		goal_pages = percpu_counter_read_positive(&vm_committed_as) +
+		goal_pages = vm_memory_committed() +
 				totalreserve_pages +
 				MB2PAGES(selfballoon_reserved_mb);
 #ifdef CONFIG_FRONTSWAP
diff -puN include/linux/mman.h~mm-export-a-function-to-get-vm-committed-memory include/linux/mman.h
--- a/include/linux/mman.h~mm-export-a-function-to-get-vm-committed-memory
+++ a/include/linux/mman.h
@@ -11,6 +11,8 @@ extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
 extern struct percpu_counter vm_committed_as;
 
+unsigned long vm_memory_committed(void);
+
 static inline void vm_acct_memory(long pages)
 {
 	percpu_counter_add(&vm_committed_as, pages);
diff -puN mm/mmap.c~mm-export-a-function-to-get-vm-committed-memory mm/mmap.c
--- a/mm/mmap.c~mm-export-a-function-to-get-vm-committed-memory
+++ a/mm/mmap.c
@@ -89,6 +89,20 @@ int sysctl_max_map_count __read_mostly =
 struct percpu_counter vm_committed_as ____cacheline_aligned_in_smp;
 
 /*
+ * The global memory commitment made in the system can be a metric
+ * that can be used to drive ballooning decisions when Linux is hosted
+ * as a guest. On Hyper-V, the host implements a policy engine for dynamically
+ * balancing memory across competing virtual machines that are hosted.
+ * Several metrics drive this policy engine including the guest reported
+ * memory commitment.
+ */
+unsigned long vm_memory_committed(void)
+{
+	return percpu_counter_read_positive(&vm_committed_as);
+}
+EXPORT_SYMBOL_GPL(vm_memory_committed);
+
+/*
  * Check that a process has enough memory to allocate a new virtual
  * mapping. 0 means there is enough memory for the allocation to
  * succeed and -ENOMEM implies there is not.
diff -puN mm/nommu.c~mm-export-a-function-to-get-vm-committed-memory mm/nommu.c
--- a/mm/nommu.c~mm-export-a-function-to-get-vm-committed-memory
+++ a/mm/nommu.c
@@ -66,6 +66,21 @@ int heap_stack_gap = 0;
 
 atomic_long_t mmap_pages_allocated;
 
+/*
+ * The global memory commitment made in the system can be a metric
+ * that can be used to drive ballooning decisions when Linux is hosted
+ * as a guest. On Hyper-V, the host implements a policy engine for dynamically
+ * balancing memory across competing virtual machines that are hosted.
+ * Several metrics drive this policy engine including the guest reported
+ * memory commitment.
+ */
+unsigned long vm_memory_committed(void)
+{
+	return percpu_counter_read_positive(&vm_committed_as);
+}
+
+EXPORT_SYMBOL_GPL(vm_memory_committed);
+
 EXPORT_SYMBOL(mem_map);
 EXPORT_SYMBOL(num_physpages);
 
_

Patches currently in -mm which might be from kys@microsoft.com are

linux-next.patch


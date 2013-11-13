From: akpm@linux-foundation.org
Subject: [merged] mm-factor-commit-limit-calculation.patch removed from
 -mm tree
Date: Wed, 13 Nov 2013 12:39:40 -0800
Message-ID: <5283e38c.CkLbxIdYfOvEBb8p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42833 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab3KMUjl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:39:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, dave.hansen@linux.intel.com, jmarchan@redhat.com

Subject: [merged] mm-factor-commit-limit-calculation.patch removed from -mm tree
To: jmarchan@redhat.com,dave.hansen@linux.intel.com,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:39:40 -0800


The patch titled
     Subject: mm: factor commit limit calculation
has been removed from the -mm tree.  Its filename was
     mm-factor-commit-limit-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jerome Marchand <jmarchan@redhat.com>
Subject: mm: factor commit limit calculation

The same calculation is currently done in three differents places.
Factor that code so future changes has to be made at only one place.

[akpm@linux-foundation.org: uninline vm_commit_limit()]
Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/meminfo.c    |    5 +----
 include/linux/mman.h |    2 ++
 mm/mmap.c            |    4 +---
 mm/nommu.c           |    3 +--
 mm/util.c            |   13 +++++++++++++
 5 files changed, 18 insertions(+), 9 deletions(-)

diff -puN fs/proc/meminfo.c~mm-factor-commit-limit-calculation fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~mm-factor-commit-limit-calculation
+++ a/fs/proc/meminfo.c
@@ -24,7 +24,6 @@ static int meminfo_proc_show(struct seq_
 {
 	struct sysinfo i;
 	unsigned long committed;
-	unsigned long allowed;
 	struct vmalloc_info vmi;
 	long cached;
 	unsigned long pages[NR_LRU_LISTS];
@@ -37,8 +36,6 @@ static int meminfo_proc_show(struct seq_
 	si_meminfo(&i);
 	si_swapinfo(&i);
 	committed = percpu_counter_read_positive(&vm_committed_as);
-	allowed = ((totalram_pages - hugetlb_total_pages())
-		* sysctl_overcommit_ratio / 100) + total_swap_pages;
 
 	cached = global_page_state(NR_FILE_PAGES) -
 			total_swapcache_pages() - i.bufferram;
@@ -147,7 +144,7 @@ static int meminfo_proc_show(struct seq_
 		K(global_page_state(NR_UNSTABLE_NFS)),
 		K(global_page_state(NR_BOUNCE)),
 		K(global_page_state(NR_WRITEBACK_TEMP)),
-		K(allowed),
+		K(vm_commit_limit()),
 		K(committed),
 		(unsigned long)VMALLOC_TOTAL >> 10,
 		vmi.used >> 10,
diff -puN include/linux/mman.h~mm-factor-commit-limit-calculation include/linux/mman.h
--- a/include/linux/mman.h~mm-factor-commit-limit-calculation
+++ a/include/linux/mman.h
@@ -87,4 +87,6 @@ calc_vm_flag_bits(unsigned long flags)
 	       _calc_vm_trans(flags, MAP_DENYWRITE,  VM_DENYWRITE ) |
 	       _calc_vm_trans(flags, MAP_LOCKED,     VM_LOCKED    );
 }
+
+unsigned long vm_commit_limit(void);
 #endif /* _LINUX_MMAN_H */
diff -puN mm/mmap.c~mm-factor-commit-limit-calculation mm/mmap.c
--- a/mm/mmap.c~mm-factor-commit-limit-calculation
+++ a/mm/mmap.c
@@ -179,14 +179,12 @@ int __vm_enough_memory(struct mm_struct
 		goto error;
 	}
 
-	allowed = (totalram_pages - hugetlb_total_pages())
-	       	* sysctl_overcommit_ratio / 100;
+	allowed = vm_commit_limit();
 	/*
 	 * Reserve some for root
 	 */
 	if (!cap_sys_admin)
 		allowed -= sysctl_admin_reserve_kbytes >> (PAGE_SHIFT - 10);
-	allowed += total_swap_pages;
 
 	/*
 	 * Don't let a single process grow so big a user can't recover
diff -puN mm/nommu.c~mm-factor-commit-limit-calculation mm/nommu.c
--- a/mm/nommu.c~mm-factor-commit-limit-calculation
+++ a/mm/nommu.c
@@ -1948,13 +1948,12 @@ int __vm_enough_memory(struct mm_struct
 		goto error;
 	}
 
-	allowed = totalram_pages * sysctl_overcommit_ratio / 100;
+	allowed = vm_commit_limit();
 	/*
 	 * Reserve some 3% for root
 	 */
 	if (!cap_sys_admin)
 		allowed -= sysctl_admin_reserve_kbytes >> (PAGE_SHIFT - 10);
-	allowed += total_swap_pages;
 
 	/*
 	 * Don't let a single process grow so big a user can't recover
diff -puN mm/util.c~mm-factor-commit-limit-calculation mm/util.c
--- a/mm/util.c~mm-factor-commit-limit-calculation
+++ a/mm/util.c
@@ -7,6 +7,9 @@
 #include <linux/security.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
+#include <linux/mman.h>
+#include <linux/hugetlb.h>
+
 #include <asm/uaccess.h>
 
 #include "internal.h"
@@ -398,6 +401,16 @@ struct address_space *page_mapping(struc
 	return mapping;
 }
 
+/*
+ * Committed memory limit enforced when OVERCOMMIT_NEVER policy is used
+ */
+unsigned long vm_commit_limit(void)
+{
+	return ((totalram_pages - hugetlb_total_pages())
+		* sysctl_overcommit_ratio / 100) + total_swap_pages;
+}
+
+
 /* Tracepoints definitions. */
 EXPORT_TRACEPOINT_SYMBOL(kmalloc);
 EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
_

Patches currently in -mm which might be from jmarchan@redhat.com are

origin.patch


From: akpm@linux-foundation.org
Subject: + mm-factor-commit-limit-calculation.patch added to -mm tree
Date: Tue, 05 Nov 2013 15:53:32 -0800
Message-ID: <527984fc.DuH4qQZZrFpCVH68%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59512 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab3KEXxd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Nov 2013 18:53:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dave.hansen@linux.intel.com, jmarchan@redhat.com

Subject: + mm-factor-commit-limit-calculation.patch added to -mm tree
To: jmarchan@redhat.com,dave.hansen@linux.intel.com
From: akpm@linux-foundation.org
Date: Tue, 05 Nov 2013 15:53:32 -0800


The patch titled
     Subject: mm: factor commit limit calculation
has been added to the -mm tree.  Its filename is
     mm-factor-commit-limit-calculation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-factor-commit-limit-calculation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-factor-commit-limit-calculation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jerome Marchand <jmarchan@redhat.com>
Subject: mm: factor commit limit calculation

The same calculation is currently done in three differents places.
Factor that code so future changes has to be made at only one place.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/meminfo.c    |    5 +----
 include/linux/mman.h |   12 ++++++++++++
 mm/mmap.c            |    4 +---
 mm/nommu.c           |    3 +--
 4 files changed, 15 insertions(+), 9 deletions(-)

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
@@ -7,6 +7,9 @@
 #include <linux/atomic.h>
 #include <uapi/linux/mman.h>
 
+#include <linux/hugetlb.h>
+#include <linux/swap.h>
+
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
 extern struct percpu_counter vm_committed_as;
@@ -87,4 +90,13 @@ calc_vm_flag_bits(unsigned long flags)
 	       _calc_vm_trans(flags, MAP_DENYWRITE,  VM_DENYWRITE ) |
 	       _calc_vm_trans(flags, MAP_LOCKED,     VM_LOCKED    );
 }
+
+/*
+ * Commited memory limit enforced when OVERCOMMIT_NEVER policy is used
+ */
+static inline unsigned long vm_commit_limit()
+{
+	return ((totalram_pages - hugetlb_total_pages())
+		* sysctl_overcommit_ratio / 100) + total_swap_pages;
+}
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
_

Patches currently in -mm which might be from jmarchan@redhat.com are

mm-compactionc-update-comment-about-zone-lock-in-isolate_freepages_block.patch
mm-factor-commit-limit-calculation.patch
mm-factor-commit-limit-calculation-fix.patch
linux-next.patch


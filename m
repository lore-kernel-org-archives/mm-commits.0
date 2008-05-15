From: akpm@linux-foundation.org
Subject: + mm-fix-atomic_t-overflow-in-vm.patch added to -mm tree
Date: Thu, 15 May 2008 16:18:56 -0700
Message-ID: <200805152318.m4FNIuFm015582@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752164AbYEOXTo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 19:19:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     mm: fix atomic_t overflow in vm
has been added to the -mm tree.  Its filename is
     mm-fix-atomic_t-overflow-in-vm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix atomic_t overflow in vm
From: Alan Cox <alan@redhat.com>

The atomic_t type is 32bit but a 64bit system can have more than 2^32
pages of virtual address space available.  Without this we overflow on
ludicrously large mappings

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_misc.c  |    2 +-
 include/linux/mman.h |    4 ++--
 mm/mmap.c            |    4 ++--
 mm/nommu.c           |    4 ++--
 mm/swap.c            |    4 ++--
 5 files changed, 9 insertions(+), 9 deletions(-)

diff -puN fs/proc/proc_misc.c~mm-fix-atomic_t-overflow-in-vm fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~mm-fix-atomic_t-overflow-in-vm
+++ a/fs/proc/proc_misc.c
@@ -139,7 +139,7 @@ static int meminfo_read_proc(char *page,
 #define K(x) ((x) << (PAGE_SHIFT - 10))
 	si_meminfo(&i);
 	si_swapinfo(&i);
-	committed = atomic_read(&vm_committed_space);
+	committed = atomic_long_read(&vm_committed_space);
 	allowed = ((totalram_pages - hugetlb_total_pages())
 		* sysctl_overcommit_ratio / 100) + total_swap_pages;
 
diff -puN include/linux/mman.h~mm-fix-atomic_t-overflow-in-vm include/linux/mman.h
--- a/include/linux/mman.h~mm-fix-atomic_t-overflow-in-vm
+++ a/include/linux/mman.h
@@ -17,14 +17,14 @@
 
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
-extern atomic_t vm_committed_space;
+extern atomic_long_t vm_committed_space;
 
 #ifdef CONFIG_SMP
 extern void vm_acct_memory(long pages);
 #else
 static inline void vm_acct_memory(long pages)
 {
-	atomic_add(pages, &vm_committed_space);
+	atomic_long_add(pages, &vm_committed_space);
 }
 #endif
 
diff -puN mm/mmap.c~mm-fix-atomic_t-overflow-in-vm mm/mmap.c
--- a/mm/mmap.c~mm-fix-atomic_t-overflow-in-vm
+++ a/mm/mmap.c
@@ -80,7 +80,7 @@ EXPORT_SYMBOL(vm_get_page_prot);
 int sysctl_overcommit_memory = OVERCOMMIT_GUESS;  /* heuristic overcommit */
 int sysctl_overcommit_ratio = 50;	/* default is 50% */
 int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
-atomic_t vm_committed_space = ATOMIC_INIT(0);
+atomic_long_t vm_committed_space = ATOMIC_LONG_INIT(0);
 
 /*
  * Check that a process has enough memory to allocate a new virtual
@@ -177,7 +177,7 @@ int __vm_enough_memory(struct mm_struct 
 	 * cast `allowed' as a signed long because vm_committed_space
 	 * sometimes has a negative value
 	 */
-	if (atomic_read(&vm_committed_space) < (long)allowed)
+	if (atomic_long_read(&vm_committed_space) < (long)allowed)
 		return 0;
 error:
 	vm_unacct_memory(pages);
diff -puN mm/nommu.c~mm-fix-atomic_t-overflow-in-vm mm/nommu.c
--- a/mm/nommu.c~mm-fix-atomic_t-overflow-in-vm
+++ a/mm/nommu.c
@@ -39,7 +39,7 @@ struct page *mem_map;
 unsigned long max_mapnr;
 unsigned long num_physpages;
 unsigned long askedalloc, realalloc;
-atomic_t vm_committed_space = ATOMIC_INIT(0);
+atomic_long_t vm_committed_space = ATOMIC_LONG_INIT(0);
 int sysctl_overcommit_memory = OVERCOMMIT_GUESS; /* heuristic overcommit */
 int sysctl_overcommit_ratio = 50; /* default is 50% */
 int sysctl_max_map_count = DEFAULT_MAX_MAP_COUNT;
@@ -1410,7 +1410,7 @@ int __vm_enough_memory(struct mm_struct 
 	 * cast `allowed' as a signed long because vm_committed_space
 	 * sometimes has a negative value
 	 */
-	if (atomic_read(&vm_committed_space) < (long)allowed)
+	if (atomic_long_read(&vm_committed_space) < (long)allowed)
 		return 0;
 error:
 	vm_unacct_memory(pages);
diff -puN mm/swap.c~mm-fix-atomic_t-overflow-in-vm mm/swap.c
--- a/mm/swap.c~mm-fix-atomic_t-overflow-in-vm
+++ a/mm/swap.c
@@ -503,7 +503,7 @@ void vm_acct_memory(long pages)
 	local = &__get_cpu_var(committed_space);
 	*local += pages;
 	if (*local > ACCT_THRESHOLD || *local < -ACCT_THRESHOLD) {
-		atomic_add(*local, &vm_committed_space);
+		atomic_long_add(*local, &vm_committed_space);
 		*local = 0;
 	}
 	preempt_enable();
@@ -520,7 +520,7 @@ static int cpu_swap_callback(struct noti
 
 	committed = &per_cpu(committed_space, (long)hcpu);
 	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
-		atomic_add(*committed, &vm_committed_space);
+		atomic_long_add(*committed, &vm_committed_space);
 		*committed = 0;
 		drain_cpu_pagevecs((long)hcpu);
 	}
_

Patches currently in -mm which might be from alan@redhat.com are

origin.patch
m68knommu-add-info-about-removing-mcfserial.patch
linux-next.patch
iphase-fix-64bit-warning.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
mm-fix-atomic_t-overflow-in-vm.patch
serial-8250_gscc-add-module_license.patch
remove-is_tty.patch
riscom8-remove-redundant-null-pointer-test.patch
unexport-proc_clear_tty.patch


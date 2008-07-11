From: akpm@linux-foundation.org
Subject: + mm-remove-mm_init-compilation-dependency-on-config_debug_memory_init.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:39:44 -0700
Message-ID: <200807111845.m6BIjPbv030956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755287AbYGKSpm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:45:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nacc@us.ibm.com, mel@csn.ul.ie, nickpiggin@yahoo.com.au


The patch titled
     mm: remove mm_init compilation dependency on CONFIG_DEBUG_MEMORY_INIT
has been added to the -mm tree.  Its filename is
     mm-remove-mm_init-compilation-dependency-on-config_debug_memory_init.patch

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
Subject: mm: remove mm_init compilation dependency on CONFIG_DEBUG_MEMORY_INIT
From: Nishanth Aravamudan <nacc@us.ibm.com>

Towards the end of putting all core mm initialization in mm_init.c, I
plan on putting the creation of a mm kobject in a function in that file.
However, the file is currently only compiled if CONFIG_DEBUG_MEMORY_INIT
is set. Remove this dependency, but put the code under an #ifdef on the
same config option. This should result in no functional changes.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Makefile  |    3 +--
 mm/mm_init.c |    2 ++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/Makefile~mm-remove-mm_init-compilation-dependency-on-config_debug_memory_init mm/Makefile
--- a/mm/Makefile~mm-remove-mm_init-compilation-dependency-on-config_debug_memory_init
+++ a/mm/Makefile
@@ -11,7 +11,7 @@ obj-y			:= bootmem.o filemap.o mempool.o
 			   maccess.o page_alloc.o page-writeback.o pdflush.o \
 			   readahead.o swap.o truncate.o vmscan.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
-			   page_isolation.o $(mmu-y)
+			   page_isolation.o mm_init.o $(mmu-y)
 
 obj-$(CONFIG_PROC_PAGE_MONITOR) += pagewalk.o
 obj-$(CONFIG_BOUNCE)	+= bounce.o
@@ -26,7 +26,6 @@ obj-$(CONFIG_TMPFS_POSIX_ACL) += shmem_a
 obj-$(CONFIG_TINY_SHMEM) += tiny-shmem.o
 obj-$(CONFIG_SLOB) += slob.o
 obj-$(CONFIG_SLAB) += slab.o
-obj-$(CONFIG_DEBUG_MEMORY_INIT) += mm_init.o
 obj-$(CONFIG_SLUB) += slub.o
 obj-$(CONFIG_KMEMCHECK) += kmemcheck.o
 obj-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o
diff -puN mm/mm_init.c~mm-remove-mm_init-compilation-dependency-on-config_debug_memory_init mm/mm_init.c
--- a/mm/mm_init.c~mm-remove-mm_init-compilation-dependency-on-config_debug_memory_init
+++ a/mm/mm_init.c
@@ -9,6 +9,7 @@
 #include <linux/init.h>
 #include "internal.h"
 
+#ifdef CONFIG_DEBUG_MEMORY_INIT
 int __meminitdata mminit_loglevel;
 
 /* The zonelists are simply reported, validation is manual. */
@@ -132,3 +133,4 @@ static __init int set_mminit_loglevel(ch
 	return 0;
 }
 early_param("mminit_loglevel", set_mminit_loglevel);
+#endif /* CONFIG_DEBUG_MEMORY_INIT */
_

Patches currently in -mm which might be from nacc@us.ibm.com are

vma-page-offset-has-no-callees-drop-it.patch
mm-remove-mm_init-compilation-dependency-on-config_debug_memory_init.patch
mm-create-sys-kernel-mm.patch
hugetlb-factor-out-prep_new_huge_page.patch
hugetlb-modular-state-for-hugetlb-page-size.patch
hugetlb-modular-state-for-hugetlb-page-size-checkpatch-fixes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes-checkpatch-fixes.patch
hugetlbfs-per-mount-huge-page-sizes.patch
hugetlb-new-sysfs-interface.patch
hugetlb-new-sysfs-interface-hugetlb-hang-off-of-sys-kernel-mm-rather-than-sys-kernel.patch
hugetlb-new-sysfs-interface-hugetlb-remove-config_sysfs-dependency.patch
hugetlb-abstract-numa-round-robin-selection.patch
hugetlb-support-boot-allocate-different-sizes.patch
hugetlb-printk-cleanup.patch
fs-check-for-statfs-overflow.patch
ixj-push-bkl-into-driver-and-wrap-ioctls.patch


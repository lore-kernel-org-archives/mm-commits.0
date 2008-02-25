From: akpm@linux-foundation.org
Subject: + memory-controller-rename-to-memory-resource-controller.patch added to -mm tree
Date: Mon, 25 Feb 2008 10:18:40 -0800
Message-ID: <200802251819.m1PIJaYl012740@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751257AbYBYSTs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Feb 2008 13:19:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, menage@google.com


The patch titled
     Memory controller: rename to Memory Resource Controller
has been added to the -mm tree.  Its filename is
     memory-controller-rename-to-memory-resource-controller.patch

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
Subject: Memory controller: rename to Memory Resource Controller
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Rename Memory Controller to Memory Resource Controller.  Reflect the same
changes in the CONFIG definition for the Memory Resource Controller.  Group
together the config options for Resource Counters and Memory Resource
Controller.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/controllers/memory.txt |    8 +++++-
 include/linux/cgroup_subsys.h        |    2 -
 include/linux/memcontrol.h           |    4 +--
 include/linux/mm_types.h             |    4 +--
 init/Kconfig                         |   30 ++++++++++++-------------
 mm/Makefile                          |    2 -
 mm/oom_kill.c                        |    2 -
 mm/vmscan.c                          |    4 +--
 8 files changed, 30 insertions(+), 26 deletions(-)

diff -puN Documentation/controllers/memory.txt~memory-controller-rename-to-memory-resource-controller Documentation/controllers/memory.txt
--- a/Documentation/controllers/memory.txt~memory-controller-rename-to-memory-resource-controller
+++ a/Documentation/controllers/memory.txt
@@ -1,4 +1,8 @@
-Memory Controller
+Memory Resource Controller
+
+NOTE: The Memory Resource Controller has been generically been referred
+to as the memory controller in this document. Do not confuse memory controller
+used here with the memory controller that is used in hardware.
 
 Salient features
 
@@ -152,7 +156,7 @@ The memory controller uses the following
 
 a. Enable CONFIG_CGROUPS
 b. Enable CONFIG_RESOURCE_COUNTERS
-c. Enable CONFIG_CGROUP_MEM_CONT
+c. Enable CONFIG_CGROUP_MEM_RES_CTLR
 
 1. Prepare the cgroups
 # mkdir -p /cgroups
diff -puN include/linux/cgroup_subsys.h~memory-controller-rename-to-memory-resource-controller include/linux/cgroup_subsys.h
--- a/include/linux/cgroup_subsys.h~memory-controller-rename-to-memory-resource-controller
+++ a/include/linux/cgroup_subsys.h
@@ -37,7 +37,7 @@ SUBSYS(cpuacct)
 
 /* */
 
-#ifdef CONFIG_CGROUP_MEM_CONT
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
 SUBSYS(mem_cgroup)
 #endif
 
diff -puN include/linux/memcontrol.h~memory-controller-rename-to-memory-resource-controller include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memory-controller-rename-to-memory-resource-controller
+++ a/include/linux/memcontrol.h
@@ -25,7 +25,7 @@ struct page_cgroup;
 struct page;
 struct mm_struct;
 
-#ifdef CONFIG_CGROUP_MEM_CONT
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
 
 extern void mm_init_cgroup(struct mm_struct *mm, struct task_struct *p);
 extern void mm_free_cgroup(struct mm_struct *mm);
@@ -72,7 +72,7 @@ extern long mem_cgroup_calc_reclaim_acti
 extern long mem_cgroup_calc_reclaim_inactive(struct mem_cgroup *mem,
 				struct zone *zone, int priority);
 
-#else /* CONFIG_CGROUP_MEM_CONT */
+#else /* CONFIG_CGROUP_MEM_RES_CTLR */
 static inline void mm_init_cgroup(struct mm_struct *mm,
 					struct task_struct *p)
 {
diff -puN include/linux/mm_types.h~memory-controller-rename-to-memory-resource-controller include/linux/mm_types.h
--- a/include/linux/mm_types.h~memory-controller-rename-to-memory-resource-controller
+++ a/include/linux/mm_types.h
@@ -91,7 +91,7 @@ struct page {
 	void *virtual;			/* Kernel virtual address (NULL if
 					   not kmapped, ie. highmem) */
 #endif /* WANT_PAGE_VIRTUAL */
-#ifdef CONFIG_CGROUP_MEM_CONT
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
 	unsigned long page_cgroup;
 #endif
 };
@@ -225,7 +225,7 @@ struct mm_struct {
 	/* aio bits */
 	rwlock_t		ioctx_list_lock;
 	struct kioctx		*ioctx_list;
-#ifdef CONFIG_CGROUP_MEM_CONT
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
 	struct mem_cgroup *mem_cgroup;
 #endif
 };
diff -puN init/Kconfig~memory-controller-rename-to-memory-resource-controller init/Kconfig
--- a/init/Kconfig~memory-controller-rename-to-memory-resource-controller
+++ a/init/Kconfig
@@ -366,6 +366,21 @@ config RESOURCE_COUNTERS
           infrastructure that works with cgroups
 	depends on CGROUPS
 
+config CGROUP_MEM_RES_CTLR
+	bool "Memory Resource Controller for Control Groups"
+	depends on CGROUPS && RESOURCE_COUNTERS
+	help
+	  Provides a memory resource controller that manages both page cache and
+	  RSS memory.
+
+	  Note that setting this option increases fixed memory overhead
+	  associated with each page of memory in the system by 4/8 bytes
+	  and also increases cache misses because struct page on many 64bit
+	  systems will not fit into a single cache line anymore.
+
+	  Only enable when you're ok with these trade offs and really
+	  sure you need the memory resource controller.
+
 config SYSFS_DEPRECATED
 	bool "Create deprecated sysfs files"
 	depends on SYSFS
@@ -387,21 +402,6 @@ config SYSFS_DEPRECATED
 	  If you are using a distro that was released in 2006 or later,
 	  it should be safe to say N here.
 
-config CGROUP_MEM_CONT
-	bool "Memory controller for cgroups"
-	depends on CGROUPS && RESOURCE_COUNTERS
-	help
-	  Provides a memory controller that manages both page cache and
-	  RSS memory.
-
-	  Note that setting this option increases fixed memory overhead
-	  associated with each page of memory in the system by 4/8 bytes
-	  and also increases cache misses because struct page on many 64bit
-	  systems will not fit into a single cache line anymore.
-
-	  Only enable when you're ok with these trade offs and really
-	  sure you need the memory controller.
-
 config PROC_PID_CPUSET
 	bool "Include legacy /proc/<pid>/cpuset file"
 	depends on CPUSETS
diff -puN mm/Makefile~memory-controller-rename-to-memory-resource-controller mm/Makefile
--- a/mm/Makefile~memory-controller-rename-to-memory-resource-controller
+++ a/mm/Makefile
@@ -32,5 +32,5 @@ obj-$(CONFIG_FS_XIP) += filemap_xip.o
 obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_SMP) += allocpercpu.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
-obj-$(CONFIG_CGROUP_MEM_CONT) += memcontrol.o
+obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o
 
diff -puN mm/oom_kill.c~memory-controller-rename-to-memory-resource-controller mm/oom_kill.c
--- a/mm/oom_kill.c~memory-controller-rename-to-memory-resource-controller
+++ a/mm/oom_kill.c
@@ -412,7 +412,7 @@ static int oom_kill_process(struct task_
 	return oom_kill_task(p);
 }
 
-#ifdef CONFIG_CGROUP_MEM_CONT
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
 void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask)
 {
 	unsigned long points = 0;
diff -puN mm/vmscan.c~memory-controller-rename-to-memory-resource-controller mm/vmscan.c
--- a/mm/vmscan.c~memory-controller-rename-to-memory-resource-controller
+++ a/mm/vmscan.c
@@ -126,7 +126,7 @@ long vm_total_pages;	/* The total number
 static LIST_HEAD(shrinker_list);
 static DECLARE_RWSEM(shrinker_rwsem);
 
-#ifdef CONFIG_CGROUP_MEM_CONT
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
 #define scan_global_lru(sc)	(!(sc)->mem_cgroup)
 #else
 #define scan_global_lru(sc)	(1)
@@ -1427,7 +1427,7 @@ unsigned long try_to_free_pages(struct z
 	return do_try_to_free_pages(zones, gfp_mask, &sc);
 }
 
-#ifdef CONFIG_CGROUP_MEM_CONT
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
 
 unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont,
 						gfp_t gfp_mask)
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

git-kvm.patch
git-sched.patch
memory-controller-rename-to-memory-resource-controller.patch

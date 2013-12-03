From: akpm@linux-foundation.org
Subject: + mm-add-overcommit_kbytes-sysctl-variable.patch added to -mm
 tree
Date: Tue, 03 Dec 2013 14:09:01 -0800
Message-ID: <529e567d.T2pM8pBLW7GoM7lG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54687 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab3LCWJC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Dec 2013 17:09:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dave.hansen@linux.intel.com, alan@lxorguk.ukuu.org.uk, jmarchan@redhat.com

Subject: + mm-add-overcommit_kbytes-sysctl-variable.patch added to -mm tree
To: jmarchan@redhat.com,alan@lxorguk.ukuu.org.uk,dave.hansen@linux.intel.com
From: akpm@linux-foundation.org
Date: Tue, 03 Dec 2013 14:09:01 -0800


The patch titled
     Subject: mm: add overcommit_kbytes sysctl variable
has been added to the -mm tree.  Its filename is
     mm-add-overcommit_kbytes-sysctl-variable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-overcommit_kbytes-sysctl-variable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-overcommit_kbytes-sysctl-variable.patch

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
Subject: mm: add overcommit_kbytes sysctl variable

Some applications that run on HPC clusters are designed around the
availability of RAM and the overcommit ratio is fine tuned to get the
maximum usage of memory without swapping.  With growing memory, the
1%-of-all-RAM grain provided by overcommit_ratio has become too coarse for
these workload (on a 2TB machine it represents no less than 20GB).

This patch adds the new overcommit_kbytes sysctl variable that allow a
much finer grain.

Signed-of-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt            |   12 +++++++++++
 Documentation/vm/overcommit-accounting |    7 +++---
 include/linux/mm.h                     |    5 ++++
 include/linux/mman.h                   |    1 
 kernel/sysctl.c                        |   10 ++++++++-
 mm/mmap.c                              |   25 +++++++++++++++++++++++
 mm/nommu.c                             |    1 
 mm/util.c                              |   12 +++++++++--
 8 files changed, 67 insertions(+), 6 deletions(-)

diff -puN Documentation/sysctl/vm.txt~mm-add-overcommit_kbytes-sysctl-variable Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-add-overcommit_kbytes-sysctl-variable
+++ a/Documentation/sysctl/vm.txt
@@ -47,6 +47,7 @@ Currently, these files are in /proc/sys/
 - numa_zonelist_order
 - oom_dump_tasks
 - oom_kill_allocating_task
+- overcommit_kbytes
 - overcommit_memory
 - overcommit_ratio
 - page-cluster
@@ -574,6 +575,17 @@ The default value is 0.
 
 ==============================================================
 
+overcommit_kbytes:
+
+When overcommit_memory is set to 2, the committed address space is not
+permitted to exceed swap plus this amount of physical RAM. See below.
+
+Note: overcommit_kbytes is the counterpart of overcommit_ratio. Only one
+of them may be specified at a time. Setting one disable the other (which
+then appears as 0 when read).
+
+==============================================================
+
 overcommit_memory:
 
 This value contains a flag that enables memory overcommitment.
diff -puN Documentation/vm/overcommit-accounting~mm-add-overcommit_kbytes-sysctl-variable Documentation/vm/overcommit-accounting
--- a/Documentation/vm/overcommit-accounting~mm-add-overcommit_kbytes-sysctl-variable
+++ a/Documentation/vm/overcommit-accounting
@@ -14,8 +14,8 @@ The Linux kernel supports the following
 
 2	-	Don't overcommit. The total address space commit
 		for the system is not permitted to exceed swap + a
-		configurable percentage (default is 50) of physical RAM.
-		Depending on the percentage you use, in most situations
+		configurable amount (default is 50%) of physical RAM.
+		Depending on the amount you use, in most situations
 		this means a process will not be killed while accessing
 		pages but will receive errors on memory allocation as
 		appropriate.
@@ -26,7 +26,8 @@ The Linux kernel supports the following
 
 The overcommit policy is set via the sysctl `vm.overcommit_memory'.
 
-The overcommit percentage is set via `vm.overcommit_ratio'.
+The overcommit amount can be set via `vm.overcommit_ratio' (percentage)
+or `vm.overcommit_kbytes' (absolute value).
 
 The current overcommit limit and amount committed are viewable in
 /proc/meminfo as CommitLimit and Committed_AS respectively.
diff -puN include/linux/mm.h~mm-add-overcommit_kbytes-sysctl-variable include/linux/mm.h
--- a/include/linux/mm.h~mm-add-overcommit_kbytes-sysctl-variable
+++ a/include/linux/mm.h
@@ -57,6 +57,11 @@ extern int sysctl_legacy_va_layout;
 extern unsigned long sysctl_user_reserve_kbytes;
 extern unsigned long sysctl_admin_reserve_kbytes;
 
+extern int overcommit_ratio_handler(struct ctl_table *, int, void __user *,
+				    size_t *, loff_t *);
+extern int overcommit_kbytes_handler(struct ctl_table *, int, void __user *,
+				    size_t *, loff_t *);
+
 #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
 
 /* to align the pointer to the (next) page boundary */
diff -puN include/linux/mman.h~mm-add-overcommit_kbytes-sysctl-variable include/linux/mman.h
--- a/include/linux/mman.h~mm-add-overcommit_kbytes-sysctl-variable
+++ a/include/linux/mman.h
@@ -9,6 +9,7 @@
 
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
+extern unsigned long sysctl_overcommit_kbytes;
 extern struct percpu_counter vm_committed_as;
 
 #ifdef CONFIG_SMP
diff -puN kernel/sysctl.c~mm-add-overcommit_kbytes-sysctl-variable kernel/sysctl.c
--- a/kernel/sysctl.c~mm-add-overcommit_kbytes-sysctl-variable
+++ a/kernel/sysctl.c
@@ -97,6 +97,7 @@
 /* External variables not in a header file. */
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
+extern unsigned long sysctl_overcommit_kbytes;
 extern int max_threads;
 extern int suid_dumpable;
 #ifdef CONFIG_COREDUMP
@@ -1128,7 +1129,14 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_overcommit_ratio,
 		.maxlen		= sizeof(sysctl_overcommit_ratio),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= overcommit_ratio_handler,
+	},
+	{
+		.procname	= "overcommit_kbytes",
+		.data		= &sysctl_overcommit_kbytes,
+		.maxlen		= sizeof(sysctl_overcommit_kbytes),
+		.mode		= 0644,
+		.proc_handler	= overcommit_kbytes_handler,
 	},
 	{
 		.procname	= "page-cluster", 
diff -puN mm/mmap.c~mm-add-overcommit_kbytes-sysctl-variable mm/mmap.c
--- a/mm/mmap.c~mm-add-overcommit_kbytes-sysctl-variable
+++ a/mm/mmap.c
@@ -86,6 +86,7 @@ EXPORT_SYMBOL(vm_get_page_prot);
 
 int sysctl_overcommit_memory __read_mostly = OVERCOMMIT_GUESS;  /* heuristic overcommit */
 int sysctl_overcommit_ratio __read_mostly = 50;	/* default is 50% */
+unsigned long sysctl_overcommit_kbytes __read_mostly = 0;
 int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
 unsigned long sysctl_user_reserve_kbytes __read_mostly = 1UL << 17; /* 128MB */
 unsigned long sysctl_admin_reserve_kbytes __read_mostly = 1UL << 13; /* 8MB */
@@ -95,6 +96,30 @@ unsigned long sysctl_admin_reserve_kbyte
  */
 struct percpu_counter vm_committed_as ____cacheline_aligned_in_smp;
 
+int overcommit_ratio_handler(struct ctl_table *table, int write,
+			     void __user *buffer, size_t *lenp,
+			     loff_t *ppos)
+{
+	int ret;
+
+	ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	if (ret == 0 && write)
+		sysctl_overcommit_kbytes = 0;
+	return ret;
+}
+
+int overcommit_kbytes_handler(struct ctl_table *table, int write,
+			     void __user *buffer, size_t *lenp,
+			     loff_t *ppos)
+{
+	int ret;
+
+	ret = proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
+	if (ret == 0 && write)
+		sysctl_overcommit_ratio = 0;
+	return ret;
+}
+
 /*
  * The global memory commitment made in the system can be a metric
  * that can be used to drive ballooning decisions when Linux is hosted
diff -puN mm/nommu.c~mm-add-overcommit_kbytes-sysctl-variable mm/nommu.c
--- a/mm/nommu.c~mm-add-overcommit_kbytes-sysctl-variable
+++ a/mm/nommu.c
@@ -60,6 +60,7 @@ unsigned long highest_memmap_pfn;
 struct percpu_counter vm_committed_as;
 int sysctl_overcommit_memory = OVERCOMMIT_GUESS; /* heuristic overcommit */
 int sysctl_overcommit_ratio = 50; /* default is 50% */
+unsigned long sysctl_overcommit_kbytes __read_mostly = 0;
 int sysctl_max_map_count = DEFAULT_MAX_MAP_COUNT;
 int sysctl_nr_trim_pages = CONFIG_NOMMU_INITIAL_TRIM_EXCESS;
 unsigned long sysctl_user_reserve_kbytes __read_mostly = 1UL << 17; /* 128MB */
diff -puN mm/util.c~mm-add-overcommit_kbytes-sysctl-variable mm/util.c
--- a/mm/util.c~mm-add-overcommit_kbytes-sysctl-variable
+++ a/mm/util.c
@@ -406,8 +406,16 @@ struct address_space *page_mapping(struc
  */
 unsigned long vm_commit_limit(void)
 {
-	return ((totalram_pages - hugetlb_total_pages())
-		* sysctl_overcommit_ratio / 100) + total_swap_pages;
+	unsigned long allowed;
+
+	if (sysctl_overcommit_kbytes)
+		allowed = sysctl_overcommit_kbytes >> (PAGE_SHIFT - 10);
+	else
+		allowed = ((totalram_pages - hugetlb_total_pages())
+			   * sysctl_overcommit_ratio / 100);
+	allowed += total_swap_pages;
+
+	return allowed;
 }
 
 
_

Patches currently in -mm which might be from jmarchan@redhat.com are

mm-add-overcommit_kbytes-sysctl-variable.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: + mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads.patch added to -mm tree
Date: Mon, 11 Jun 2012 14:53:49 -0700
Message-ID: <20120611215349.9BCBAA0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:50567 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2FKVxu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 17:53:50 -0400
Received: by ggeh3 with SMTP id h3so417995gge.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 14:53:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liwp@linux.vnet.ibm.com, fengguang.wu@intel.com


The patch titled
     Subject: mm: prepare for removal of obsolete /proc/sys/vm/nr_pdflush_threads
has been added to the -mm tree.  Its filename is
     mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: mm: prepare for removal of obsolete /proc/sys/vm/nr_pdflush_threads

Since per-BDI flusher threads were introduced in 2.6, the pdflush
mechanism is not used any more.  But the old interface exported through
/proc/sys/vm/nr_pdflush_threads still exists and is obviously useless.

For back-compatibility, printk warning information and return 2 to notify
the users that the interface is removed.

Signed-off-by: Wanpeng Li <liwp@linux.vnet.ibm.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/obsolete/proc-sys-vm-nr_pdflush_threads |    5 ++
 Documentation/feature-removal-schedule.txt                |    8 ++++
 Documentation/sysctl/vm.txt                               |   11 -----
 fs/fs-writeback.c                                         |    5 --
 include/linux/backing-dev.h                               |    3 +
 include/linux/writeback.h                                 |    5 --
 kernel/sysctl.c                                           |    8 +---
 kernel/sysctl_binary.c                                    |    2 -
 mm/backing-dev.c                                          |   20 ++++++++++
 9 files changed, 40 insertions(+), 27 deletions(-)

diff -puN /dev/null Documentation/ABI/obsolete/proc-sys-vm-nr_pdflush_threads
--- /dev/null
+++ a/Documentation/ABI/obsolete/proc-sys-vm-nr_pdflush_threads
@@ -0,0 +1,5 @@
+What:		/proc/sys/vm/nr_pdflush_threads
+Date:		June 2012
+Contact:	Wanpeng Li <liwp@linux.vnet.ibm.com>
+Description: Since pdflush is replaced by per-BDI flusher, the interface of old pdflush
+             exported in /proc/sys/vm/ should be removed.
diff -puN Documentation/feature-removal-schedule.txt~mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads
+++ a/Documentation/feature-removal-schedule.txt
@@ -13,6 +13,14 @@ Who:	Jim Cromie <jim.cromie@gmail.com>, 
 
 ---------------------------
 
+What: /proc/sys/vm/nr_pdflush_threads
+When: 2012
+Why: Since pdflush is deprecated, the interface exported in /proc/sys/vm/
+     should be removed.
+Who: Wanpeng Li <liwp@linux.vnet.ibm.com>
+
+---------------------------
+
 What:	CONFIG_APM_CPU_IDLE, and its ability to call APM BIOS in idle
 When:	2012
 Why:	This optional sub-feature of APM is of dubious reliability,
diff -puN Documentation/sysctl/vm.txt~mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads
+++ a/Documentation/sysctl/vm.txt
@@ -42,7 +42,6 @@ Currently, these files are in /proc/sys/
 - mmap_min_addr
 - nr_hugepages
 - nr_overcommit_hugepages
-- nr_pdflush_threads
 - nr_trim_pages         (only if CONFIG_MMU=n)
 - numa_zonelist_order
 - oom_dump_tasks
@@ -426,16 +425,6 @@ See Documentation/vm/hugetlbpage.txt
 
 ==============================================================
 
-nr_pdflush_threads
-
-The current number of pdflush threads.  This value is read-only.
-The value changes according to the number of dirty pages in the system.
-
-When necessary, additional pdflush threads are created, one per second, up to
-nr_pdflush_threads_max.
-
-==============================================================
-
 nr_trim_pages
 
 This is available only on NOMMU kernels.
diff -puN fs/fs-writeback.c~mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads fs/fs-writeback.c
--- a/fs/fs-writeback.c~mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads
+++ a/fs/fs-writeback.c
@@ -52,11 +52,6 @@ struct wb_writeback_work {
 	struct completion *done;	/* set if the caller waits */
 };
 
-/*
- * We don't actually have pdflush, but this one is exported though /proc...
- */
-int nr_pdflush_threads;
-
 /**
  * writeback_in_progress - determine whether there is writeback in progress
  * @bdi: the device's backing_dev_info structure.
diff -puN include/linux/backing-dev.h~mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads
+++ a/include/linux/backing-dev.h
@@ -17,6 +17,7 @@
 #include <linux/timer.h>
 #include <linux/writeback.h>
 #include <linux/atomic.h>
+#include <linux/sysctl.h>
 
 struct page;
 struct device;
@@ -304,6 +305,8 @@ void clear_bdi_congested(struct backing_
 void set_bdi_congested(struct backing_dev_info *bdi, int sync);
 long congestion_wait(int sync, long timeout);
 long wait_iff_congested(struct zone *zone, int sync, long timeout);
+int pdflush_proc_obsolete(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp, loff_t *ppos);
 
 static inline bool bdi_cap_writeback_dirty(struct backing_dev_info *bdi)
 {
diff -puN include/linux/writeback.h~mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads include/linux/writeback.h
--- a/include/linux/writeback.h~mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads
+++ a/include/linux/writeback.h
@@ -189,9 +189,4 @@ void tag_pages_for_writeback(struct addr
 
 void account_page_redirty(struct page *page);
 
-/* pdflush.c */
-extern int nr_pdflush_threads;	/* Global so it can be exported to sysctl
-				   read-only. */
-
-
 #endif		/* WRITEBACK_H */
diff -puN kernel/sysctl.c~mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads kernel/sysctl.c
--- a/kernel/sysctl.c~mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads
+++ a/kernel/sysctl.c
@@ -1106,11 +1106,9 @@ static struct ctl_table vm_table[] = {
 		.extra1		= &zero,
 	},
 	{
-		.procname	= "nr_pdflush_threads",
-		.data		= &nr_pdflush_threads,
-		.maxlen		= sizeof nr_pdflush_threads,
-		.mode		= 0444 /* read-only*/,
-		.proc_handler	= proc_dointvec,
+		.procname       = "nr_pdflush_threads",
+		.mode           = 0444 /* read-only */,
+		.proc_handler   = pdflush_proc_obsolete,
 	},
 	{
 		.procname	= "swappiness",
diff -puN kernel/sysctl_binary.c~mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads kernel/sysctl_binary.c
--- a/kernel/sysctl_binary.c~mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads
+++ a/kernel/sysctl_binary.c
@@ -147,7 +147,7 @@ static const struct bin_table bin_vm_tab
 	{ CTL_INT,	VM_DIRTY_RATIO,			"dirty_ratio" },
 	/* VM_DIRTY_WB_CS "dirty_writeback_centisecs" no longer used */
 	/* VM_DIRTY_EXPIRE_CS "dirty_expire_centisecs" no longer used */
-	{ CTL_INT,	VM_NR_PDFLUSH_THREADS,		"nr_pdflush_threads" },
+	/* VM_NR_PDFLUSH_THREADS "nr_pdflush_threads" no longer used */
 	{ CTL_INT,	VM_OVERCOMMIT_RATIO,		"overcommit_ratio" },
 	/* VM_PAGEBUF unused */
 	/* VM_HUGETLB_PAGES "nr_hugepages" no longer used */
diff -puN mm/backing-dev.c~mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads mm/backing-dev.c
--- a/mm/backing-dev.c~mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads
+++ a/mm/backing-dev.c
@@ -886,3 +886,23 @@ out:
 	return ret;
 }
 EXPORT_SYMBOL(wait_iff_congested);
+
+int pdflush_proc_obsolete(struct ctl_table *table, int write,
+			void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	char kbuf[] = "0\n";
+
+	if (*ppos) {
+		*lenp = 0;
+		return 0;
+	}
+
+	if (copy_to_user(buffer, kbuf, sizeof(kbuf)))
+		return -EFAULT;
+	printk_once(KERN_WARNING "%s exported in /proc is scheduled for removal\n",
+			table->procname);
+
+	*lenp = 2;
+	*ppos += *lenp;
+	return 2;
+}
_
Subject: Subject: mm: prepare for removal of obsolete /proc/sys/vm/nr_pdflush_threads

Patches currently in -mm which might be from liwp@linux.vnet.ibm.com are

mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads.patch


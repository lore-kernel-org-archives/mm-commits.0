From: akpm@linux-foundation.org
Subject: + mm-add-dirty_highmem-option.patch added to -mm tree
Date: Mon, 26 Nov 2007 20:54:34 -0800
Message-ID: <200711270454.lAR4sYw7027691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34753 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757610AbXK0Eys (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 23:54:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: brong@fastmail.fm, a.p.zijlstra@chello.nl, solo@google.com, torvalds@linux-foundation.org, wfg@mail.ustc.edu.cn


The patch titled
     mm: add dirty_highmem option
has been added to the -mm tree.  Its filename is
     mm-add-dirty_highmem-option.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: add dirty_highmem option
From: Bron Gondwana <brong@fastmail.fm>

A 32 bit machine with HIGHMEM64 enabled running DCC has an MMAPed file of
approximately 2Gb size which contains a hash format that is written
"randomly" by the dbclean process.  On 2.6.16 this process took a few
minutes.  With lowmem only accounting of dirty ratios, this takes about 12
hours of 100% disk IO, all random writes.

This patch includes some code cleanup from Linus and a toggle in
/proc/sys/vm/dirty_highmem which can be set to 1 to add the highmem back to
the total available memory count.

Signed-off-by: Bron Gondwana <brong@fastmail.fm>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: WU Fengguang <wfg@mail.ustc.edu.cn>
Cc: Ethan Solomita <solo@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   12 ++++++++++++
 Documentation/sysctl/vm.txt        |    9 +++++----
 include/linux/writeback.h          |    1 +
 kernel/sysctl.c                    |   16 +++++++++++++++-
 mm/page-writeback.c                |    9 ++++++++-
 5 files changed, 41 insertions(+), 6 deletions(-)

diff -puN Documentation/filesystems/proc.txt~mm-add-dirty_highmem-option Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-add-dirty_highmem-option
+++ a/Documentation/filesystems/proc.txt
@@ -1258,6 +1258,18 @@ dirty_background_ratio
 Contains, as a percentage of total system memory, the number of pages at which
 the pdflush background writeback daemon will start writing out dirty data.
 
+dirty_highmem
+-------------
+
+Contains, as a boolean, a switch to allow highmem to be counted as
+part of the "available" memory against which the dirty ratios will be
+applied.
+
+Setting this to 1 can be useful on 32 bit machines where you want to make
+random changes within an MMAPed file that is larger than your available
+lowmem, however it is potentially dangerous and has serious bounce-buffer
+issues.
+
 dirty_ratio
 -----------------
 
diff -puN Documentation/sysctl/vm.txt~mm-add-dirty_highmem-option Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-add-dirty_highmem-option
+++ a/Documentation/sysctl/vm.txt
@@ -18,6 +18,7 @@ files can be found in mm/swap.c.
 Currently, these files are in /proc/sys/vm:
 - overcommit_memory
 - page-cluster
+- dirty_highmem
 - dirty_ratio
 - dirty_background_ratio
 - dirty_expire_centisecs
@@ -37,10 +38,10 @@ Currently, these files are in /proc/sys/
 
 ==============================================================
 
-dirty_ratio, dirty_background_ratio, dirty_expire_centisecs,
-dirty_writeback_centisecs, vfs_cache_pressure, laptop_mode,
-block_dump, swap_token_timeout, drop-caches,
-hugepages_treat_as_movable:
+dirty_highmem, dirty_ratio, dirty_background_ratio,
+dirty_expire_centisecs, dirty_writeback_centisecs,
+vfs_cache_pressure, laptop_mode, block_dump,
+swap_token_timeout, drop-caches, hugepages_treat_as_movable:
 
 See Documentation/filesystems/proc.txt
 
diff -puN include/linux/writeback.h~mm-add-dirty_highmem-option include/linux/writeback.h
--- a/include/linux/writeback.h~mm-add-dirty_highmem-option
+++ a/include/linux/writeback.h
@@ -98,6 +98,7 @@ void throttle_vm_writeout(gfp_t gfp_mask
 
 /* These are exported to sysctl. */
 extern int dirty_background_ratio;
+extern int vm_dirty_highmem;
 extern int vm_dirty_ratio;
 extern int dirty_writeback_interval;
 extern int dirty_expire_interval;
diff -puN kernel/sysctl.c~mm-add-dirty_highmem-option kernel/sysctl.c
--- a/kernel/sysctl.c~mm-add-dirty_highmem-option
+++ a/kernel/sysctl.c
@@ -82,9 +82,10 @@ extern int maps_protect;
 extern int sysctl_stat_interval;
 extern int audit_argv_kb;
 
+static int one = 1;
+
 /* Constants used for minimum and  maximum */
 #ifdef CONFIG_DETECT_SOFTLOCKUP
-static int one = 1;
 static int sixty = 60;
 #endif
 
@@ -1081,6 +1082,19 @@ static struct ctl_table vm_table[] = {
 		.extra1		= &zero,
 	},
 #endif
+#ifdef CONFIG_HIGHMEM
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "dirty_highmem",
+		.data		= &vm_dirty_highmem,
+		.maxlen		= sizeof(vm_dirty_highmem),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+#endif
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
diff -puN mm/page-writeback.c~mm-add-dirty_highmem-option mm/page-writeback.c
--- a/mm/page-writeback.c~mm-add-dirty_highmem-option
+++ a/mm/page-writeback.c
@@ -69,6 +69,12 @@ static inline long sync_writeback_pages(
 int dirty_background_ratio = 5;
 
 /*
+ * free highmem will not be subtracted from the total free memory
+ * for calculating free ratios if vm_dirty_highmem is true
+ */
+int vm_dirty_highmem;
+
+/*
  * The generator of dirty data starts writeback at this percentage
  */
 int vm_dirty_ratio = 10;
@@ -287,7 +293,8 @@ static unsigned long determine_dirtyable
 	x = global_page_state(NR_FREE_PAGES)
 		+ global_page_state(NR_INACTIVE)
 		+ global_page_state(NR_ACTIVE);
-	x -= highmem_dirtyable_memory(x);
+	if (!vm_dirty_highmem)
+		x -= highmem_dirtyable_memory(x);
 	return x + 1;	/* Ensure that we never return 0 */
 }
 
_

Patches currently in -mm which might be from brong@fastmail.fm are

mm-add-dirty_highmem-option.patch
mm-add-dirty_highmem-option-fix.patch

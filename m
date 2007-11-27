From: akpm@linux-foundation.org
Subject: + mm-page-writeback-highmem_is_dirtyable-option.patch added to -mm tree
Date: Tue, 27 Nov 2007 14:24:58 -0800
Message-ID: <200711272224.lARMOwBu002547@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47671 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751830AbXK0WZO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 17:25:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: brong@fastmail.fm, a.p.zijlstra@chello.nl, solo@google.com, torvalds@linux-foundation.org, wfg@mail.ustc.edu.cn


The patch titled
     mm/page-writeback: highmem_is_dirtyable option
has been added to the -mm tree.  Its filename is
     mm-page-writeback-highmem_is_dirtyable-option.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm/page-writeback: highmem_is_dirtyable option
From: Bron Gondwana <brong@fastmail.fm>

Add vm.highmem_is_dirtyable toggle

A 32 bit machine with HIGHMEM64 enabled running DCC has an MMAPed file of
approximately 2Gb size which contains a hash format that is written
randomly by the dbclean process.  On 2.6.16 this process took a few
minutes.  With lowmem only accounting of dirty ratios, this takes about 12
hours of 100% disk IO, all random writes.

Include a toggle in /proc/sys/vm/highmem_is_dirtyable which can be set to 1 to
add the highmem back to the total available memory count.

Signed-off-by: Bron Gondwana <brong@fastmail.fm>
Cc: Ethan Solomita <solo@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: WU Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   15 +++++++++++++++
 Documentation/sysctl/vm.txt        |    7 ++++---
 include/linux/writeback.h          |    1 +
 kernel/sysctl.c                    |   14 ++++++++++++++
 mm/page-writeback.c                |   11 ++++++++++-
 5 files changed, 44 insertions(+), 4 deletions(-)

diff -puN Documentation/filesystems/proc.txt~mm-page-writeback-highmem_is_dirtyable-option Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-page-writeback-highmem_is_dirtyable-option
+++ a/Documentation/filesystems/proc.txt
@@ -1282,6 +1282,21 @@ for writeout by the pdflush daemons.  It
 Data which has been dirty in-memory for longer than this interval will be
 written out next time a pdflush daemon wakes up.
 
+highmem_is_dirtyable
+--------------------
+
+Only present if CONFIG_HIGHMEM is set.
+
+This defaults to 0 (false), meaning that the ratios set above are calculated
+as a percentage of lowmem only.  This protects against excessive scanning
+in page reclaim, swapping and general VM distress.
+
+Setting this to 1 can be useful on 32 bit machines where you want to make
+random changes within an MMAPed file that is larger than your available
+lowmem without causing large quantities of random IO.  Is is safe if the
+behavior of all programs running on the machine is known and memory will
+not be otherwise stressed.
+
 legacy_va_layout
 ----------------
 
diff -puN Documentation/sysctl/vm.txt~mm-page-writeback-highmem_is_dirtyable-option Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-page-writeback-highmem_is_dirtyable-option
+++ a/Documentation/sysctl/vm.txt
@@ -22,6 +22,7 @@ Currently, these files are in /proc/sys/
 - dirty_background_ratio
 - dirty_expire_centisecs
 - dirty_writeback_centisecs
+- highmem_is_dirtyable   (only if CONFIG_HIGHMEM set)
 - max_map_count
 - min_free_kbytes
 - laptop_mode
@@ -38,9 +39,9 @@ Currently, these files are in /proc/sys/
 ==============================================================
 
 dirty_ratio, dirty_background_ratio, dirty_expire_centisecs,
-dirty_writeback_centisecs, vfs_cache_pressure, laptop_mode,
-block_dump, swap_token_timeout, drop-caches,
-hugepages_treat_as_movable:
+dirty_writeback_centisecs, highmem_is_dirtyable,
+vfs_cache_pressure, laptop_mode, block_dump, swap_token_timeout,
+drop-caches, hugepages_treat_as_movable:
 
 See Documentation/filesystems/proc.txt
 
diff -puN include/linux/writeback.h~mm-page-writeback-highmem_is_dirtyable-option include/linux/writeback.h
--- a/include/linux/writeback.h~mm-page-writeback-highmem_is_dirtyable-option
+++ a/include/linux/writeback.h
@@ -101,6 +101,7 @@ extern int dirty_background_ratio;
 extern int vm_dirty_ratio;
 extern int dirty_writeback_interval;
 extern int dirty_expire_interval;
+extern int vm_highmem_is_dirtyable;
 extern int block_dump;
 extern int laptop_mode;
 
diff -puN kernel/sysctl.c~mm-page-writeback-highmem_is_dirtyable-option kernel/sysctl.c
--- a/kernel/sysctl.c~mm-page-writeback-highmem_is_dirtyable-option
+++ a/kernel/sysctl.c
@@ -93,6 +93,7 @@ static int two = 2;
 #endif
 
 static int zero;
+static int one = 1;
 static int one_hundred = 100;
 
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
@@ -1099,6 +1100,19 @@ static struct ctl_table vm_table[] = {
 		.extra1		= &zero,
 	},
 #endif
+#ifdef CONFIG_HIGHMEM
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "highmem_is_dirtyable",
+		.data		= &vm_highmem_is_dirtyable,
+		.maxlen		= sizeof(vm_highmem_is_dirtyable),
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
diff -puN mm/page-writeback.c~mm-page-writeback-highmem_is_dirtyable-option mm/page-writeback.c
--- a/mm/page-writeback.c~mm-page-writeback-highmem_is_dirtyable-option
+++ a/mm/page-writeback.c
@@ -69,6 +69,12 @@ static inline long sync_writeback_pages(
 int dirty_background_ratio = 5;
 
 /*
+ * free highmem will not be subtracted from the total free memory
+ * for calculating free ratios if vm_highmem_is_dirtyable is true
+ */
+int vm_highmem_is_dirtyable;
+
+/*
  * The generator of dirty data starts writeback at this percentage
  */
 int vm_dirty_ratio = 10;
@@ -287,7 +293,10 @@ static unsigned long determine_dirtyable
 	x = global_page_state(NR_FREE_PAGES)
 		+ global_page_state(NR_INACTIVE)
 		+ global_page_state(NR_ACTIVE);
-	x -= highmem_dirtyable_memory(x);
+
+	if (!vm_highmem_is_dirtyable)
+		x -= highmem_dirtyable_memory(x);
+
 	return x + 1;	/* Ensure that we never return 0 */
 }
 
_

Patches currently in -mm which might be from brong@fastmail.fm are

mm-page-writeback-highmem_is_dirtyable-option.patch
mm-add-dirty_highmem-option.patch
mm-add-dirty_highmem-option-fix.patch

From: akpm@linux-foundation.org
Subject: + maps2-make-proc-pid-smaps-optional-under-config_embedded.patch added to -mm tree
Date: Fri, 06 Apr 2007 23:55:51 -0700
Message-ID: <200704070655.l376tpMg029490@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46465 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965524AbXDGG4A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 02:56:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com, jeremy@goop.org, rientjes@google.com


The patch titled
     maps: make /proc/pid/smaps optional under CONFIG_EMBEDDED
has been added to the -mm tree.  Its filename is
     maps2-make-proc-pid-smaps-optional-under-config_embedded.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: maps: make /proc/pid/smaps optional under CONFIG_EMBEDDED
From: Matt Mackall <mpm@selenic.com>

This interface is primarily useful for doing memory profiling and not much use
on deployed embedded boxes.  Make it optional.  Together with
/proc/pid/clear_refs, this save a few K.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c     |    4 ++++
 fs/proc/task_mmu.c |    2 ++
 init/Kconfig       |    8 ++++++++
 3 files changed, 14 insertions(+)

diff -puN fs/proc/base.c~maps2-make-proc-pid-smaps-optional-under-config_embedded fs/proc/base.c
--- a/fs/proc/base.c~maps2-make-proc-pid-smaps-optional-under-config_embedded
+++ a/fs/proc/base.c
@@ -1853,8 +1853,10 @@ static struct pid_entry tgid_base_stuff[
 	REG("mountstats", S_IRUSR, mountstats),
 #ifdef CONFIG_MMU
 	REG("clear_refs", S_IWUSR, clear_refs),
+#ifdef CONFIG_PROC_SMAPS
 	REG("smaps",      S_IRUGO, smaps),
 #endif
+#endif
 #ifdef CONFIG_SECURITY
 	DIR("attr",       S_IRUGO|S_IXUGO, attr_dir),
 #endif
@@ -2135,8 +2137,10 @@ static struct pid_entry tid_base_stuff[]
 	REG("mounts",    S_IRUGO, mounts),
 #ifdef CONFIG_MMU
 	REG("clear_refs", S_IWUSR, clear_refs),
+#ifdef CONFIG_PROC_SMAPS
 	REG("smaps",     S_IRUGO, smaps),
 #endif
+#endif
 #ifdef CONFIG_SECURITY
 	DIR("attr",      S_IRUGO|S_IXUGO, attr_dir),
 #endif
diff -puN fs/proc/task_mmu.c~maps2-make-proc-pid-smaps-optional-under-config_embedded fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~maps2-make-proc-pid-smaps-optional-under-config_embedded
+++ a/fs/proc/task_mmu.c
@@ -310,6 +310,7 @@ const struct file_operations proc_maps_o
 	.release	= seq_release_private,
 };
 
+#ifdef CONFIG_PROC_SMAPS
 struct mem_size_stats
 {
 	struct vm_area_struct *vma;
@@ -417,6 +418,7 @@ const struct file_operations proc_smaps_
 	.llseek		= seq_lseek,
 	.release	= seq_release_private,
 };
+#endif
 
 static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 				unsigned long end, void *private)
diff -puN init/Kconfig~maps2-make-proc-pid-smaps-optional-under-config_embedded init/Kconfig
--- a/init/Kconfig~maps2-make-proc-pid-smaps-optional-under-config_embedded
+++ a/init/Kconfig
@@ -492,6 +492,14 @@ config VM_EVENT_COUNTERS
 	  on EMBEDDED systems.  /proc/vmstat will only show page counts
 	  if VM event counters are disabled.
 
+config PROC_SMAPS
+	default y
+	bool "Enable /proc/pid/smaps support" if EMBEDDED && PROC_FS && MMU
+	help
+	  The /proc/pid/smaps interface reports a process's private and
+          shared memory per mapping. Disabling this interface will reduce
+          the size of the kernel for small machines.
+
 endmenu		# General setup
 
 config RT_MUTEXES
_

Patches currently in -mm which might be from mpm@selenic.com are

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
smaps-add-clear_refs-file-to-clear-reference-cleanup.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch

From: akpm@linux-foundation.org
Subject: + maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch added to -mm tree
Date: Fri, 06 Apr 2007 23:55:53 -0700
Message-ID: <200704070655.l376trmD029494@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46470 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965456AbXDGG4F (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 02:56:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com, jeremy@goop.org, rientjes@google.com


The patch titled
     maps: make /proc/pid/clear_refs option under CONFIG_EMBEDDED
has been added to the -mm tree.  Its filename is
     maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: maps: make /proc/pid/clear_refs option under CONFIG_EMBEDDED
From: Matt Mackall <mpm@selenic.com>

This interface is primarily useful for doing memory profiling and not much use
on deployed embedded boxes.  Make it optional.  Together with /proc/pid/smaps,
this save a few K.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c     |    4 ++++
 fs/proc/task_mmu.c |    2 ++
 init/Kconfig       |    9 +++++++++
 3 files changed, 15 insertions(+)

diff -puN fs/proc/base.c~maps2-make-proc-pid-clear_refs-option-under-config_embedded fs/proc/base.c
--- a/fs/proc/base.c~maps2-make-proc-pid-clear_refs-option-under-config_embedded
+++ a/fs/proc/base.c
@@ -1852,7 +1852,9 @@ static struct pid_entry tgid_base_stuff[
 	REG("mounts",     S_IRUGO, mounts),
 	REG("mountstats", S_IRUSR, mountstats),
 #ifdef CONFIG_MMU
+#ifdef CONFIG_PROC_CLEAR_REFS
 	REG("clear_refs", S_IWUSR, clear_refs),
+#endif
 #ifdef CONFIG_PROC_SMAPS
 	REG("smaps",      S_IRUGO, smaps),
 #endif
@@ -2136,7 +2138,9 @@ static struct pid_entry tid_base_stuff[]
 	LNK("exe",       exe),
 	REG("mounts",    S_IRUGO, mounts),
 #ifdef CONFIG_MMU
+#ifdef CONFIG_PROC_CLEAR_REFS
 	REG("clear_refs", S_IWUSR, clear_refs),
+#endif
 #ifdef CONFIG_PROC_SMAPS
 	REG("smaps",     S_IRUGO, smaps),
 #endif
diff -puN fs/proc/task_mmu.c~maps2-make-proc-pid-clear_refs-option-under-config_embedded fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~maps2-make-proc-pid-clear_refs-option-under-config_embedded
+++ a/fs/proc/task_mmu.c
@@ -420,6 +420,7 @@ const struct file_operations proc_smaps_
 };
 #endif
 
+#ifdef CONFIG_PROC_CLEAR_REFS
 static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 				unsigned long end, void *private)
 {
@@ -489,6 +490,7 @@ static ssize_t clear_refs_write(struct f
 const struct file_operations proc_clear_refs_operations = {
 	.write		= clear_refs_write,
 };
+#endif
 
 #ifdef CONFIG_NUMA
 extern int show_numa_map(struct seq_file *m, void *v);
diff -puN init/Kconfig~maps2-make-proc-pid-clear_refs-option-under-config_embedded init/Kconfig
--- a/init/Kconfig~maps2-make-proc-pid-clear_refs-option-under-config_embedded
+++ a/init/Kconfig
@@ -500,6 +500,15 @@ config PROC_SMAPS
           shared memory per mapping. Disabling this interface will reduce
           the size of the kernel for small machines.
 
+config PROC_CLEAR_REFS
+	default y
+	bool "Enable /proc/pid/clear_refs support" if EMBEDDED && PROC_FS && MMU
+	help
+	  The /proc/pid/clear_refs interface allows clearing the
+          referenced bits on a process's memory maps to allow monitoring
+          working set size. Disabling this interface will reduce
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

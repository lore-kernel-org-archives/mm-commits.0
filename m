From: akpm@linux-foundation.org
Subject: - maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch removed from -mm tree
Date: Tue, 16 Oct 2007 14:36:32 -0700
Message-ID: <200710162136.l9GLaW3Z018593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54324 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965438AbXJPVhP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:37:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, jeremy@goop.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     maps: make /proc/pid/clear_refs option under CONFIG_EMBEDDED
has been removed from the -mm tree.  Its filename was
     maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch

This patch was dropped because an updated version will be merged

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
@@ -2033,7 +2033,9 @@ static const struct pid_entry tgid_base_
 	REG("mounts",     S_IRUGO, mounts),
 	REG("mountstats", S_IRUSR, mountstats),
 #ifdef CONFIG_MMU
+#ifdef CONFIG_PROC_CLEAR_REFS
 	REG("clear_refs", S_IWUSR, clear_refs),
+#endif
 #ifdef CONFIG_PROC_SMAPS
 	REG("smaps",      S_IRUGO, smaps),
 #endif
@@ -2321,7 +2323,9 @@ static const struct pid_entry tid_base_s
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
@@ -424,6 +424,7 @@ const struct file_operations proc_smaps_
 };
 #endif
 
+#ifdef CONFIG_PROC_CLEAR_REFS
 static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 				unsigned long end, void *private)
 {
@@ -493,6 +494,7 @@ static ssize_t clear_refs_write(struct f
 const struct file_operations proc_clear_refs_operations = {
 	.write		= clear_refs_write,
 };
+#endif
 
 #ifdef CONFIG_NUMA
 extern int show_numa_map(struct seq_file *m, void *v);
diff -puN init/Kconfig~maps2-make-proc-pid-clear_refs-option-under-config_embedded init/Kconfig
--- a/init/Kconfig~maps2-make-proc-pid-clear_refs-option-under-config_embedded
+++ a/init/Kconfig
@@ -604,6 +604,15 @@ config PROC_SMAPS
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

origin.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-return-length-calculation.patch
maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-end-address-calculation.patch
maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-header-copy-to-userspace.patch
maps2-add-proc-kpagemap-interface.patch
mmaps2-vma-out-of-mem_size_stats.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
maps-pssproportional-set-size-accounting-in-smaps.patch
lib-sortc-optimization.patch
sparse-pointer-use-of-zero-as-null.patch
sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch

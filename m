From: akpm@linux-foundation.org
Subject: - maps2-make-proc-pid-smaps-optional-under-config_embedded.patch removed from -mm tree
Date: Tue, 16 Oct 2007 14:36:30 -0700
Message-ID: <200710162136.l9GLaUW8018586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42040 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934737AbXJPVhG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:37:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, jeremy@goop.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     maps: make /proc/pid/smaps optional under CONFIG_EMBEDDED
has been removed from the -mm tree.  Its filename was
     maps2-make-proc-pid-smaps-optional-under-config_embedded.patch

This patch was dropped because an updated version will be merged

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
@@ -2034,8 +2034,10 @@ static const struct pid_entry tgid_base_
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
@@ -2320,8 +2322,10 @@ static const struct pid_entry tid_base_s
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
@@ -314,6 +314,7 @@ const struct file_operations proc_maps_o
 	.release	= seq_release_private,
 };
 
+#ifdef CONFIG_PROC_SMAPS
 struct mem_size_stats
 {
 	struct vm_area_struct *vma;
@@ -421,6 +422,7 @@ const struct file_operations proc_smaps_
 	.llseek		= seq_lseek,
 	.release	= seq_release_private,
 };
+#endif
 
 static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 				unsigned long end, void *private)
diff -puN init/Kconfig~maps2-make-proc-pid-smaps-optional-under-config_embedded init/Kconfig
--- a/init/Kconfig~maps2-make-proc-pid-smaps-optional-under-config_embedded
+++ a/init/Kconfig
@@ -596,6 +596,14 @@ config SLOB
 
 endchoice
 
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

origin.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
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

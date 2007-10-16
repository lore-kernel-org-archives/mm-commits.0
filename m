From: akpm@linux-foundation.org
Subject: - maps2-add-proc-kpagemap-interface.patch removed from -mm tree
Date: Tue, 16 Oct 2007 14:36:45 -0700
Message-ID: <200710162136.l9GLajcL018616@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59437 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966103AbXJPVtJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:49:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, bunk@stusta.de, jeremy@goop.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     maps: add /proc/kpagemap interface
has been removed from the -mm tree.  Its filename was
     maps2-add-proc-kpagemap-interface.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: maps: add /proc/kpagemap interface
From: Matt Mackall <mpm@selenic.com>

This makes physical page flags and counts available to userspace.  Together
with /proc/pid/pagemap and /proc/pid/clear_refs, this can be used to measure
memory usage on a per-page basis.

[bunk@stusta.de: make struct proc_kpagemap static]
Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_misc.c |   92 ++++++++++++++++++++++++++++++++++++++++++
 init/Kconfig        |    9 ++++
 2 files changed, 101 insertions(+)

diff -puN fs/proc/proc_misc.c~maps2-add-proc-kpagemap-interface fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~maps2-add-proc-kpagemap-interface
+++ a/fs/proc/proc_misc.c
@@ -46,6 +46,8 @@
 #include <linux/vmalloc.h>
 #include <linux/crash_dump.h>
 #include <linux/pid_namespace.h>
+#include <linux/ptrace.h>
+#include <linux/bootmem.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
@@ -670,6 +672,91 @@ static const struct file_operations proc
 };
 #endif
 
+#ifdef CONFIG_PROC_KPAGEMAP
+#define KPMSIZE (sizeof(unsigned long) * 2)
+#define KPMMASK (KPMSIZE - 1)
+/* /proc/kpagemap - an array exposing page flags and counts
+ *
+ * Each entry is a pair of unsigned longs representing the
+ * corresponding physical page, the first containing the page flags
+ * and the second containing the page use count.
+ *
+ * The first 4 bytes of this file form a simple header:
+ *
+ * first byte:   0 for big endian, 1 for little
+ * second byte:  page shift (eg 12 for 4096 byte pages)
+ * third byte:   entry size in bytes (currently either 4 or 8)
+ * fourth byte:  header size
+ */
+static ssize_t kpagemap_read(struct file *file, char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	unsigned long *page;
+	struct page *ppage;
+	unsigned long src = *ppos;
+	unsigned long pfn;
+	ssize_t ret = 0;
+	int chunk, i;
+
+	pfn = src / KPMSIZE - 1;
+	count = min_t(size_t, count, ((max_pfn + 1) * KPMSIZE) - src);
+	if (src & KPMMASK || count & KPMMASK)
+		return -EIO;
+
+	page = (unsigned long *)__get_free_page(GFP_USER);
+	if (!page)
+		return -ENOMEM;
+
+	while (count > 0) {
+		chunk = min_t(size_t, count, PAGE_SIZE);
+		i = 0;
+
+		if (pfn == -1) {
+			page[0] = 0;
+			page[1] = 0;
+			((char *)page)[0] = (ntohl(1) != 1);
+			((char *)page)[1] = PAGE_SHIFT;
+			((char *)page)[2] = sizeof(unsigned long);
+			((char *)page)[3] = KPMSIZE;
+			i = 2;
+			pfn++;
+		}
+
+		for (; i < 2 * chunk / KPMSIZE; i += 2, pfn++) {
+			ppage = pfn_to_page(pfn);
+			if (!ppage) {
+				page[i] = 0;
+				page[i + 1] = 0;
+			} else {
+				page[i] = ppage->flags;
+				page[i + 1] = atomic_read(&ppage->_count);
+			}
+		}
+		chunk = (i / 2) * KPMSIZE;
+
+		if (copy_to_user(buf, page, chunk)) {
+			ret = -EFAULT;
+			break;
+		}
+		ret += chunk;
+		src += chunk;
+		buf += chunk;
+		count -= chunk;
+		cond_resched();
+	}
+	*ppos = src;
+
+	free_page((unsigned long)page);
+	return ret;
+}
+
+static struct proc_dir_entry *proc_kpagemap;
+static struct file_operations proc_kpagemap_operations = {
+	.llseek = mem_lseek,
+	.read = kpagemap_read,
+};
+#endif
+
 struct proc_dir_entry *proc_root_kcore;
 
 void create_seq_entry(char *name, mode_t mode, const struct file_operations *f)
@@ -750,6 +837,11 @@ void __init proc_misc_init(void)
 				(size_t)high_memory - PAGE_OFFSET + PAGE_SIZE;
 	}
 #endif
+#ifdef CONFIG_PROC_KPAGEMAP
+	proc_kpagemap = create_proc_entry("kpagemap", S_IRUSR, NULL);
+	if (proc_kpagemap)
+		proc_kpagemap->proc_fops = &proc_kpagemap_operations;
+#endif
 #ifdef CONFIG_PROC_VMCORE
 	proc_vmcore = create_proc_entry("vmcore", S_IRUSR, NULL);
 	if (proc_vmcore)
diff -puN init/Kconfig~maps2-add-proc-kpagemap-interface init/Kconfig
--- a/init/Kconfig~maps2-add-proc-kpagemap-interface
+++ a/init/Kconfig
@@ -623,6 +623,15 @@ config PROC_PAGEMAP
           with other processes. Disabling this interface will reduce the
           size of the kernel for small machines.
 
+config PROC_KPAGEMAP
+	default y
+	bool "Enable /proc/kpagemap support" if EMBEDDED && PROC_FS
+	help
+	  The /proc/pid/kpagemap interface allows reading the
+          kernel's per-page flag and usage counts to gather precise
+          information on page-level memory usage. Disabling this interface
+          will reduce the size of the kernel for small machines.
+
 endmenu		# General setup
 
 config RT_MUTEXES
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch
maps2-add-proc-kpagemap-interface.patch
mmaps2-vma-out-of-mem_size_stats.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
maps-pssproportional-set-size-accounting-in-smaps.patch
lib-sortc-optimization.patch
sparse-pointer-use-of-zero-as-null.patch
sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch

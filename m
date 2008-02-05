From: akpm@linux-foundation.org
Subject: - maps4-add-proc-kpagecount-interface.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:31:19 -0800
Message-ID: <200802052231.m15MV0Dr012122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58398 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761883AbYBEWng (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, bunk@stusta.de, haveblue@us.ibm.com, jeremy@goop.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     maps4: add /proc/kpagecount interface
has been removed from the -mm tree.  Its filename was
     maps4-add-proc-kpagecount-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: maps4: add /proc/kpagecount interface
From: Matt Mackall <mpm@selenic.com>

This makes physical page map counts available to userspace. Together
with /proc/pid/pagemap and /proc/pid/clear_refs, this can be used to
monitor memory usage on a per-page basis.

[akpm@linux-foundation.org: remove unneeded access_ok()]
[bunk@stusta.de: make struct proc_kpagemap static]
Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_misc.c |   50 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff -puN fs/proc/proc_misc.c~maps4-add-proc-kpagecount-interface fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~maps4-add-proc-kpagecount-interface
+++ a/fs/proc/proc_misc.c
@@ -46,6 +46,7 @@
 #include <linux/vmalloc.h>
 #include <linux/crash_dump.h>
 #include <linux/pid_namespace.h>
+#include <linux/bootmem.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
@@ -675,6 +676,54 @@ static const struct file_operations proc
 };
 #endif
 
+#define KPMSIZE sizeof(u64)
+#define KPMMASK (KPMSIZE - 1)
+/* /proc/kpagecount - an array exposing page counts
+ *
+ * Each entry is a u64 representing the corresponding
+ * physical page count.
+ */
+static ssize_t kpagecount_read(struct file *file, char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	u64 __user *out = (u64 __user *)buf;
+	struct page *ppage;
+	unsigned long src = *ppos;
+	unsigned long pfn;
+	ssize_t ret = 0;
+	u64 pcount;
+
+	pfn = src / KPMSIZE;
+	count = min_t(size_t, count, (max_pfn * KPMSIZE) - src);
+	if (src & KPMMASK || count & KPMMASK)
+		return -EIO;
+
+	while (count > 0) {
+		ppage = pfn_to_page(pfn++);
+		if (!ppage)
+			pcount = 0;
+		else
+			pcount = atomic_read(&ppage->_count);
+
+		if (put_user(pcount, out++)) {
+			ret = -EFAULT;
+			break;
+		}
+
+		count -= KPMSIZE;
+	}
+
+	*ppos += (char __user *)out - buf;
+	if (!ret)
+		ret = (char __user *)out - buf;
+	return ret;
+}
+
+static struct file_operations proc_kpagecount_operations = {
+	.llseek = mem_lseek,
+	.read = kpagecount_read,
+};
+
 struct proc_dir_entry *proc_root_kcore;
 
 void create_seq_entry(char *name, mode_t mode, const struct file_operations *f)
@@ -755,6 +804,7 @@ void __init proc_misc_init(void)
 				(size_t)high_memory - PAGE_OFFSET + PAGE_SIZE;
 	}
 #endif
+	create_seq_entry("kpagecount", S_IRUSR, &proc_kpagecount_operations);
 #ifdef CONFIG_PROC_VMCORE
 	proc_vmcore = create_proc_entry("vmcore", S_IRUSR, NULL);
 	if (proc_vmcore)
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch
drivers-char-randomcwrite_pool-cond_resched-needed.patch
random-clean-up-checkpatch-complaints.patch
random-clean-up-checkpatch-complaints-fix.patch
random-consolidate-wakeup-logic.patch
random-use-unlocked_ioctl.patch
random-reuse-rand_initialize.patch
random-improve-variable-naming-clear-extract-buffer.patch
random-make-backtracking-attacks-harder.patch
random-remove-cacheline-alignment-for-locks.patch
random-eliminate-redundant-new_rotate-variable.patch
random-remove-some-prefetch-logic.patch
random-simplify-add_ptr-logic.patch
random-make-mixing-interface-byte-oriented.patch
random-simplify-and-rename-credit_entropy_store.patch
random-add-async-notification-support-to-dev-random.patch

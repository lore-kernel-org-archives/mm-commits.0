From: akpm@linux-foundation.org
Subject: + maps4-add-proc-kpageflags-interface.patch added to -mm tree
Date: Mon, 29 Oct 2007 14:57:46 -0700
Message-ID: <200710292157.l9TLvkq3025372@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38291 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753582AbXJ2V6g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 17:58:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com, haveblue@us.ibm.com


The patch titled
     maps4: add /proc/kpageflags interface
has been added to the -mm tree.  Its filename is
     maps4-add-proc-kpageflags-interface.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: maps4: add /proc/kpageflags interface
From: Matt Mackall <mpm@selenic.com>

This makes a subset of physical page flags available to userspace. Together
with /proc/pid/kpagemap, this allows tracking of a wide variety of VM behaviors.

Exported flags are decoupled from the kernel's internal flags. This
allows us to reorder flag bits, and synthesize any bits that get
redefined in terms of other bits.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_misc.c |   79 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff -puN fs/proc/proc_misc.c~maps4-add-proc-kpageflags-interface fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~maps4-add-proc-kpageflags-interface
+++ a/fs/proc/proc_misc.c
@@ -727,6 +727,84 @@ static struct file_operations proc_kpage
 	.read = kpagecount_read,
 };
 
+/* /proc/kpageflags - an array exposing page flags
+ *
+ * Each entry is a u64 representing the corresponding
+ * physical page flags.
+ */
+
+/* These macros are used to decouple internal flags from exported ones */
+
+#define KPF_LOCKED     0
+#define KPF_ERROR      1
+#define KPF_REFERENCED 2
+#define KPF_UPTODATE   3
+#define KPF_DIRTY      4
+#define KPF_LRU        5
+#define KPF_ACTIVE     6
+#define KPF_SLAB       7
+#define KPF_WRITEBACK  8
+#define KPF_RECLAIM    9
+#define KPF_BUDDY     10
+
+#define kpf_copy_bit(flags, srcpos, dstpos) (((flags >> srcpos) & 1) << dstpos)
+
+static ssize_t kpageflags_read(struct file *file, char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	u64 __user *out = (u64 __user *)buf;
+	struct page *ppage;
+	unsigned long src = *ppos;
+	unsigned long pfn;
+	ssize_t ret = 0;
+	u64 kflags, uflags;
+
+	if (!access_ok(VERIFY_WRITE, buf, count))
+		return -EFAULT;
+
+	pfn = src / KPMSIZE;
+	count = min_t(unsigned long, count, (max_pfn * KPMSIZE) - src);
+	if (src & KPMMASK || count & KPMMASK)
+		return -EIO;
+
+	while (count > 0) {
+		ppage = pfn_to_page(pfn++);
+		if (!ppage)
+			kflags = 0;
+		else
+			kflags = ppage->flags;
+
+		uflags = kpf_copy_bit(KPF_LOCKED, PG_locked, kflags) |
+			kpf_copy_bit(kflags, KPF_ERROR, PG_error) |
+			kpf_copy_bit(kflags, KPF_REFERENCED, PG_referenced) |
+			kpf_copy_bit(kflags, KPF_UPTODATE, PG_uptodate) |
+			kpf_copy_bit(kflags, KPF_DIRTY, PG_dirty) |
+			kpf_copy_bit(kflags, KPF_LRU, PG_lru) |
+			kpf_copy_bit(kflags, KPF_ACTIVE, PG_active) |
+			kpf_copy_bit(kflags, KPF_SLAB, PG_slab) |
+			kpf_copy_bit(kflags, KPF_WRITEBACK, PG_writeback) |
+			kpf_copy_bit(kflags, KPF_RECLAIM, PG_reclaim) |
+			kpf_copy_bit(kflags, KPF_BUDDY, PG_buddy);
+
+		if (put_user(uflags, out++)) {
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
+static struct file_operations proc_kpageflags_operations = {
+	.llseek = mem_lseek,
+	.read = kpageflags_read,
+};
+
 struct proc_dir_entry *proc_root_kcore;
 
 void create_seq_entry(char *name, mode_t mode, const struct file_operations *f)
@@ -808,6 +886,7 @@ void __init proc_misc_init(void)
 	}
 #endif
 	create_seq_entry("kpagecount", S_IRUSR, &proc_kpagecount_operations);
+	create_seq_entry("kpageflags", S_IRUSR, &proc_kpageflags_operations);
 #ifdef CONFIG_PROC_VMCORE
 	proc_vmcore = create_proc_entry("vmcore", S_IRUSR, NULL);
 	if (proc_vmcore)
_

Patches currently in -mm which might be from mpm@selenic.com are

maps4-add-proportional-set-size-accounting-in-smaps.patch
maps4-from-dave-hansen-haveblue-usibmcom.patch
maps4-move-is_swap_pte.patch
maps4-introduce-a-generic-page-walker.patch
maps4-use-pagewalker-in-clear_refs-and-smaps.patch
maps4-simplify-interdependence-of-maps-and-smaps.patch
maps4-move-clear_refs-code-to-task_mmuc.patch
maps4-regroup-task_mmu-by-interface.patch
maps4-add-proc-pid-pagemap-interface.patch
maps4-add-proc-kpagecount-interface.patch
maps4-add-proc-kpageflags-interface.patch
maps4-make-page-monitoring-proc-file-optional.patch

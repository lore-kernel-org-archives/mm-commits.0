From: akpm@linux-foundation.org
Subject: + vmalloc-show-vmalloced-areas-via-proc-vmallocinfo.patch added to -mm tree
Date: Wed, 19 Mar 2008 15:05:30 -0700
Message-ID: <200803192205.m2JM5V3s006265@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761742AbYCSWGN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Mar 2008 18:06:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, hugh@veritas.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au


The patch titled
     vmalloc: show vmalloced areas via /proc/vmallocinfo
has been added to the -mm tree.  Its filename is
     vmalloc-show-vmalloced-areas-via-proc-vmallocinfo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmalloc: show vmalloced areas via /proc/vmallocinfo
From: Christoph Lameter <clameter@sgi.com>

Implement a new proc file that allows the display of the currently allocated
vmalloc memory.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_misc.c     |   14 +++++++
 include/linux/vmalloc.h |    2 +
 mm/vmalloc.c            |   76 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 91 insertions(+), 1 deletion(-)

diff -puN fs/proc/proc_misc.c~vmalloc-show-vmalloced-areas-via-proc-vmallocinfo fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~vmalloc-show-vmalloced-areas-via-proc-vmallocinfo
+++ a/fs/proc/proc_misc.c
@@ -456,6 +456,18 @@ static const struct file_operations proc
 #endif
 #endif
 
+static int vmalloc_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &vmalloc_op);
+}
+
+static const struct file_operations proc_vmalloc_operations = {
+	.open		= vmalloc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 static int show_stat(struct seq_file *p, void *v)
 {
 	int i;
@@ -869,6 +881,8 @@ void __init proc_misc_init(void)
 	create_seq_entry("slab_allocators", 0 ,&proc_slabstats_operations);
 #endif
 #endif
+	proc_create("vmallocinfo",S_IWUSR|S_IRUGO, NULL,
+						&proc_vmalloc_operations);
 	create_seq_entry("buddyinfo",S_IRUGO, &fragmentation_file_operations);
 	create_seq_entry("pagetypeinfo", S_IRUGO, &pagetypeinfo_file_ops);
 	create_seq_entry("vmstat",S_IRUGO, &proc_vmstat_file_operations);
diff -puN include/linux/vmalloc.h~vmalloc-show-vmalloced-areas-via-proc-vmallocinfo include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~vmalloc-show-vmalloced-areas-via-proc-vmallocinfo
+++ a/include/linux/vmalloc.h
@@ -87,4 +87,6 @@ extern void free_vm_area(struct vm_struc
 extern rwlock_t vmlist_lock;
 extern struct vm_struct *vmlist;
 
+extern const struct seq_operations vmalloc_op;
+
 #endif /* _LINUX_VMALLOC_H */
diff -puN mm/vmalloc.c~vmalloc-show-vmalloced-areas-via-proc-vmallocinfo mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-show-vmalloced-areas-via-proc-vmallocinfo
+++ a/mm/vmalloc.c
@@ -14,7 +14,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
-
+#include <linux/seq_file.h>
 #include <linux/vmalloc.h>
 
 #include <asm/uaccess.h>
@@ -873,3 +873,77 @@ void free_vm_area(struct vm_struct *area
 	kfree(area);
 }
 EXPORT_SYMBOL_GPL(free_vm_area);
+
+
+#ifdef CONFIG_PROC_FS
+static void *s_start(struct seq_file *m, loff_t *pos)
+{
+	loff_t n = *pos;
+	struct vm_struct *v;
+
+	read_lock(&vmlist_lock);
+	v = vmlist;
+	while (n > 0 && v) {
+		n--;
+		v = v->next;
+	}
+	if (!n)
+		return v;
+
+	return NULL;
+
+}
+
+static void *s_next(struct seq_file *m, void *p, loff_t *pos)
+{
+	struct vm_struct *v = p;
+
+	++*pos;
+	return v->next;
+}
+
+static void s_stop(struct seq_file *m, void *p)
+{
+	read_unlock(&vmlist_lock);
+}
+
+static int s_show(struct seq_file *m, void *p)
+{
+	struct vm_struct *v = p;
+
+	seq_printf(m, "0x%p-0x%p %7ld",
+		v->addr, v->addr + v->size, v->size);
+
+	if (v->nr_pages)
+		seq_printf(m, " pages=%d", v->nr_pages);
+
+	if (v->phys_addr)
+		seq_printf(m, " phys=%lx", v->phys_addr);
+
+	if (v->flags & VM_IOREMAP)
+		seq_printf(m, " ioremap");
+
+	if (v->flags & VM_ALLOC)
+		seq_printf(m, " vmalloc");
+
+	if (v->flags & VM_MAP)
+		seq_printf(m, " vmap");
+
+	if (v->flags & VM_USERMAP)
+		seq_printf(m, " user");
+
+	if (v->flags & VM_VPAGES)
+		seq_printf(m, " vpages");
+
+	seq_putc(m, '\n');
+	return 0;
+}
+
+const struct seq_operations vmalloc_op = {
+	.start = s_start,
+	.next = s_next,
+	.stop = s_stop,
+	.show = s_show,
+};
+#endif
+
_

Patches currently in -mm which might be from clameter@sgi.com are

mm-fix-boundary-checking-in-free_bootmem_core.patch
mm-fix-boundary-checking-in-free_bootmem_core-fix.patch
x86_64-free_bootmem-should-take-phy.patch
git-unionfs.patch
git-slub.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
remove-set_migrateflags.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-fix-memcg-ooms.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages-do_try_to_free_pages-gfp_mask-redundant.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework.patch
mm-move-cache_line_size-to-linux-cacheh.patch
mempolicy-convert-mpol-constants-to-enum.patch
mempolicy-support-optional-mode-flags.patch
mempolicy-support-optional-mode-flags-fix.patch
mempolicy-add-mpol_f_static_nodes-flag.patch
mempolicy-add-bitmap_onto-and-bitmap_fold-operations.patch
mempolicy-add-mpol_f_relative_nodes-flag.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-move-rebind-functions.patch
mempolicy-create-mempolicy_operations-structure.patch
mempolicy-create-mempolicy_operations-structure-fix.patch
mempolicy-small-header-file-cleanup.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
mempolicy-fix-parsing-of-tmpfs-mpol-mount-option.patch
mm-make-mem_map-allocation-continuous.patch
mm-fix-alloc_bootmem_core-to-use-fast-searching-for-all-nodes.patch
mm-allocate-section_map-for-sparse_init.patch
mm-make-early_pfn_to_nid-a-c-function.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-checkpatch-fixes.patch
vmallocinfo-add-caller-information.patch
vmallocinfo-add-caller-information-checkpatch-fixes.patch
mm-add-nr_writeback_temp-counter.patch
remove-div_long_long_rem.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch


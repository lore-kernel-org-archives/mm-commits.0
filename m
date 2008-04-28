From: akpm@linux-foundation.org
Subject: - vmalloc-show-vmalloced-areas-via-proc-vmallocinfo.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:52:03 -0700
Message-ID: <200804282152.m3SLq36R017715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965032AbYD1VwP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:52:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, arjan@infradead.org, hugh@veritas.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     vmalloc: show vmalloced areas via /proc/vmallocinfo
has been removed from the -mm tree.  Its filename was
     vmalloc-show-vmalloced-areas-via-proc-vmallocinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmalloc: show vmalloced areas via /proc/vmallocinfo
From: Christoph Lameter <clameter@sgi.com>

Implement a new proc file that allows the display of the currently allocated
vmalloc memory.

It allows to see the users of vmalloc.  That is important if vmalloc space is
scarce (i386 for example).

And it's going to be important for the compound page fallback to vmalloc. 
Many of the current users can be switched to use compound pages with fallback.
 This means that the number of users of vmalloc is reduced and page tables no
longer necessary to access the memory.  /proc/vmallocinfo allows to review how
that reduction occurs.

If memory becomes fragmented and larger order allocations are no longer
possible then /proc/vmallocinfo allows to see which compound page allocations
fell back to virtual compound pages.  That is important for new users of
virtual compound pages.  Such as order 1 stack allocation etc that may
fallback to virtual compound pages in the future.

/proc/vmallocinfo permissions are made readable-only-by-root to avoid possible
information leakage.

[akpm@linux-foundation.org: coding-style fixes]
[akpm@linux-foundation.org: CONFIG_MMU=n build fix]
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_misc.c     |   17 ++++++++
 include/linux/vmalloc.h |    2 +
 mm/vmalloc.c            |   76 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 94 insertions(+), 1 deletion(-)

diff -puN fs/proc/proc_misc.c~vmalloc-show-vmalloced-areas-via-proc-vmallocinfo fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~vmalloc-show-vmalloced-areas-via-proc-vmallocinfo
+++ a/fs/proc/proc_misc.c
@@ -456,6 +456,20 @@ static const struct file_operations proc
 #endif
 #endif
 
+#ifdef CONFIG_MMU
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
+#endif
+
 static int show_stat(struct seq_file *p, void *v)
 {
 	int i;
@@ -869,6 +883,9 @@ void __init proc_misc_init(void)
 	create_seq_entry("slab_allocators", 0 ,&proc_slabstats_operations);
 #endif
 #endif
+#ifdef CONFIG_MMU
+	proc_create("vmallocinfo", S_IRUSR, NULL, &proc_vmalloc_operations);
+#endif
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

origin.patch
git-unionfs.patch
git-pekka.patch
page-allcoator-smarter-retry-of-costly-order-allocations.patch
page-allocator-explicitly-retry-hugepage-allocations.patch
ipc-add-definitions-of-ushort_max-and-others.patch
mm-add-nr_writeback_temp-counter.patch
remove-div_long_long_rem.patch
slab-add-a-flag-to-prevent-debug_free-checks-on-a-kmem_cache.patch
add-kbuildh-that-contains-common-definitions-for-kbuild-users.patch
x86-use-kbuildh.patch
mips-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch
alpha-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch
ia64-use-kbuildh-macros-instead-of-defining-macros-in-asm-offsetsc.patch
arm-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch
xtensa-use-kbuildh-macros-instead-of-defining-them-in-asm-offsetsc.patch
sparc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
avr32-use-kbuildh-macros-instead-of-defining-macros-in-asm-offsetsc.patch
blackfin-use-kbuildh-instead-of-defining-macros-in-asm-macrosc.patch
frv-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
h8300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
m68k-m68kmmu-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
mn10300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
parisc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
ppc-powerpc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc-update.patch
sh-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
v850-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch


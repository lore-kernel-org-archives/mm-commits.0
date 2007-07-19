From: akpm@linux-foundation.org
Subject: - coredump-masking-add-an-interface-for-core-dump-filter.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:02:18 -0700
Message-ID: <200707192002.l6JK2I8q019653@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54915 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932304AbXGSUbn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:31:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidehiro.kawai.ez@hitachi.com, alan@lxorguk.ukuu.org.uk, dhowells@redhat.com, hugh@veritas.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     coredump masking: add an interface for core dump filter
has been removed from the -mm tree.  Its filename was
     coredump-masking-add-an-interface-for-core-dump-filter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: coredump masking: add an interface for core dump filter
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>

This patch adds an interface to set/reset flags which determines each memory
segment should be dumped or not when a core file is generated.

/proc/<pid>/coredump_filter file is provided to access the flags.  You can
change the flag status for a particular process by writing to or reading from
the file.

The flag status is inherited to the child process when it is created.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c        |   89 ++++++++++++++++++++++++++++++++++++++++
 include/linux/sched.h |   14 ++++++
 kernel/fork.c         |    2 
 3 files changed, 105 insertions(+)

diff -puN fs/proc/base.c~coredump-masking-add-an-interface-for-core-dump-filter fs/proc/base.c
--- a/fs/proc/base.c~coredump-masking-add-an-interface-for-core-dump-filter
+++ a/fs/proc/base.c
@@ -72,6 +72,7 @@
 #include <linux/poll.h>
 #include <linux/nsproxy.h>
 #include <linux/oom.h>
+#include <linux/elf.h>
 #include "internal.h"
 
 /* NOTE:
@@ -1785,6 +1786,91 @@ static const struct inode_operations pro
 
 #endif
 
+#if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
+static ssize_t proc_coredump_filter_read(struct file *file, char __user *buf,
+					 size_t count, loff_t *ppos)
+{
+	struct task_struct *task = get_proc_task(file->f_dentry->d_inode);
+	struct mm_struct *mm;
+	char buffer[PROC_NUMBUF];
+	size_t len;
+	int ret;
+
+	if (!task)
+		return -ESRCH;
+
+	ret = 0;
+	mm = get_task_mm(task);
+	if (mm) {
+		len = snprintf(buffer, sizeof(buffer), "%08lx\n",
+			       ((mm->flags & MMF_DUMP_FILTER_MASK) >>
+				MMF_DUMP_FILTER_SHIFT));
+		mmput(mm);
+		ret = simple_read_from_buffer(buf, count, ppos, buffer, len);
+	}
+
+	put_task_struct(task);
+
+	return ret;
+}
+
+static ssize_t proc_coredump_filter_write(struct file *file,
+					  const char __user *buf,
+					  size_t count,
+					  loff_t *ppos)
+{
+	struct task_struct *task;
+	struct mm_struct *mm;
+	char buffer[PROC_NUMBUF], *end;
+	unsigned int val;
+	int ret;
+	int i;
+	unsigned long mask;
+
+	ret = -EFAULT;
+	memset(buffer, 0, sizeof(buffer));
+	if (count > sizeof(buffer) - 1)
+		count = sizeof(buffer) - 1;
+	if (copy_from_user(buffer, buf, count))
+		goto out_no_task;
+
+	ret = -EINVAL;
+	val = (unsigned int)simple_strtoul(buffer, &end, 0);
+	if (*end == '\n')
+		end++;
+	if (end - buffer == 0)
+		goto out_no_task;
+
+	ret = -ESRCH;
+	task = get_proc_task(file->f_dentry->d_inode);
+	if (!task)
+		goto out_no_task;
+
+	ret = end - buffer;
+	mm = get_task_mm(task);
+	if (!mm)
+		goto out_no_mm;
+
+	for (i = 0, mask = 1; i < MMF_DUMP_FILTER_BITS; i++, mask <<= 1) {
+		if (val & mask)
+			set_bit(i + MMF_DUMP_FILTER_SHIFT, &mm->flags);
+		else
+			clear_bit(i + MMF_DUMP_FILTER_SHIFT, &mm->flags);
+	}
+
+	mmput(mm);
+ out_no_mm:
+	put_task_struct(task);
+ out_no_task:
+	return ret;
+}
+
+static const struct file_operations proc_coredump_filter_operations = {
+	.read		= proc_coredump_filter_read,
+	.write		= proc_coredump_filter_write,
+};
+#endif
+
 /*
  * /proc/self:
  */
@@ -2005,6 +2091,9 @@ static const struct pid_entry tgid_base_
 #ifdef CONFIG_FAULT_INJECTION
 	REG("make-it-fail", S_IRUGO|S_IWUSR, fault_inject),
 #endif
+#if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
+	REG("coredump_filter", S_IRUGO|S_IWUSR, coredump_filter),
+#endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
 	INF("io",	S_IRUGO, pid_io_accounting),
 #endif
diff -puN include/linux/sched.h~coredump-masking-add-an-interface-for-core-dump-filter include/linux/sched.h
--- a/include/linux/sched.h~coredump-masking-add-an-interface-for-core-dump-filter
+++ a/include/linux/sched.h
@@ -349,8 +349,22 @@ extern void set_dumpable(struct mm_struc
 extern int get_dumpable(struct mm_struct *mm);
 
 /* mm flags */
+/* dumpable bits */
 #define MMF_DUMPABLE      0  /* core dump is permitted */
 #define MMF_DUMP_SECURELY 1  /* core file is readable only by root */
+#define MMF_DUMPABLE_BITS 2
+
+/* coredump filter bits */
+#define MMF_DUMP_ANON_PRIVATE	2
+#define MMF_DUMP_ANON_SHARED	3
+#define MMF_DUMP_MAPPED_PRIVATE	4
+#define MMF_DUMP_MAPPED_SHARED	5
+#define MMF_DUMP_FILTER_SHIFT	MMF_DUMPABLE_BITS
+#define MMF_DUMP_FILTER_BITS	4
+#define MMF_DUMP_FILTER_MASK \
+	(((1 << MMF_DUMP_FILTER_BITS) - 1) << MMF_DUMP_FILTER_SHIFT)
+#define MMF_DUMP_FILTER_DEFAULT \
+	((1 << MMF_DUMP_ANON_PRIVATE) |	(1 << MMF_DUMP_ANON_SHARED))
 
 struct mm_struct {
 	struct vm_area_struct * mmap;		/* list of VMAs */
diff -puN kernel/fork.c~coredump-masking-add-an-interface-for-core-dump-filter kernel/fork.c
--- a/kernel/fork.c~coredump-masking-add-an-interface-for-core-dump-filter
+++ a/kernel/fork.c
@@ -334,6 +334,8 @@ static struct mm_struct * mm_init(struct
 	atomic_set(&mm->mm_count, 1);
 	init_rwsem(&mm->mmap_sem);
 	INIT_LIST_HEAD(&mm->mmlist);
+	mm->flags = (current->mm) ? current->mm->flags
+				  : MMF_DUMP_FILTER_DEFAULT;
 	mm->core_waiters = 0;
 	mm->nr_ptes = 0;
 	set_mm_counter(mm, file_rss, 0);
_

Patches currently in -mm which might be from hidehiro.kawai.ez@hitachi.com are

origin.patch

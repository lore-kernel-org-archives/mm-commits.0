From: akpm@linux-foundation.org
Subject: [merged] fs-proc-clean-up-printks.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:11:43 -0800
Message-ID: <20130228201143.AC4D15A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:49284 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab3B1ULo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:11:44 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so244607ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:11:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc: clean up printks
has been removed from the -mm tree.  Its filename was
     fs-proc-clean-up-printks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/proc: clean up printks

- use pr_foo() throughout

- remove a couple of duplicated KERN_WARNINGs, via WARN(KERN_WARNING "...")

- nuke a few warnings which I've never seen happen, ever.

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c         |    3 ++-
 fs/proc/generic.c      |   27 +++++++++------------------
 fs/proc/inode.c        |    5 +++--
 fs/proc/kcore.c        |    3 ++-
 fs/proc/proc_devtree.c |   13 +++++++------
 fs/proc/proc_sysctl.c  |   19 ++++++++++---------
 fs/proc/vmcore.c       |   15 ++++++---------
 7 files changed, 39 insertions(+), 46 deletions(-)

diff -puN fs/proc/base.c~fs-proc-clean-up-printks fs/proc/base.c
--- a/fs/proc/base.c~fs-proc-clean-up-printks
+++ a/fs/proc/base.c
@@ -73,6 +73,7 @@
 #include <linux/security.h>
 #include <linux/ptrace.h>
 #include <linux/tracehook.h>
+#include <linux/printk.h>
 #include <linux/cgroup.h>
 #include <linux/cpuset.h>
 #include <linux/audit.h>
@@ -952,7 +953,7 @@ static ssize_t oom_adj_write(struct file
 	 * /proc/pid/oom_adj is provided for legacy purposes, ask users to use
 	 * /proc/pid/oom_score_adj instead.
 	 */
-	printk_once(KERN_WARNING "%s (%d): /proc/%d/oom_adj is deprecated, please use /proc/%d/oom_score_adj instead.\n",
+	pr_warn_once("%s (%d): /proc/%d/oom_adj is deprecated, please use /proc/%d/oom_score_adj instead.\n",
 		  current->comm, task_pid_nr(current), task_pid_nr(task),
 		  task_pid_nr(task));
 
diff -puN fs/proc/generic.c~fs-proc-clean-up-printks fs/proc/generic.c
--- a/fs/proc/generic.c~fs-proc-clean-up-printks
+++ a/fs/proc/generic.c
@@ -15,6 +15,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/printk.h>
 #include <linux/mount.h>
 #include <linux/init.h>
 #include <linux/idr.h>
@@ -132,11 +133,8 @@ __proc_file_read(struct file *file, char
 		}
 
 		if (start == NULL) {
-			if (n > PAGE_SIZE) {
-				printk(KERN_ERR
-				       "proc_file_read: Apparent buffer overflow!\n");
+			if (n > PAGE_SIZE)	/* Apparent buffer overflow */
 				n = PAGE_SIZE;
-			}
 			n -= *ppos;
 			if (n <= 0)
 				break;
@@ -144,26 +142,19 @@ __proc_file_read(struct file *file, char
 				n = count;
 			start = page + *ppos;
 		} else if (start < page) {
-			if (n > PAGE_SIZE) {
-				printk(KERN_ERR
-				       "proc_file_read: Apparent buffer overflow!\n");
+			if (n > PAGE_SIZE)	/* Apparent buffer overflow */
 				n = PAGE_SIZE;
-			}
 			if (n > count) {
 				/*
 				 * Don't reduce n because doing so might
 				 * cut off part of a data block.
 				 */
-				printk(KERN_WARNING
-				       "proc_file_read: Read count exceeded\n");
+				pr_warn("proc_file_read: count exceeded\n");
 			}
 		} else /* start >= page */ {
 			unsigned long startoff = (unsigned long)(start - page);
-			if (n > (PAGE_SIZE - startoff)) {
-				printk(KERN_ERR
-				       "proc_file_read: Apparent buffer overflow!\n");
+			if (n > (PAGE_SIZE - startoff))	/* buffer overflow? */
 				n = PAGE_SIZE - startoff;
-			}
 			if (n > count)
 				n = count;
 		}
@@ -569,7 +560,7 @@ static int proc_register(struct proc_dir
 
 	for (tmp = dir->subdir; tmp; tmp = tmp->next)
 		if (strcmp(tmp->name, dp->name) == 0) {
-			WARN(1, KERN_WARNING "proc_dir_entry '%s/%s' already registered\n",
+			WARN(1, "proc_dir_entry '%s/%s' already registered\n",
 				dir->name, dp->name);
 			break;
 		}
@@ -830,9 +821,9 @@ void remove_proc_entry(const char *name,
 	if (S_ISDIR(de->mode))
 		parent->nlink--;
 	de->nlink = 0;
-	WARN(de->subdir, KERN_WARNING "%s: removing non-empty directory "
-			"'%s/%s', leaking at least '%s'\n", __func__,
-			de->parent->name, de->name, de->subdir->name);
+	WARN(de->subdir, "%s: removing non-empty directory "
+			 "'%s/%s', leaking at least '%s'\n", __func__,
+			 de->parent->name, de->name, de->subdir->name);
 	pde_put(de);
 }
 EXPORT_SYMBOL(remove_proc_entry);
diff -puN fs/proc/inode.c~fs-proc-clean-up-printks fs/proc/inode.c
--- a/fs/proc/inode.c~fs-proc-clean-up-printks
+++ a/fs/proc/inode.c
@@ -13,6 +13,7 @@
 #include <linux/stat.h>
 #include <linux/completion.h>
 #include <linux/poll.h>
+#include <linux/printk.h>
 #include <linux/file.h>
 #include <linux/limits.h>
 #include <linux/init.h>
@@ -495,13 +496,13 @@ int proc_fill_super(struct super_block *
 	pde_get(&proc_root);
 	root_inode = proc_get_inode(s, &proc_root);
 	if (!root_inode) {
-		printk(KERN_ERR "proc_fill_super: get root inode failed\n");
+		pr_err("proc_fill_super: get root inode failed\n");
 		return -ENOMEM;
 	}
 
 	s->s_root = d_make_root(root_inode);
 	if (!s->s_root) {
-		printk(KERN_ERR "proc_fill_super: allocate dentry failed\n");
+		pr_err("proc_fill_super: allocate dentry failed\n");
 		return -ENOMEM;
 	}
 
diff -puN fs/proc/kcore.c~fs-proc-clean-up-printks fs/proc/kcore.c
--- a/fs/proc/kcore.c~fs-proc-clean-up-printks
+++ a/fs/proc/kcore.c
@@ -17,6 +17,7 @@
 #include <linux/elfcore.h>
 #include <linux/vmalloc.h>
 #include <linux/highmem.h>
+#include <linux/printk.h>
 #include <linux/bootmem.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -619,7 +620,7 @@ static int __init proc_kcore_init(void)
 	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL,
 				      &proc_kcore_operations);
 	if (!proc_root_kcore) {
-		printk(KERN_ERR "couldn't create /proc/kcore\n");
+		pr_err("couldn't create /proc/kcore\n");
 		return 0; /* Always returns 0. */
 	}
 	/* Store text area if it's special */
diff -puN fs/proc/proc_devtree.c~fs-proc-clean-up-printks fs/proc/proc_devtree.c
--- a/fs/proc/proc_devtree.c~fs-proc-clean-up-printks
+++ a/fs/proc/proc_devtree.c
@@ -8,6 +8,7 @@
 #include <linux/time.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/printk.h>
 #include <linux/stat.h>
 #include <linux/string.h>
 #include <linux/of.h>
@@ -110,8 +111,8 @@ void proc_device_tree_update_prop(struct
 		if (ent->data == oldprop)
 			break;
 	if (ent == NULL) {
-		printk(KERN_WARNING "device-tree: property \"%s\" "
-		       " does not exist\n", oldprop->name);
+		pr_warn("device-tree: property \"%s\" does not exist\n",
+			oldprop->name);
 	} else {
 		ent->data = newprop;
 		ent->size = newprop->length;
@@ -153,8 +154,8 @@ static const char *fixup_name(struct dev
 realloc:
 	fixed_name = kmalloc(fixup_len, GFP_KERNEL);
 	if (fixed_name == NULL) {
-		printk(KERN_ERR "device-tree: Out of memory trying to fixup "
-				"name \"%s\"\n", name);
+		pr_err("device-tree: Out of memory trying to fixup "
+		       "name \"%s\"\n", name);
 		return name;
 	}
 
@@ -175,8 +176,8 @@ retry:
 		goto retry;
 	}
 
-	printk(KERN_WARNING "device-tree: Duplicate name in %s, "
-			"renamed to \"%s\"\n", np->full_name, fixed_name);
+	pr_warn("device-tree: Duplicate name in %s, renamed to \"%s\"\n",
+		np->full_name, fixed_name);
 
 	return fixed_name;
 }
diff -puN fs/proc/proc_sysctl.c~fs-proc-clean-up-printks fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~fs-proc-clean-up-printks
+++ a/fs/proc/proc_sysctl.c
@@ -5,6 +5,7 @@
 #include <linux/sysctl.h>
 #include <linux/poll.h>
 #include <linux/proc_fs.h>
+#include <linux/printk.h>
 #include <linux/security.h>
 #include <linux/sched.h>
 #include <linux/namei.h>
@@ -57,7 +58,7 @@ static void sysctl_print_dir(struct ctl_
 {
 	if (dir->header.parent)
 		sysctl_print_dir(dir->header.parent);
-	printk(KERN_CONT "%s/", dir->header.ctl_table[0].procname);
+	pr_cont("%s/", dir->header.ctl_table[0].procname);
 }
 
 static int namecmp(const char *name1, int len1, const char *name2, int len2)
@@ -134,9 +135,9 @@ static int insert_entry(struct ctl_table
 		else if (cmp > 0)
 			p = &(*p)->rb_right;
 		else {
-			printk(KERN_ERR "sysctl duplicate entry: ");
+			pr_err("sysctl duplicate entry: ");
 			sysctl_print_dir(head->parent);
-			printk(KERN_CONT "/%s\n", entry->procname);
+			pr_cont("/%s\n", entry->procname);
 			return -EEXIST;
 		}
 	}
@@ -927,9 +928,9 @@ found:
 	subdir->header.nreg++;
 failed:
 	if (unlikely(IS_ERR(subdir))) {
-		printk(KERN_ERR "sysctl could not get directory: ");
+		pr_err("sysctl could not get directory: ");
 		sysctl_print_dir(dir);
-		printk(KERN_CONT "/%*.*s %ld\n",
+		pr_cont("/%*.*s %ld\n",
 			namelen, namelen, name, PTR_ERR(subdir));
 	}
 	drop_sysctl_table(&dir->header);
@@ -995,8 +996,8 @@ static int sysctl_err(const char *path, 
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	printk(KERN_ERR "sysctl table check failed: %s/%s %pV\n",
-		path, table->procname, &vaf);
+	pr_err("sysctl table check failed: %s/%s %pV\n",
+	       path, table->procname, &vaf);
 
 	va_end(args);
 	return -EINVAL;
@@ -1510,9 +1511,9 @@ static void put_links(struct ctl_table_h
 			drop_sysctl_table(link_head);
 		}
 		else {
-			printk(KERN_ERR "sysctl link missing during unregister: ");
+			pr_err("sysctl link missing during unregister: ");
 			sysctl_print_dir(parent);
-			printk(KERN_CONT "/%s\n", name);
+			pr_cont("/%s\n", name);
 		}
 	}
 }
diff -puN fs/proc/vmcore.c~fs-proc-clean-up-printks fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~fs-proc-clean-up-printks
+++ a/fs/proc/vmcore.c
@@ -15,6 +15,7 @@
 #include <linux/export.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
+#include <linux/printk.h>
 #include <linux/bootmem.h>
 #include <linux/init.h>
 #include <linux/crash_dump.h>
@@ -553,8 +554,7 @@ static int __init parse_crash_elf64_head
 		ehdr.e_ehsize != sizeof(Elf64_Ehdr) ||
 		ehdr.e_phentsize != sizeof(Elf64_Phdr) ||
 		ehdr.e_phnum == 0) {
-		printk(KERN_WARNING "Warning: Core image elf header is not"
-					"sane\n");
+		pr_warn("Warning: Core image elf header is not sane\n");
 		return -EINVAL;
 	}
 
@@ -609,8 +609,7 @@ static int __init parse_crash_elf32_head
 		ehdr.e_ehsize != sizeof(Elf32_Ehdr) ||
 		ehdr.e_phentsize != sizeof(Elf32_Phdr) ||
 		ehdr.e_phnum == 0) {
-		printk(KERN_WARNING "Warning: Core image elf header is not"
-					"sane\n");
+		pr_warn("Warning: Core image elf header is not sane\n");
 		return -EINVAL;
 	}
 
@@ -653,8 +652,7 @@ static int __init parse_crash_elf_header
 	if (rc < 0)
 		return rc;
 	if (memcmp(e_ident, ELFMAG, SELFMAG) != 0) {
-		printk(KERN_WARNING "Warning: Core image elf header"
-					" not found\n");
+		pr_warn("Warning: Core image elf header not found\n");
 		return -EINVAL;
 	}
 
@@ -673,8 +671,7 @@ static int __init parse_crash_elf_header
 		/* Determine vmcore size. */
 		vmcore_size = get_vmcore_size_elf32(elfcorebuf);
 	} else {
-		printk(KERN_WARNING "Warning: Core image elf header is not"
-					" sane\n");
+		pr_warn("Warning: Core image elf header is not sane\n");
 		return -EINVAL;
 	}
 	return 0;
@@ -690,7 +687,7 @@ static int __init vmcore_init(void)
 		return rc;
 	rc = parse_crash_elf_headers();
 	if (rc) {
-		printk(KERN_WARNING "Kdump: vmcore not initialized\n");
+		pr_warn("Kdump: vmcore not initialized\n");
 		return rc;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
mm.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-use-cancellation-list-lazily-fix-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-dont-include-aioh-in-schedh-fix-3-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


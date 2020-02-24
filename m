From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch
 added to -mm tree
Date: Sun, 23 Feb 2020 19:24:11 -0800
Message-ID: <20200224032411._DoGAI1ov%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727156AbgBXDYO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 23 Feb 2020 22:24:14 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: proc-faster-open-read-close-with-permanent-files-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: proc-faster-open-read-close-with-permanent-files-checkpatch-fixes

WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
#12: 
Save 2 atomic ops, 1 allocation, 1 free per open/read/close sequence for such

WARNING: braces {} are not necessary for single statement blocks
#163: FILE: fs/proc/generic.c:536:
+	if (pde->proc_ops->proc_flags & PROC_ENTRY_PERMANENT) {
+		pde->flags |= PROC_ENTRY_PERMANENT;
+	}

WARNING: line over 80 characters
#203: FILE: fs/proc/generic.c:676:
+			WARN(1, "removing permanent /proc entry '%s'", de->name);

WARNING: braces {} are not necessary for single statement blocks
#207: FILE: fs/proc/generic.c:680:
+			if (S_ISDIR(de->mode)) {
+				parent->nlink--;
+			}

WARNING: line over 80 characters
#244: FILE: fs/proc/inode.c:198:
+static loff_t pde_lseek(struct proc_dir_entry *pde, struct file *file, loff_t offset, int whence)

WARNING: line over 80 characters
#274: FILE: fs/proc/inode.c:222:
+static ssize_t pde_read(struct proc_dir_entry *pde, struct file *file, char __user *buf, size_t count, loff_t *ppos)

WARNING: line over 80 characters
#303: FILE: fs/proc/inode.c:246:
+static ssize_t pde_write(struct proc_dir_entry *pde, struct file *file, const char __user *buf, size_t count, loff_t *ppos)

WARNING: line over 80 characters
#332: FILE: fs/proc/inode.c:270:
+static __poll_t pde_poll(struct proc_dir_entry *pde, struct file *file, struct poll_table_struct *pts)

WARNING: line over 80 characters
#361: FILE: fs/proc/inode.c:294:
+static long pde_ioctl(struct proc_dir_entry *pde, struct file *file, unsigned int cmd, unsigned long arg)

WARNING: line over 80 characters
#391: FILE: fs/proc/inode.c:319:
+static long pde_compat_ioctl(struct proc_dir_entry *pde, struct file *file, unsigned int cmd, unsigned long arg)

WARNING: line over 80 characters
#421: FILE: fs/proc/inode.c:343:
+static int pde_mmap(struct proc_dir_entry *pde, struct file *file, struct vm_area_struct *vma)

WARNING: line over 80 characters
#452: FILE: fs/proc/inode.c:368:
+pde_get_unmapped_area(struct proc_dir_entry *pde, struct file *file, unsigned long orig_addr,

WARNING: line over 80 characters
#489: FILE: fs/proc/inode.c:393:
+		return pde_get_unmapped_area(pde, file, orig_addr, len, pgoff, flags);

WARNING: line over 80 characters
#491: FILE: fs/proc/inode.c:395:
+		rv = pde_get_unmapped_area(pde, file, orig_addr, len, pgoff, flags);

WARNING: braces {} are not necessary for single statement blocks
#518: FILE: fs/proc/inode.c:470:
+		if (release) {
+			return release(inode, file);
+		}

total: 0 errors, 15 warnings, 462 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/proc-faster-open-read-close-with-permanent-files.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/proc/generic.c~proc-faster-open-read-close-with-permanent-files-checkpatch-fixes
+++ a/fs/proc/generic.c
@@ -533,9 +533,8 @@ struct proc_dir_entry *proc_create_reg(c
 
 static inline void pde_set_flags(struct proc_dir_entry *pde)
 {
-	if (pde->proc_ops->proc_flags & PROC_ENTRY_PERMANENT) {
+	if (pde->proc_ops->proc_flags & PROC_ENTRY_PERMANENT)
 		pde->flags |= PROC_ENTRY_PERMANENT;
-	}
 }
 
 struct proc_dir_entry *proc_create_data(const char *name, umode_t mode,
@@ -677,9 +676,8 @@ void remove_proc_entry(const char *name,
 			de = NULL;
 		} else {
 			rb_erase(&de->subdir_node, &parent->subdir);
-			if (S_ISDIR(de->mode)) {
+			if (S_ISDIR(de->mode))
 				parent->nlink--;
-			}
 		}
 	}
 	write_unlock(&proc_subdir_lock);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-numa-fix-bad-pmd-by-atomically-check-for-pmd_trans_huge-when-marking-page-tables-prot_numa-fix.patch
mm.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
selftest-add-mremap_dontunmap-selftest-fix.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch
mm-migratec-migrate-pg_readahead-flag-fix.patch
proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch

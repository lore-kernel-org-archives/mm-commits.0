From: akpm@linux-foundation.org
Subject: + pagemap-check-permissions-and-capabilities-at-open-time.patch
 added to -mm tree
Date: Tue, 14 Jul 2015 11:57:51 -0700
Message-ID: <55a55baf.KqJW9vNaLcu0aLdH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbbGNS5w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 14:57:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@yandex-team.ru, mwilliamson@undo-software.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pagemap: check permissions and capabilities at open time
has been added to the -mm tree.  Its filename is
     pagemap-check-permissions-and-capabilities-at-open-time.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pagemap-check-permissions-and-capabilities-at-open-time.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pagemap-check-permissions-and-capabilities-at-open-time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: pagemap: check permissions and capabilities at open time

This patchset makes pagemap useable again in the safe way (after row
hammer bug it was made CAP_SYS_ADMIN-only).  This patchset restores access
for non-privileged users but hides PFNs from them.

Also it adds bit 'map-exclusive' which is set if page is mapped only here:
it helps in estimation of working set without exposing pfns and allows to
distinguish CoWed and non-CoWed private anonymous pages.

Second patch removes page-shift bits and completes migration to the new
pagemap format: flags soft-dirty and mmap-exclusive are available only in
the new format.


This patch (of 5):

This patch moves permission checks from pagemap_read() into pagemap_open().

Pointer to mm is saved in file->private_data. This reference pins only
mm_struct itself. /proc/*/mem, maps, smaps already work in the same way.

See http://lkml.kernel.org/r/CA+55aFyKpWrt_Ajzh1rzp_GcwZ4=6Y=kOv8hBz172CFJp6L8Tg@mail.gmail.com

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mark Williamson <mwilliamson@undo-software.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   48 +++++++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff -puN fs/proc/task_mmu.c~pagemap-check-permissions-and-capabilities-at-open-time fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-check-permissions-and-capabilities-at-open-time
+++ a/fs/proc/task_mmu.c
@@ -1230,40 +1230,33 @@ static int pagemap_hugetlb_range(pte_t *
 static ssize_t pagemap_read(struct file *file, char __user *buf,
 			    size_t count, loff_t *ppos)
 {
-	struct task_struct *task = get_proc_task(file_inode(file));
-	struct mm_struct *mm;
+	struct mm_struct *mm = file->private_data;
 	struct pagemapread pm;
-	int ret = -ESRCH;
 	struct mm_walk pagemap_walk = {};
 	unsigned long src;
 	unsigned long svpfn;
 	unsigned long start_vaddr;
 	unsigned long end_vaddr;
-	int copied = 0;
+	int ret = 0, copied = 0;
 
-	if (!task)
+	if (!mm || !atomic_inc_not_zero(&mm->mm_users))
 		goto out;
 
 	ret = -EINVAL;
 	/* file position must be aligned */
 	if ((*ppos % PM_ENTRY_BYTES) || (count % PM_ENTRY_BYTES))
-		goto out_task;
+		goto out_mm;
 
 	ret = 0;
 	if (!count)
-		goto out_task;
+		goto out_mm;
 
 	pm.v2 = soft_dirty_cleared;
 	pm.len = (PAGEMAP_WALK_SIZE >> PAGE_SHIFT);
 	pm.buffer = kmalloc(pm.len * PM_ENTRY_BYTES, GFP_TEMPORARY);
 	ret = -ENOMEM;
 	if (!pm.buffer)
-		goto out_task;
-
-	mm = mm_access(task, PTRACE_MODE_READ);
-	ret = PTR_ERR(mm);
-	if (!mm || IS_ERR(mm))
-		goto out_free;
+		goto out_mm;
 
 	pagemap_walk.pmd_entry = pagemap_pte_range;
 	pagemap_walk.pte_hole = pagemap_pte_hole;
@@ -1276,10 +1269,10 @@ static ssize_t pagemap_read(struct file
 	src = *ppos;
 	svpfn = src / PM_ENTRY_BYTES;
 	start_vaddr = svpfn << PAGE_SHIFT;
-	end_vaddr = TASK_SIZE_OF(task);
+	end_vaddr = mm->task_size;
 
 	/* watch out for wraparound */
-	if (svpfn > TASK_SIZE_OF(task) >> PAGE_SHIFT)
+	if (svpfn > mm->task_size >> PAGE_SHIFT)
 		start_vaddr = end_vaddr;
 
 	/*
@@ -1306,7 +1299,7 @@ static ssize_t pagemap_read(struct file
 		len = min(count, PM_ENTRY_BYTES * pm.pos);
 		if (copy_to_user(buf, pm.buffer, len)) {
 			ret = -EFAULT;
-			goto out_mm;
+			goto out_free;
 		}
 		copied += len;
 		buf += len;
@@ -1316,24 +1309,38 @@ static ssize_t pagemap_read(struct file
 	if (!ret || ret == PM_END_OF_BUFFER)
 		ret = copied;
 
-out_mm:
-	mmput(mm);
 out_free:
 	kfree(pm.buffer);
-out_task:
-	put_task_struct(task);
+out_mm:
+	mmput(mm);
 out:
 	return ret;
 }
 
 static int pagemap_open(struct inode *inode, struct file *file)
 {
+	struct mm_struct *mm;
+
 	/* do not disclose physical addresses: attack vector */
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	pr_warn_once("Bits 55-60 of /proc/PID/pagemap entries are about "
 			"to stop being page-shift some time soon. See the "
 			"linux/Documentation/vm/pagemap.txt for details.\n");
+
+	mm = proc_mem_open(inode, PTRACE_MODE_READ);
+	if (IS_ERR(mm))
+		return PTR_ERR(mm);
+	file->private_data = mm;
+	return 0;
+}
+
+static int pagemap_release(struct inode *inode, struct file *file)
+{
+	struct mm_struct *mm = file->private_data;
+
+	if (mm)
+		mmdrop(mm);
 	return 0;
 }
 
@@ -1341,6 +1348,7 @@ const struct file_operations proc_pagema
 	.llseek		= mem_lseek, /* borrow this */
 	.read		= pagemap_read,
 	.open		= pagemap_open,
+	.release	= pagemap_release,
 };
 #endif /* CONFIG_PROC_PAGE_MONITOR */
 
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

pagemap-check-permissions-and-capabilities-at-open-time.patch
pagemap-switch-to-the-new-format-and-do-some-cleanup.patch
pagemap-rework-hugetlb-and-thp-report.patch
pagemap-hide-physical-addresses-from-non-privileged-users.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix.patch


From: akpm@linux-foundation.org
Subject: + smaps-add-clear_refs-file-to-clear-reference-fix.patch added to -mm tree
Date: Fri, 09 Feb 2007 17:02:08 -0800
Message-ID: <200702100102.l1A128VL031811@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58508 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946819AbXBJBCX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 20:02:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, clameter@sgi.com, hugh@veritas.com, lethal@linux-sh.org, oleg@tv-sign.ru, rientjes@google.com


The patch titled
     smaps-add-clear_refs-file-to-clear-reference-fix
has been added to the -mm tree.  Its filename is
     smaps-add-clear_refs-file-to-clear-reference-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: smaps-add-clear_refs-file-to-clear-reference-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Hugh Dickins <hugh@veritas.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c          |    7 ++++++-
 fs/proc/task_mmu.c      |    8 ++++++--
 include/linux/proc_fs.h |    2 +-
 3 files changed, 13 insertions(+), 4 deletions(-)

diff -puN fs/proc/base.c~smaps-add-clear_refs-file-to-clear-reference-fix fs/proc/base.c
--- a/fs/proc/base.c~smaps-add-clear_refs-file-to-clear-reference-fix
+++ a/fs/proc/base.c
@@ -720,6 +720,7 @@ static ssize_t clear_refs_write(struct f
 {
 	struct task_struct *task;
 	char buffer[PROC_NUMBUF], *end;
+	struct mm_struct *mm;
 
 	memset(buffer, 0, sizeof(buffer));
 	if (count > sizeof(buffer) - 1)
@@ -733,7 +734,11 @@ static ssize_t clear_refs_write(struct f
 	task = get_proc_task(file->f_path.dentry->d_inode);
 	if (!task)
 		return -ESRCH;
-	clear_refs_smap(task->mm->mmap);
+	mm = get_task_mm(task);
+	if (mm) {
+		clear_refs_smap(mm);
+		mmput(mm);
+	}
 	put_task_struct(task);
 	if (end - buffer == 0)
 		return -EIO;
diff -puN fs/proc/task_mmu.c~smaps-add-clear_refs-file-to-clear-reference-fix fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~smaps-add-clear_refs-file-to-clear-reference-fix
+++ a/fs/proc/task_mmu.c
@@ -350,11 +350,15 @@ static int show_smap(struct seq_file *m,
 	return show_map_internal(m, v, &mss);
 }
 
-void clear_refs_smap(struct vm_area_struct *vma)
+void clear_refs_smap(struct mm_struct *mm)
 {
-	for (; vma; vma = vma->vm_next)
+	struct vm_area_struct *vma;
+
+	down_read(&mm->mmap_sem);
+	for (vma = mm->mmap; vma; vma = vma->vm_next)
 		if (vma->vm_mm && !is_vm_hugetlb_page(vma))
 			for_each_pmd(vma, clear_refs_one_pmd, NULL);
+	up_read(&mm->mmap_sem);
 }
 
 static void *m_start(struct seq_file *m, loff_t *pos)
diff -puN include/linux/proc_fs.h~smaps-add-clear_refs-file-to-clear-reference-fix include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~smaps-add-clear_refs-file-to-clear-reference-fix
+++ a/include/linux/proc_fs.h
@@ -104,7 +104,7 @@ int proc_pid_readdir(struct file * filp,
 unsigned long task_vsize(struct mm_struct *);
 int task_statm(struct mm_struct *, int *, int *, int *, int *);
 char *task_mem(struct mm_struct *, char *);
-void clear_refs_smap(struct vm_area_struct *);
+void clear_refs_smap(struct mm_struct *mm);
 
 extern struct proc_dir_entry *create_proc_entry(const char *name, mode_t mode,
 						struct proc_dir_entry *parent);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
acpi-bay-driver-warning-fix.patch
git-cifs-fix.patch
fix-warning-in-device_add_attrs.patch
git-drm.patch
git-dvb.patch
kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch
git-infiniband.patch
git-libata-all.patch
sis-warning-fixes.patch
git-libata-all-lib-iomapc-fix-for-config_pci=n.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-net.patch
git-backlight-acpi-fix.patch
git-backlight-asus-fix.patch
git-backlight-sony-fix.patch
git-sh.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block.patch
revert-x86_64-mm-msr-on-cpu.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
mm-vm_insert_pfn-tidy.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
swiotlb-uninlinings.patch
kprobes-list-all-active-probes-in-the-system-tidy.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
revert-x86_64-mm-putreg-check.patch
fix-utrace-utrace-ptrace-compat.patch
fbdev-driver-for-s3-trio-virge-update-2-fix.patch
deprecate-sa_interrupt-and-friends.patch
git-gccbug-fixup.patch

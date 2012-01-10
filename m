From: akpm@linux-foundation.org
Subject: [folded] procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 10 Jan 2012 14:54:56 -0800
Message-ID: <20120110225456.C2D361000CB@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:61955 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab2AJWy5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 17:54:57 -0500
Received: by ghrr15 with SMTP id r15so14315ghr.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 14:54:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gorcunov@openvz.org, kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch

This patch was dropped because it was folded into procfs-introduce-the-proc-pid-map_files-directory.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes

Cc: "Kirill A. Shutemov" <kirill@shutemov.name>

WARNING: line over 80 characters
#286: FILE: fs/proc/base.c:2433:
+static int proc_map_files_readdir(struct file *filp, void *dirent, filldir_t filldir)

WARNING: line over 80 characters
#351: FILE: fs/proc/base.c:2498:
+			fa = flex_array_alloc(sizeof(info), nr_files, GFP_KERNEL);

WARNING: line over 80 characters
#352: FILE: fs/proc/base.c:2499:
+			if (!fa || flex_array_prealloc(fa, 0, nr_files, GFP_KERNEL)) {

WARNING: line over 80 characters
#360: FILE: fs/proc/base.c:2507:
+			for (i = 0, vma = mm->mmap, pos = 2; vma; vma = vma->vm_next) {

WARNING: line over 80 characters
#368: FILE: fs/proc/base.c:2515:
+				info.len = snprintf(info.name, sizeof(info.name),

WARNING: line over 80 characters
#424: FILE: fs/proc/base.c:3179:
+	DIR("map_files",  S_IRUSR|S_IXUSR, proc_map_files_inode_operations, proc_map_files_operations),

WARNING: line over 80 characters
#437: FILE: include/linux/mm.h:1497:
+find_exact_vma(struct mm_struct *mm, unsigned long vm_start, unsigned long vm_end)

total: 0 errors, 7 warnings, 387 lines checked

./patches/procfs-introduce-the-proc-pid-map_files-directory.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c     |   18 +++++++++++-------
 include/linux/mm.h |    4 ++--
 2 files changed, 13 insertions(+), 9 deletions(-)

diff -puN fs/proc/base.c~procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes fs/proc/base.c
--- a/fs/proc/base.c~procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes
+++ a/fs/proc/base.c
@@ -2260,7 +2260,8 @@ static const struct inode_operations pro
 	.setattr	= proc_setattr,
 };
 
-static int proc_map_files_readdir(struct file *filp, void *dirent, filldir_t filldir)
+static int
+proc_map_files_readdir(struct file *filp, void *dirent, filldir_t filldir)
 {
 	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
@@ -2325,8 +2326,10 @@ static int proc_map_files_readdir(struct
 		}
 
 		if (nr_files) {
-			fa = flex_array_alloc(sizeof(info), nr_files, GFP_KERNEL);
-			if (!fa || flex_array_prealloc(fa, 0, nr_files, GFP_KERNEL)) {
+			fa = flex_array_alloc(sizeof(info), nr_files,
+						GFP_KERNEL);
+			if (!fa || flex_array_prealloc(fa, 0, nr_files,
+							GFP_KERNEL)) {
 				ret = -ENOMEM;
 				if (fa)
 					flex_array_free(fa);
@@ -2334,7 +2337,8 @@ static int proc_map_files_readdir(struct
 				mmput(mm);
 				goto out_unlock;
 			}
-			for (i = 0, vma = mm->mmap, pos = 2; vma; vma = vma->vm_next) {
+			for (i = 0, vma = mm->mmap, pos = 2; vma;
+					vma = vma->vm_next) {
 				if (!vma->vm_file)
 					continue;
 				if (++pos <= filp->f_pos)
@@ -2342,9 +2346,9 @@ static int proc_map_files_readdir(struct
 
 				get_file(vma->vm_file);
 				info.file = vma->vm_file;
-				info.len = snprintf(info.name, sizeof(info.name),
-						    "%lx-%lx", vma->vm_start,
-						    vma->vm_end);
+				info.len = snprintf(info.name,
+						sizeof(info.name), "%lx-%lx",
+						vma->vm_start, vma->vm_end);
 				if (flex_array_put(fa, i++, &info, GFP_KERNEL))
 					BUG();
 			}
diff -puN include/linux/mm.h~procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes include/linux/mm.h
--- a/include/linux/mm.h~procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes
+++ a/include/linux/mm.h
@@ -1483,8 +1483,8 @@ static inline unsigned long vma_pages(st
 }
 
 /* Look up the first VMA which exactly match the interval vm_start ... vm_end */
-static inline struct vm_area_struct *
-find_exact_vma(struct mm_struct *mm, unsigned long vm_start, unsigned long vm_end)
+static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm,
+				unsigned long vm_start, unsigned long vm_end)
 {
 	struct vm_area_struct *vma = find_vma(mm, vm_start);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault.patch
mm-more-intensive-memory-corruption-debug.patch
mm-exclude-reserved-pages-from-dirtyable-memory.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma.patch
mempool-fix-first-round-failure-behavior.patch
backlight-convert-pwm_bl-to-dev_pm_ops.patch
leds-add-driver-for-tca6507-led-controller.patch
checkpatch-improve-memset-and-min-max-with-cast-checking.patch
checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line.patch
drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc.patch
drivers-rtc-rtc-mxcc-make-alarm-work.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc.patch
procfs-introduce-the-proc-pid-map_files-directory.patch
procfs-parse-mount-options-fix.patch
procfs-add-hidepid=-and-gid=-mount-options-fix-2.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch


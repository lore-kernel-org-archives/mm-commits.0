From: akpm@linux-foundation.org
Subject: + procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch added to -mm tree
Date: Wed, 09 Nov 2011 14:18:34 -0800
Message-ID: <201111092218.pA9MIZgJ016725@hpaq6.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:38258 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab1KIWSq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2011 17:18:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, gorcunov@openvz.org, kirill@shutemov.name


The patch titled
     Subject: procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -2430,7 +2430,8 @@ static const struct inode_operations pro
 	.setattr	= proc_setattr,
 };
 
-static int proc_map_files_readdir(struct file *filp, void *dirent, filldir_t filldir)
+static int
+proc_map_files_readdir(struct file *filp, void *dirent, filldir_t filldir)
 {
 	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
@@ -2495,8 +2496,10 @@ static int proc_map_files_readdir(struct
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
@@ -2504,7 +2507,8 @@ static int proc_map_files_readdir(struct
 				mmput(mm);
 				goto out_unlock;
 			}
-			for (i = 0, vma = mm->mmap, pos = 2; vma; vma = vma->vm_next) {
+			for (i = 0, vma = mm->mmap, pos = 2; vma;
+					vma = vma->vm_next) {
 				if (!vma->vm_file)
 					continue;
 				if (++pos <= filp->f_pos)
@@ -2512,9 +2516,9 @@ static int proc_map_files_readdir(struct
 
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
@@ -1493,8 +1493,8 @@ static inline unsigned long vma_pages(st
 }
 
 /* Look up the first VMA which exactly match the interval vm_start ... vm_end */
-static inline struct vm_area_struct *
-find_exact_vma(struct mm_struct *mm, unsigned long vm_start, unsigned long vm_end)
+static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm,
+				unsigned long vm_start, unsigned long vm_end)
 {
 	struct vm_area_struct *vma = find_vma(mm, vm_start);
 
_
Subject: Subject: procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
mrst-battery-fixes-fix.patch
x86-reduce-clock-calibration-time-during-slave-cpu-startup-fix.patch
drivers-net-ethernet-oki-semi-pch_gbe-pch_gbeh-remove-unused-macro-pr_fmt.patch
debugobjects-extend-to-assert-that-an-object-is-initialized.patch
kernel-timerc-use-debugobjects-to-catch-deletion-of-uninitialized-timers.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
kexec-remove-kmsg_dump_kexec.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch


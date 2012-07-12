From: akpm@linux-foundation.org
Subject: [merged] c-r-prctl-less-paranoid-prctl_set_mm_exe_file.patch removed from -mm tree
Date: Thu, 12 Jul 2012 12:36:35 -0700
Message-ID: <20120712193636.611795C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:60896 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932899Ab2GLTgj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 15:36:39 -0400
Received: by weyr1 with SMTP id r1so145519wey.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 12:36:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, gorcunov@openvz.org, keescook@chromium.org, kosaki.motohiro@jp.fujitsu.com, matthltc@us.ibm.com, oleg@redhat.com, tj@kernel.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: c/r: prctl: less paranoid prctl_set_mm_exe_file()
has been removed from the -mm tree.  Its filename was
     c-r-prctl-less-paranoid-prctl_set_mm_exe_file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: c/r: prctl: less paranoid prctl_set_mm_exe_file()

"no other files mapped" requirement from my previous patch (c/r: prctl:
update prctl_set_mm_exe_file() after mm->num_exe_file_vmas removal) is too
paranoid, it forbids operation even if there mapped one shared-anon vma.

Let's check that current mm->exe_file already unmapped, in this case
exe_file symlink already outdated and its changing is reasonable.

Plus, this patch fixes exit code in case operation success.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Reported-by: Cyrill Gorcunov <gorcunov@openvz.org>
Tested-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN kernel/sys.c~c-r-prctl-less-paranoid-prctl_set_mm_exe_file kernel/sys.c
--- a/kernel/sys.c~c-r-prctl-less-paranoid-prctl_set_mm_exe_file
+++ a/kernel/sys.c
@@ -1788,7 +1788,6 @@ SYSCALL_DEFINE1(umask, int, mask)
 #ifdef CONFIG_CHECKPOINT_RESTORE
 static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
 {
-	struct vm_area_struct *vma;
 	struct file *exe_file;
 	struct dentry *dentry;
 	int err;
@@ -1816,13 +1815,17 @@ static int prctl_set_mm_exe_file(struct 
 	down_write(&mm->mmap_sem);
 
 	/*
-	 * Forbid mm->exe_file change if there are mapped other files.
+	 * Forbid mm->exe_file change if old file still mapped.
 	 */
 	err = -EBUSY;
-	for (vma = mm->mmap; vma; vma = vma->vm_next) {
-		if (vma->vm_file && !path_equal(&vma->vm_file->f_path,
-						&exe_file->f_path))
-			goto exit_unlock;
+	if (mm->exe_file) {
+		struct vm_area_struct *vma;
+
+		for (vma = mm->mmap; vma; vma = vma->vm_next)
+			if (vma->vm_file &&
+			    path_equal(&vma->vm_file->f_path,
+				       &mm->exe_file->f_path))
+				goto exit_unlock;
 	}
 
 	/*
@@ -1835,6 +1838,7 @@ static int prctl_set_mm_exe_file(struct 
 	if (test_and_set_bit(MMF_EXE_FILE_CHANGED, &mm->flags))
 		goto exit_unlock;
 
+	err = 0;
 	set_mm_exe_file(mm, exe_file);
 exit_unlock:
 	up_write(&mm->mmap_sem);
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
vmscan-remove-obsolete-shrink_control-comment.patch


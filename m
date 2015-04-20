From: akpm@linux-foundation.org
Subject: [merged] oprofile-reduce-mmap_sem-hold-for-mm-exe_file.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:20:50 -0700
Message-ID: <55355192.94L5G4XKfAOyICgn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40510 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbbDTTO3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:14:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, rric@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: oprofile: reduce mmap_sem hold for mm->exe_file
has been removed from the -mm tree.  Its filename was
     oprofile-reduce-mmap_sem-hold-for-mm-exe_file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: oprofile: reduce mmap_sem hold for mm->exe_file

sync_buffer() needs the mmap_sem for two distinct operations, both only
occurring upon user context switch handling:

 1) Dealing with the exe_file.

 2) Adding the dcookie data as we need to lookup the vma that
   backs it. This is done via add_sample() and add_data().

This patch isolates 1), for it will no longer need the mmap_sem for
serialization.  However, for now, make of the more standard
get_mm_exe_file(), requiring only holding the mmap_sem to read the value,
and relying on reference counting to make sure that the exe file won't
dissappear underneath us while doing the get dcookie.

As a consequence, for 2) we move the mmap_sem locking into where we really
need it, in lookup_dcookie().  The benefits are twofold: reduce mmap_sem
hold times, and cleaner code.

[akpm@linux-foundation.org: export get_mm_exe_file for arch/x86/oprofile/oprofile.ko]
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Robert Richter <rric@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/oprofile/buffer_sync.c |   30 ++++++++++++++++--------------
 kernel/fork.c                  |    1 +
 2 files changed, 17 insertions(+), 14 deletions(-)

diff -puN drivers/oprofile/buffer_sync.c~oprofile-reduce-mmap_sem-hold-for-mm-exe_file drivers/oprofile/buffer_sync.c
--- a/drivers/oprofile/buffer_sync.c~oprofile-reduce-mmap_sem-hold-for-mm-exe_file
+++ a/drivers/oprofile/buffer_sync.c
@@ -21,6 +21,7 @@
  * objects.
  */
 
+#include <linux/file.h>
 #include <linux/mm.h>
 #include <linux/workqueue.h>
 #include <linux/notifier.h>
@@ -224,10 +225,18 @@ static inline unsigned long fast_get_dco
 static unsigned long get_exec_dcookie(struct mm_struct *mm)
 {
 	unsigned long cookie = NO_COOKIE;
+	struct file *exe_file;
 
-	if (mm && mm->exe_file)
-		cookie = fast_get_dcookie(&mm->exe_file->f_path);
+	if (!mm)
+		goto done;
 
+	exe_file = get_mm_exe_file(mm);
+	if (!exe_file)
+		goto done;
+
+	cookie = fast_get_dcookie(&exe_file->f_path);
+	fput(exe_file);
+done:
 	return cookie;
 }
 
@@ -236,6 +245,8 @@ static unsigned long get_exec_dcookie(st
  * pair that can then be added to the global event buffer. We make
  * sure to do this lookup before a mm->mmap modification happens so
  * we don't lose track.
+ *
+ * The caller must ensure the mm is not nil (ie: not a kernel thread).
  */
 static unsigned long
 lookup_dcookie(struct mm_struct *mm, unsigned long addr, off_t *offset)
@@ -243,6 +254,7 @@ lookup_dcookie(struct mm_struct *mm, uns
 	unsigned long cookie = NO_COOKIE;
 	struct vm_area_struct *vma;
 
+	down_read(&mm->mmap_sem);
 	for (vma = find_vma(mm, addr); vma; vma = vma->vm_next) {
 
 		if (addr < vma->vm_start || addr >= vma->vm_end)
@@ -262,6 +274,7 @@ lookup_dcookie(struct mm_struct *mm, uns
 
 	if (!vma)
 		cookie = INVALID_COOKIE;
+	up_read(&mm->mmap_sem);
 
 	return cookie;
 }
@@ -402,20 +415,9 @@ static void release_mm(struct mm_struct
 {
 	if (!mm)
 		return;
-	up_read(&mm->mmap_sem);
 	mmput(mm);
 }
 
-
-static struct mm_struct *take_tasks_mm(struct task_struct *task)
-{
-	struct mm_struct *mm = get_task_mm(task);
-	if (mm)
-		down_read(&mm->mmap_sem);
-	return mm;
-}
-
-
 static inline int is_code(unsigned long val)
 {
 	return val == ESCAPE_CODE;
@@ -532,7 +534,7 @@ void sync_buffer(int cpu)
 				new = (struct task_struct *)val;
 				oldmm = mm;
 				release_mm(oldmm);
-				mm = take_tasks_mm(new);
+				mm = get_task_mm(new);
 				if (mm != oldmm)
 					cookie = get_exec_dcookie(mm);
 				add_user_ctx_switch(new, cookie);
diff -puN kernel/fork.c~oprofile-reduce-mmap_sem-hold-for-mm-exe_file kernel/fork.c
--- a/kernel/fork.c~oprofile-reduce-mmap_sem-hold-for-mm-exe_file
+++ a/kernel/fork.c
@@ -752,6 +752,7 @@ struct file *get_mm_exe_file(struct mm_s
 	rcu_read_unlock();
 	return exe_file;
 }
+EXPORT_SYMBOL(get_mm_exe_file);
 
 /**
  * get_task_mm - acquire a reference to the task's mm
_

Patches currently in -mm which might be from dave@stgolabs.net are

origin.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: + oprofile-reduce-mmap_sem-hold-for-mm-exe_file.patch added to
 -mm tree
Date: Fri, 27 Feb 2015 13:58:08 -0800
Message-ID: <54f0e870.ay10SlpQy1f/W/dn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47974 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbbB0V6J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Feb 2015 16:58:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, rric@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: oprofile: reduce mmap_sem hold for mm->exe_file
has been added to the -mm tree.  Its filename is
     oprofile-reduce-mmap_sem-hold-for-mm-exe_file.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oprofile-reduce-mmap_sem-hold-for-mm-exe_file.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oprofile-reduce-mmap_sem-hold-for-mm-exe_file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Robert Richter <rric@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/oprofile/buffer_sync.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

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

From: akpm@linux-foundation.org
Subject: + powerpc-oprofile-reduce-mmap_sem-hold-for-exe_file.patch added
 to -mm tree
Date: Fri, 27 Feb 2015 13:58:10 -0800
Message-ID: <54f0e872.3Uev62OcTv2O6dYn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47978 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbbB0V6L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Feb 2015 16:58:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, arnd@arndb.de, benh@kernel.crashing.org, dbueso@suse.de, rric@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/oprofile: reduce mmap_sem hold for exe_file
has been added to the -mm tree.  Its filename is
     powerpc-oprofile-reduce-mmap_sem-hold-for-exe_file.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-oprofile-reduce-mmap_sem-hold-for-exe_file.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-oprofile-reduce-mmap_sem-hold-for-exe_file.patch

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
Subject: powerpc/oprofile: reduce mmap_sem hold for exe_file

In the future mm->exe_file will be done without mmap_sem serialization,
thus isolate and reorganize the related code to make the transition
easier.  Good users will, make use of the more standard get_mm_exe_file(),
requiring only holding the mmap_sem to read the value, and relying on
reference counting to make sure that the exe file won't dissappear
underneath us while getting the dcookie.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Robert Richter <rric@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/oprofile/cell/spu_task_sync.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN arch/powerpc/oprofile/cell/spu_task_sync.c~powerpc-oprofile-reduce-mmap_sem-hold-for-exe_file arch/powerpc/oprofile/cell/spu_task_sync.c
--- a/arch/powerpc/oprofile/cell/spu_task_sync.c~powerpc-oprofile-reduce-mmap_sem-hold-for-exe_file
+++ a/arch/powerpc/oprofile/cell/spu_task_sync.c
@@ -22,6 +22,7 @@
 #include <linux/kref.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
+#include <linux/file.h>
 #include <linux/module.h>
 #include <linux/notifier.h>
 #include <linux/numa.h>
@@ -322,18 +323,20 @@ get_exec_dcookie_and_offset(struct spu *
 	unsigned long app_cookie = 0;
 	unsigned int my_offset = 0;
 	struct vm_area_struct *vma;
+	struct file *exe_file;
 	struct mm_struct *mm = spu->mm;
 
 	if (!mm)
 		goto out;
 
-	down_read(&mm->mmap_sem);
-
-	if (mm->exe_file) {
-		app_cookie = fast_get_dcookie(&mm->exe_file->f_path);
-		pr_debug("got dcookie for %pD\n", mm->exe_file);
+	exe_file = get_mm_exe_file(mm);
+	if (exe_file) {
+		app_cookie = fast_get_dcookie(&exe_file->f_path);
+		pr_debug("got dcookie for %pD\n", exe_file);
+		fput(exe_file);
 	}
 
+	down_read(&mm->mmap_sem);
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		if (vma->vm_start > spu_ref || vma->vm_end <= spu_ref)
 			continue;
_

Patches currently in -mm which might be from dave@stgolabs.net are

mm-hugetlb-close-race-when-setting-pagetail-for-gigantic-pages.patch
arc-do-not-export-symbols-in-troubleshootc.patch
linux-next.patch
tile-elf-reorganize-notify_exec.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file.patch
powerpc-oprofile-reduce-mmap_sem-hold-for-exe_file.patch


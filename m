From: akpm@linux-foundation.org
Subject: + tile-elf-reorganize-notify_exec.patch added to -mm tree
Date: Fri, 27 Feb 2015 13:58:06 -0800
Message-ID: <54f0e86e.XfHttmRlQCbk2t+K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47969 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbbB0V6H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Feb 2015 16:58:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, cmetcalf@ezchip.com, dbueso@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: tile/elf: reorganize notify_exec()
has been added to the -mm tree.  Its filename is
     tile-elf-reorganize-notify_exec.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tile-elf-reorganize-notify_exec.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tile-elf-reorganize-notify_exec.patch

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
Subject: tile/elf: reorganize notify_exec()

This patch series addresses exe_file use for users that require the
mmap_sem for other things (mostly looking up the related vma->vm_file). 
In a lot of cases we end up with scenarios where we take the mmap_sem in
get_mm_exe_file(), just to then take it again soon after.  This is only
temporary as we will remove the need for mmap_sem when dealing with
exe_file.

This patch (of 3):

In the future mm->exe_file will be done without mmap_sem serialization,
thus isolate and reorganize the tile elf code to make the transition
easier.  Good users will, make use of the more standard get_mm_exe_file(),
requiring only holding the mmap_sem to read the value, and relying on
reference counting to make sure that the exe file won't dissappear
underneath us.

The visible effects of this patch are:

   o We now take and drop the mmap_sem more often. Instead of
     just in arch_setup_additional_pages(), we also do it in:

     1) get_mm_exe_file()
     2) to get the mm->vm_file and notify the simulator.

    [Note that 1) will disappear once we change the locking
     rules for exe_file.]

   o We avoid getting a free page and doing d_path() while
     holding the mmap_sem. This requires reordering the checks.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/mm/elf.c |   47 ++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 18 deletions(-)

diff -puN arch/tile/mm/elf.c~tile-elf-reorganize-notify_exec arch/tile/mm/elf.c
--- a/arch/tile/mm/elf.c~tile-elf-reorganize-notify_exec
+++ a/arch/tile/mm/elf.c
@@ -17,6 +17,7 @@
 #include <linux/binfmts.h>
 #include <linux/compat.h>
 #include <linux/mman.h>
+#include <linux/file.h>
 #include <linux/elf.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -39,30 +40,34 @@ static void sim_notify_exec(const char *
 
 static int notify_exec(struct mm_struct *mm)
 {
+	int ret = 0;
 	char *buf, *path;
 	struct vm_area_struct *vma;
+	struct file *exe_file;
 
 	if (!sim_is_simulator())
 		return 1;
 
-	if (mm->exe_file == NULL)
-		return 0;
-
-	for (vma = current->mm->mmap; ; vma = vma->vm_next) {
-		if (vma == NULL)
-			return 0;
-		if (vma->vm_file == mm->exe_file)
-			break;
-	}
-
 	buf = (char *) __get_free_page(GFP_KERNEL);
 	if (buf == NULL)
 		return 0;
 
-	path = d_path(&mm->exe_file->f_path, buf, PAGE_SIZE);
-	if (IS_ERR(path)) {
-		free_page((unsigned long)buf);
-		return 0;
+	exe_file = get_mm_exe_file(mm);
+	if (exe_file == NULL)
+		goto done_free;
+
+	path = d_path(&exe_file->f_path, buf, PAGE_SIZE);
+	if (IS_ERR(path))
+		goto done_put;
+
+	down_read(&mm->mmap_sem);
+	for (vma = current->mm->mmap; ; vma = vma->vm_next) {
+		if (vma == NULL) {
+			up_read(&mm->mmap_sem);
+			goto done_put;
+		}
+		if (vma->vm_file == exe_file)
+			break;
 	}
 
 	/*
@@ -80,14 +85,20 @@ static int notify_exec(struct mm_struct
 			__insn_mtspr(SPR_SIM_CONTROL,
 				     (SIM_CONTROL_DLOPEN
 				      | (c << _SIM_CONTROL_OPERATOR_BITS)));
-			if (c == '\0')
+			if (c == '\0') {
+				ret = 1; /* success */
 				break;
+			}
 		}
 	}
+	up_read(&mm->mmap_sem);
 
 	sim_notify_exec(path);
+done_put:
+	fput(exe_file);
+done_free:
 	free_page((unsigned long)buf);
-	return 1;
+	return ret;
 }
 
 /* Notify a running simulator, if any, that we loaded an interpreter. */
@@ -109,8 +120,6 @@ int arch_setup_additional_pages(struct l
 	struct mm_struct *mm = current->mm;
 	int retval = 0;
 
-	down_write(&mm->mmap_sem);

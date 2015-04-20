From: akpm@linux-foundation.org
Subject: [merged] powerpc-oprofile-reduce-mmap_sem-hold-for-exe_file.patch removed from -mm tree
Date: Mon, 20 Apr 2015 12:20:52 -0700
Message-ID: <55355194.t0dXcnpyTzTgUbFs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40516 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbbDTTOb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:14:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, arnd@arndb.de, benh@kernel.crashing.org, dbueso@suse.de, rric@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/oprofile: reduce mmap_sem hold for exe_file
has been removed from the -mm tree.  Its filename was
     powerpc-oprofile-reduce-mmap_sem-hold-for-exe_file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

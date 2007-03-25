From: akpm@linux-foundation.org
Subject: + integrity-mtime-patch-for-mmap-files.patch added to -mm tree
Date: Sat, 24 Mar 2007 23:55:37 -0800
Message-ID: <200703250755.l2P7tbYM023251@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35519 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478AbXCYHz6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 03:55:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zohar@linux.vnet.ibm.com, zohar@us.ibm.com


The patch titled
     integrity: mtime patch for mmap files
has been added to the -mm tree.  Its filename is
     integrity-mtime-patch-for-mmap-files.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: integrity: mtime patch for mmap files
From: Mimi Zohar <zohar@linux.vnet.ibm.com>

mmaped files are hashed and hmac'ed properly by EVM after being modified when
the file's mtime is updated correctly.  Peter Staubach's 'memory mapped files
not updating timestamps v2' patch properly updates the mmapped file's mtime. 
In those cases when an application does not first msync the file before
calling munmap, the mtime is eventually updated, but not before file_close is
called.  This patch forces the mtime for mmaped files to be updated in a
timely manner.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/mmap.c~integrity-mtime-patch-for-mmap-files mm/mmap.c
--- a/mm/mmap.c~integrity-mtime-patch-for-mmap-files
+++ a/mm/mmap.c
@@ -1790,6 +1790,7 @@ int do_munmap(struct mm_struct *mm, unsi
 {
 	unsigned long end;
 	struct vm_area_struct *vma, *prev, *last;
+	struct file *file;
 
 	if ((start & ~PAGE_MASK) || start > TASK_SIZE || len > TASK_SIZE-start)
 		return -EINVAL;
@@ -1808,6 +1809,10 @@ int do_munmap(struct mm_struct *mm, unsi
 	if (vma->vm_start >= end)
 		return 0;
 
+	file = vma->vm_file;
+	if (file && test_and_clear_bit(AS_MCTIME, &file->f_mapping->flags))
+		file_update_time(file);
+
 	/*
 	 * If we need to split any vma, do it now to save pain later.
 	 *
_

Patches currently in -mm which might be from zohar@linux.vnet.ibm.com are

integrity-new-hooks.patch
integrity-fs-hook-placement.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-mtime-patch-for-mmap-files.patch
integrity-tpm-internal-kernel-interface.patch
ibac-patch.patch

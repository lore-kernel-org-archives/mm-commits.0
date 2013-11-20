From: akpm@linux-foundation.org
Subject: +
 fs-ramfs-file-nommuc-make-ramfs_nommu_get_unmapped_area-and-ramfs_nommu_mmap-static.patch added to -mm tree
Date: Wed, 20 Nov 2013 14:42:45 -0800
Message-ID: <528d3ae5.HekZPR9Ss+5WGZXE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36246 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab3KTWmq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Nov 2013 17:42:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, axel.lin@ingics.com

Subject: + fs-ramfs-file-nommuc-make-ramfs_nommu_get_unmapped_area-and-ramfs_nommu_mmap-static.patch added to -mm tree
To: axel.lin@ingics.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Wed, 20 Nov 2013 14:42:45 -0800


The patch titled
     Subject: fs/ramfs/file-nommu.c: make ramfs_nommu_get_unmapped_area() and ramfs_nommu_mmap() static
has been added to the -mm tree.  Its filename is
     fs-ramfs-file-nommuc-make-ramfs_nommu_get_unmapped_area-and-ramfs_nommu_mmap-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ramfs-file-nommuc-make-ramfs_nommu_get_unmapped_area-and-ramfs_nommu_mmap-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ramfs-file-nommuc-make-ramfs_nommu_get_unmapped_area-and-ramfs_nommu_mmap-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Axel Lin <axel.lin@ingics.com>
Subject: fs/ramfs/file-nommu.c: make ramfs_nommu_get_unmapped_area() and ramfs_nommu_mmap() static

Since commit 853ac43ab194f "shmem: unify regular and tiny shmem",
ramfs_nommu_get_unmapped_area() and ramfs_nommu_mmap() are not directly
referenced outside of file-nommu.c.  Thus make them static.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/file-nommu.c |   10 ++++++++--
 include/linux/ramfs.h |    7 -------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff -puN fs/ramfs/file-nommu.c~fs-ramfs-file-nommuc-make-ramfs_nommu_get_unmapped_area-and-ramfs_nommu_mmap-static fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~fs-ramfs-file-nommuc-make-ramfs_nommu_get_unmapped_area-and-ramfs_nommu_mmap-static
+++ a/fs/ramfs/file-nommu.c
@@ -27,6 +27,12 @@
 #include "internal.h"
 
 static int ramfs_nommu_setattr(struct dentry *, struct iattr *);
+static unsigned long ramfs_nommu_get_unmapped_area(struct file *file,
+						   unsigned long addr,
+						   unsigned long len,
+						   unsigned long pgoff,
+						   unsigned long flags);
+static int ramfs_nommu_mmap(struct file *file, struct vm_area_struct *vma);
 
 const struct address_space_operations ramfs_aops = {
 	.readpage		= simple_readpage,
@@ -197,7 +203,7 @@ static int ramfs_nommu_setattr(struct de
  *   - the pages to be mapped must exist
  *   - the pages be physically contiguous in sequence
  */
-unsigned long ramfs_nommu_get_unmapped_area(struct file *file,
+static unsigned long ramfs_nommu_get_unmapped_area(struct file *file,
 					    unsigned long addr, unsigned long len,
 					    unsigned long pgoff, unsigned long flags)
 {
@@ -256,7 +262,7 @@ out:
 /*
  * set up a mapping for shared memory segments
  */
-int ramfs_nommu_mmap(struct file *file, struct vm_area_struct *vma)
+static int ramfs_nommu_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	if (!(vma->vm_flags & VM_SHARED))
 		return -ENOSYS;
diff -puN include/linux/ramfs.h~fs-ramfs-file-nommuc-make-ramfs_nommu_get_unmapped_area-and-ramfs_nommu_mmap-static include/linux/ramfs.h
--- a/include/linux/ramfs.h~fs-ramfs-file-nommuc-make-ramfs_nommu_get_unmapped_area-and-ramfs_nommu_mmap-static
+++ a/include/linux/ramfs.h
@@ -14,13 +14,6 @@ ramfs_nommu_expand_for_mapping(struct in
 }
 #else
 extern int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize);
-extern unsigned long ramfs_nommu_get_unmapped_area(struct file *file,
-						   unsigned long addr,
-						   unsigned long len,
-						   unsigned long pgoff,
-						   unsigned long flags);

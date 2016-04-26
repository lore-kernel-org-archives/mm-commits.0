From: akpm@linux-foundation.org
Subject: + tmpfs-fix-vm_mayshare-mappings-for-nommu.patch added to -mm
 tree
Date: Mon, 25 Apr 2016 17:09:15 -0700
Message-ID: <571eb1ab.xqd9SRAcfNCFNw9O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbcDZAJQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2016 20:09:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dalias@libc.org, geert@linux-m68k.org, gerg@uclinux.org, mhocko@suse.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: ramfs: fix VM_MAYSHARE mappings for NOMMU
has been added to the -mm tree.  Its filename is
     tmpfs-fix-vm_mayshare-mappings-for-nommu.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tmpfs-fix-vm_mayshare-mappings-for-nommu.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tmpfs-fix-vm_mayshare-mappings-for-nommu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rich Felker <dalias@libc.org>
Subject: ramfs: fix VM_MAYSHARE mappings for NOMMU

The nommu do_mmap expects f_op->get_unmapped_area to either succeed or
return -ENOSYS for VM_MAYSHARE (e.g.  private read-only) mappings. 
Returning addr in the non-MAP_SHARED case was completely wrong, and only
happened to work because addr was 0.  However, it prevented VM_MAYSHARE
mappings from sharing backing with the fs cache, and forced such mappings
(including shareable program text) to be copied whenever the number of
mappings transitioned from 0 to 1, impacting performance and memory usage.
Subsequent mappings beyond the first still correctly shared memory with
the first.

Instead, treat VM_MAYSHARE identically to VM_SHARED at the file ops level;
do_mmap already handles the semantic differences between them.

Signed-off-by: Rich Felker <dalias@libc.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/file-nommu.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN fs/ramfs/file-nommu.c~tmpfs-fix-vm_mayshare-mappings-for-nommu fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~tmpfs-fix-vm_mayshare-mappings-for-nommu
+++ a/fs/ramfs/file-nommu.c
@@ -211,14 +211,11 @@ static unsigned long ramfs_nommu_get_unm
 	struct page **pages = NULL, **ptr, *page;
 	loff_t isize;
 
-	if (!(flags & MAP_SHARED))
-		return addr;
-
 	/* the mapping mustn't extend beyond the EOF */
 	lpages = (len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	isize = i_size_read(inode);
 
-	ret = -EINVAL;
+	ret = -ENOSYS;
 	maxpages = (isize + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	if (pgoff >= maxpages)
 		goto out;
@@ -227,7 +224,6 @@ static unsigned long ramfs_nommu_get_unm
 		goto out;
 
 	/* gang-find the pages */
-	ret = -ENOMEM;
 	pages = kcalloc(lpages, sizeof(struct page *), GFP_KERNEL);
 	if (!pages)
 		goto out_free;
@@ -263,7 +259,7 @@ out:
  */
 static int ramfs_nommu_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	if (!(vma->vm_flags & VM_SHARED))
+	if (!(vma->vm_flags & (VM_SHARED | VM_MAYSHARE)))
 		return -ENOSYS;
 
 	file_accessed(file);
_

Patches currently in -mm which might be from dalias@libc.org are

tmpfs-fix-vm_mayshare-mappings-for-nommu.patch


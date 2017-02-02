From: akpm@linux-foundation.org
Subject: + mmfsdax-change-pmd_fault-to-huge_fault-fix-2.patch added to -mm tree
Date: Thu, 02 Feb 2017 14:42:59 -0800
Message-ID: <5893b5f3.7D7/gQVpPEGcJJV7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52236 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751520AbdBBWnA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2017 17:43:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, arnd@arndb.de, dave.jiang@intel.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: ext4: Remove unused function ext4_dax_huge_fault()
has been added to the -mm tree.  Its filename is
     mmfsdax-change-pmd_fault-to-huge_fault-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmfsdax-change-pmd_fault-to-huge_fault-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmfsdax-change-pmd_fault-to-huge_fault-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: ext4: Remove unused function ext4_dax_huge_fault()

ext4_dax_pmd_fault() was renamed to ext4_dax_huge_fault() in this commit:

commit 7e90fc0f8785 ("mm,fs,dax: change ->pmd_fault to ->huge_fault")

However, the vm_operations_struct ops table for ext4 was modified in that
commit so that .huge_fault called ext4_dax_fault(), not
ext4_dax_huge_fault().  This is actually fine, though, since as of that
commit ext4_dax_fault() and ext4_dax_huge_fault() are identical, both
eventually calling dax_iomap_fault().

So, instead of changing the opts table to have .huge_fault call
ext4_dax_huge_fault(), just leave it calling ext4_dax_fault() and remove
the unused function.

This fix also quiets the following compilation warning:

/ext4/file.c:279:1: warning: `ext4_dax_huge_fault' defined but not used [-Wunused-function]
 ext4_dax_huge_fault(struct vm_fault *vmf)

Fixes: 7e90fc0f8785 ("mm,fs,dax: change ->pmd_fault to ->huge_fault")
Link: http://lkml.kernel.org/r/1485813172-7284-1-git-send-email-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/file.c |   21 ---------------------
 1 file changed, 21 deletions(-)

diff -puN fs/ext4/file.c~mmfsdax-change-pmd_fault-to-huge_fault-fix-2 fs/ext4/file.c
--- a/fs/ext4/file.c~mmfsdax-change-pmd_fault-to-huge_fault-fix-2
+++ a/fs/ext4/file.c
@@ -275,27 +275,6 @@ static int ext4_dax_fault(struct vm_faul
 	return result;
 }
 
-static int
-ext4_dax_huge_fault(struct vm_fault *vmf)
-{
-	int result;
-	struct inode *inode = file_inode(vmf->vma->vm_file);
-	struct super_block *sb = inode->i_sb;
-	bool write = vmf->flags & FAULT_FLAG_WRITE;
-
-	if (write) {
-		sb_start_pagefault(sb);
-		file_update_time(vmf->vma->vm_file);
-	}
-	down_read(&EXT4_I(inode)->i_mmap_sem);
-	result = dax_iomap_fault(vmf, &ext4_iomap_ops);
-	up_read(&EXT4_I(inode)->i_mmap_sem);
-	if (write)
-		sb_end_pagefault(sb);
-
-	return result;
-}

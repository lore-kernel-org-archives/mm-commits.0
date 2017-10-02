From: akpm@linux-foundation.org
Subject: + dax-stop-using-vm_hugepage-for-dax.patch added to -mm tree
Date: Mon, 02 Oct 2017 15:48:10 -0700
Message-ID: <59d2c22a.0KA+RJWdq8YcozRe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44218 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750949AbdJBWsL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Oct 2017 18:48:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, hch@lst.de, jack@suse.cz, jmoyer@redhat.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: stop using VM_HUGEPAGE for dax
has been added to the -mm tree.  Its filename is
     dax-stop-using-vm_hugepage-for-dax.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-stop-using-vm_hugepage-for-dax.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-stop-using-vm_hugepage-for-dax.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: dax: stop using VM_HUGEPAGE for dax

This flag is deprecated in favor of the vma_is_dax() check in
transparent_hugepage_enabled() added in commit baabda261424 "mm: always
enable thp for dax mappings"

Link: http://lkml.kernel.org/r/150664808322.36094.377701515526275078.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/device.c |    1 -
 fs/ext4/file.c       |    1 -
 fs/xfs/xfs_file.c    |    2 --
 3 files changed, 4 deletions(-)

diff -puN drivers/dax/device.c~dax-stop-using-vm_hugepage-for-dax drivers/dax/device.c
--- a/drivers/dax/device.c~dax-stop-using-vm_hugepage-for-dax
+++ a/drivers/dax/device.c
@@ -450,7 +450,6 @@ static int dax_mmap(struct file *filp, s
 		return rc;
 
 	vma->vm_ops = &dax_vm_ops;
-	vma->vm_flags |= VM_HUGEPAGE;
 	return 0;
 }
 
diff -puN fs/ext4/file.c~dax-stop-using-vm_hugepage-for-dax fs/ext4/file.c
--- a/fs/ext4/file.c~dax-stop-using-vm_hugepage-for-dax
+++ a/fs/ext4/file.c
@@ -352,7 +352,6 @@ static int ext4_file_mmap(struct file *f
 	file_accessed(file);
 	if (IS_DAX(file_inode(file))) {
 		vma->vm_ops = &ext4_dax_vm_ops;
-		vma->vm_flags |= VM_HUGEPAGE;
 	} else {
 		vma->vm_ops = &ext4_file_vm_ops;
 	}
diff -puN fs/xfs/xfs_file.c~dax-stop-using-vm_hugepage-for-dax fs/xfs/xfs_file.c
--- a/fs/xfs/xfs_file.c~dax-stop-using-vm_hugepage-for-dax
+++ a/fs/xfs/xfs_file.c
@@ -1133,8 +1133,6 @@ xfs_file_mmap(
 {
 	file_accessed(filp);
 	vma->vm_ops = &xfs_file_vm_ops;
-	if (IS_DAX(file_inode(filp)))
-		vma->vm_flags |= VM_HUGEPAGE;
 	return 0;
 }
 
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

dax-quiet-bdev_dax_supported.patch
dax-disable-filesystem-dax-on-devices-that-do-not-map-pages.patch
dax-stop-using-vm_mixedmap-for-dax.patch
dax-stop-using-vm_hugepage-for-dax.patch


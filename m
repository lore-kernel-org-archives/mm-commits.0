From: akpm@linux-foundation.org
Subject: +
 mm-move-mremap-from-file_operations-to-vm_operations_struct.patch added to
 -mm tree
Date: Thu, 09 Jul 2015 15:26:28 -0700
Message-ID: <559ef514.w/TAr/rzD/ZDyVOI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53077 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105AbbGIW0a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 18:26:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, bcrl@kvack.org, hughd@google.com, jmoyer@redhat.com, kirill.shutemov@linux.intel.com, ldufour@linux.vnet.ibm.com, rientjes@google.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move ->mremap() from file_operations to vm_operations_struct
has been added to the -mm tree.  Its filename is
     mm-move-mremap-from-file_operations-to-vm_operations_struct.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move-mremap-from-file_operations-to-vm_operations_struct.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move-mremap-from-file_operations-to-vm_operations_struct.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mm: move ->mremap() from file_operations to vm_operations_struct

vma->vm_ops->mremap() looks more natural and clean in move_vma(), and this
way ->mremap() can have more users.  Say, vdso.

While at it, s/aio_ring_remap/aio_ring_mremap/.

Note: this is the minimal change before ->mremap() finds another user in
file_operations; this method should have more arguments, and it can be
used to kill arch_remap().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c           |   25 ++++++++++++++++---------
 include/linux/fs.h |    1 -
 include/linux/mm.h |    1 +
 mm/mremap.c        |    4 ++--
 4 files changed, 19 insertions(+), 12 deletions(-)

diff -puN fs/aio.c~mm-move-mremap-from-file_operations-to-vm_operations_struct fs/aio.c
--- a/fs/aio.c~mm-move-mremap-from-file_operations-to-vm_operations_struct
+++ a/fs/aio.c
@@ -308,15 +308,9 @@ static void aio_free_ring(struct kioctx
 	}
 }
 
-static int aio_ring_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	vma->vm_flags |= VM_DONTEXPAND;
-	vma->vm_ops = &generic_file_vm_ops;
-	return 0;
-}
-
-static int aio_ring_remap(struct file *file, struct vm_area_struct *vma)
+static int aio_ring_mremap(struct vm_area_struct *vma)
 {
+	struct file *file = vma->vm_file;
 	struct mm_struct *mm = vma->vm_mm;
 	struct kioctx_table *table;
 	int i, res = -EINVAL;
@@ -342,9 +336,22 @@ static int aio_ring_remap(struct file *f
 	return res;
 }
 
+static const struct vm_operations_struct aio_ring_vm_ops = {
+	.mremap		= aio_ring_mremap,
+	.fault		= filemap_fault,
+	.map_pages	= filemap_map_pages,
+	.page_mkwrite	= filemap_page_mkwrite,
+};
+
+static int aio_ring_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	vma->vm_flags |= VM_DONTEXPAND;
+	vma->vm_ops = &aio_ring_vm_ops;
+	return 0;
+}
+
 static const struct file_operations aio_ring_fops = {
 	.mmap = aio_ring_mmap,
-	.mremap = aio_ring_remap,
 };
 
 #if IS_ENABLED(CONFIG_MIGRATION)
diff -puN include/linux/fs.h~mm-move-mremap-from-file_operations-to-vm_operations_struct include/linux/fs.h
--- a/include/linux/fs.h~mm-move-mremap-from-file_operations-to-vm_operations_struct
+++ a/include/linux/fs.h
@@ -1595,7 +1595,6 @@ struct file_operations {
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
-	int (*mremap)(struct file *, struct vm_area_struct *);
 	int (*open) (struct inode *, struct file *);
 	int (*flush) (struct file *, fl_owner_t id);
 	int (*release) (struct inode *, struct file *);
diff -puN include/linux/mm.h~mm-move-mremap-from-file_operations-to-vm_operations_struct include/linux/mm.h
--- a/include/linux/mm.h~mm-move-mremap-from-file_operations-to-vm_operations_struct
+++ a/include/linux/mm.h
@@ -248,6 +248,7 @@ struct vm_fault {
 struct vm_operations_struct {
 	void (*open)(struct vm_area_struct * area);
 	void (*close)(struct vm_area_struct * area);
+	int (*mremap)(struct vm_area_struct * area);
 	int (*fault)(struct vm_area_struct *vma, struct vm_fault *vmf);
 	void (*map_pages)(struct vm_area_struct *vma, struct vm_fault *vmf);
 
diff -puN mm/mremap.c~mm-move-mremap-from-file_operations-to-vm_operations_struct mm/mremap.c
--- a/mm/mremap.c~mm-move-mremap-from-file_operations-to-vm_operations_struct
+++ a/mm/mremap.c
@@ -277,8 +277,8 @@ static unsigned long move_vma(struct vm_
 				     need_rmap_locks);
 	if (moved_len < old_len) {
 		err = -ENOMEM;
-	} else if (vma->vm_file && vma->vm_file->f_op->mremap) {
-		err = vma->vm_file->f_op->mremap(vma->vm_file, new_vma);
+	} else if (vma->vm_ops && vma->vm_ops->mremap) {
+		err = vma->vm_ops->mremap(new_vma);
 	}
 
 	if (unlikely(err)) {
_

Patches currently in -mm which might be from oleg@redhat.com are

mremap-dont-leak-new_vma-if-f_op-mremap-fails.patch
mm-move-mremap-from-file_operations-to-vm_operations_struct.patch
mremap-dont-do-mm_populatenew_addr-on-failure.patch
mremap-dont-do-uneccesary-checks-if-new_len-==-old_len.patch
mremap-simplify-the-overlap-check-in-mremap_to.patch
kmod-bunch-of-internal-functions-renames.patch
kmod-add-up-to-date-explanations-on-the-purpose-of-each-asynchronous-levels.patch
kmod-remove-unecessary-explicit-wide-cpu-affinity-setting.patch
linux-next.patch


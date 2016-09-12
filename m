From: akpm@linux-foundation.org
Subject: + ipc-shm-fix-crash-if-config_shmem-is-not-set.patch added to -mm tree
Date: Mon, 12 Sep 2016 15:21:53 -0700
Message-ID: <57d72a81.h+AePpJk4qwonhds%akpm__8863.85827693648$1473718933$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51275 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756079AbcILWV7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2016 18:21:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, hughd@google.com, stable@vger.kernel.org, tonyb@cybernetics.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/shm: fix crash if CONFIG_SHMEM is not set
has been added to the -mm tree.  Its filename is
     ipc-shm-fix-crash-if-config_shmem-is-not-set.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-shm-fix-crash-if-config_shmem-is-not-set.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-shm-fix-crash-if-config_shmem-is-not-set.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: ipc/shm: fix crash if CONFIG_SHMEM is not set

c01d5b300774 ("shmem: get_unmapped_area align huge page") makes use of
shm_get_unmapped_area() in shm_file_operations() unconditional to
CONFIG_MMU.

As Tony Battersby pointed this can lead NULL-pointer dereference on
machine with CONFIG_MMU=y and CONFIG_SHMEM=n.  In this case ipc/shm is
backed by ramfs which doesn't provide f_op->get_unmapped_area for
configurations with MMU.

The solution is to provide dummy f_op->get_unmapped_area for ramfs when
CONFIG_MMU=y, which just call current->mm->get_unmapped_area().

Fixes: c01d5b300774 ("shmem: get_unmapped_area align huge page")
Link: http://lkml.kernel.org/r/20160912102704.140442-1-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Tony Battersby <tonyb@cybernetics.com>
Tested-by: Tony Battersby <tonyb@cybernetics.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>	[4.7.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/file-mmu.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN fs/ramfs/file-mmu.c~ipc-shm-fix-crash-if-config_shmem-is-not-set fs/ramfs/file-mmu.c
--- a/fs/ramfs/file-mmu.c~ipc-shm-fix-crash-if-config_shmem-is-not-set
+++ a/fs/ramfs/file-mmu.c
@@ -27,9 +27,17 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/ramfs.h>
+#include <linux/sched.h>
 
 #include "internal.h"
 
+static unsigned long ramfs_mmu_get_unmapped_area(struct file *file,
+		unsigned long addr, unsigned long len, unsigned long pgoff,
+		unsigned long flags)
+{
+	return current->mm->get_unmapped_area(file, addr, len, pgoff, flags);
+}
+
 const struct file_operations ramfs_file_operations = {
 	.read_iter	= generic_file_read_iter,
 	.write_iter	= generic_file_write_iter,
@@ -38,6 +46,7 @@ const struct file_operations ramfs_file_
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.llseek		= generic_file_llseek,
+	.get_unmapped_area	= ramfs_mmu_get_unmapped_area,
 };
 
 const struct inode_operations ramfs_file_inode_operations = {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

khugepaged-fix-use-after-free-in-collapse_huge_page.patch
mm-avoid-endless-recursion-in-dump_page.patch
ipc-shm-fix-crash-if-config_shmem-is-not-set.patch


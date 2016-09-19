From: akpm@linux-foundation.org
Subject: [patch 10/20] ipc/shm: fix crash if CONFIG_SHMEM is not set
Date: Mon, 19 Sep 2016 15:12:26 -0700
Message-ID: <57e062ca.4PK2A6uGsrcl8rli%akpm__9642.31052571467$1474323174$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53452 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753301AbcISWM1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Sep 2016 18:12:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, hughd@google.com, stable@vger.kernel.org, tonyb@cybernetics.com

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

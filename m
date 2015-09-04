From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-move-mremap-from-file_operations-to-vm_operations_struct-v3.patch
 removed from -mm tree
Date: Fri, 04 Sep 2015 15:35:56 -0700
Message-ID: <55ea1ccc.+YQRk9c8FKdrfFNt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933022AbbIDWf5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2015 18:35:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, fengguang.wu@intel.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-move-mremap-from-file_operations-to-vm_operations_struct-v3
has been removed from the -mm tree.  Its filename was
     mm-move-mremap-from-file_operations-to-vm_operations_struct-v3.patch

This patch was dropped because it was folded into mm-move-mremap-from-file_operations-to-vm_operations_struct.patch

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mm-move-mremap-from-file_operations-to-vm_operations_struct-v3

fs/aio.c can't be compiled if CONFIG_MMU=n, filemap_page_mkwrite() is
not defined in this case. Add ifdef(CONFIG_MMU) into aio_ring_vm_ops.

Note that this only fixes the build error, currently aio doesn't work
if !CONFIG_MMU anyway.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/aio.c~mm-move-mremap-from-file_operations-to-vm_operations_struct-v3 fs/aio.c
--- a/fs/aio.c~mm-move-mremap-from-file_operations-to-vm_operations_struct-v3
+++ a/fs/aio.c
@@ -338,9 +338,11 @@ static int aio_ring_mremap(struct vm_are
 
 static const struct vm_operations_struct aio_ring_vm_ops = {
 	.mremap		= aio_ring_mremap,
+#if IS_ENABLED(CONFIG_MMU)
 	.fault		= filemap_fault,
 	.map_pages	= filemap_map_pages,
 	.page_mkwrite	= filemap_page_mkwrite,
+#endif
 };
 
 static int aio_ring_mmap(struct file *file, struct vm_area_struct *vma)
_

Patches currently in -mm which might be from oleg@redhat.com are

mremap-dont-leak-new_vma-if-f_op-mremap-fails.patch
mm-move-mremap-from-file_operations-to-vm_operations_struct.patch
mremap-dont-do-mm_populatenew_addr-on-failure.patch
mremap-dont-do-uneccesary-checks-if-new_len-==-old_len.patch
mremap-simplify-the-overlap-check-in-mremap_to.patch


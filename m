From: akpm@linux-foundation.org
Subject: +
 mm-move-mremap-from-file_operations-to-vm_operations_struct-v3.patch added
 to -mm tree
Date: Tue, 21 Jul 2015 12:56:51 -0700
Message-ID: <55aea403.7lLnaMe8rhQeZb+1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbbGUT4w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jul 2015 15:56:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, fengguang.wu@intel.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-move-mremap-from-file_operations-to-vm_operations_struct-v3
has been added to the -mm tree.  Its filename is
     mm-move-mremap-from-file_operations-to-vm_operations_struct-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move-mremap-from-file_operations-to-vm_operations_struct-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move-mremap-from-file_operations-to-vm_operations_struct-v3.patch

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

signal-fix-information-leak-in-copy_siginfo_from_user32.patch
signal-fix-information-leak-in-copy_siginfo_to_user.patch
mremap-dont-leak-new_vma-if-f_op-mremap-fails.patch
mm-move-mremap-from-file_operations-to-vm_operations_struct.patch
mm-move-mremap-from-file_operations-to-vm_operations_struct-v3.patch
mremap-dont-do-mm_populatenew_addr-on-failure.patch
mremap-dont-do-uneccesary-checks-if-new_len-==-old_len.patch
mremap-simplify-the-overlap-check-in-mremap_to.patch
mm-introduce-vma_is_anonymousvma-helper.patch
mmap-fix-the-usage-of-vm_pgoff-in-special_mapping-paths.patch
mremap-fix-the-wrong-vma-vm_file-check-in-copy_vma.patch
linux-next.patch


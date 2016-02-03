From: akpm@linux-foundation.org
Subject: [merged]
 drivers-scsi-sgc-mark-vma-as-vm_io-to-prevent-migration.patch removed from
 -mm tree
Date: Wed, 03 Feb 2016 13:53:14 -0800
Message-ID: <56b276ca.E5pYPEe03UkGKuZe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42243 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965157AbcBCVxP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2016 16:53:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, James.Bottomley@HansenPartnership.com, dgilbert@interlog.com, dvyukov@google.com, glider@google.com, hughd@google.com, kcc@google.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, sasha.levin@oracle.com, shashim@codeaurora.org, stable@vger.kernel.org, syzkaller@googlegroups.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/scsi/sg.c: mark VMA as VM_IO to prevent migration
has been removed from the -mm tree.  Its filename was
     drivers-scsi-sgc-mark-vma-as-vm_io-to-prevent-migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: drivers/scsi/sg.c: mark VMA as VM_IO to prevent migration

Reduced testcase:

	#include <fcntl.h>
	#include <unistd.h>
	#include <sys/mman.h>
	#include <numaif.h>

	#define SIZE 0x2000

	int main()
	{
		int fd;
		void *p;

		fd = open("/dev/sg0", O_RDWR);
		p = mmap(NULL, SIZE, PROT_EXEC, MAP_PRIVATE | MAP_LOCKED, fd, 0);
		mbind(p, SIZE, 0, NULL, 0, MPOL_MF_MOVE);
		return 0;
	}

We shouldn't try to migrate pages in sg VMA as we don't have a way to
update Sg_scatter_hold::pages accordingly from mm core.

Let's mark the VMA as VM_IO to indicate to mm core that the VMA is
not migratable.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Shiraz Hashim <shashim@codeaurora.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: syzkaller <syzkaller@googlegroups.com>
Cc: Kostya Serebryany <kcc@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/sg.c~drivers-scsi-sgc-mark-vma-as-vm_io-to-prevent-migration drivers/scsi/sg.c
--- a/drivers/scsi/sg.c~drivers-scsi-sgc-mark-vma-as-vm_io-to-prevent-migration
+++ a/drivers/scsi/sg.c
@@ -1261,7 +1261,7 @@ sg_mmap(struct file *filp, struct vm_are
 	}
 
 	sfp->mmap_called = 1;
-	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
+	vma->vm_flags |= VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_private_data = sfp;
 	vma->vm_ops = &sg_mmap_vm_ops;
 	return 0;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mempolicy-do-not-try-to-queue-pages-from-vma_migratable.patch
mm-downgrade-vm_bug-in-isolate_lru_page-to-warning.patch
ipc-shm-handle-removed-segments-gracefully-in-shm_mmap.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch


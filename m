From: akpm@linux-foundation.org
Subject: + drivers-scsi-sgc-mark-vma-as-vm_io-to-prevent-migration.patch
 added to -mm tree
Date: Tue, 26 Jan 2016 12:48:31 -0800
Message-ID: <56a7db9f.usilnOHw1ZVCEhQC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49376 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbcAZUsd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 15:48:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, James.Bottomley@HansenPartnership.com, dgilbert@interlog.com, dvyukov@google.com, glider@google.com, hughd@google.com, kcc@google.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, sasha.levin@oracle.com, shashim@codeaurora.org, syzkaller@googlegroups.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/scsi/sg.c: mark VMA as VM_IO to prevent migration
has been added to the -mm tree.  Its filename is
     drivers-scsi-sgc-mark-vma-as-vm_io-to-prevent-migration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-scsi-sgc-mark-vma-as-vm_io-to-prevent-migration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-scsi-sgc-mark-vma-as-vm_io-to-prevent-migration.patch

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
migratable.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
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

thp-make-split_queue-per-node.patch
thp-change-deferred_split_count-to-return-number-of-thp-in-queue.patch
thp-change-deferred_split_count-to-return-number-of-thp-in-queue-fix.patch
thp-limit-number-of-object-to-scan-on-deferred_split_scan.patch
drivers-scsi-sgc-mark-vma-as-vm_io-to-prevent-migration.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch


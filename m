From: akpm@linux-foundation.org
Subject: + mm-loosen-madv_nohugepage-to-enable-qemu-postcopy-on-s390.patch added to -mm tree
Date: Tue, 17 Nov 2015 13:45:44 -0800
Message-ID: <564ba008.wsfxKfqtUYOa07KH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45092 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbbKQVpp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 16:45:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jjherne@linux.vnet.ibm.com, aarcange@redhat.com, borntraeger@de.ibm.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: Loosen MADV_NOHUGEPAGE to enable Qemu postcopy on s390
has been added to the -mm tree.  Its filename is
     mm-loosen-madv_nohugepage-to-enable-qemu-postcopy-on-s390.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-loosen-madv_nohugepage-to-enable-qemu-postcopy-on-s390.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-loosen-madv_nohugepage-to-enable-qemu-postcopy-on-s390.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Jason J. Herne" <jjherne@linux.vnet.ibm.com>
Subject: mm: Loosen MADV_NOHUGEPAGE to enable Qemu postcopy on s390

MADV_NOHUGEPAGE processing is too restrictive.  kvm already disables
hugepage but hugepage_madvise() takes the error path when we ask to turn
on the MADV_NOHUGEPAGE bit and the bit is already on.  This causes Qemu's
new postcopy migration feature to fail on s390 because its first action is
to madvise the guest address space as NOHUGEPAGE.  This patch modifies the
code so that the operation succeeds without error now.

For consistency reasons do the same for MADV_HUGEPAGE.

Signed-off-by: Jason J. Herne <jjherne@linux.vnet.ibm.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/huge_memory.c~mm-loosen-madv_nohugepage-to-enable-qemu-postcopy-on-s390 mm/huge_memory.c
--- a/mm/huge_memory.c~mm-loosen-madv_nohugepage-to-enable-qemu-postcopy-on-s390
+++ a/mm/huge_memory.c
@@ -2009,7 +2009,7 @@ int hugepage_madvise(struct vm_area_stru
 		/*
 		 * Be somewhat over-protective like KSM for now!
 		 */
-		if (*vm_flags & (VM_HUGEPAGE | VM_NO_THP))
+		if (*vm_flags & VM_NO_THP)
 			return -EINVAL;
 		*vm_flags &= ~VM_NOHUGEPAGE;
 		*vm_flags |= VM_HUGEPAGE;
@@ -2025,7 +2025,7 @@ int hugepage_madvise(struct vm_area_stru
 		/*
 		 * Be somewhat over-protective like KSM for now!
 		 */
-		if (*vm_flags & (VM_NOHUGEPAGE | VM_NO_THP))
+		if (*vm_flags & VM_NO_THP)
 			return -EINVAL;
 		*vm_flags &= ~VM_HUGEPAGE;
 		*vm_flags |= VM_NOHUGEPAGE;
_

Patches currently in -mm which might be from jjherne@linux.vnet.ibm.com are

mm-loosen-madv_nohugepage-to-enable-qemu-postcopy-on-s390.patch


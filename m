From: akpm@linux-foundation.org
Subject: + userfaultfd-introduce-vma_can_userfault.patch added to -mm tree
Date: Wed, 04 Jan 2017 16:54:16 -0800
Message-ID: <586d9938.AODaYpQSSQ8+cGld%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36188 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937489AbdAEAyW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 19:54:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: introduce vma_can_userfault
has been added to the -mm tree.  Its filename is
     userfaultfd-introduce-vma_can_userfault.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-introduce-vma_can_userfault.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-introduce-vma_can_userfault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: introduce vma_can_userfault

Check whether a VMA can be used with userfault in more compact way

Link: http://lkml.kernel.org/r/20161216144821.5183-28-aarcange@redhat.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-introduce-vma_can_userfault fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-introduce-vma_can_userfault
+++ a/fs/userfaultfd.c
@@ -1063,6 +1063,11 @@ static __always_inline int validate_rang
 	return 0;
 }
 
+static inline bool vma_can_userfault(struct vm_area_struct *vma)
+{
+	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma);
+}
+
 static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 				unsigned long arg)
 {
@@ -1152,7 +1157,7 @@ static int userfaultfd_register(struct u
 
 		/* check not compatible vmas */
 		ret = -EINVAL;
-		if (!vma_is_anonymous(cur) && !is_vm_hugetlb_page(cur))
+		if (!vma_can_userfault(cur))
 			goto out_unlock;
 		/*
 		 * If this vma contains ending address, and huge pages
@@ -1196,7 +1201,7 @@ static int userfaultfd_register(struct u
 	do {
 		cond_resched();
 
-		BUG_ON(!vma_is_anonymous(vma) && !is_vm_hugetlb_page(vma));
+		BUG_ON(!vma_can_userfault(vma));
 		BUG_ON(vma->vm_userfaultfd_ctx.ctx &&
 		       vma->vm_userfaultfd_ctx.ctx != ctx);
 
@@ -1334,7 +1339,7 @@ static int userfaultfd_unregister(struct
 		 * provides for more strict behavior to notice
 		 * unregistration errors.
 		 */
-		if (!vma_is_anonymous(cur) && !is_vm_hugetlb_page(cur))
+		if (!vma_can_userfault(cur))
 			goto out_unlock;
 
 		found = true;
@@ -1348,7 +1353,7 @@ static int userfaultfd_unregister(struct
 	do {
 		cond_resched();
 
-		BUG_ON(!vma_is_anonymous(vma) && !is_vm_hugetlb_page(vma));
+		BUG_ON(!vma_can_userfault(vma));
 
 		/*
 		 * Nothing to do: this vma is already registered into this
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are

userfaultfd-non-cooperative-dup_userfaultfd-use-mm_count-instead-of-mm_users.patch
userfaultfd-introduce-vma_can_userfault.patch
userfaultfd-shmem-add-shmem_mcopy_atomic_pte-for-userfaultfd-support.patch
userfaultfd-shmem-introduce-vma_is_shmem.patch
userfaultfd-shmem-use-shmem_mcopy_atomic_pte-for-shared-memory.patch
userfaultfd-shmem-add-userfaultfd-hook-for-shared-memory-faults.patch
userfaultfd-shmem-allow-registration-of-shared-memory-ranges.patch
userfaultfd-shmem-add-userfaultfd_shmem-test.patch
userfaultfd-non-cooperative-selftest-introduce-userfaultfd_open.patch
userfaultfd-non-cooperative-selftest-add-ufd-parameter-to-copy_page.patch
userfaultfd-non-cooperative-selftest-add-test-for-fork-madvdontneed-and-remap-events.patch


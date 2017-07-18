From: akpm@linux-foundation.org
Subject: +
 userfaultfd-non-cooperative-notify-about-unmap-of-destination-during-mremap.patch added to -mm tree
Date: Tue, 18 Jul 2017 16:52:27 -0700
Message-ID: <596e9f3b.UFfOGa76LteyPKYD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34028 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752447AbdGRXw2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Jul 2017 19:52:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, aarcange@redhat.com, stable@vger.kernel.org, xemul@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: non-cooperative: notify about unmap of destination during mremap
has been added to the -mm tree.  Its filename is
     userfaultfd-non-cooperative-notify-about-unmap-of-destination-during-mremap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-non-cooperative-notify-about-unmap-of-destination-during-mremap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-non-cooperative-notify-about-unmap-of-destination-during-mremap.patch

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
Subject: userfaultfd: non-cooperative: notify about unmap of destination during mremap

When mremap is called with MREMAP_FIXED it unmaps memory at the
destination address without notifying userfaultfd monitor.  If the
destination were registered with userfaultfd, the monitor has no way to
distinguish between the old and new ranges and to properly relate the page
faults that would occur in the destination region.

Fixes: 897ab3e0c49e ("userfaultfd: non-cooperative: add event for memory unmaps")
Link: http://lkml.kernel.org/r/1500276876-3350-1-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Acked-by: Pavel Emelyanov <xemul@virtuozzo.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/mremap.c~userfaultfd-non-cooperative-notify-about-unmap-of-destination-during-mremap mm/mremap.c
--- a/mm/mremap.c~userfaultfd-non-cooperative-notify-about-unmap-of-destination-during-mremap
+++ a/mm/mremap.c
@@ -429,6 +429,7 @@ static struct vm_area_struct *vma_to_res
 static unsigned long mremap_to(unsigned long addr, unsigned long old_len,
 		unsigned long new_addr, unsigned long new_len, bool *locked,
 		struct vm_userfaultfd_ctx *uf,
+		struct list_head *uf_unmap_early,
 		struct list_head *uf_unmap)
 {
 	struct mm_struct *mm = current->mm;
@@ -447,7 +448,7 @@ static unsigned long mremap_to(unsigned
 	if (addr + old_len > new_addr && new_addr + new_len > addr)
 		goto out;
 
-	ret = do_munmap(mm, new_addr, new_len, NULL);
+	ret = do_munmap(mm, new_addr, new_len, uf_unmap_early);
 	if (ret)
 		goto out;
 
@@ -515,6 +516,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	unsigned long charged = 0;
 	bool locked = false;
 	struct vm_userfaultfd_ctx uf = NULL_VM_UFFD_CTX;
+	LIST_HEAD(uf_unmap_early);
 	LIST_HEAD(uf_unmap);
 
 	if (flags & ~(MREMAP_FIXED | MREMAP_MAYMOVE))
@@ -542,7 +544,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 
 	if (flags & MREMAP_FIXED) {
 		ret = mremap_to(addr, old_len, new_addr, new_len,
-				&locked, &uf, &uf_unmap);
+				&locked, &uf, &uf_unmap_early, &uf_unmap);
 		goto out;
 	}
 
@@ -622,6 +624,7 @@ out:
 	up_write(&current->mm->mmap_sem);
 	if (locked && new_len > old_len)
 		mm_populate(new_addr + old_len, new_len - old_len);
+	userfaultfd_unmap_complete(mm, &uf_unmap_early);
 	mremap_userfaultfd_complete(&uf, addr, new_addr, old_len);
 	userfaultfd_unmap_complete(mm, &uf_unmap);
 	return ret;
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are

userfaultfd-non-cooperative-notify-about-unmap-of-destination-during-mremap.patch


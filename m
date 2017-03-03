From: akpm@linux-foundation.org
Subject: +
 userfaultfd-non-cooperative-userfaultfd_remove-revalidate-vma-in-madv_dontneed.patch added to -mm tree
Date: Fri, 03 Mar 2017 14:17:33 -0800
Message-ID: <58b9eb7d.H7tPo2CzC7kttkX2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42124 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752004AbdCCWkz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 17:40:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: non-cooperative: userfaultfd_remove revalidate vma in MADV_DONTNEED
has been added to the -mm tree.  Its filename is
     userfaultfd-non-cooperative-userfaultfd_remove-revalidate-vma-in-madv_dontneed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-non-cooperative-userfaultfd_remove-revalidate-vma-in-madv_dontneed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-non-cooperative-userfaultfd_remove-revalidate-vma-in-madv_dontneed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: non-cooperative: userfaultfd_remove revalidate vma in MADV_DONTNEED

userfaultfd_remove() has to be execute before zapping the pagetables or
UFFDIO_COPY could keep filling pages after zap_page_range returned,
which would result in non zero data after a MADV_DONTNEED.

However userfaultfd_remove() may have to release the mmap_sem. This
was handled correctly in MADV_REMOVE, but MADV_DONTNEED accessed a
potentially stale vma (the very vma passed to zap_page_range(vma, ...)).

The fix consists in revalidating the vma in case userfaultfd_remove()
had to release the mmap_sem.

This also optimizes away an unnecessary down_read/up_read in the
MADV_REMOVE case if UFFD_EVENT_FORK had to be delivered.

It all remains zero runtime cost in case CONFIG_USERFAULTFD=n as
userfaultfd_remove() will be defined as "true" at build time.

Link: http://lkml.kernel.org/r/20170302173738.18994-3-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c              |    9 ++----
 include/linux/userfaultfd_k.h |    7 ++---
 mm/madvise.c                  |   44 +++++++++++++++++++++++++++++---
 3 files changed, 47 insertions(+), 13 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-non-cooperative-userfaultfd_remove-revalidate-vma-in-madv_dontneed fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-non-cooperative-userfaultfd_remove-revalidate-vma-in-madv_dontneed
+++ a/fs/userfaultfd.c
@@ -695,8 +695,7 @@ void mremap_userfaultfd_complete(struct
 	userfaultfd_event_wait_completion(ctx, &ewq);
 }
 
-void userfaultfd_remove(struct vm_area_struct *vma,
-			struct vm_area_struct **prev,
+bool userfaultfd_remove(struct vm_area_struct *vma,
 			unsigned long start, unsigned long end)
 {
 	struct mm_struct *mm = vma->vm_mm;
@@ -705,13 +704,11 @@ void userfaultfd_remove(struct vm_area_s
 
 	ctx = vma->vm_userfaultfd_ctx.ctx;
 	if (!ctx || !(ctx->features & UFFD_FEATURE_EVENT_REMOVE))
-		return;
+		return true;
 
 	userfaultfd_ctx_get(ctx);
 	up_read(&mm->mmap_sem);
 
-	*prev = NULL; /* We wait for ACK w/o the mmap semaphore */
-
 	msg_init(&ewq.msg);
 
 	ewq.msg.event = UFFD_EVENT_REMOVE;
@@ -720,7 +717,7 @@ void userfaultfd_remove(struct vm_area_s
 
 	userfaultfd_event_wait_completion(ctx, &ewq);
 
-	down_read(&mm->mmap_sem);
+	return false;
 }
 
 static bool has_unmap_ctx(struct userfaultfd_ctx *ctx, struct list_head *unmaps,
diff -puN include/linux/userfaultfd_k.h~userfaultfd-non-cooperative-userfaultfd_remove-revalidate-vma-in-madv_dontneed include/linux/userfaultfd_k.h
--- a/include/linux/userfaultfd_k.h~userfaultfd-non-cooperative-userfaultfd_remove-revalidate-vma-in-madv_dontneed
+++ a/include/linux/userfaultfd_k.h
@@ -61,8 +61,7 @@ extern void mremap_userfaultfd_complete(
 					unsigned long from, unsigned long to,
 					unsigned long len);
 
-extern void userfaultfd_remove(struct vm_area_struct *vma,
-			       struct vm_area_struct **prev,
+extern bool userfaultfd_remove(struct vm_area_struct *vma,
 			       unsigned long start,
 			       unsigned long end);
 
@@ -118,11 +117,11 @@ static inline void mremap_userfaultfd_co
 {
 }
 
-static inline void userfaultfd_remove(struct vm_area_struct *vma,
-				      struct vm_area_struct **prev,
+static inline bool userfaultfd_remove(struct vm_area_struct *vma,
 				      unsigned long start,
 				      unsigned long end)
 {
+	return true;
 }
 
 static inline int userfaultfd_unmap_prep(struct vm_area_struct *vma,
diff -puN mm/madvise.c~userfaultfd-non-cooperative-userfaultfd_remove-revalidate-vma-in-madv_dontneed mm/madvise.c
--- a/mm/madvise.c~userfaultfd-non-cooperative-userfaultfd_remove-revalidate-vma-in-madv_dontneed
+++ a/mm/madvise.c
@@ -513,7 +513,43 @@ static long madvise_dontneed(struct vm_a
 	if (!can_madv_dontneed_vma(vma))
 		return -EINVAL;
 
-	userfaultfd_remove(vma, prev, start, end);
+	if (!userfaultfd_remove(vma, start, end)) {
+		*prev = NULL; /* mmap_sem has been dropped, prev is stale */
+
+		down_read(&current->mm->mmap_sem);
+		vma = find_vma(current->mm, start);
+		if (!vma)
+			return -ENOMEM;
+		if (start < vma->vm_start) {
+			/*
+			 * This "vma" under revalidation is the one
+			 * with the lowest vma->vm_start where start
+			 * is also < vma->vm_end. If start <
+			 * vma->vm_start it means an hole materialized
+			 * in the user address space within the
+			 * virtual range passed to MADV_DONTNEED.
+			 */
+			return -ENOMEM;
+		}
+		if (!can_madv_dontneed_vma(vma))
+			return -EINVAL;
+		if (end > vma->vm_end) {
+			/*
+			 * Don't fail if end > vma->vm_end. If the old
+			 * vma was splitted while the mmap_sem was
+			 * released the effect of the concurrent
+			 * operation may not cause MADV_DONTNEED to
+			 * have an undefined result. There may be an
+			 * adjacent next vma that we'll walk
+			 * next. userfaultfd_remove() will generate an
+			 * UFFD_EVENT_REMOVE repetition on the
+			 * end-vma->vm_end range, but the manager can
+			 * handle a repetition fine.
+			 */
+			end = vma->vm_end;
+		}
+		VM_WARN_ON(start >= end);
+	}
 	zap_page_range(vma, start, end - start);
 	return 0;
 }
@@ -554,8 +590,10 @@ static long madvise_remove(struct vm_are
 	 * mmap_sem.
 	 */
 	get_file(f);
-	userfaultfd_remove(vma, prev, start, end);
-	up_read(&current->mm->mmap_sem);
+	if (userfaultfd_remove(vma, start, end)) {
+		/* mmap_sem was not released by userfaultfd_remove() */
+		up_read(&current->mm->mmap_sem);
+	}
 	error = vfs_fallocate(f,
 				FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
 				offset, end - start);
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-shmem-__do_fault-requires-vm_fault_nopage.patch
userfaultfd-non-cooperative-rollback-userfaultfd_exit.patch
userfaultfd-non-cooperative-robustness-check.patch
userfaultfd-non-cooperative-release-all-ctx-in-dup_userfaultfd_complete.patch
userfaultfd-non-cooperative-userfaultfd_remove-revalidate-vma-in-madv_dontneed.patch
userfaultfd-selftest-vm-allow-to-build-in-vm-directory.patch


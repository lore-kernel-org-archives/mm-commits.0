From: akpm@linux-foundation.org
Subject: [merged] mm-gup-use-get_user_pages_unlocked.patch removed from
 -mm tree
Date: Thu, 12 Feb 2015 11:38:00 -0800
Message-ID: <54dd0118.s7ypR0J5xllROeQ6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58380 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbbBLTiB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:38:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, andreslc@google.com, kirill.shutemov@linux.intel.com, pfeiner@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: gup: use get_user_pages_unlocked
has been removed from the -mm tree.  Its filename was
     mm-gup-use-get_user_pages_unlocked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: gup: use get_user_pages_unlocked

This allows those get_user_pages calls to pass FAULT_FLAG_ALLOW_RETRY to
the page fault in order to release the mmap_sem during the I/O.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Peter Feiner <pfeiner@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/pci/ivtv/ivtv-udma.c |    6 ++----
 drivers/scsi/st.c                  |    7 ++-----
 drivers/video/fbdev/pvr2fb.c       |    6 ++----
 mm/process_vm_access.c             |    7 ++-----
 net/ceph/pagevec.c                 |    6 ++----
 5 files changed, 10 insertions(+), 22 deletions(-)

diff -puN drivers/media/pci/ivtv/ivtv-udma.c~mm-gup-use-get_user_pages_unlocked drivers/media/pci/ivtv/ivtv-udma.c
--- a/drivers/media/pci/ivtv/ivtv-udma.c~mm-gup-use-get_user_pages_unlocked
+++ a/drivers/media/pci/ivtv/ivtv-udma.c
@@ -124,10 +124,8 @@ int ivtv_udma_setup(struct ivtv *itv, un
 	}
 
 	/* Get user pages for DMA Xfer */
-	down_read(&current->mm->mmap_sem);
-	err = get_user_pages(current, current->mm,
-			user_dma.uaddr, user_dma.page_count, 0, 1, dma->map, NULL);
-	up_read(&current->mm->mmap_sem);
+	err = get_user_pages_unlocked(current, current->mm,
+			user_dma.uaddr, user_dma.page_count, 0, 1, dma->map);
 
 	if (user_dma.page_count != err) {
 		IVTV_DEBUG_WARN("failed to map user pages, returned %d instead of %d\n",
diff -puN drivers/scsi/st.c~mm-gup-use-get_user_pages_unlocked drivers/scsi/st.c
--- a/drivers/scsi/st.c~mm-gup-use-get_user_pages_unlocked
+++ a/drivers/scsi/st.c
@@ -4551,18 +4551,15 @@ static int sgl_map_user_pages(struct st_
 		return -ENOMEM;
 
         /* Try to fault in all of the necessary pages */
-	down_read(&current->mm->mmap_sem);
         /* rw==READ means read from drive, write into memory area */
-	res = get_user_pages(
+	res = get_user_pages_unlocked(
 		current,
 		current->mm,
 		uaddr,
 		nr_pages,
 		rw == READ,
 		0, /* don't force */
-		pages,
-		NULL);
-	up_read(&current->mm->mmap_sem);
+		pages);
 
 	/* Errors and no page mapped should return here */
 	if (res < nr_pages)
diff -puN drivers/video/fbdev/pvr2fb.c~mm-gup-use-get_user_pages_unlocked drivers/video/fbdev/pvr2fb.c
--- a/drivers/video/fbdev/pvr2fb.c~mm-gup-use-get_user_pages_unlocked
+++ a/drivers/video/fbdev/pvr2fb.c
@@ -686,10 +686,8 @@ static ssize_t pvr2fb_write(struct fb_in
 	if (!pages)
 		return -ENOMEM;
 
-	down_read(&current->mm->mmap_sem);
-	ret = get_user_pages(current, current->mm, (unsigned long)buf,
-			     nr_pages, WRITE, 0, pages, NULL);
-	up_read(&current->mm->mmap_sem);
+	ret = get_user_pages_unlocked(current, current->mm, (unsigned long)buf,
+				      nr_pages, WRITE, 0, pages);
 
 	if (ret < nr_pages) {
 		nr_pages = ret;
diff -puN mm/process_vm_access.c~mm-gup-use-get_user_pages_unlocked mm/process_vm_access.c
--- a/mm/process_vm_access.c~mm-gup-use-get_user_pages_unlocked
+++ a/mm/process_vm_access.c
@@ -99,11 +99,8 @@ static int process_vm_rw_single_vec(unsi
 		size_t bytes;
 
 		/* Get the pages we're interested in */
-		down_read(&mm->mmap_sem);
-		pages = get_user_pages(task, mm, pa, pages,
-				      vm_write, 0, process_pages, NULL);
-		up_read(&mm->mmap_sem);
-
+		pages = get_user_pages_unlocked(task, mm, pa, pages,
+						vm_write, 0, process_pages);
 		if (pages <= 0)
 			return -EFAULT;
 
diff -puN net/ceph/pagevec.c~mm-gup-use-get_user_pages_unlocked net/ceph/pagevec.c
--- a/net/ceph/pagevec.c~mm-gup-use-get_user_pages_unlocked
+++ a/net/ceph/pagevec.c
@@ -23,17 +23,15 @@ struct page **ceph_get_direct_page_vecto
 	if (!pages)
 		return ERR_PTR(-ENOMEM);
 
-	down_read(&current->mm->mmap_sem);
 	while (got < num_pages) {
-		rc = get_user_pages(current, current->mm,
+		rc = get_user_pages_unlocked(current, current->mm,
 		    (unsigned long)data + ((unsigned long)got * PAGE_SIZE),
-		    num_pages - got, write_page, 0, pages + got, NULL);
+		    num_pages - got, write_page, 0, pages + got);
 		if (rc < 0)
 			break;
 		BUG_ON(rc == 0);
 		got += rc;
 	}
-	up_read(&current->mm->mmap_sem);
 	if (rc < 0)
 		goto fail;
 	return pages;
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
linux-next.patch


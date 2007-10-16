From: akpm@linux-foundation.org
Subject: - hugetlbfs-read-support-fix-2-fix.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:37:43 -0700
Message-ID: <200710160437.l9G4bhtK009124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42091 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754297AbXJPEjF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:39:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbadari@us.ibm.com, agl@us.ibm.com, bill.irwin@oracle.com, david@gibson.dropbear.id.au, kenchen@google.com, nacc@us.ibm.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     Fixes to hugetlbfs_read() support
has been removed from the -mm tree.  Its filename was
     hugetlbfs-read-support-fix-2-fix.patch

This patch was dropped because it was folded into hugetlbfs-read-support.patch

------------------------------------------------------
Subject: Fixes to hugetlbfs_read() support
From: Badari Pulavarty <pbadari@us.ibm.com>

Various fixes to hugetlbfs_read() support

- handle HOLES correcty
- clean up weird looking loop condition reported by Ken Chen
- integrated "not updating file offset after read" fix by Ken Chen
- holding i_mutex to prevent any unwanted interactions with truncate

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Cc: William Irwin <bill.irwin@oracle.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Acked-by: Ken Chen <kenchen@google.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/hugetlbfs/inode.c~hugetlbfs-read-support-fix-2-fix fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-read-support-fix-2-fix
+++ a/fs/hugetlbfs/inode.c
@@ -228,11 +228,13 @@ static ssize_t hugetlbfs_read(struct fil
 	struct address_space *mapping = filp->f_mapping;
 	struct inode *inode = mapping->host;
 	unsigned long index = *ppos >> HPAGE_SHIFT;
+	unsigned long offset = *ppos & ~HPAGE_MASK;
 	unsigned long end_index;
 	loff_t isize;
-	unsigned long offset;
 	ssize_t retval = 0;
 
+	mutex_lock(&inode->i_mutex);
+
 	/* validate length */
 	if (len == 0)
 		goto out;
@@ -241,7 +243,6 @@ static ssize_t hugetlbfs_read(struct fil
 	if (!isize)
 		goto out;
 
-	offset = *ppos & ~HPAGE_MASK;
 	end_index = (isize - 1) >> HPAGE_SHIFT;
 	for (;;) {
 		struct page *page;
@@ -263,18 +264,23 @@ static ssize_t hugetlbfs_read(struct fil
 		page = find_get_page(mapping, index);
 		if (unlikely(page == NULL)) {
 			/*
-			 * We can't find the page in the cache - bail out ?
+			 * We have a HOLE, zero out the user-buffer for the
+			 * length of the hole or request.
 			 */
-			goto out;
+			ret = len < nr ? len : nr;
+			if (clear_user(buf, ret))
+				ret = -EFAULT;
+		} else {
+			/*
+			 * We have the page, copy it to user space buffer.
+			 */
+			ret = hugetlbfs_read_actor(page, offset, buf, len, nr);
 		}
-		/*
-		 * Ok, we have the page, copy it to user space buffer.
-		 */
-		ret = hugetlbfs_read_actor(page, offset, buf, len, nr);
 		if (ret < 0) {
 			if (retval == 0)
 				retval = ret;
-			page_cache_release(page);
+			if (page)
+				page_cache_release(page);
 			goto out;
 		}
 
@@ -284,12 +290,16 @@ static ssize_t hugetlbfs_read(struct fil
 		index += offset >> HPAGE_SHIFT;
 		offset &= ~HPAGE_MASK;
 
-		page_cache_release(page);
-		if (ret == nr && len)
-			continue;
-		goto out;
+		if (page)
+			page_cache_release(page);
+
+		/* short read or no more work */
+		if ((ret != nr) || (len == 0))
+			break;
 	}
 out:
+	*ppos = ((loff_t)index << HPAGE_SHIFT) + offset;
+	mutex_unlock(&inode->i_mutex);
 	return retval;
 }
 
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

ppc64-sparsemem_vmemmap-support.patch
ext3-convert-to-new-aops.patch
ext4-convert-to-new-aops.patch
fs-restore-nobh.patch
memory-unplug-v7-memory-hotplug-cleanup.patch
hugetlb-move-update_and_free_page.patch
hugetlb-try-to-grow-hugetlb-pool-for-map_private-mappings.patch
hugetlb-try-to-grow-hugetlb-pool-for-map_shared-mappings.patch
hugetlb-add-hugetlb_dynamic_pool-sysctl.patch
hugetlbfs-read-support.patch
hugetlbfs-read-support-fix-2-fix.patch
hugetlb-fix-pool-resizing-corner-case-v2.patch
hugetlb-fix-hugepage-allocation-with-memoryless-nodes.patch
hugetlb-fix-dynamic-pool-resize-failure-case.patch
ext2-statfs-improvement-for-block-and-inode-free-count.patch
aio-account-i-o-wait-time-properly.patch
fix-for-ext2-reservation.patch
sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
mem-controller-gfp-mask-fix.patch
powerpc-add-scaled-time-accounting-speedup.patch

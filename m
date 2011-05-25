From: akpm@linux-foundation.org
Subject: [merged] mm-remove-last-trace-of-shmem_get_unmapped_area.patch removed from -mm tree
Date: Wed, 25 May 2011 13:30:13 -0700
Message-ID: <201105252028.p4PKSaPE014754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41815 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755404Ab1EYU3H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:29:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: remove last trace of shmem_get_unmapped_area
has been removed from the -mm tree.  Its filename was
     mm-remove-last-trace-of-shmem_get_unmapped_area.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove last trace of shmem_get_unmapped_area
From: Hugh Dickins <hughd@google.com>

Remove noMMU declaration of shmem_get_unmapped_area() from mm.h: it fell
out of use in 2.6.21 and ceased to exist in 2.6.29.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    8 --------
 1 file changed, 8 deletions(-)

diff -puN include/linux/mm.h~mm-remove-last-trace-of-shmem_get_unmapped_area include/linux/mm.h
--- a/include/linux/mm.h~mm-remove-last-trace-of-shmem_get_unmapped_area
+++ a/include/linux/mm.h
@@ -873,14 +873,6 @@ int shmem_lock(struct file *file, int lo
 struct file *shmem_file_setup(const char *name, loff_t size, unsigned long long vm_flags);
 int shmem_zero_setup(struct vm_area_struct *);
 
-#ifndef CONFIG_MMU
-extern unsigned long shmem_get_unmapped_area(struct file *file,
-					     unsigned long addr,
-					     unsigned long len,
-					     unsigned long pgoff,
-					     unsigned long flags);
-#endif

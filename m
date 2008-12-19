From: akpm@linux-foundation.org
Subject: - shmem-remove-unused-shmem_get_unmapped_area.patch removed from -mm tree
Date: Fri, 19 Dec 2008 12:04:46 -0800
Message-ID: <200812192004.mBJK4kIj010597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752470AbYLSUFV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Dec 2008 15:05:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, dhowells@redhat.com, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     shmem: remove unused shmem_get_unmapped_area
has been removed from the -mm tree.  Its filename was
     shmem-remove-unused-shmem_get_unmapped_area.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: shmem: remove unused shmem_get_unmapped_area
From: Matt Mackall <mpm@selenic.com>

Signed-off-by: Matt Mackall <mpm@selenic.com>
Acked-by: David Howells <dhowells@redhat.com>
Acked-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    8 --------
 mm/tiny-shmem.c    |   11 -----------
 2 files changed, 19 deletions(-)

diff -puN include/linux/mm.h~shmem-remove-unused-shmem_get_unmapped_area include/linux/mm.h
--- a/include/linux/mm.h~shmem-remove-unused-shmem_get_unmapped_area
+++ a/include/linux/mm.h
@@ -722,14 +722,6 @@ struct file *shmem_file_setup(char *name
 
 int shmem_zero_setup(struct vm_area_struct *);
 
-#ifndef CONFIG_MMU
-extern unsigned long shmem_get_unmapped_area(struct file *file,
-					     unsigned long addr,
-					     unsigned long len,
-					     unsigned long pgoff,
-					     unsigned long flags);
-#endif
-
 extern int can_do_mlock(void);
 extern int user_shm_lock(size_t, struct user_struct *);
 extern void user_shm_unlock(size_t, struct user_struct *);
diff -puN mm/tiny-shmem.c~shmem-remove-unused-shmem_get_unmapped_area mm/tiny-shmem.c
--- a/mm/tiny-shmem.c~shmem-remove-unused-shmem_get_unmapped_area
+++ a/mm/tiny-shmem.c
@@ -121,14 +121,3 @@ int shmem_unuse(swp_entry_t entry, struc
 {
 	return 0;
 }

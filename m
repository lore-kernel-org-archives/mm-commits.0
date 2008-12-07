From: akpm@linux-foundation.org
Subject: + shmem-remove-unused-shmem_get_unmapped_area.patch added to -mm tree
Date: Sun, 07 Dec 2008 00:08:15 -0800
Message-ID: <200812070808.mB788Ff1017819@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698AbYLGIJe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 7 Dec 2008 03:09:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com, dhowells@redhat.com, hugh@veritas.com


The patch titled
     shmem: remove unused shmem_get_unmapped_area
has been added to the -mm tree.  Its filename is
     shmem-remove-unused-shmem_get_unmapped_area.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

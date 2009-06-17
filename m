From: akpm@linux-foundation.org
Subject: [merged] mm-cleanup-shmem_file_setup-char-const-char-for-name-argument.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:36:12 -0700
Message-ID: <200906171836.n5HIaCHl002232@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760637AbZFQShH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:37:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: slyfox@inbox.ru, hugh.dickins@tiscali.co.uk, mm-commits@vger.kernel.org


The patch titled
     mm cleanup: shmem_file_setup: 'char *' -> 'const char *' for name argument
has been removed from the -mm tree.  Its filename was
     mm-cleanup-shmem_file_setup-char-const-char-for-name-argument.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm cleanup: shmem_file_setup: 'char *' -> 'const char *' for name argument
From: Sergei Trofimovich <slyfox@inbox.ru>

As function shmem_file_setup does not modify/allocate/free/pass given
filename - mark it as const.

Signed-off-by: Sergei Trofimovich <slyfox@inbox.ru>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 mm/shmem.c         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/mm.h~mm-cleanup-shmem_file_setup-char-const-char-for-name-argument include/linux/mm.h
--- a/include/linux/mm.h~mm-cleanup-shmem_file_setup-char-const-char-for-name-argument
+++ a/include/linux/mm.h
@@ -724,7 +724,7 @@ static inline int shmem_lock(struct file
 	return 0;
 }
 #endif
-struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags);
+struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags);
 
 int shmem_zero_setup(struct vm_area_struct *);
 
diff -puN mm/shmem.c~mm-cleanup-shmem_file_setup-char-const-char-for-name-argument mm/shmem.c
--- a/mm/shmem.c~mm-cleanup-shmem_file_setup-char-const-char-for-name-argument
+++ a/mm/shmem.c
@@ -2612,7 +2612,7 @@ int shmem_unuse(swp_entry_t entry, struc
  * @size: size to be set for the file
  * @flags: VM_NORESERVE suppresses pre-accounting of the entire object size
  */
-struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags)
+struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags)
 {
 	int error;
 	struct file *file;
_

Patches currently in -mm which might be from slyfox@inbox.ru are

origin.patch


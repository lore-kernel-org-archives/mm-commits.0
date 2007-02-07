From: akpm@linux-foundation.org
Subject: + define-the-shmem_inode_info-flags-directly.patch added to -mm tree
Date: Wed, 07 Feb 2007 15:31:42 -0800
Message-ID: <200702072331.l17NVgEM031177@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45390 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161321AbXBGXdd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 18:33:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agl@us.ibm.com, hugh@veritas.com


The patch titled
     Define the shmem_inode_info flags directly
has been added to the -mm tree.  Its filename is
     define-the-shmem_inode_info-flags-directly.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Define the shmem_inode_info flags directly
From: Adam Litke <agl@us.ibm.com>

Defining flags in terms of other flags is always confusing.  Give them
literal values instead of defining them in terms of VM_flags.  While we're
at it, move them to a header file in preparation for the introduction of a
SHMEM_HUGETLB flag.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    4 ++++
 mm/shmem.c               |    4 ----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/shmem_fs.h~define-the-shmem_inode_info-flags-directly include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~define-the-shmem_inode_info-flags-directly
+++ a/include/linux/shmem_fs.h
@@ -8,6 +8,10 @@
 
 #define SHMEM_NR_DIRECT 16
 
+/* These info->flags are used to handle pagein/truncate races efficiently */
+#define SHMEM_PAGEIN	0x00000001
+#define SHMEM_TRUNCATE	0x00000002
+
 struct shmem_inode_info {
 	spinlock_t		lock;
 	unsigned long		flags;
diff -puN mm/shmem.c~define-the-shmem_inode_info-flags-directly mm/shmem.c
--- a/mm/shmem.c~define-the-shmem_inode_info-flags-directly
+++ a/mm/shmem.c
@@ -66,10 +66,6 @@
 
 #define VM_ACCT(size)    (PAGE_CACHE_ALIGN(size) >> PAGE_SHIFT)
 
-/* info->flags needs VM_flags to handle pagein/truncate races efficiently */
-#define SHMEM_PAGEIN	 VM_READ
-#define SHMEM_TRUNCATE	 VM_WRITE
-
 /* Definition to limit shmem_truncate's steps between cond_rescheds */
 #define LATENCY_LIMIT	 64
 
_

Patches currently in -mm which might be from agl@us.ibm.com are

hugetlb-preserve-hugetlb-pte-dirty-state.patch
define-the-shmem_inode_info-flags-directly.patch

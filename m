From: akpm@linux-foundation.org
Subject: + shmem-respect-max_lfs_filesize.patch added to -mm tree
Date: Thu, 09 Apr 2009 16:36:21 -0700
Message-ID: <200904092336.n39NaLuo025263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40444 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937376AbZDIXjd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 19:39:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, paulus@samba.org, yur@emcraft.com


The patch titled
     shmem: respect MAX_LFS_FILESIZE
has been added to the -mm tree.  Its filename is
     shmem-respect-max_lfs_filesize.patch

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
Subject: shmem: respect MAX_LFS_FILESIZE
From: Hugh Dickins <hugh@veritas.com>

SHMEM_MAX_BYTES was derived from the maximum size of its triple-indirect
swap vector, forgetting to take the MAX_LFS_FILESIZE limit into account. 
Never mind 256kB pages, even 8kB pages on 32-bit kernels allowed files to
grow slightly bigger than that supposed maximum.

Fix this by using the min of both (at build time not run time).  And it
happens that this calculation is good as far as 8MB pages on 32-bit or
16MB pages on 64-bit: though SHMSWP_MAX_INDEX gets truncated before that,
it's truncated to such large numbers that we don't need to care.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Yuri Tikhonov <yur@emcraft.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff -puN mm/shmem.c~shmem-respect-max_lfs_filesize mm/shmem.c
--- a/mm/shmem.c~shmem-respect-max_lfs_filesize
+++ a/mm/shmem.c
@@ -65,13 +65,28 @@ static struct vfsmount *shm_mnt;
 #include <asm/div64.h>
 #include <asm/pgtable.h>
 
+/*
+ * The maximum size of a shmem/tmpfs file is limited by the maximum size of
+ * its triple-indirect swap vector - see illustration at shmem_swp_entry().
+ *
+ * With 4kB page size, maximum file size is just over 2TB on a 32-bit kernel,
+ * but one eighth of that on a 64-bit kernel.  With 8kB page size, maximum
+ * file size is just over 4TB on a 64-bit kernel, but 16TB on a 32-bit kernel,
+ * MAX_LFS_FILESIZE being then more restrictive than swap vector layout.
+ *
+ * We use / and * instead of shifts in the definitions below, so that the swap
+ * vector can be tested with small even values (e.g. 20) for ENTRIES_PER_PAGE.
+ */
 #define ENTRIES_PER_PAGE (PAGE_CACHE_SIZE/sizeof(unsigned long))
 #define ENTRIES_PER_PAGEPAGE ((unsigned long long)ENTRIES_PER_PAGE*ENTRIES_PER_PAGE)
-#define BLOCKS_PER_PAGE  (PAGE_CACHE_SIZE/512)
 
-#define SHMEM_MAX_INDEX  (SHMEM_NR_DIRECT + (ENTRIES_PER_PAGEPAGE/2) * (ENTRIES_PER_PAGE+1))
-#define SHMEM_MAX_BYTES  ((unsigned long long)SHMEM_MAX_INDEX << PAGE_CACHE_SHIFT)
+#define SHMSWP_MAX_INDEX (SHMEM_NR_DIRECT + (ENTRIES_PER_PAGEPAGE/2) * (ENTRIES_PER_PAGE+1))
+#define SHMSWP_MAX_BYTES (SHMSWP_MAX_INDEX << PAGE_CACHE_SHIFT)
+
+#define SHMEM_MAX_BYTES  min(SHMSWP_MAX_BYTES, (unsigned long long)MAX_LFS_FILESIZE)
+#define SHMEM_MAX_INDEX  ((unsigned long)((SHMEM_MAX_BYTES+1) >> PAGE_CACHE_SHIFT))
 
+#define BLOCKS_PER_PAGE  (PAGE_CACHE_SIZE/512)
 #define VM_ACCT(size)    (PAGE_CACHE_ALIGN(size) >> PAGE_SHIFT)
 
 /* info->flags needs VM_flags to handle pagein/truncate races efficiently */
@@ -2581,7 +2596,7 @@ int shmem_unuse(swp_entry_t entry, struc
 #define shmem_get_inode(sb, mode, dev, flags)	ramfs_get_inode(sb, mode, dev)
 #define shmem_acct_size(flags, size)		0
 #define shmem_unacct_size(flags, size)		do {} while (0)
-#define SHMEM_MAX_BYTES				LLONG_MAX
+#define SHMEM_MAX_BYTES				MAX_LFS_FILESIZE
 
 #endif /* CONFIG_SHMEM */
 
_

Patches currently in -mm which might be from hugh@veritas.com are

clocksource-pass-clocksource-to-read-callback.patch
mm-disable-preemption-in-apply_to_pte_range.patch
shmem-fix-division-by-zero.patch
shmem-respect-max_lfs_filesize.patch
powerpc-allow-256kb-pages-with-shmem.patch
mm-update_page_reclaim_stat-is-called-from-page-fault-path.patch
getrusage-fill-ru_maxrss-value.patch
prio_tree-debugging-patch.patch


From: akpm@linux-foundation.org
Subject: [merged] shmem-respect-max_lfs_filesize.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:50:00 -0700
Message-ID: <200904141950.n3EJo0FI019916@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752709AbZDNTyi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:54:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, paulus@samba.org, randy.dunlap@oracle.com, yur@emcraft.com, mm-commits@vger.kernel.org


The patch titled
     shmem: respect MAX_LFS_FILESIZE
has been removed from the -mm tree.  Its filename was
     shmem-respect-max_lfs_filesize.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: it needs pagemap.h]
[akpm@linux-foundation.org: fix sparc64 min() warnings]
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Yuri Tikhonov <yur@emcraft.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff -puN mm/shmem.c~shmem-respect-max_lfs_filesize mm/shmem.c
--- a/mm/shmem.c~shmem-respect-max_lfs_filesize
+++ a/mm/shmem.c
@@ -24,6 +24,7 @@
 #include <linux/init.h>
 #include <linux/vfs.h>
 #include <linux/mount.h>
+#include <linux/pagemap.h>
 #include <linux/file.h>
 #include <linux/mm.h>
 #include <linux/module.h>
@@ -43,7 +44,6 @@ static struct vfsmount *shm_mnt;
 #include <linux/exportfs.h>
 #include <linux/generic_acl.h>
 #include <linux/mman.h>
-#include <linux/pagemap.h>
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/backing-dev.h>
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
 
+#define SHMEM_MAX_BYTES  min_t(unsigned long long, SHMSWP_MAX_BYTES, MAX_LFS_FILESIZE)
+#define SHMEM_MAX_INDEX  ((unsigned long)((SHMEM_MAX_BYTES+1) >> PAGE_CACHE_SHIFT))
+
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

origin.patch
clocksource-pass-clocksource-to-read-callback.patch
mm-disable-preemption-in-apply_to_pte_range.patch
powerpc-allow-256kb-pages-with-shmem.patch
getrusage-fill-ru_maxrss-value.patch
prio_tree-debugging-patch.patch


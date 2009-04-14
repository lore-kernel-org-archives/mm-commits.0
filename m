From: akpm@linux-foundation.org
Subject: [merged] shmem-fix-division-by-zero.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:49:56 -0700
Message-ID: <200904141949.n3EJnuBN019910@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751503AbZDNTxZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:53:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yur@emcraft.com, hugh@veritas.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     shmem: fix division by zero
has been removed from the -mm tree.  Its filename was
     shmem-fix-division-by-zero.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: shmem: fix division by zero
From: Yuri Tikhonov <yur@emcraft.com>

Fix a division by zero which we have in shmem_truncate_range() and
shmem_unuse_inode() when using big PAGE_SIZE values (e.g.  256kB on
ppc44x).

With 256kB PAGE_SIZE, the ENTRIES_PER_PAGEPAGE constant becomes too large
(0x1.0000.0000) on a 32-bit kernel, so this patch just changes its type
from 'unsigned long' to 'unsigned long long'.

Hugh: reverted its unsigned long longs in shmem_truncate_range() and
shmem_getpage(): the pagecache index cannot be more than an unsigned long,
so the divisions by zero occurred in unreached code.  It's a pity we need
any ULL arithmetic here, but I found no pretty way to avoid it.

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/shmem.c~shmem-fix-division-by-zero mm/shmem.c
--- a/mm/shmem.c~shmem-fix-division-by-zero
+++ a/mm/shmem.c
@@ -66,7 +66,7 @@ static struct vfsmount *shm_mnt;
 #include <asm/pgtable.h>
 
 #define ENTRIES_PER_PAGE (PAGE_CACHE_SIZE/sizeof(unsigned long))
-#define ENTRIES_PER_PAGEPAGE (ENTRIES_PER_PAGE*ENTRIES_PER_PAGE)
+#define ENTRIES_PER_PAGEPAGE ((unsigned long long)ENTRIES_PER_PAGE*ENTRIES_PER_PAGE)
 #define BLOCKS_PER_PAGE  (PAGE_CACHE_SIZE/512)
 
 #define SHMEM_MAX_INDEX  (SHMEM_NR_DIRECT + (ENTRIES_PER_PAGEPAGE/2) * (ENTRIES_PER_PAGE+1))
_

Patches currently in -mm which might be from yur@emcraft.com are

origin.patch
powerpc-allow-256kb-pages-with-shmem.patch


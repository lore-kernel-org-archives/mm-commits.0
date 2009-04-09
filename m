From: akpm@linux-foundation.org
Subject: + shmem-fix-division-by-zero.patch added to -mm tree
Date: Thu, 09 Apr 2009 16:36:19 -0700
Message-ID: <200904092336.n39NaJ6R025260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35330 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937376AbZDIXjb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 19:39:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yur@emcraft.com, hugh@veritas.com, paulus@samba.org


The patch titled
     shmem: fix division by zero
has been added to the -mm tree.  Its filename is
     shmem-fix-division-by-zero.patch

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

shmem-fix-division-by-zero.patch
shmem-respect-max_lfs_filesize.patch
powerpc-allow-256kb-pages-with-shmem.patch


From: akpm@linux-foundation.org
Subject: - tmpfs-fix-mounts-when-size-is-less-than-the-page-size.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:30:22 -0800
Message-ID: <200802052230.m15MU3le012031@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34447 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932228AbYBEWnD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike@marineau.org, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     tmpfs: fix mounts when size is less than the page size
has been removed from the -mm tree.  Its filename was
     tmpfs-fix-mounts-when-size-is-less-than-the-page-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmpfs: fix mounts when size is less than the page size
From: Michael Marineau <mike@marineau.org>

When tmpfs is mounted with a size less than one page, the number of blocks
is set to 0 which makes the tmpfs mount unlimited.  This can lead to a
quick and surprising death if someone typos a tmpfs mount command and
writes too much.

tmpfs can still be mounted as unlimited if size or nr_blocks is exactly 0,
as Documentation/filesystems/tmpfs.txt says.

Hugh: do this by rounding size up instead of down in all cases: which
slightly expands other odd-sized tmpfs mounts, but in a consistent way.

Signed-off-by: Michael Marineau <mike@marineau.org>
Signed-off-by: Hugh Dickins <hugh@veritas.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/shmem.c~tmpfs-fix-mounts-when-size-is-less-than-the-page-size mm/shmem.c
--- a/mm/shmem.c~tmpfs-fix-mounts-when-size-is-less-than-the-page-size
+++ a/mm/shmem.c
@@ -2012,7 +2012,7 @@ static int shmem_parse_options(char *opt
 			}
 			if (*rest)
 				goto bad_val;
-			*blocks = size >> PAGE_CACHE_SHIFT;
+			*blocks = DIV_ROUND_UP(size, PAGE_CACHE_SIZE);
 		} else if (!strcmp(this_char,"nr_blocks")) {
 			*blocks = memparse(value,&rest);
 			if (*rest)
_

Patches currently in -mm which might be from mike@marineau.org are

origin.patch

From: akpm@linux-foundation.org
Subject: + tmpfs-fix-mounts-when-size-is-less-than-the-page-size.patch added to -mm tree
Date: Mon, 05 Nov 2007 16:09:08 -0800
Message-ID: <200711060009.lA60981u026854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36164 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753715AbXKFAJP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 19:09:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike@marineau.org, hugh@veritas.com


The patch titled
     tmpfs: fix mounts when size is less than the page size
has been added to the -mm tree.  Its filename is
     tmpfs-fix-mounts-when-size-is-less-than-the-page-size.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

tmpfs-fix-mounts-when-size-is-less-than-the-page-size.patch

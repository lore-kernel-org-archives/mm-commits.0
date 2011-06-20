From: akpm@linux-foundation.org
Subject: + romfs-fix-romfs_get_unmapped_area-param-check.patch added to -mm tree
Date: Mon, 20 Jun 2011 16:09:17 -0700
Message-ID: <201106202309.p5KN9Hwa028827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756113Ab1FTXL3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jun 2011 19:11:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lliubbo@gmail.com, dhowells@redhat.com, geert@linux-m68k.org, gerg@snapgear.com, lethal@linux-sh.org


The patch titled
     romfs: fix romfs_get_unmapped_area() argument check
has been added to the -mm tree.  Its filename is
     romfs-fix-romfs_get_unmapped_area-param-check.patch

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
Subject: romfs: fix romfs_get_unmapped_area() argument check
From: Bob Liu <lliubbo@gmail.com>

romfs_get_unmapped_area() checks argument `len' without considering
PAGE_ALIGN which will cause do_mmap_pgoff() return -EINVAL error after
commit f67d9b1576c ("nommu: add page_align to mmap").

Fix the check by changing it in same way ramfs_nommu_get_unmapped_area()
was changed in ramfs/file-nommu.c.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Greg Ungerer <gerg@snapgear.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/romfs/mmap-nommu.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN fs/romfs/mmap-nommu.c~romfs-fix-romfs_get_unmapped_area-param-check fs/romfs/mmap-nommu.c
--- a/fs/romfs/mmap-nommu.c~romfs-fix-romfs_get_unmapped_area-param-check
+++ a/fs/romfs/mmap-nommu.c
@@ -27,14 +27,18 @@ static unsigned long romfs_get_unmapped_
 {
 	struct inode *inode = file->f_mapping->host;
 	struct mtd_info *mtd = inode->i_sb->s_mtd;
-	unsigned long isize, offset;
+	unsigned long isize, offset, maxpages, lpages;
 
 	if (!mtd)
 		goto cant_map_directly;
 
+	/* the mapping mustn't extend beyond the EOF */
+	lpages = (len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	isize = i_size_read(inode);
 	offset = pgoff << PAGE_SHIFT;
-	if (offset > isize || len > isize || offset > isize - len)
+
+	maxpages = (isize + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if ((pgoff >= maxpages) || (maxpages - pgoff < lpages))
 		return (unsigned long) -EINVAL;
 
 	/* we need to call down to the MTD layer to do the actual mapping */
_

Patches currently in -mm which might be from lliubbo@gmail.com are

romfs-fix-romfs_get_unmapped_area-param-check.patch
mm-nommuc-fix-remap_pfn_range.patch


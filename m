From: akpm@linux-foundation.org
Subject: - cifs-use-simple_prepare_write-to-zero-page-data.patch removed from -mm tree
Date: Mon, 16 Jul 2007 14:00:04 -0700
Message-ID: <200707162100.l6GL04st002569@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34088 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755014AbXGPVN5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:13:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nate.diller@gmail.com, sfrench@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cifs: use simple_prepare_write to zero page data
has been removed from the -mm tree.  Its filename was
     cifs-use-simple_prepare_write-to-zero-page-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cifs: use simple_prepare_write to zero page data
From: Nate Diller <nate.diller@gmail.com>

It's common for file systems to need to zero data on either side of a
write, if a page is not Uptodate during prepare_write.  It just so happens
that simple_prepare_write() in libfs.c does exactly that, so we can avoid
duplication and just call that function to zero page data.

Signed-off-by: Nate Diller <nate.diller@gmail.com>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/file.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff -puN fs/cifs/file.c~cifs-use-simple_prepare_write-to-zero-page-data fs/cifs/file.c
--- a/fs/cifs/file.c~cifs-use-simple_prepare_write-to-zero-page-data
+++ a/fs/cifs/file.c
@@ -1965,14 +1965,7 @@ static int cifs_prepare_write(struct fil
 		 * We don't need to read data beyond the end of the file.
 		 * zero it, and set the page uptodate
 		 */
-		void *kaddr = kmap_atomic(page, KM_USER0);
-
-		if (from)
-			memset(kaddr, 0, from);
-		if (to < PAGE_CACHE_SIZE)
-			memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		simple_prepare_write(file, page, from, to);
 		SetPageUptodate(page);
 	} else if ((file->f_flags & O_ACCMODE) != O_WRONLY) {
 		/* might as well read a page, it is fast enough */
_

Patches currently in -mm which might be from nate.diller@gmail.com are

origin.patch
git-cifs.patch
reiser4.patch

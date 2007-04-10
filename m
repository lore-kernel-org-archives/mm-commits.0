From: akpm@linux-foundation.org
Subject: + cifs-use-simple_prepare_write-to-zero-page-data.patch added to -mm tree
Date: Mon, 09 Apr 2007 23:18:04 -0700
Message-ID: <200704100618.l3A6I4lO000539@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45642 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030396AbXDJGSK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 02:18:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nate.diller@gmail.com, sfrench@us.ibm.com


The patch titled
     cifs: use simple_prepare_write to zero page data
has been added to the -mm tree.  Its filename is
     cifs-use-simple_prepare_write-to-zero-page-data.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1955,14 +1955,7 @@ static int cifs_prepare_write(struct fil
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

cifs-use-simple_prepare_write-to-zero-page-data.patch
reiser4-use-simple_prepare_write-to-zero-page-data.patch
ext4-use-simple_prepare_write-to-zero-page-data.patch

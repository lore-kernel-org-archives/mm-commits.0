From: akpm@linux-foundation.org
Subject: + ocfs2-use-zero_user_page.patch added to -mm tree
Date: Tue, 10 Apr 2007 23:18:14 -0700
Message-ID: <200704110618.l3B6IE4t030134@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33081 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161227AbXDKGSS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 02:18:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nate.diller@gmail.com


The patch titled
     ocfs2: use zero_user_page
has been added to the -mm tree.  Its filename is
     ocfs2-use-zero_user_page.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ocfs2: use zero_user_page
From: Nate Diller <nate.diller@gmail.com>

Use zero_user_page() instead of open-coding it.

Signed-off-by: Nate Diller <nate.diller@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-use-zero_user_page fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-use-zero_user_page
+++ a/fs/ocfs2/aops.c
@@ -234,10 +234,7 @@ static int ocfs2_readpage(struct file *f
 	 * XXX sys_readahead() seems to get that wrong?
 	 */
 	if (start >= i_size_read(inode)) {
-		char *addr = kmap(page);
-		memset(addr, 0, PAGE_SIZE);
-		flush_dcache_page(page);
-		kunmap(page);
+		zero_user_page(page, 0, PAGE_SIZE, KM_USER0);
 		SetPageUptodate(page);
 		ret = 0;
 		goto out_alloc;
_

Patches currently in -mm which might be from nate.diller@gmail.com are

cifs-use-simple_prepare_write-to-zero-page-data.patch
ext4-use-simple_prepare_write-to-zero-page-data.patch
fs-convert-core-functions-to-zero_user_page.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
affs-use-zero_user_page.patch
ecryptfs-use-zero_user_page.patch
ext3-use-zero_user_page.patch
ext4-use-zero_user_page.patch
gfs2-use-zero_user_page.patch
nfs-use-zero_user_page.patch
ntfs-use-zero_user_page.patch
ocfs2-use-zero_user_page.patch
reiserfs-use-zero_user_page.patch
xfs-use-zero_user_page.patch
fs-deprecate-memclear_highpage_flush.patch
reiser4-use-zero_user_page.patch
reiser4-use-simple_prepare_write-to-zero-page-data.patch

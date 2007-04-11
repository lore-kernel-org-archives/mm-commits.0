From: akpm@linux-foundation.org
Subject: + nfs-use-zero_user_page.patch added to -mm tree
Date: Tue, 10 Apr 2007 23:18:03 -0700
Message-ID: <200704110618.l3B6I3LM030122@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33058 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161223AbXDKGSI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 02:18:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nate.diller@gmail.com


The patch titled
     nfs: use zero_user_page
has been added to the -mm tree.  Its filename is
     nfs-use-zero_user_page.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: nfs: use zero_user_page
From: Nate Diller <nate.diller@gmail.com>

Use zero_user_page() instead of the newly deprecated memclear_highpage_flush().

Signed-off-by: Nate Diller <nate.diller@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/read.c  |   10 +++++-----
 fs/nfs/write.c |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/nfs/read.c~nfs-use-zero_user_page fs/nfs/read.c
--- a/fs/nfs/read.c~nfs-use-zero_user_page
+++ a/fs/nfs/read.c
@@ -79,7 +79,7 @@ void nfs_readdata_release(void *data)
 static
 int nfs_return_empty_page(struct page *page)
 {
-	memclear_highpage_flush(page, 0, PAGE_CACHE_SIZE);
+	zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
 	SetPageUptodate(page);
 	unlock_page(page);
 	return 0;
@@ -103,10 +103,10 @@ static void nfs_readpage_truncate_uninit
 	pglen = PAGE_CACHE_SIZE - base;
 	for (;;) {
 		if (remainder <= pglen) {
-			memclear_highpage_flush(*pages, base, remainder);
+			zero_user_page(*pages, base, remainder, KM_USER0);
 			break;
 		}
-		memclear_highpage_flush(*pages, base, pglen);
+		zero_user_page(*pages, base, pglen, KM_USER0);
 		pages++;
 		remainder -= pglen;
 		pglen = PAGE_CACHE_SIZE;
@@ -130,7 +130,7 @@ static int nfs_readpage_async(struct nfs
 		return PTR_ERR(new);
 	}
 	if (len < PAGE_CACHE_SIZE)
-		memclear_highpage_flush(page, len, PAGE_CACHE_SIZE - len);
+		zero_user_page(page, len, PAGE_CACHE_SIZE - len, KM_USER0);
 
 	nfs_list_add_request(new, &one_request);
 	nfs_pagein_one(&one_request, inode);
@@ -561,7 +561,7 @@ readpage_async_filler(void *data, struct
 			return PTR_ERR(new);
 	}
 	if (len < PAGE_CACHE_SIZE)
-		memclear_highpage_flush(page, len, PAGE_CACHE_SIZE - len);
+		zero_user_page(page, len, PAGE_CACHE_SIZE - len, KM_USER0);
 	nfs_list_add_request(new, desc->head);
 	return 0;
 }
diff -puN fs/nfs/write.c~nfs-use-zero_user_page fs/nfs/write.c
--- a/fs/nfs/write.c~nfs-use-zero_user_page
+++ a/fs/nfs/write.c
@@ -169,7 +169,7 @@ static void nfs_mark_uptodate(struct pag
 	if (count != nfs_page_length(page))
 		return;
 	if (count != PAGE_CACHE_SIZE)
-		memclear_highpage_flush(page, count, PAGE_CACHE_SIZE - count);
+		zero_user_page(page, count, PAGE_CACHE_SIZE - count, KM_USER0);
 	SetPageUptodate(page);
 }
 
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

From: akpm@linux-foundation.org
Subject: - nfs-use-zero_user_page.patch removed from -mm tree
Date: Tue, 15 May 2007 11:07:38 -0700
Message-ID: <200705151807.l4FI7b1Z014177@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48984 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755804AbXEOSIU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 14:08:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nate.diller@gmail.com, bfields@fieldses.org, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     nfs: use zero_user_page
has been removed from the -mm tree.  Its filename was
     nfs-use-zero_user_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nfs: use zero_user_page
From: Nate Diller <nate.diller@gmail.com>

Use zero_user_page() instead of the newly deprecated memclear_highpage_flush().

Signed-off-by: Nate Diller <nate.diller@gmail.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
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
 	if (NFS_SERVER(inode)->rsize < PAGE_CACHE_SIZE)
@@ -532,7 +532,7 @@ readpage_async_filler(void *data, struct
 			return PTR_ERR(new);
 	}
 	if (len < PAGE_CACHE_SIZE)
-		memclear_highpage_flush(page, len, PAGE_CACHE_SIZE - len);
+		zero_user_page(page, len, PAGE_CACHE_SIZE - len, KM_USER0);
 	nfs_pageio_add_request(desc->pgio, new);
 	return 0;
 }
diff -puN fs/nfs/write.c~nfs-use-zero_user_page fs/nfs/write.c
--- a/fs/nfs/write.c~nfs-use-zero_user_page
+++ a/fs/nfs/write.c
@@ -168,7 +168,7 @@ static void nfs_mark_uptodate(struct pag
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
git-gfs2-nmw.patch
git-nfs.patch
git-ocfs2.patch
xfs-use-zero_user_page.patch
ext4-use-simple_prepare_write-to-zero-page-data.patch
ext4-use-zero_user_page.patch
ecryptfs-use-zero_user_page.patch
reiser4.patch
reiser4-use-zero_user_page.patch

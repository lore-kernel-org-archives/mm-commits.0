From: akpm@linux-foundation.org
Subject: - affs-use-zero_user_page.patch removed from -mm tree
Date: Wed, 09 May 2007 14:53:50 -0700
Message-ID: <200705092153.l49LroSr003115@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758689AbXEIVyN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:54:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nate.diller@gmail.com, mm-commits@vger.kernel.org


The patch titled
     affs: use zero_user_page
has been removed from the -mm tree.  Its filename was
     affs-use-zero_user_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: affs: use zero_user_page
From: Nate Diller <nate.diller@gmail.com>

Use zero_user_page() instead of open-coding it.

Signed-off-by: Nate Diller <nate.diller@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/file.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN fs/affs/file.c~affs-use-zero_user_page fs/affs/file.c
--- a/fs/affs/file.c~affs-use-zero_user_page
+++ a/fs/affs/file.c
@@ -628,11 +628,7 @@ static int affs_prepare_write_ofs(struct
 			return err;
 	}
 	if (to < PAGE_CACHE_SIZE) {
-		char *kaddr = kmap_atomic(page, KM_USER0);
-
-		memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_user_page(page, to, PAGE_CACHE_SIZE - to, KM_USER0);
 		if (size > offset + to) {
 			if (size < offset + PAGE_CACHE_SIZE)
 				tmp = size & ~PAGE_CACHE_MASK;
_

Patches currently in -mm which might be from nate.diller@gmail.com are

origin.patch
cifs-use-simple_prepare_write-to-zero-page-data.patch
ext4-use-simple_prepare_write-to-zero-page-data.patch
ecryptfs-use-zero_user_page.patch
ext4-use-zero_user_page.patch
gfs2-use-zero_user_page.patch
nfs-use-zero_user_page.patch
ntfs-use-zero_user_page.patch
ocfs2-use-zero_user_page.patch
xfs-use-zero_user_page.patch
reiser4.patch
reiser4-use-zero_user_page.patch

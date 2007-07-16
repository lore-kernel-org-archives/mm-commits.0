From: akpm@linux-foundation.org
Subject: - cifs-zero_user_page-conversion.patch removed from -mm tree
Date: Mon, 16 Jul 2007 14:00:06 -0700
Message-ID: <200707162100.l6GL06OQ002572@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50260 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751706AbXGPVMN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:12:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@redhat.com, sfrench@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cifs: zero_user_page() conversions
has been removed from the -mm tree.  Its filename was
     cifs-zero_user_page-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cifs: zero_user_page() conversions
From: Eric Sandeen <sandeen@redhat.com>

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/inode.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN fs/cifs/inode.c~cifs-zero_user_page-conversion fs/cifs/inode.c
--- a/fs/cifs/inode.c~cifs-zero_user_page-conversion
+++ a/fs/cifs/inode.c
@@ -1338,17 +1338,13 @@ static int cifs_truncate_page(struct add
 	pgoff_t index = from >> PAGE_CACHE_SHIFT;
 	unsigned offset = from & (PAGE_CACHE_SIZE - 1);
 	struct page *page;
-	char *kaddr;
 	int rc = 0;
 
 	page = grab_cache_page(mapping, index);
 	if (!page)
 		return -ENOMEM;
 
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, PAGE_CACHE_SIZE - offset);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	zero_user_page(page, offset, PAGE_CACHE_SIZE - offset, KM_USER0);
 	unlock_page(page);
 	page_cache_release(page);
 	return rc;
_

Patches currently in -mm which might be from sandeen@redhat.com are

origin.patch
git-cifs.patch
git-ocfs2.patch
ext4-zero_user_page-conversion.patch

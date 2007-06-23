From: akpm@linux-foundation.org
Subject: + cifs-zero_user_page-conversion.patch added to -mm tree
Date: Sat, 23 Jun 2007 09:47:35 -0700
Message-ID: <200706231647.l5NGlWnW019487@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44176 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757498AbXFWQrr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 12:47:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com, sfrench@us.ibm.com


The patch titled
     cifs: zero_user_page() conversions
has been added to the -mm tree.  Its filename is
     cifs-zero_user_page-conversion.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1335,17 +1335,13 @@ static int cifs_truncate_page(struct add
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

cifs-zero_user_page-conversion.patch
gfs2-zero_user_page-conversion.patch
ocfs2-zero_user_page-conversion.patch
ext4-zero_user_page-conversion.patch

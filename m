From: akpm@linux-foundation.org
Subject: + gfs2-zero_user_page-conversion.patch added to -mm tree
Date: Sat, 23 Jun 2007 09:48:25 -0700
Message-ID: <200706231648.l5NGmMxg019501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57285 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759652AbXFWQsf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 12:48:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com, swhiteho@redhat.com


The patch titled
     gfs2: zero_user_page() conversions
has been added to the -mm tree.  Its filename is
     gfs2-zero_user_page-conversion.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: gfs2: zero_user_page() conversions
From: Eric Sandeen <sandeen@redhat.com>

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/ops_address.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/gfs2/ops_address.c~gfs2-zero_user_page-conversion fs/gfs2/ops_address.c
--- a/fs/gfs2/ops_address.c~gfs2-zero_user_page-conversion
+++ a/fs/gfs2/ops_address.c
@@ -208,10 +208,7 @@ static int stuffed_readpage(struct gfs2_
 	 * so we need to supply one here. It doesn't happen often.
 	 */
 	if (unlikely(page->index)) {
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr, 0, PAGE_CACHE_SIZE);
-		kunmap_atomic(kaddr, KM_USER0);
-		flush_dcache_page(page);
+		zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
 		SetPageUptodate(page);
 		return 0;
 	}
_

Patches currently in -mm which might be from sandeen@redhat.com are

cifs-zero_user_page-conversion.patch
gfs2-zero_user_page-conversion.patch
ocfs2-zero_user_page-conversion.patch
ext4-zero_user_page-conversion.patch

From: akpm@linux-foundation.org
Subject: - gfs2-zero_user_page-conversion.patch removed from -mm tree
Date: Sat, 23 Jun 2007 12:28:11 -0700
Message-ID: <200706231928.l5NJSB2Y022122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43385 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753031AbXFWTej (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 15:34:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@redhat.com, swhiteho@redhat.com, mm-commits@vger.kernel.org


The patch titled
     gfs2: zero_user_page() conversions
has been removed from the -mm tree.  Its filename was
     gfs2-zero_user_page-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-ocfs2.patch
ext4-zero_user_page-conversion.patch

From: akpm@linux-foundation.org
Subject: - fs-deprecate-memclear_highpage_flush.patch removed from -mm tree
Date: Wed, 09 May 2007 14:53:58 -0700
Message-ID: <200705092153.l49LrwOo003125@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754757AbXEIVyR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:54:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nate.diller@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fs: deprecate memclear_highpage_flush
has been removed from the -mm tree.  Its filename was
     fs-deprecate-memclear_highpage_flush.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs: deprecate memclear_highpage_flush
From: Nate Diller <nate.diller@gmail.com>

Now that all the in-tree users are converted over to zero_user_page(),
deprecate the old memclear_highpage_flush() call.

Signed-off-by: Nate Diller <nate.diller@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/highmem.h~fs-deprecate-memclear_highpage_flush include/linux/highmem.h
--- a/include/linux/highmem.h~fs-deprecate-memclear_highpage_flush
+++ a/include/linux/highmem.h
@@ -110,8 +110,7 @@ static inline void clear_highpage(struct
 		kunmap_atomic(kaddr, (km_type));		\
 	} while (0)
 
-
-static inline void memclear_highpage_flush(struct page *page,
+static inline void __deprecated memclear_highpage_flush(struct page *page,
 			unsigned int offset, unsigned int size)
 {
 	zero_user_page(page, offset, size, KM_USER0);
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

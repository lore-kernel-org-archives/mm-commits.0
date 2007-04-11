From: akpm@linux-foundation.org
Subject: + fs-deprecate-memclear_highpage_flush.patch added to -mm tree
Date: Tue, 10 Apr 2007 23:18:25 -0700
Message-ID: <200704110618.l3B6IP3F030146@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33091 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161242AbXDKGS2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 02:18:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nate.diller@gmail.com


The patch titled
     From: Nate Diller <nate.diller@gmail.com>
has been added to the -mm tree.  Its filename is
     fs-deprecate-memclear_highpage_flush.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: From: Nate Diller <nate.diller@gmail.com>


Now that all the in-tree users are converted over to zero_user_page(),
deprecate the old memclear_highpage_flush() call.

Signed-off-by: Nate Diller <nate.diller@gmail.com>

---

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/highmem.h~fs-deprecate-memclear_highpage_flush include/linux/highmem.h
--- a/include/linux/highmem.h~fs-deprecate-memclear_highpage_flush
+++ a/include/linux/highmem.h
@@ -152,8 +152,7 @@ static inline void clear_highpage(struct
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

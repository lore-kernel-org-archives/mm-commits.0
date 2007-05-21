From: akpm@linux-foundation.org
Subject: - fix-fs-convert-core-functions-to-zero_user_page.patch removed from -mm tree
Date: Mon, 21 May 2007 13:09:11 -0700
Message-ID: <200705212009.l4LK9B2i018750@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50752 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935741AbXEUULO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 16:11:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, nate.diller@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Fix "fs: convert core functions to zero_user_page"
has been removed from the -mm tree.  Its filename was
     fix-fs-convert-core-functions-to-zero_user_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix "fs: convert core functions to zero_user_page"
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

The bug introduced by 01f2705daf5a36208e69d7cf95db9c330f843af6.
It misses to convert the first argument, it should be "new_page".

This became the cause of fatfs corruption.

Cc: Nate Diller <nate.diller@gmail.com>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/buffer.c~fix-fs-convert-core-functions-to-zero_user_page fs/buffer.c
--- a/fs/buffer.c~fix-fs-convert-core-functions-to-zero_user_page
+++ a/fs/buffer.c
@@ -2101,7 +2101,7 @@ int cont_prepare_write(struct page *page
 						PAGE_CACHE_SIZE, get_block);
 		if (status)
 			goto out_unmap;
-		zero_user_page(page, zerofrom, PAGE_CACHE_SIZE - zerofrom,
+		zero_user_page(new_page, zerofrom, PAGE_CACHE_SIZE - zerofrom,
 				KM_USER0);
 		generic_commit_write(NULL, new_page, zerofrom, PAGE_CACHE_SIZE);
 		unlock_page(new_page);
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

origin.patch
power-fix-sizeofpage_size-typo.patch
fat-gcc-43-warning-fix.patch

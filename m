From: akpm@linux-foundation.org
Subject: + fix-fs-convert-core-functions-to-zero_user_page.patch added to -mm tree
Date: Sun, 20 May 2007 10:32:32 -0700
Message-ID: <200705201732.l4KHWXRO025800@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54742 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756638AbXETRe2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 May 2007 13:34:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp, nate.diller@gmail.com


The patch titled
     Fix "fs: convert core functions to zero_user_page"
has been added to the -mm tree.  Its filename is
     fix-fs-convert-core-functions-to-zero_user_page.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

fix-fs-convert-core-functions-to-zero_user_page.patch
power-fix-sizeofpage_size-typo.patch

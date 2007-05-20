From: akpm@linux-foundation.org
Subject: + power-fix-sizeofpage_size-typo.patch added to -mm tree
Date: Sun, 20 May 2007 10:34:17 -0700
Message-ID: <200705201734.l4KHYGTo025828@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55985 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755659AbXETRhu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 May 2007 13:37:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp, hogawa@miraclelinux.com, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     power: Fix sizeof(PAGE_SIZE) typo
has been added to the -mm tree.  Its filename is
     power-fix-sizeofpage_size-typo.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: power: Fix sizeof(PAGE_SIZE) typo
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Fix sizeof(PAGE_SIZE) typo.  It should be just PAGE_SIZE for zeroing the
swsusp_header.

Signed-off-by: OGAWA Hirofumi <hogawa@miraclelinux.com>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/power/swap.c~power-fix-sizeofpage_size-typo kernel/power/swap.c
--- a/kernel/power/swap.c~power-fix-sizeofpage_size-typo
+++ a/kernel/power/swap.c
@@ -584,7 +584,7 @@ int swsusp_check(void)
 	resume_bdev = open_by_devnum(swsusp_resume_device, FMODE_READ);
 	if (!IS_ERR(resume_bdev)) {
 		set_blocksize(resume_bdev, PAGE_SIZE);
-		memset(swsusp_header, 0, sizeof(PAGE_SIZE));
+		memset(swsusp_header, 0, PAGE_SIZE);
 		error = bio_read_page(swsusp_resume_block,
 					swsusp_header, NULL);
 		if (error)
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

fix-fs-convert-core-functions-to-zero_user_page.patch
power-fix-sizeofpage_size-typo.patch
fat-gcc-43-warning-fix.patch

From: akpm@linux-foundation.org
Subject: + md-check-return-code-of-read_sb_page.patch added to -mm tree
Date: Wed, 08 Sep 2010 13:06:20 -0700
Message-ID: <201009082006.o88K6KZ6006044@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753632Ab0IHUGu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Sep 2010 16:06:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segooon@gmail.com, neilb@suse.de


The patch titled
     md: check return code of read_sb_page
has been added to the -mm tree.  Its filename is
     md-check-return-code-of-read_sb_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: check return code of read_sb_page
From: Vasiliy Kulikov <segooon@gmail.com>

Function read_sb_page may return ERR_PTR(...). Check for it.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bitmap.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/md/bitmap.c~md-check-return-code-of-read_sb_page drivers/md/bitmap.c
--- a/drivers/md/bitmap.c~md-check-return-code-of-read_sb_page
+++ a/drivers/md/bitmap.c
@@ -936,6 +936,7 @@ static int bitmap_init_from_disk(struct 
 	int outofdate;
 	int ret = -ENOSPC;
 	void *paddr;
+	struct page *p;
 
 	chunks = bitmap->chunks;
 	file = bitmap->file;
@@ -999,11 +1000,16 @@ static int bitmap_init_from_disk(struct 
 				 */
 				page = bitmap->sb_page;
 				offset = sizeof(bitmap_super_t);
-				if (!file)
-					read_sb_page(bitmap->mddev,
+				if (!file) {
+					p = read_sb_page(bitmap->mddev,
 						     bitmap->mddev->bitmap_info.offset,
 						     page,
 						     index, count);
+					if (IS_ERR(p)) {
+						ret = PTR_ERR(p);
+						goto err;
+					}
+				}
 			} else if (file) {
 				page = read_page(file, index, bitmap, count);
 				offset = 0;
_

Patches currently in -mm which might be from segooon@gmail.com are

linux-next.patch
md-check-return-code-of-read_sb_page.patch


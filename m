From: akpm@linux-foundation.org
Subject: + minix-fix-add-links-wrong-position-calculation.patch added to -mm tree
Date: Tue, 30 Dec 2008 15:33:05 -0800
Message-ID: <200812302333.mBUNX5II004418@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752472AbYL3Xdq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Dec 2008 18:33:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dushistov@mail.ru, nickpiggin@yahoo.com.au, stable@kernel.org


The patch titled
     minix: fix add link's wrong position calculation
has been added to the -mm tree.  Its filename is
     minix-fix-add-links-wrong-position-calculation.patch

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
Subject: minix: fix add link's wrong position calculation
From: Evgeniy Dushistov <dushistov@mail.ru>

Fix the add link method.  The oosition in the directory was calculated in
wrong way - it had the incorrect shift direction.

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: <stable@kernel.org>		[2.6.lots]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/minix/dir.c~minix-fix-add-links-wrong-position-calculation fs/minix/dir.c
--- a/fs/minix/dir.c~minix-fix-add-links-wrong-position-calculation
+++ a/fs/minix/dir.c
@@ -280,7 +280,7 @@ int minix_add_link(struct dentry *dentry
 	return -EINVAL;
 
 got_it:
-	pos = (page->index >> PAGE_CACHE_SHIFT) + p - (char*)page_address(page);
+	pos = page_offset(page) + p - (char*)page_address(page);
 	err = __minix_write_begin(NULL, page->mapping, pos, sbi->s_dirsize,
 					AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
 	if (err)
_

Patches currently in -mm which might be from dushistov@mail.ru are

origin.patch
minix-fix-add-links-wrong-position-calculation.patch
ufs-sector_t-cannot-be-negative.patch


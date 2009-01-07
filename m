From: akpm@linux-foundation.org
Subject: - minix-fix-add-links-wrong-position-calculation.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:20:03 -0800
Message-ID: <200901072220.n07MK3HA019365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762352AbZAGWhl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:37:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dushistov@mail.ru, nickpiggin@yahoo.com.au, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     minix: fix add link's wrong position calculation
has been removed from the -mm tree.  Its filename was
     minix-fix-add-links-wrong-position-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: minix: fix add link's wrong position calculation
From: Evgeniy Dushistov <dushistov@mail.ru>

Fix the add link method.  The oosition in the directory was calculated in
wrong way - it had the incorrect shift direction.

[akpm@linux-foundation.org: coding-style fixes]
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
+	pos = page_offset(page) + p - (char *)page_address(page);
 	err = __minix_write_begin(NULL, page->mapping, pos, sbi->s_dirsize,
 					AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
 	if (err)
_

Patches currently in -mm which might be from dushistov@mail.ru are

origin.patch
ufs-sector_t-cannot-be-negative.patch


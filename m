From: akpm@linux-foundation.org
Subject: - jffs2-fix-panics-caused-by-wrong-condition-for-hole-frag-creation-in-write_begin.patch removed from -mm tree
Date: Tue, 15 Apr 2008 13:43:26 -0700
Message-ID: <200804152043.m3FKhQCg014590@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755655AbYDOUny (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 16:43:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akorolev@infradead.org, dwmw2@infradead.org, vasiliy.leonenko@mail.ru, mm-commits@vger.kernel.org


The patch titled
     jffs2: fix panics caused by wrong condition for hole frag creation in write_begin
has been removed from the -mm tree.  Its filename was
     jffs2-fix-panics-caused-by-wrong-condition-for-hole-frag-creation-in-write_begin.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jffs2: fix panics caused by wrong condition for hole frag creation in write_begin
From: Alexey Korolev <akorolev@infradead.org>

This fixes a regression introduced in commit
205c109a7a96d9a3d8ffe64c4068b70811fef5e8 when switching to
write_begin/write_end operations in JFFS2.  The page offset is miscalculated,
leading to corruption of the fragment lists and subsequently to memory
corruption and panics.

Signed-off-by: Alexey Korolev <akorolev@infradead.org>
Signed-off-by: Vasiliy Leonenko <vasiliy.leonenko@mail.ru>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/jffs2/file.c~jffs2-fix-panics-caused-by-wrong-condition-for-hole-frag-creation-in-write_begin fs/jffs2/file.c
--- a/fs/jffs2/file.c~jffs2-fix-panics-caused-by-wrong-condition-for-hole-frag-creation-in-write_begin
+++ a/fs/jffs2/file.c
@@ -129,7 +129,7 @@ static int jffs2_write_begin(struct file
 	struct inode *inode = mapping->host;
 	struct jffs2_inode_info *f = JFFS2_INODE_INFO(inode);
 	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
-	uint32_t pageofs = pos & (PAGE_CACHE_SIZE - 1);
+	uint32_t pageofs = index << PAGE_CACHE_SHIFT;
 	int ret = 0;
 
 	pg = __grab_cache_page(mapping, index);
_

Patches currently in -mm which might be from akorolev@infradead.org are

origin.patch


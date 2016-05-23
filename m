From: akpm@linux-foundation.org
Subject: [patch 11/84] fs/befs/io.c:befs_bread_iaddr(): remove unneeded
 initialization to NULL
Date: Mon, 23 May 2016 16:22:52 -0700
Message-ID: <574390cc./qrJ4CkGSlZhE/uY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbcEWXWx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:22:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, salah.triki@acm.org

From: Salah Triki <salah.triki@acm.org>
Subject: fs/befs/io.c:befs_bread_iaddr(): remove unneeded initialization to NULL

bh is reinitialized by sb_bread() so no need to init it
with NULL in the beginning of befs_bread_iaddr()

Link: http://lkml.kernel.org/r/586d2639d729345b9c07aac10ba713d8ceb8745a.1462841692.git.salah.triki@acm.org
Signed-off-by: Salah Triki <salah.triki@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/befs/io.c~fs-befs-ioc-befs_bread_iaddr-remove-unneeded-initialization-to-null fs/befs/io.c
--- a/fs/befs/io.c~fs-befs-ioc-befs_bread_iaddr-remove-unneeded-initialization-to-null
+++ a/fs/befs/io.c
@@ -26,7 +26,7 @@
 struct buffer_head *
 befs_bread_iaddr(struct super_block *sb, befs_inode_addr iaddr)
 {
-	struct buffer_head *bh = NULL;
+	struct buffer_head *bh;
 	befs_blocknr_t block = 0;
 	struct befs_sb_info *befs_sb = BEFS_SB(sb);
 
_

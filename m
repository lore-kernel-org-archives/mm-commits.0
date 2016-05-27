From: akpm@linux-foundation.org
Subject: [merged]
 fs-befs-ioc-befs_bread-remove-unneeded-initialization-to-null.patch removed from -mm tree
Date: Fri, 27 May 2016 11:42:36 -0700
Message-ID: <5748951c.L4rs2XEteUL0vMI/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbcE0Smh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:42:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: salah.triki@acm.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/befs/io.c:befs_bread(): remove unneeded initialization to NULL
has been removed from the -mm tree.  Its filename was
     fs-befs-ioc-befs_bread-remove-unneeded-initialization-to-null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Salah Triki <salah.triki@acm.org>
Subject: fs/befs/io.c:befs_bread(): remove unneeded initialization to NULL

bh is reinitialized by sb_bread() so no need to init it
with NULL in the beginning of befs_bread()

Link: http://lkml.kernel.org/r/88481760b43226fac16adb1f1e68897e47d8235c.1462841692.git.salah.triki@acm.org
Signed-off-by: Salah Triki <salah.triki@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/befs/io.c~fs-befs-ioc-befs_bread-remove-unneeded-initialization-to-null fs/befs/io.c
--- a/fs/befs/io.c~fs-befs-ioc-befs_bread-remove-unneeded-initialization-to-null
+++ a/fs/befs/io.c
@@ -63,7 +63,7 @@ befs_bread_iaddr(struct super_block *sb,
 struct buffer_head *
 befs_bread(struct super_block *sb, befs_blocknr_t block)
 {
-	struct buffer_head *bh = NULL;
+	struct buffer_head *bh;
 
 	befs_debug(sb, "---> Enter %s %lu", __func__, (unsigned long)block);
 
_

Patches currently in -mm which might be from salah.triki@acm.org are



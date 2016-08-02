From: akpm@linux-foundation.org
Subject: [merged] befs-remove-unused-functions.patch removed from -mm tree
Date: Mon, 01 Aug 2016 17:25:37 -0700
Message-ID: <579fe881.p3ocRBtFzBk6zhQN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47770 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483AbcHBAZh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2016 20:25:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luisbg@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: befs: remove unused functions
has been removed from the -mm tree.  Its filename was
     befs-remove-unused-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: befs: remove unused functions

befs_iaddr_is_empty() and befs_brun_size() are unused. Remove them.

Link: http://lkml.kernel.org/r/1465700235-22881-3-git-send-email-luisbg@osg.samsung.com
Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/befs.h |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN fs/befs/befs.h~befs-remove-unused-functions fs/befs/befs.h
--- a/fs/befs/befs.h~befs-remove-unused-functions
+++ a/fs/befs/befs.h
@@ -140,18 +140,6 @@ befs_iaddrs_per_block(struct super_block
 	return BEFS_SB(sb)->block_size / sizeof (befs_disk_inode_addr);
 }
 
-static inline int
-befs_iaddr_is_empty(const befs_inode_addr *iaddr)
-{
-	return (!iaddr->allocation_group) && (!iaddr->start) && (!iaddr->len);
-}
-
-static inline size_t
-befs_brun_size(struct super_block *sb, befs_block_run run)
-{
-	return BEFS_SB(sb)->block_size * run.len;
-}

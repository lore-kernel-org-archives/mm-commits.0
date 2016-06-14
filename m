From: akpm@linux-foundation.org
Subject: + befs-remove-unused-functions.patch added to -mm tree
Date: Tue, 14 Jun 2016 16:10:32 -0700
Message-ID: <57608ee8.3E3fYepNdnHeipSK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56577 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbcFNXKd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jun 2016 19:10:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luisbg@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: befs: remove unused functions
has been added to the -mm tree.  Its filename is
     befs-remove-unused-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/befs-remove-unused-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/befs-remove-unused-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

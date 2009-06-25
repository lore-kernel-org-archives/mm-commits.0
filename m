From: akpm@linux-foundation.org
Subject: + adfs-remove-redundant-test-on-unsigned.patch added to -mm tree
Date: Thu, 25 Jun 2009 15:53:29 -0700
Message-ID: <200906252253.n5PMrTAd021030@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752786AbZFYWx2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jun 2009 18:53:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com


The patch titled
     adfs: remove redundant test on unsigned
has been added to the -mm tree.  Its filename is
     adfs-remove-redundant-test-on-unsigned.patch

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
Subject: adfs: remove redundant test on unsigned
From: Roel Kluin <roel.kluin@gmail.com>

unsigned block cannot be less than 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/inode.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN fs/adfs/inode.c~adfs-remove-redundant-test-on-unsigned fs/adfs/inode.c
--- a/fs/adfs/inode.c~adfs-remove-redundant-test-on-unsigned
+++ a/fs/adfs/inode.c
@@ -19,9 +19,6 @@ static int
 adfs_get_block(struct inode *inode, sector_t block, struct buffer_head *bh,
 	       int create)
 {
-	if (block < 0)
-		goto abort_negative;
-
 	if (!create) {
 		if (block >= inode->i_blocks)
 			goto abort_toobig;
@@ -34,10 +31,6 @@ adfs_get_block(struct inode *inode, sect
 	/* don't support allocation of blocks yet */
 	return -EIO;
 
-abort_negative:
-	adfs_error(inode->i_sb, "block %d < 0", block);
-	return -EIO;

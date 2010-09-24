From: akpm@linux-foundation.org
Subject: + affs-testing-the-wrong-variable.patch added to -mm tree
Date: Fri, 24 Sep 2010 15:11:44 -0700
Message-ID: <201009242211.o8OMBiT2028239@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49859 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753384Ab0IXWLp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Sep 2010 18:11:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com


The patch titled
     affs: testing the wrong variable
has been added to the -mm tree.  Its filename is
     affs-testing-the-wrong-variable.patch

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
Subject: affs: testing the wrong variable
From: Dan Carpenter <error27@gmail.com>

The intent was to verify that bh = affs_bread_ino(...) returned a valid
pointer.  We checked "ext_bh" earlier in the function and it's valid here.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/affs/file.c~affs-testing-the-wrong-variable fs/affs/file.c
--- a/fs/affs/file.c~affs-testing-the-wrong-variable
+++ a/fs/affs/file.c
@@ -894,9 +894,9 @@ affs_truncate(struct inode *inode)
 		if (AFFS_SB(sb)->s_flags & SF_OFS) {
 			struct buffer_head *bh = affs_bread_ino(inode, last_blk, 0);
 			u32 tmp;
-			if (IS_ERR(ext_bh)) {
+			if (IS_ERR(bh)) {
 				affs_warning(sb, "truncate", "unexpected read error for last block %u (%d)",
-					     ext, PTR_ERR(ext_bh));
+					     ext, PTR_ERR(bh));
 				return;
 			}
 			tmp = be32_to_cpu(AFFS_DATA_HEAD(bh)->next);
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
linux-next.patch
rocket-release_region-or-error-path.patch
affs-testing-the-wrong-variable.patch


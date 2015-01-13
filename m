From: akpm@linux-foundation.org
Subject: + ocfs2-xattr-remove-unused-function.patch added to -mm tree
Date: Mon, 12 Jan 2015 16:24:49 -0800
Message-ID: <54b465d1.eUBjBr5egHJTDcYo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37602 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbbAMAYu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 19:24:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rickard_strandqvist@spectrumdigital.se, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: xattr: Remove unused function
has been added to the -mm tree.  Its filename is
     ocfs2-xattr-remove-unused-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-xattr-remove-unused-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-xattr-remove-unused-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: ocfs2: xattr: Remove unused function

Remove function ocfs2_xattr_bucket_get_val() that is not used anywhere.

This was partially found by using a static code analysis program called
cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN fs/ocfs2/xattr.c~ocfs2-xattr-remove-unused-function fs/ocfs2/xattr.c
--- a/fs/ocfs2/xattr.c~ocfs2-xattr-remove-unused-function
+++ a/fs/ocfs2/xattr.c
@@ -5334,16 +5334,6 @@ out:
 	return ret;
 }
 
-static inline char *ocfs2_xattr_bucket_get_val(struct inode *inode,
-					struct ocfs2_xattr_bucket *bucket,
-					int offs)
-{
-	int block_off = offs >> inode->i_sb->s_blocksize_bits;
-
-	offs = offs % inode->i_sb->s_blocksize;
-	return bucket_block(bucket, block_off) + offs;
-}

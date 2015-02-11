From: akpm@linux-foundation.org
Subject: [merged] ocfs2-xattr-remove-unused-function.patch removed from
 -mm tree
Date: Wed, 11 Feb 2015 12:21:06 -0800
Message-ID: <54dbb9b2.SAPWeleurJgqboSM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbbBKUVH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:21:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rickard_strandqvist@spectrumdigital.se, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: xattr: remove unused function
has been removed from the -mm tree.  Its filename was
     ocfs2-xattr-remove-unused-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: ocfs2: xattr: remove unused function

Remove ocfs2_xattr_bucket_get_val() that is not used anywhere.

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

From: akpm@linux-foundation.org
Subject: [merged] ocfs2-quota_local-remove-unused-function.patch removed
 from -mm tree
Date: Wed, 11 Feb 2015 12:21:08 -0800
Message-ID: <54dbb9b4.QxWh9ag8wzOOy7L9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbbBKUVJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:21:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rickard_strandqvist@spectrumdigital.se, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: quota_local: remove unused function
has been removed from the -mm tree.  Its filename was
     ocfs2-quota_local-remove-unused-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: ocfs2: quota_local: remove unused function

Remove ol_dqblk_file_block() that is not used anywhere.

This was partially found by using a static code analysis program called
cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/quota_local.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN fs/ocfs2/quota_local.c~ocfs2-quota_local-remove-unused-function fs/ocfs2/quota_local.c
--- a/fs/ocfs2/quota_local.c~ocfs2-quota_local-remove-unused-function
+++ a/fs/ocfs2/quota_local.c
@@ -73,12 +73,6 @@ static loff_t ol_dqblk_off(struct super_
 	       ol_dqblk_block_off(sb, c, off);
 }
 
-/* Compute block number from given offset */
-static inline unsigned int ol_dqblk_file_block(struct super_block *sb, loff_t off)
-{
-	return off >> sb->s_blocksize_bits;
-}

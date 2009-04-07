From: akpm@linux-foundation.org
Subject: [merged] nilfs2-super-block-operations-fix-endian-bug.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:09:43 -0700
Message-ID: <200904071909.n37J9hOt012476@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34082 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752414AbZDGTVj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:21:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     nilfs2: super block operations fix endian bug
has been removed from the -mm tree.  Its filename was
     nilfs2-super-block-operations-fix-endian-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: super block operations fix endian bug
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This adds a missing endian conversion of checksum field in the super
block.  This fixes compatibility issue on big endian machines which will
come to surface after supporting recovery of super block.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/super.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/nilfs2/super.c~nilfs2-super-block-operations-fix-endian-bug fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-super-block-operations-fix-endian-bug
+++ a/fs/nilfs2/super.c
@@ -287,9 +287,9 @@ int nilfs_commit_super(struct nilfs_sb_i
 	sbp->s_free_blocks_count = cpu_to_le64(nfreeblocks);
 	sbp->s_wtime = cpu_to_le64(get_seconds());
 	sbp->s_sum = 0;
-	sbp->s_sum = crc32_le(nilfs->ns_crc_seed, (unsigned char *)sbp,
-			      le16_to_cpu(sbp->s_bytes));

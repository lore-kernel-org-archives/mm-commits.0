From: akpm@linux-foundation.org
Subject: - ext2-xip-check-fix.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:24:43 -0800
Message-ID: <200802070024.m170OOfi006604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44577 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935037AbYBGAop (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, cotte@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ext2: xip check fix
has been removed from the -mm tree.  Its filename was
     ext2-xip-check-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext2: xip check fix
From: Nick Piggin <npiggin@suse.de>

ext2 should not worry about checking sb->s_blocksize for XIP before the
sb's blocksize actually gets set.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/super.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/ext2/super.c~ext2-xip-check-fix fs/ext2/super.c
--- a/fs/ext2/super.c~ext2-xip-check-fix
+++ a/fs/ext2/super.c
@@ -868,8 +868,7 @@ static int ext2_fill_super(struct super_
 
 	blocksize = BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
 
-	if ((ext2_use_xip(sb)) && ((blocksize != PAGE_SIZE) ||
-				  (sb->s_blocksize != blocksize))) {
+	if (ext2_use_xip(sb) && blocksize != PAGE_SIZE) {
 		if (!silent)
 			printk("XIP: Unsupported blocksize\n");
 		goto failed_mount;
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
drm-convert-from-nopage-to-fault.patch
git-kvm.patch
nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
sg-nopage.patch
mm-special-mapping-nopage.patch
rewrite-rd.patch
rewrite-rd-fix.patch
rewrite-rd-fix-2.patch
rd-support-xip.patch
mm-remove-nopage.patch
buffer_head-fix-private_list-handling.patch
reiser4.patch
reiser4-correct-references-to-filemap_nopage.patch

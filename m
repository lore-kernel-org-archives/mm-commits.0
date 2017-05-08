From: akpm@linux-foundation.org
Subject: [folded-merged] mm-introduce-kvalloc-helpers-fix.patch removed
 from -mm tree
Date: Mon, 08 May 2017 15:46:09 -0700
Message-ID: <5910f531.TrIZcqZEKcc/JBSQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44654 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750883AbdEHWqK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:46:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, jaegeuk@kernel.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce kv[mz]alloc helpers - f2fs fix up
has been removed from the -mm tree.  Its filename was
     mm-introduce-kvalloc-helpers-fix.patch

This patch was dropped because it was folded into mm-introduce-kvalloc-helpers.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: mm: introduce kv[mz]alloc helpers - f2fs fix up

f2fs fixup

Link: http://lkml.kernel.org/r/20170320163735.332e64b7@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/f2fs/node.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/f2fs/node.c~mm-introduce-kvalloc-helpers-fix fs/f2fs/node.c
--- a/fs/f2fs/node.c~mm-introduce-kvalloc-helpers-fix
+++ a/fs/f2fs/node.c
@@ -2662,7 +2662,7 @@ static int init_free_nid_cache(struct f2
 	if (!nm_i->nat_block_bitmap)
 		return -ENOMEM;
 
-	nm_i->free_nid_count = f2fs_kvzalloc(nm_i->nat_blocks *
+	nm_i->free_nid_count = kvzalloc(nm_i->nat_blocks *
 					sizeof(unsigned short), GFP_KERNEL);
 	if (!nm_i->free_nid_count)
 		return -ENOMEM;
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-introduce-kvalloc-helpers.patch
gfs2-replace-current_time-with-current_time.patch


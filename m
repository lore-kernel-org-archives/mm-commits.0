From: akpm@osdl.org
Subject: - ocfs2-build-fix.patch removed from -mm tree
Date: Fri, 26 Jan 2007 17:32:44 -0800
Message-ID: <200701270132.l0R1WiFw031950@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35593 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752236AbXA0Bcx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 20:32:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Joel.Becker@oracle.com, mark.fasheh@oracle.com, mm-commits@vger.kernel.org


The patch titled
     ocfs2 build fix
has been removed from the -mm tree.  Its filename was
     ocfs2-build-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ocfs2 build fix
From: Joel Becker <Joel.Becker@oracle.com>

WARNING: "__udivdi3" [fs/ocfs2/ocfs2.ko] undefined!

Cc: Mark Fasheh <mark.fasheh@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ocfs2/ocfs2_fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/ocfs2_fs.h~ocfs2-build-fix fs/ocfs2/ocfs2_fs.h
--- a/fs/ocfs2/ocfs2_fs.h~ocfs2-build-fix
+++ a/fs/ocfs2/ocfs2_fs.h
@@ -587,7 +587,7 @@ static inline u64 ocfs2_backup_super_blk
 
 	if (index >= 0 && index < OCFS2_MAX_BACKUP_SUPERBLOCKS) {
 		offset <<= (2 * index);
-		offset /= sb->s_blocksize;
+		offset >>= sb->s_blocksize_bits;
 		return offset;
 	}
 
_

Patches currently in -mm which might be from Joel.Becker@oracle.com are

transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch

From: akpm@linux-foundation.org
Subject: - add-balance_dirty_pages_ratelimited-to-cont_expand_zero.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:01:40 -0700
Message-ID: <200804282201.m3SM1e5p018886@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965778AbYD1WBn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:01:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Add balance_dirty_pages_ratelimited() to cont_expand_zero()
has been removed from the -mm tree.  Its filename was
     add-balance_dirty_pages_ratelimited-to-cont_expand_zero.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add balance_dirty_pages_ratelimited() to cont_expand_zero()
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

On the systems, ftruncate() which expand size for FAT became the cause
of OOM.  The cont_expand_zero() filled all memory with dirty pages,
and since disk is very slow, limit of page scanning was exceeded, then
it triggered OOM.

This adds balance_dirty_pages_ratelimited() to avoid filling memory
with dirty pages.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/buffer.c~add-balance_dirty_pages_ratelimited-to-cont_expand_zero fs/buffer.c
--- a/fs/buffer.c~add-balance_dirty_pages_ratelimited-to-cont_expand_zero
+++ a/fs/buffer.c
@@ -2246,6 +2246,8 @@ int cont_expand_zero(struct file *file, 
 			goto out;
 		BUG_ON(err != len);
 		err = 0;
+
+		balance_dirty_pages_ratelimited(mapping);
 	}
 
 	/* page covers the boundary, find the boundary offset */
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

origin.patch
vfs-fix-unconditional-write_super-call-in-file_fsync.patch
fat-use-get-put_unaligned_-helpers.patch


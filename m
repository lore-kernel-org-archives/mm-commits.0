From: akpm@linux-foundation.org
Subject: - xfs-use-zero_user_page.patch removed from -mm tree
Date: Tue, 29 May 2007 11:56:22 -0700
Message-ID: <200705291856.l4TIuLUK008642@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760036AbXE2S4s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:56:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nate.diller@gmail.com, mm-commits@vger.kernel.org


The patch titled
     xfs: use zero_user_page
has been removed from the -mm tree.  Its filename was
     xfs-use-zero_user_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: xfs: use zero_user_page
From: Nate Diller <nate.diller@gmail.com>

Use zero_user_page() instead of the newly deprecated memclear_highpage_flush().

Signed-off-by: Nate Diller <nate.diller@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/linux-2.6/xfs_lrw.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/xfs/linux-2.6/xfs_lrw.c~xfs-use-zero_user_page fs/xfs/linux-2.6/xfs_lrw.c
--- a/fs/xfs/linux-2.6/xfs_lrw.c~xfs-use-zero_user_page
+++ a/fs/xfs/linux-2.6/xfs_lrw.c
@@ -159,7 +159,7 @@ xfs_iozero(
 		if (status)
 			goto unlock;
 
-		memclear_highpage_flush(page, offset, bytes);
+		zero_user_page(page, offset, bytes, KM_USER0);
 
 		status = mapping->a_ops->commit_write(NULL, page, offset,
 							offset + bytes);
_

Patches currently in -mm which might be from nate.diller@gmail.com are

cifs-use-simple_prepare_write-to-zero-page-data.patch
git-gfs2-nmw.patch
ext4-use-simple_prepare_write-to-zero-page-data.patch
ext4-use-zero_user_page.patch
reiser4.patch
reiser4-use-zero_user_page.patch

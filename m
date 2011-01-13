From: akpm@linux-foundation.org
Subject: [merged] cramfs-hide-function-prototypes-behind-__kernel__-macro.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:10:03 -0800
Message-ID: <201101132012.p0DKCixD030322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933703Ab1AMUNP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:13:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: virtuoso@slind.org, mm-commits@vger.kernel.org


The patch titled
     cramfs: hide function prototypes behind __KERNEL__ macro
has been removed from the -mm tree.  Its filename was
     cramfs-hide-function-prototypes-behind-__kernel__-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cramfs: hide function prototypes behind __KERNEL__ macro
From: Alexander Shishkin <virtuoso@slind.org>

Currently, 3 kernel function prototypes are present in a header
file exported to userland. This patch fixes it.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cramfs_fs.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/cramfs_fs.h~cramfs-hide-function-prototypes-behind-__kernel__-macro include/linux/cramfs_fs.h
--- a/include/linux/cramfs_fs.h~cramfs-hide-function-prototypes-behind-__kernel__-macro
+++ a/include/linux/cramfs_fs.h
@@ -84,9 +84,11 @@ struct cramfs_super {
 				| CRAMFS_FLAG_WRONG_SIGNATURE \
 				| CRAMFS_FLAG_SHIFTED_ROOT_OFFSET )
 
+#ifdef __KERNEL__
 /* Uncompression interfaces to the underlying zlib */
 int cramfs_uncompress_block(void *dst, int dstlen, void *src, int srclen);
 int cramfs_uncompress_init(void);
 void cramfs_uncompress_exit(void);
+#endif /* __KERNEL__ */
 
 #endif
_

Patches currently in -mm which might be from virtuoso@slind.org are

origin.patch
scsi-fix-a-header-to-include-linux-typesh.patch


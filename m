From: akpm@linux-foundation.org
Subject: [merged] romfs-have-romfs_fsh-pull-in-necessary-headers.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:10:10 -0800
Message-ID: <201101132012.p0DKCpOi030332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756782Ab1AMUNU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:13:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     romfs: have romfs_fs.h pull in necessary headers
has been removed from the -mm tree.  Its filename was
     romfs-have-romfs_fsh-pull-in-necessary-headers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: romfs: have romfs_fs.h pull in necessary headers
From: Mike Frysinger <vapier@gentoo.org>

This header uses things like __be32, so pull in linux/types.h.

Further, it uses BLOCK_SIZE, so pull in linux/fs.h.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/romfs_fs.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/linux/romfs_fs.h~romfs-have-romfs_fsh-pull-in-necessary-headers include/linux/romfs_fs.h
--- a/include/linux/romfs_fs.h~romfs-have-romfs_fsh-pull-in-necessary-headers
+++ a/include/linux/romfs_fs.h
@@ -1,6 +1,9 @@
 #ifndef __LINUX_ROMFS_FS_H
 #define __LINUX_ROMFS_FS_H
 
+#include <linux/types.h>
+#include <linux/fs.h>
+
 /* The basic structures of the romfs filesystem */
 
 #define ROMBSIZE BLOCK_SIZE
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch


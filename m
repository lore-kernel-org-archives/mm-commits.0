From: akpm@linux-foundation.org
Subject: - fix-headers-check-fallout.patch removed from -mm tree
Date: Mon, 21 May 2007 22:56:38 -0700
Message-ID: <200705220556.l4M5ubH5028395@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36137 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756044AbXEVF6W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 01:58:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Fix headers check fallout
has been removed from the -mm tree.  Its filename was
     fix-headers-check-fallout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix headers check fallout
From: Stephen Rothwell <sfr@canb.auug.org.au>

commit e8edc6e03a5c8562dc70a6d969f732bdb355a7e7 added an include of
linux/jiffies.h in linux/smb_fs.h outside the ifdef __KERNEL__.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smb_fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/smb_fs.h~fix-headers-check-fallout include/linux/smb_fs.h
--- a/include/linux/smb_fs.h~fix-headers-check-fallout
+++ a/include/linux/smb_fs.h
@@ -9,7 +9,6 @@
 #ifndef _LINUX_SMB_FS_H
 #define _LINUX_SMB_FS_H
 
-#include <linux/jiffies.h>
 #include <linux/smb.h>
 
 /*
@@ -30,6 +29,7 @@
 #include <linux/pagemap.h>
 #include <linux/vmalloc.h>
 #include <linux/smb_mount.h>
+#include <linux/jiffies.h>
 #include <asm/unaligned.h>
 
 static inline struct smb_sb_info *SMB_SB(struct super_block *sb)
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch

From: akpm@linux-foundation.org
Subject: - set-xip-mount-option-on-ext2-bypass-check.patch removed from -mm tree
Date: Mon, 25 Jun 2007 02:21:21 -0700
Message-ID: <200706250921.l5P9LLhH031089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51984 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751284AbXFYJYy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 05:24:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cotte@de.ibm.com, yanzheng@21cn.com, mm-commits@vger.kernel.org


The patch titled
     ext2: disallow setting xip on remount
has been removed from the -mm tree.  Its filename was
     set-xip-mount-option-on-ext2-bypass-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext2: disallow setting xip on remount
From: Carsten Otte <cotte@de.ibm.com>

Yan Zheng pointed out that ext2_remount lacks checking if -o xip should be
enabled or not.  This patch checks for presence of direct_access on the
backing block device and if the blocksize meets the requirements.

Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Cc: Yan Zheng <yanzheng@21cn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/super.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN fs/ext2/super.c~set-xip-mount-option-on-ext2-bypass-check fs/ext2/super.c
--- a/fs/ext2/super.c~set-xip-mount-option-on-ext2-bypass-check
+++ a/fs/ext2/super.c
@@ -1038,6 +1038,14 @@ static int ext2_remount (struct super_bl
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
 		((sbi->s_mount_opt & EXT2_MOUNT_POSIX_ACL) ? MS_POSIXACL : 0);
 
+	ext2_xip_verify_sb(sb); /* see if bdev supports xip, unset
+				    EXT2_MOUNT_XIP if not */
+
+	if ((ext2_use_xip(sb)) && (sb->s_blocksize != PAGE_SIZE)) {
+		printk("XIP: Unsupported blocksize\n");
+		goto restore_opts;
+	}
+
 	es = sbi->s_es;
 	if (((sbi->s_mount_opt & EXT2_MOUNT_XIP) !=
 	    (old_mount_opt & EXT2_MOUNT_XIP)) &&
_

Patches currently in -mm which might be from cotte@de.ibm.com are

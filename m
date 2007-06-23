From: akpm@linux-foundation.org
Subject: + set-xip-mount-option-on-ext2-bypass-check.patch added to -mm tree
Date: Sat, 23 Jun 2007 09:39:55 -0700
Message-ID: <200706231639.l5NGduiF019344@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38119 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753762AbXFWQkc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 12:40:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cotte@de.ibm.com, yanzheng@21cn.com


The patch titled
     ext2: disallow setting xip on remount
has been added to the -mm tree.  Its filename is
     set-xip-mount-option-on-ext2-bypass-check.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

set-xip-mount-option-on-ext2-bypass-check.patch

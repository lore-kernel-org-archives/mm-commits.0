From: akpm@linux-foundation.org
Subject: - fs_mbcache-dont-needlessly-make-it-built-in.patch removed from -mm tree
Date: Fri, 24 Oct 2008 12:40:53 -0700
Message-ID: <200810241940.m9OJer5v001011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752184AbYJXTlG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Oct 2008 15:41:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, agruen@suse.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     FS_MBCACHE: don't needlessly make it built-in
has been removed from the -mm tree.  Its filename was
     fs_mbcache-dont-needlessly-make-it-built-in.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: FS_MBCACHE: don't needlessly make it built-in
From: Adrian Bunk <bunk@kernel.org>

Assume you have:
- one or more of ext2/3/4 statically built into your kernel
- none of these with extended attributes enabled and
- want to add onother one of ext2/3/4 modular and with
  extended attributes enabled

then you currently have to reboot to use it since this results in
CONFIG_FS_MBCACHE=y.

That's not a common issue, but I just ran into it and since there's no
reason to get a built-in mbcache in this case this patch fixes it.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Andreas Gruenbacher <agruen@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/Kconfig~fs_mbcache-dont-needlessly-make-it-built-in fs/Kconfig
--- a/fs/Kconfig~fs_mbcache-dont-needlessly-make-it-built-in
+++ a/fs/Kconfig
@@ -270,9 +270,10 @@ config JBD2_DEBUG
 config FS_MBCACHE
 # Meta block cache for Extended Attributes (ext2/ext3/ext4)
 	tristate
-	depends on EXT2_FS_XATTR || EXT3_FS_XATTR || EXT4_FS_XATTR
-	default y if EXT2_FS=y || EXT3_FS=y || EXT4_FS=y
-	default m if EXT2_FS=m || EXT3_FS=m || EXT4_FS=m
+	default y if EXT2_FS=y && EXT2_FS_XATTR
+	default y if EXT3_FS=y && EXT3_FS_XATTR
+	default y if EXT4_FS=y && EXT4_FS_XATTR
+	default m if EXT2_FS_XATTR || EXT3_FS_XATTR || EXT4_FS_XATTR
 
 config REISERFS_FS
 	tristate "Reiserfs support"
_

Patches currently in -mm which might be from bunk@kernel.org are

linux-next.patch
m32r-kernel-smpbootc-must-include-linux-cpuh.patch
the-overdue-eepro100-removal.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
if-0-ses_match_host.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
reiser4.patch


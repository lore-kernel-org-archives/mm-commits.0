From: akpm@linux-foundation.org
Subject: + fs_mbcache-dont-needlessly-make-it-built-in.patch added to -mm tree
Date: Mon, 04 Aug 2008 16:09:09 -0700
Message-ID: <200808042309.m74N99rb004580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756974AbYHDXJl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 19:09:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, agruen@suse.de, viro@zeniv.linux.org.uk


The patch titled
     FS_MBCACHE: don't needlessly make it built-in
has been added to the -mm tree.  Its filename is
     fs_mbcache-dont-needlessly-make-it-built-in.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
-	depends on EXT2_FS_XATTR || EXT3_FS_XATTR || EXT4DEV_FS_XATTR
-	default y if EXT2_FS=y || EXT3_FS=y || EXT4DEV_FS=y
-	default m if EXT2_FS=m || EXT3_FS=m || EXT4DEV_FS=m
+	default y if EXT2_FS=y && EXT2_FS_XATTR
+	default y if EXT3_FS=y && EXT3_FS_XATTR
+	default y if EXT4DEV_FS=y && EXT4DEV_FS_XATTR
+	default m if EXT2_FS_XATTR || EXT3_FS_XATTR || EXT4DEV_FS_XATTR
 
 config REISERFS_FS
 	tristate "Reiserfs support"
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
mm_initc-avoid-ifdef-inside-macro-expansion.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
m32r-dont-offer-config_isa.patch
if-0-ses_match_host.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
git-xtensa.patch
uml-remove-the-dead-tty_log-code.patch
include-linux-kernelh-userspace-header-cleanup.patch
make-mm-rmapc-anon_vma_cachep-static.patch
reiser4.patch


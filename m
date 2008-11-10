From: akpm@linux-foundation.org
Subject: - fat-document-additional-vfat-mount-options.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:33:05 -0800
Message-ID: <200811102033.mAAKX5mg024278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751005AbYKJUe0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:34:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bart@jukie.net, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     fat: document additional vfat mount options
has been removed from the -mm tree.  Its filename was
     fat-document-additional-vfat-mount-options.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fat: document additional vfat mount options
From: Bart Trojanowski <bart@jukie.net>

While debugging a sync mount regression on vfat I noticed that there were
mount options parsed by the driver that were not documented.

[hirofumi@mail.parknet.co.jp: fix some parts]
Signed-off-by: Bart Trojanowski <bart@jukie.net>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/vfat.txt |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff -puN Documentation/filesystems/vfat.txt~fat-document-additional-vfat-mount-options Documentation/filesystems/vfat.txt
--- a/Documentation/filesystems/vfat.txt~fat-document-additional-vfat-mount-options
+++ a/Documentation/filesystems/vfat.txt
@@ -8,6 +8,12 @@ if you want to format from within Linux.
 
 VFAT MOUNT OPTIONS
 ----------------------------------------------------------------------
+uid=###       -- Set the owner of all files on this filesystem.
+		 The default is the uid of current process.
+
+gid=###       -- Set the group of all files on this filesystem.
+		 The default is the gid of current process.
+
 umask=###     -- The permission mask (for files and directories, see umask(1)).
                  The default is the umask of current process.
 
@@ -36,7 +42,7 @@ codepage=###  -- Sets the codepage numbe
 		 characters on FAT filesystem.
 		 By default, FAT_DEFAULT_CODEPAGE setting is used.
 
-iocharset=name -- Character set to use for converting between the
+iocharset=<name> -- Character set to use for converting between the
 		 encoding is used for user visible filename and 16 bit
 		 Unicode characters. Long filenames are stored on disk
 		 in Unicode format, but Unix for the most part doesn't
@@ -86,6 +92,8 @@ check=s|r|n   -- Case sensitivity checki
                  r: relaxed, case insensitive
                  n: normal, default setting, currently case insensitive
 
+nocase        -- This was deprecated for vfat. Use shortname=win95 instead.
+
 shortname=lower|win95|winnt|mixed
 	      -- Shortname display/create setting.
 		 lower: convert to lowercase for display,
@@ -99,11 +107,23 @@ shortname=lower|win95|winnt|mixed
 tz=UTC        -- Interpret timestamps as UTC rather than local time.
                  This option disables the conversion of timestamps
                  between local time (as used by Windows on FAT) and UTC
-                 (which Linux uses internally).  This is particuluarly
+                 (which Linux uses internally).  This is particularly
                  useful when mounting devices (like digital cameras)
                  that are set to UTC in order to avoid the pitfalls of
                  local time.
 
+showexec      -- If set, the execute permission bits of the file will be
+		 allowed only if the extension part of the name is .EXE,
+		 .COM, or .BAT. Not set by default.
+
+debug         -- Can be set, but unused by the current implementation.
+
+sys_immutable -- If set, ATTR_SYS attribute on FAT is handled as
+		 IMMUTABLE flag on Linux. Not set by default.
+
+flush         -- If set, the filesystem will try to flush to disk more
+		 early than normal. Not set by default.
+
 <bool>: 0,1,yes,no,true,false
 
 TODO
_

Patches currently in -mm which might be from bart@jukie.net are



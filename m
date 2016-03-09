From: akpm@linux-foundation.org
Subject: +
 fat-add-config-option-to-set-utf-8-mount-option-by-default.patch added to
 -mm tree
Date: Wed, 09 Mar 2016 13:12:46 -0800
Message-ID: <56e091ce.9db/33iuygmVhC9I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55310 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbcCIVMr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2016 16:12:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mail@maciej.szmigiero.name, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: add config option to set UTF-8 mount option by default
has been added to the -mm tree.  Its filename is
     fat-add-config-option-to-set-utf-8-mount-option-by-default.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fat-add-config-option-to-set-utf-8-mount-option-by-default.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fat-add-config-option-to-set-utf-8-mount-option-by-default.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: fat: add config option to set UTF-8 mount option by default

FAT has long supported its own default file name encoding config setting,
separate from CONFIG_NLS_DEFAULT.

However, if UTF-8 encoded file names are desired FAT character set should
not be set to utf8 since this would make file names case sensitive even if
case insensitive matching is requested.  Instead, "utf8" mount options
should be provided to enable UTF-8 file names in FAT file system.

Unfortunately, there was no possibility to set the default value of this
option so on UTF-8 system "utf8" mount option had to be added manually to
most FAT mounts.

This patch adds config option to set such default value.

Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/vfat.txt |    7 ++++---
 fs/fat/Kconfig                     |   18 +++++++++++++++++-
 fs/fat/inode.c                     |    4 +++-
 3 files changed, 24 insertions(+), 5 deletions(-)

diff -puN Documentation/filesystems/vfat.txt~fat-add-config-option-to-set-utf-8-mount-option-by-default Documentation/filesystems/vfat.txt
--- a/Documentation/filesystems/vfat.txt~fat-add-config-option-to-set-utf-8-mount-option-by-default
+++ a/Documentation/filesystems/vfat.txt
@@ -56,9 +56,10 @@ iocharset=<name> -- Character set to use
 		 you should consider the following option instead.
 
 utf8=<bool>   -- UTF-8 is the filesystem safe version of Unicode that
-		 is used by the console.  It can be enabled for the
-		 filesystem with this option. If 'uni_xlate' gets set,
-		 UTF-8 gets disabled.
+		 is used by the console. It can be enabled or disabled
+		 for the filesystem with this option.
+		 If 'uni_xlate' gets set, UTF-8 gets disabled.
+		 By default, FAT_DEFAULT_UTF8 setting is used.
 
 uni_xlate=<bool> -- Translate unhandled Unicode characters to special
 		 escaped sequences.  This would let you backup and
diff -puN fs/fat/Kconfig~fat-add-config-option-to-set-utf-8-mount-option-by-default fs/fat/Kconfig
--- a/fs/fat/Kconfig~fat-add-config-option-to-set-utf-8-mount-option-by-default
+++ a/fs/fat/Kconfig
@@ -93,8 +93,24 @@ config FAT_DEFAULT_IOCHARSET
 	  that most of your FAT filesystems use, and can be overridden
 	  with the "iocharset" mount option for FAT filesystems.
 	  Note that "utf8" is not recommended for FAT filesystems.
-	  If unsure, you shouldn't set "utf8" here.
+	  If unsure, you shouldn't set "utf8" here - select the next option
+	  instead if you would like to use UTF-8 encoded file names by default.
 	  See <file:Documentation/filesystems/vfat.txt> for more information.
 
 	  Enable any character sets you need in File Systems/Native Language
 	  Support.
+
+config FAT_DEFAULT_UTF8
+	bool "Enable FAT UTF-8 option by default"
+	depends on VFAT_FS
+	default n
+	help
+	  Set this if you would like to have "utf8" mount option set
+	  by default when mounting FAT filesystems.
+
+	  Even if you say Y here can always disable UTF-8 for
+	  particular mount by adding "utf8=0" to mount options.
+
+	  Say Y if you use UTF-8 encoding for file names, N otherwise.
+
+	  See <file:Documentation/filesystems/vfat.txt> for more information.
diff -puN fs/fat/inode.c~fat-add-config-option-to-set-utf-8-mount-option-by-default fs/fat/inode.c
--- a/fs/fat/inode.c~fat-add-config-option-to-set-utf-8-mount-option-by-default
+++ a/fs/fat/inode.c
@@ -1127,7 +1127,7 @@ static int parse_options(struct super_bl
 	}
 	opts->name_check = 'n';
 	opts->quiet = opts->showexec = opts->sys_immutable = opts->dotsOK =  0;
-	opts->utf8 = opts->unicode_xlate = 0;
+	opts->unicode_xlate = 0;
 	opts->numtail = 1;
 	opts->usefree = opts->nocase = 0;
 	opts->tz_set = 0;
@@ -1135,6 +1135,8 @@ static int parse_options(struct super_bl
 	opts->errors = FAT_ERRORS_RO;
 	*debug = 0;
 
+	opts->utf8 = IS_ENABLED(CONFIG_FAT_DEFAULT_UTF8) && is_vfat;
+
 	if (!options)
 		goto out;
 
_

Patches currently in -mm which might be from mail@maciej.szmigiero.name are

fat-add-config-option-to-set-utf-8-mount-option-by-default.patch


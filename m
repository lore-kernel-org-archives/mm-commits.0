From: akpm@linux-foundation.org
Subject: [patch 007/108] scripts/gen_initramfs_list.sh: teach
 INITRAMFS_ROOT_UID and INITRAMFS_ROOT_GID that -1 means "current user".
Date: Thu, 06 Jul 2017 15:35:43 -0700
Message-ID: <20170706223543.-zqkdJRpr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34376 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752683AbdGFWfo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:35:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, mmarek@suse.com, rob@landley.net, torvalds@linux-foundation.org

From: Rob Landley <rob@landley.net>
Subject: scripts/gen_initramfs_list.sh: teach INITRAMFS_ROOT_UID and INITRAMFS_ROOT_GID that -1 means "current user".

Teach INITRAMFS_ROOT_UID and INITRAMFS_ROOT_GID that -1 means "current user".

Link: http://lkml.kernel.org/r/2df3a9fb-4378-fa16-679d-99e788926c05@landley.net
Signed-off-by: Rob Landley <rob@landley.net>
Cc: Michal Marek <mmarek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gen_initramfs_list.sh |    2 ++
 usr/Kconfig                   |   12 ++++--------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff -puN scripts/gen_initramfs_list.sh~teach-initramfs_root_uid-and-initramfs_root_gid-that-1-means-current-user scripts/gen_initramfs_list.sh
--- a/scripts/gen_initramfs_list.sh~teach-initramfs_root_uid-and-initramfs_root_gid-that-1-means-current-user
+++ a/scripts/gen_initramfs_list.sh
@@ -271,10 +271,12 @@ while [ $# -gt 0 ]; do
 	case "$arg" in
 		"-u")	# map $1 to uid=0 (root)
 			root_uid="$1"
+			[ "$root_uid" = "-1" ] && root_uid=$(id -u || echo 0)
 			shift
 			;;
 		"-g")	# map $1 to gid=0 (root)
 			root_gid="$1"
+			[ "$root_gid" = "-1" ] && root_gid=$(id -g || echo 0)
 			shift
 			;;
 		"-d")	# display default initramfs list
diff -puN usr/Kconfig~teach-initramfs_root_uid-and-initramfs_root_gid-that-1-means-current-user usr/Kconfig
--- a/usr/Kconfig~teach-initramfs_root_uid-and-initramfs_root_gid-that-1-means-current-user
+++ a/usr/Kconfig
@@ -36,10 +36,8 @@ config INITRAMFS_ROOT_UID
 	depends on INITRAMFS_SOURCE!=""
 	default "0"
 	help
-	  This setting is only meaningful if the INITRAMFS_SOURCE is
-	  contains a directory.  Setting this user ID (UID) to something
-	  other than "0" will cause all files owned by that UID to be
-	  owned by user root in the initial ramdisk image.
+	  If INITRAMFS_SOURCE points to a directory, files owned by this UID
+	  (-1 = current user) will be owned by root in the resulting image.
 
 	  If you are not sure, leave it set to "0".
 
@@ -48,10 +46,8 @@ config INITRAMFS_ROOT_GID
 	depends on INITRAMFS_SOURCE!=""
 	default "0"
 	help
-	  This setting is only meaningful if the INITRAMFS_SOURCE is
-	  contains a directory.  Setting this group ID (GID) to something
-	  other than "0" will cause all files owned by that GID to be
-	  owned by group root in the initial ramdisk image.
+	  If INITRAMFS_SOURCE points to a directory, files owned by this GID
+	  (-1 = current group) will be owned by root in the resulting image.
 
 	  If you are not sure, leave it set to "0".
 
_

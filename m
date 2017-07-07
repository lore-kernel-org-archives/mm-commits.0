From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?teach-initramfs=5Froot=5Fuid-and-initramfs=5Froot=5Fgid-tha?=
 =?US-ASCII?Q?t-1-means-current-user.patch?= removed from -mm tree
Date: Fri, 07 Jul 2017 12:07:16 -0700
Message-ID: <20170707190716.J-sNh3wJr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60562 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751438AbdGGTHR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:07:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mmarek@suse.com, rob@landley.net


The patch titled
     Subject: scripts/gen_initramfs_list.sh: teach INITRAMFS_ROOT_UID and INITRAMFS_ROOT_GID that -1 means "current user".
has been removed from the -mm tree.  Its filename was
     teach-initramfs_root_uid-and-initramfs_root_gid-that-1-means-current-user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from rob@landley.net are



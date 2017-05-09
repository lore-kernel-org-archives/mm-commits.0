From: akpm@linux-foundation.org
Subject: +
 teach-initramfs_root_uid-and-initramfs_root_gid-that-1-means-current-user.patch added to -mm tree
Date: Tue, 09 May 2017 14:32:46 -0700
Message-ID: <5912357e.4CosBVPU2XPtWi6Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58888 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750803AbdEIVcr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 17:32:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob@landley.net, mmarek@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gen_initramfs_list.sh: teach INITRAMFS_ROOT_UID and INITRAMFS_ROOT_GID that -1 means "current user".
has been added to the -mm tree.  Its filename is
     teach-initramfs_root_uid-and-initramfs_root_gid-that-1-means-current-user.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/teach-initramfs_root_uid-and-initramfs_root_gid-that-1-means-current-user.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/teach-initramfs_root_uid-and-initramfs_root_gid-that-1-means-current-user.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

teach-initramfs_root_uid-and-initramfs_root_gid-that-1-means-current-user.patch


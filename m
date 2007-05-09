From: akpm@linux-foundation.org
Subject: + add-support-for-squashing-uid-gid-in-gen_initramfs_listsh.patch added to -mm tree
Date: Wed, 09 May 2007 13:46:09 -0700
Message-ID: <200705092046.l49Kk9il000658@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754732AbXEIUqN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 16:46:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, sam@ravnborg.org


The patch titled
     add support for squashing uid/gid in gen_initramfs_list.sh
has been added to the -mm tree.  Its filename is
     add-support-for-squashing-uid-gid-in-gen_initramfs_listsh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add support for squashing uid/gid in gen_initramfs_list.sh
From: Mike Frysinger <vapier@gentoo.org>

Sometimes it is useful to squash all uid's/gid's to 0:0 regardless of
current owner.  For example, in build systems that get run as arbitrary
users (uClinux-dist).  This adds a special "squash" keyword so you can do
'-g squash -u squash' and have ownership squashed to root.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gen_initramfs_list.sh |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff -puN scripts/gen_initramfs_list.sh~add-support-for-squashing-uid-gid-in-gen_initramfs_listsh scripts/gen_initramfs_list.sh
--- a/scripts/gen_initramfs_list.sh~add-support-for-squashing-uid-gid-in-gen_initramfs_listsh
+++ a/scripts/gen_initramfs_list.sh
@@ -19,11 +19,11 @@ $0 [-o <file>] [-u <uid>] [-g <gid>] {-d
 	-o <file>      Create gzipped initramfs file named <file> using
 		       gen_init_cpio and gzip
 	-u <uid>       User ID to map to user ID 0 (root).
-		       <uid> is only meaningful if <cpio_source>
-		       is a directory.
+		       <uid> is only meaningful if <cpio_source> is a
+		       directory.  "squash" forces all files to uid 0.
 	-g <gid>       Group ID to map to group ID 0 (root).
-		       <gid> is only meaningful if <cpio_source>
-		       is a directory.
+		       <gid> is only meaningful if <cpio_source> is a
+		       directory.  "squash" forces all files to gid 0.
 	<cpio_source>  File list or directory for cpio archive.
 		       If <cpio_source> is a .cpio file it will be used
 		       as direct input to initramfs.
@@ -113,8 +113,8 @@ parse() {
 	local gid="$4"
 	local ftype=$(filetype "${location}")
 	# remap uid/gid to 0 if necessary
-	[ "$uid" -eq "$root_uid" ] && uid=0
-	[ "$gid" -eq "$root_gid" ] && gid=0
+	[ "$root_uid" = "squash" ] && uid=0 || [ "$uid" -eq "$root_uid" ] && uid=0
+	[ "$root_gid" = "squash" ] && gid=0 || [ "$gid" -eq "$root_gid" ] && gid=0
 	local str="${mode} ${uid} ${gid}"
 
 	[ "${ftype}" == "invalid" ] && return 0
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
add-support-for-reading-stdin-with-gen_init_cpio.patch
add-support-for-squashing-uid-gid-in-gen_initramfs_listsh.patch
dont-force-uclinux-mtd-map-to-be-root-dev.patch

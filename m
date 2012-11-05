From: akpm@linux-foundation.org
Subject: [nacked] documentation-update-nfs-option-in-filesystem-vfattxt.patch removed from -mm tree
Date: Mon, 05 Nov 2012 12:07:04 -0800
Message-ID: <20121105200705.25D865C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:35253 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab2KEUHH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2012 15:07:07 -0500
Received: by mail-lb0-f202.google.com with SMTP id l12so403142lbo.1
        for <mm-commits@vger.kernel.org>; Mon, 05 Nov 2012 12:07:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namjae.jeon@samsung.com, a.sahrawat@samsung.com, bfields@fieldses.org, hirofumi@mail.parknet.co.jp, ravi.n1@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: update nfs option in filesystem/vfat.txt
has been removed from the -mm tree.  Its filename was
     documentation-update-nfs-option-in-filesystem-vfattxt.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: Documentation: update nfs option in filesystem/vfat.txt

Update nfs option in filesystem/vfat.txt

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/vfat.txt |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff -puN Documentation/filesystems/vfat.txt~documentation-update-nfs-option-in-filesystem-vfattxt Documentation/filesystems/vfat.txt
--- a/Documentation/filesystems/vfat.txt~documentation-update-nfs-option-in-filesystem-vfattxt
+++ a/Documentation/filesystems/vfat.txt
@@ -141,12 +141,25 @@ discard       -- If set, issues discard/
 		 device when blocks are freed. This is useful for SSD devices
 		 and sparse/thinly-provisoned LUNs.
 
-nfs           -- This option maintains an index (cache) of directory
+nfs= stale_rw|nostale_ro
+	      -- Enable this only if you want to export the FAT filesystem
+		 over NFS
+
+		 stale_rw:This option maintains an index (cache) of directory
 		 inodes by i_logstart which is used by the nfs-related code to
-		 improve look-ups.
+		 improve look-ups.Full file operations (read/write) over NFS is supported
+		 but with cache eviction at NFS server, this could result in ESTALE issues.
 
-		 Enable this only if you want to export the FAT filesystem
-		 over NFS
+		 nostale_ro:This option bases the inode number and filehandle on the on-disk
+		 location of a file in the MS-DOS directory entry.This ensures that ESTALE
+		 will not be returned after a file is evicted from the inode cache. However,
+		 it means that operations such as rename, create and unlink could cause
+		 filehandles that previously pointed at one file to point at a different file,
+		 potentially causing data corruption. For this reason, this option also mounts
+		 the filesystem readonly.
+
+		 To maintain backward compatibility, '-o nfs' is also accepted, defaulting to
+		 stale_rw
 
 <bool>: 0,1,yes,no,true,false
 
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

fat-remove-parent_logstart-check-in-fat_get_parent.patch
fat-restructure-export-operations.patch
fat-move-fat_i_pos_read-to-fath.patch
fat-exportfs-move-code-to-rebuild-directory-inode-to-separate-function.patch
fat-add-mutex-lock-to-fat_build_inode.patch


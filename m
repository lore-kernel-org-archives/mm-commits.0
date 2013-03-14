From: akpm@linux-foundation.org
Subject: + documentation-update-nfs-option-in-filesystem-vfattxt.patch added to -mm tree
Date: Thu, 14 Mar 2013 14:36:46 -0700
Message-ID: <20130314213646.D3D195A421B@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:60974 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab3CNVgs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 17:36:48 -0400
Received: by mail-yh0-f74.google.com with SMTP id z6so276915yhz.3
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 14:36:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namjae.jeon@samsung.com, a.sahrawat@samsung.com, hirofumi@mail.parknet.co.jp, ravi.n1@samsung.com, rob@landley.net


The patch titled
     Subject: Documentation: update nfs option in filesystem/vfat.txt
has been added to the -mm tree.  Its filename is
     documentation-update-nfs-option-in-filesystem-vfattxt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: Documentation: update nfs option in filesystem/vfat.txt

Add descriptions about 'stale_rw' and 'nostale_ro' nfs options in
filesystem/vfat.txt

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Acked-by: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/vfat.txt |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff -puN Documentation/filesystems/vfat.txt~documentation-update-nfs-option-in-filesystem-vfattxt Documentation/filesystems/vfat.txt
--- a/Documentation/filesystems/vfat.txt~documentation-update-nfs-option-in-filesystem-vfattxt
+++ a/Documentation/filesystems/vfat.txt
@@ -150,12 +150,28 @@ discard       -- If set, issues discard/
 		 device when blocks are freed. This is useful for SSD devices
 		 and sparse/thinly-provisoned LUNs.
 
-nfs           -- This option maintains an index (cache) of directory
-		 inodes by i_logstart which is used by the nfs-related code to
-		 improve look-ups.
+nfs=stale_rw|nostale_ro
+		Enable this only if you want to export the FAT filesystem
+		over NFS.
+
+		stale_rw: This option maintains an index (cache) of directory
+		inodes by i_logstart which is used by the nfs-related code to
+		improve look-ups. Full file operations (read/write) over NFS is
+		supported but with cache eviction at NFS server, this could
+		result in ESTALE issues.
+
+		nostale_ro: This option bases the inode number and filehandle
+		on the on-disk location of a file in the MS-DOS directory entry.
+		This ensures that ESTALE will not be returned after a file is
+		evicted from the inode cache. However, it means that operations
+		such as rename, create and unlink could cause filehandles that
+		previously pointed at one file to point at a different file,
+		potentially causing data corruption. For this reason, this
+		option also mounts the filesystem readonly.
+
+		To maintain backward compatibility, '-o nfs' is also accepted,
+		defaulting to stale_rw
 
-		 Enable this only if you want to export the FAT filesystem
-		 over NFS
 
 <bool>: 0,1,yes,no,true,false
 
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

linux-next.patch
fat-introduce-2-new-values-for-the-o-nfs-mount-option.patch
fat-move-fat_i_pos_read-to-fath.patch
fat-introduce-a-helper-fat_get_blknr_offset.patch
fat-restructure-export_operations.patch
fat-exportfs-rebuild-inode-if-ilookup-fails.patch
fat-exportfs-rebuild-directory-inode-if-fat_dget.patch
documentation-update-nfs-option-in-filesystem-vfattxt.patch


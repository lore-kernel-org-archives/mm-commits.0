From: akpm@linux-foundation.org
Subject: [merged] documentation-update-nfs-option-in-filesystem-vfattxt.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:01:56 -0700
Message-ID: <20130430190156.816145A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:60448 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933296Ab3D3TB5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:01:57 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so87394ggm.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:01:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namjae.jeon@samsung.com, a.sahrawat@samsung.com, hirofumi@mail.parknet.co.jp, ravi.n1@samsung.com, rob@landley.net, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: update nfs option in filesystem/vfat.txt
has been removed from the -mm tree.  Its filename was
     documentation-update-nfs-option-in-filesystem-vfattxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-fix.patch


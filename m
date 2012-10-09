From: akpm@linux-foundation.org
Subject: + documentation-update-nfs-option-in-filesystem-vfattxt.patch added to -mm tree
Date: Tue, 09 Oct 2012 14:59:34 -0700
Message-ID: <20121009215935.1AEB220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:51010 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab2JIV7i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 17:59:38 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so317580lah.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 14:59:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namjae.jeon@samsung.com, a.sahrawat@samsung.com, bfields@fieldses.org, hirofumi@mail.parknet.co.jp, ravi.n1@samsung.com


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

fat-modify-nfs-mount-option.patch
fat-exportfs-rebuild-inode-if-ilookup-fails.patch
fat-exportfs-rebuild-directory-inode-if-fat_dget-fails.patch
documentation-update-nfs-option-in-filesystem-vfattxt.patch


From: akpm@linux-foundation.org
Subject: [patch 22/96] bfs: fix sanity checks for empty files
Date: Wed, 12 Jul 2017 14:34:07 -0700
Message-ID: <20170712213407.8-nEy1WHM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53348 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754555AbdGLVeN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:34:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aivazian.tigran@gmail.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org, rakesh@tuxera.com, torvalds@linux-foundation.org

From: Rakesh Pandit <rakesh@tuxera.com>
Subject: bfs: fix sanity checks for empty files

Mount fails if file system image has empty files because of sanity check
while reading superblock.  For empty files disk offset to end of file
(i_eoffset) is cpu_to_le32(-1).  Sanity check comparison, which compares
disk offset with file system size isn't valid for this value and hence is
ignored with this patch.

Steps to reproduce:

$  dd if=/dev/zero of=bfs-image count=204800
$  mkfs.bfs bfs-image
$  mkdir bfs-mount-point
$  sudo mount -t bfs -o loop bfs-image bfs-mount-point/
$  cd bfs-mount-point/
$  sudo touch a
$  cd ..
$  sudo umount bfs-mount-point/
$  sudo mount -t bfs -o loop bfs-image bfs-mount-point/
mount: /dev/loop0: can't read superblock

$  dmesg
[25526.689580] BFS-fs: bfs_fill_super(): Inode 0x00000003 corrupted

Tigran said:

: If you had created the filesystem with the proper mkfs under SCO UnixWare
: 7 you (probably) wouldn't encounter this issue.  But since commercial
: Unix-es are now part of history and the only proper way is the Linux
: mkfs.bfs utility, your patch is fine.

Link: http://lkml.kernel.org/r/20170505201625.GA3097@hercules.tuxera.com
Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
Acked-by: Tigran Aivazian <aivazian.tigran@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/bfs/inode.c~bfs-fix-sanity-checks-for-empty-files fs/bfs/inode.c
--- a/fs/bfs/inode.c~bfs-fix-sanity-checks-for-empty-files
+++ a/fs/bfs/inode.c
@@ -419,7 +419,7 @@ static int bfs_fill_super(struct super_b
 		if (i_sblock > info->si_blocks ||
 			i_eblock > info->si_blocks ||
 			i_sblock > i_eblock ||
-			i_eoff > s_size ||
+			(i_eoff != le32_to_cpu(-1) && i_eoff > s_size) ||
 			i_sblock * BFS_BSIZE > i_eoff) {
 
 			printf("Inode 0x%08x corrupted\n", i);
_

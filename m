From: akpm@linux-foundation.org
Subject: + bfs-fix-sanity-checks-for-empty-files.patch added to -mm tree
Date: Tue, 09 May 2017 14:00:52 -0700
Message-ID: <59122e04.bDYwSXDABJLBy4p1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56474 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbdEIVAx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 17:00:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rakesh@tuxera.com, tigran@aivazian.fsnet.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: bfs: fix sanity checks for empty files
has been added to the -mm tree.  Its filename is
     bfs-fix-sanity-checks-for-empty-files.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bfs-fix-sanity-checks-for-empty-files.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bfs-fix-sanity-checks-for-empty-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
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

Patches currently in -mm which might be from rakesh@tuxera.com are

bfs-fix-sanity-checks-for-empty-files.patch


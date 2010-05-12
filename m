From: akpm@linux-foundation.org
Subject: + ufs-permit-mounting-of-borderware-filesystems.patch added to -mm tree
Date: Wed, 12 May 2010 13:56:14 -0700
Message-ID: <201005122056.o4CKuE0X019869@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757305Ab0ELU4q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 16:56:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thomas@stewarts.org.uk, dushistov@mail.ru


The patch titled
     ufs: permit mounting of BorderWare filesystems
has been added to the -mm tree.  Its filename is
     ufs-permit-mounting-of-borderware-filesystems.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ufs: permit mounting of BorderWare filesystems
From: Thomas Stewart <thomas@stewarts.org.uk>

I recently had to recover some files from an old broken machine that was
running BorderWare Document Gateway.  It's basically a drop in web server
for sharing files.  From the look of the init process and using strings on
of a few files it seems to be based on FreeBSD 3.3.

The process turned out to be more difficult than I imagined, but to cut a
long story short BorderWare in their wisdom use a nonstandard magic number
in their UFS (ufstype=44bsd) file systems.  Thus Linux refuses to mount
the file systems in order to recover the data.  After a bit of hunting I
was able to make a quick fix to fs/ufs/super.c in order to detect the new
magic number.

I assume that this number is the same for all installations.  It's quite
easy to find out from ufs_fs.h.  The superblock sits 8k into the block
device and the magic number its 1372 bytes into the superblock struct.

# dd if=/dev/sda5 skip=$(( 8192 + 1372 )) bs=1 count=4 2> /dev/null | hd
00000000  97 26 24 0f                                       |.&$.|
#

Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c  |    2 ++
 fs/ufs/ufs_fs.h |    1 +
 2 files changed, 3 insertions(+)

diff -puN fs/ufs/super.c~ufs-permit-mounting-of-borderware-filesystems fs/ufs/super.c
--- a/fs/ufs/super.c~ufs-permit-mounting-of-borderware-filesystems
+++ a/fs/ufs/super.c
@@ -918,6 +918,7 @@ again:	
 	sbi->s_bytesex = BYTESEX_LE;
 	switch ((uspi->fs_magic = fs32_to_cpu(sb, usb3->fs_magic))) {
 		case UFS_MAGIC:
+		case UFS_MAGIC_BW:
 		case UFS2_MAGIC:
 		case UFS_MAGIC_LFN:
 	        case UFS_MAGIC_FEA:
@@ -927,6 +928,7 @@ again:	
 	sbi->s_bytesex = BYTESEX_BE;
 	switch ((uspi->fs_magic = fs32_to_cpu(sb, usb3->fs_magic))) {
 		case UFS_MAGIC:
+		case UFS_MAGIC_BW:
 		case UFS2_MAGIC:
 		case UFS_MAGIC_LFN:
 	        case UFS_MAGIC_FEA:
diff -puN fs/ufs/ufs_fs.h~ufs-permit-mounting-of-borderware-filesystems fs/ufs/ufs_fs.h
--- a/fs/ufs/ufs_fs.h~ufs-permit-mounting-of-borderware-filesystems
+++ a/fs/ufs/ufs_fs.h
@@ -48,6 +48,7 @@ typedef __u16 __bitwise __fs16;
 #define UFS_SECTOR_SIZE 512
 #define UFS_SECTOR_BITS 9
 #define UFS_MAGIC  0x00011954
+#define UFS_MAGIC_BW 0x0f242697
 #define UFS2_MAGIC 0x19540119
 #define UFS_CIGAM  0x54190100 /* byteswapped MAGIC */
 
_

Patches currently in -mm which might be from thomas@stewarts.org.uk are

ufs-permit-mounting-of-borderware-filesystems.patch


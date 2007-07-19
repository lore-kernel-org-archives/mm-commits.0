From: akpm@linux-foundation.org
Subject: + fs-mark-nibblemap-const.patch added to -mm tree
Date: Thu, 19 Jul 2007 16:40:03 -0700
Message-ID: <200707192340.l6JNe3C5028859@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44822 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755099AbXGSXkN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 19:40:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: phdm@macqel.be


The patch titled
     fs: mark nibblemap const
has been added to the -mm tree.  Its filename is
     fs-mark-nibblemap-const.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs: mark nibblemap const
From: Philippe De Muyter <phdm@macqel.be>

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/bitmap.c  |    2 +-
 fs/ext2/balloc.c  |    2 +-
 fs/ext3/bitmap.c  |    2 +-
 fs/ext4/bitmap.c  |    2 +-
 fs/minix/bitmap.c |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/affs/bitmap.c~fs-mark-nibblemap-const fs/affs/bitmap.c
--- a/fs/affs/bitmap.c~fs-mark-nibblemap-const
+++ a/fs/affs/bitmap.c
@@ -11,7 +11,7 @@
 
 /* This is, of course, shamelessly stolen from fs/minix */
 
-static int nibblemap[] = { 0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4 };
+static const int nibblemap[] = { 0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4 };
 
 static u32
 affs_count_free_bits(u32 blocksize, const void *data)
diff -puN fs/ext2/balloc.c~fs-mark-nibblemap-const fs/ext2/balloc.c
--- a/fs/ext2/balloc.c~fs-mark-nibblemap-const
+++ a/fs/ext2/balloc.c
@@ -522,7 +522,7 @@ io_error:
 
 #ifdef EXT2FS_DEBUG
 
-static int nibblemap[] = {4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1, 2, 1, 1, 0};
+static const int nibblemap[] = {4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1, 2, 1, 1, 0};
 
 unsigned long ext2_count_free (struct buffer_head * map, unsigned int numchars)
 {
diff -puN fs/ext3/bitmap.c~fs-mark-nibblemap-const fs/ext3/bitmap.c
--- a/fs/ext3/bitmap.c~fs-mark-nibblemap-const
+++ a/fs/ext3/bitmap.c
@@ -13,7 +13,7 @@
 
 #ifdef EXT3FS_DEBUG
 
-static int nibblemap[] = {4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1, 2, 1, 1, 0};
+static const int nibblemap[] = {4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1, 2, 1, 1, 0};
 
 unsigned long ext3_count_free (struct buffer_head * map, unsigned int numchars)
 {
diff -puN fs/ext4/bitmap.c~fs-mark-nibblemap-const fs/ext4/bitmap.c
--- a/fs/ext4/bitmap.c~fs-mark-nibblemap-const
+++ a/fs/ext4/bitmap.c
@@ -13,7 +13,7 @@
 
 #ifdef EXT4FS_DEBUG
 
-static int nibblemap[] = {4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1, 2, 1, 1, 0};
+static const int nibblemap[] = {4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1, 2, 1, 1, 0};
 
 unsigned long ext4_count_free (struct buffer_head * map, unsigned int numchars)
 {
diff -puN fs/minix/bitmap.c~fs-mark-nibblemap-const fs/minix/bitmap.c
--- a/fs/minix/bitmap.c~fs-mark-nibblemap-const
+++ a/fs/minix/bitmap.c
@@ -17,7 +17,7 @@
 #include <linux/bitops.h>
 #include <linux/sched.h>
 
-static int nibblemap[] = { 4,3,3,2,3,2,2,1,3,2,2,1,2,1,1,0 };
+static const int nibblemap[] = { 4,3,3,2,3,2,2,1,3,2,2,1,2,1,1,0 };
 
 static unsigned long count_free(struct buffer_head *map[], unsigned numblocks, __u32 numbits)
 {
_

Patches currently in -mm which might be from phdm@macqel.be are

origin.patch
git-mtd.patch
fs-mark-nibblemap-const.patch

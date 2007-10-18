From: akpm@linux-foundation.org
Subject: - fs-mark-nibblemap-const.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:53:14 -0700
Message-ID: <200710180653.l9I6rEIf030422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43361 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932148AbXJRHhw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:37:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: phdm@macqel.be, mm-commits@vger.kernel.org


The patch titled
     fs: mark nibblemap const
has been removed from the -mm tree.  Its filename was
     fs-mark-nibblemap-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

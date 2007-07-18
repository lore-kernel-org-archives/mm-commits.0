From: akpm@linux-foundation.org
Subject: + zisofs-use-mutex-instead-of-semaphore.patch added to -mm tree
Date: Wed, 18 Jul 2007 15:50:15 -0700
Message-ID: <200707182250.l6IMoFJc000606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54405 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756964AbXGRWuX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 18:50:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, hpa@zytor.com


The patch titled
     zisofs use mutex instead of semaphore
has been added to the -mm tree.  Its filename is
     zisofs-use-mutex-instead-of-semaphore.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: zisofs use mutex instead of semaphore
From: Dave Young <hidave.darkstar@gmail.com>

Use mutex instead of semaphore in fs/isofs/compress.c, and remove an
unnecessary variable.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/compress.c |   25 +++++--------------------
 1 files changed, 5 insertions(+), 20 deletions(-)

diff -puN fs/isofs/compress.c~zisofs-use-mutex-instead-of-semaphore fs/isofs/compress.c
--- a/fs/isofs/compress.c~zisofs-use-mutex-instead-of-semaphore
+++ a/fs/isofs/compress.c
@@ -33,7 +33,7 @@ static char zisofs_sink_page[PAGE_CACHE_
  * allocation; this avoids failures at block-decompression time.
  */
 static void *zisofs_zlib_workspace;
-static struct semaphore zisofs_zlib_semaphore;
+static DEFINE_MUTEX(zisofs_zlib_lock);
 
 /*
  * When decompressing, we typically obtain more than one page
@@ -180,9 +180,9 @@ static int zisofs_readpage(struct file *
 
 		/* First block is special since it may be fractional.
 		   We also wait for it before grabbing the zlib
-		   semaphore; odds are that the subsequent blocks are
+		   mutex; odds are that the subsequent blocks are
 		   going to come in in short order so we don't hold
-		   the zlib semaphore longer than necessary. */
+		   the zlib mutex longer than necessary. */
 
 		if ( !bh || (wait_on_buffer(bh), !buffer_uptodate(bh)) ) {
 			printk(KERN_DEBUG "zisofs: Hit null buffer, fpage = %d, xpage = %d, csize = %ld\n",
@@ -194,7 +194,7 @@ static int zisofs_readpage(struct file *
 		csize -= stream.avail_in;
 
 		stream.workspace = zisofs_zlib_workspace;
-		down(&zisofs_zlib_semaphore);
+		mutex_lock(&zisofs_zlib_lock);
 		
 		zerr = zlib_inflateInit(&stream);
 		if ( zerr != Z_OK ) {
@@ -281,7 +281,7 @@ static int zisofs_readpage(struct file *
 		zlib_inflateEnd(&stream);
 
 	z_eio:
-		up(&zisofs_zlib_semaphore);
+		mutex_unlock(&zisofs_zlib_lock);
 
 	b_eio:
 		for ( i = 0 ; i < haveblocks ; i++ ) {
@@ -317,31 +317,16 @@ const struct address_space_operations zi
 	/* No bmap operation supported */
 };
 
-static int initialized;
-
 int __init zisofs_init(void)
 {
-	if ( initialized ) {
-		printk("zisofs_init: called more than once\n");
-		return 0;
-	}
-
 	zisofs_zlib_workspace = vmalloc(zlib_inflate_workspacesize());
 	if ( !zisofs_zlib_workspace )
 		return -ENOMEM;
-	init_MUTEX(&zisofs_zlib_semaphore);
 
-	initialized = 1;
 	return 0;
 }
 
 void zisofs_cleanup(void)
 {
-	if ( !initialized ) {
-		printk("zisofs_cleanup: called without initialization\n");
-		return;
-	}
-
 	vfree(zisofs_zlib_workspace);
-	initialized = 0;
 }
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

origin.patch
x86-fix-iounmaps-use-of-vm_structs-size-field.patch
zisofs-use-mutex-instead-of-semaphore.patch

From: akpm@linux-foundation.org
Subject: + getblk-handle-2tb-devices-fix.patch added to -mm tree
Date: Fri, 09 Nov 2007 11:42:54 -0800
Message-ID: <200711091942.lA9Jgskf028964@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36382 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751220AbXKITnG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 14:43:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: deweerdt@free.fr, frederik.deweerdt@gmail.com


The patch titled
     fix getblk_slow "integer constant is too large" warning
has been added to the -mm tree.  Its filename is
     getblk-handle-2tb-devices-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix getblk_slow "integer constant is too large" warning
From: Frederik Deweerdt <deweerdt@free.fr>

On Tue, Nov 06, 2007 at 02:33:53AM -0800, akpm@linux-foundation.org wrote:
> The mm snapshot broken-out-2007-11-06-02-32.tar.gz has been uploaded to
>
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-11-06-02-32.tar.gz
>
> It contains the following patches against 2.6.24-rc1:
>
[...]
> getblk-handle-2tb-devices.patch
[...]
0xffffffff00000000 is unsigned long long on 32 bits
fs/buffer.c: In function '__getblk_slow':
fs/buffer.c:1126: warning: integer constant is too large for 'unsigned long' type

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/buffer.c~getblk-handle-2tb-devices-fix fs/buffer.c
--- a/fs/buffer.c~getblk-handle-2tb-devices-fix
+++ a/fs/buffer.c
@@ -1123,7 +1123,7 @@ __getblk_slow(struct block_device *bdev,
 
 #if (BITS_PER_LONG == 32) && defined(CONFIG_LBD)
 	if ((block >> (PAGE_CACHE_SHIFT - bdev->bd_inode->i_blkbits)) &
-			0xffffffff00000000UL) {
+			0xffffffff00000000ULL) {
 		/*
 		 * We'll fail because the block is outside the range
 		 * which a 32-bit pagecache index can address
_

Patches currently in -mm which might be from deweerdt@free.fr are

revoke-core-code.patch
reiser4-sb_sync_inodes.patch
getblk-handle-2tb-devices-fix.patch

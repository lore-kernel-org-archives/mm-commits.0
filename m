From: akpm@linux-foundation.org
Subject: + deny-partial-write-for-loop-dev-fd.patch added to -mm tree
Date: Fri, 13 Jul 2007 00:59:00 -0700
Message-ID: <200707130759.l6D7x0Xc006724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49524 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758071AbXGMH7o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 03:59:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@sw.ru, dmonakhov@openvz.org, nickpiggin@yahoo.com.au


The patch titled
     deny partial write for loop dev fd
has been added to the -mm tree.  Its filename is
     deny-partial-write-for-loop-dev-fd.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: deny partial write for loop dev fd
From: Dmitry Monakhov <dmonakhov@sw.ru>

Partial write can be easily supported by LO_CRYPT_NONE mode, but it is not
easy in LO_CRYPT_CRYPTOAPI case, because of its block nature.  I don't know
who still used cryptoapi, but theoretically it is possible.  So let's leave
things as they are.  Loop device doesn't support partial write before
Nick's "write_begin/write_end" patch set, and let's it behave the same way
after.

Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/block/loop.c~deny-partial-write-for-loop-dev-fd drivers/block/loop.c
--- a/drivers/block/loop.c~deny-partial-write-for-loop-dev-fd
+++ a/drivers/block/loop.c
@@ -244,10 +244,8 @@ static int do_lo_send_aops(struct loop_d
 
 		ret = pagecache_write_end(file, mapping, pos, size, copied,
 							page, fsdata);
-		if (ret < 0)
+		if (ret < 0 || ret != copied)
 			goto fail;
-		if (ret < copied)
-			copied = ret;
 
 		if (unlikely(transfer_result))
 			goto fail;
_

Patches currently in -mm which might be from dmonakhov@sw.ru are

mspec_mmap-dont-set-vm_locked.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
deny-partial-write-for-loop-dev-fd.patch
ext3-convert-to-new-aops-fix.patch
ext4-convert-to-new-aops-fix.patch

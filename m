From: akpm@linux-foundation.org
Subject: + eliminate-warnings-in-ide-tapec.patch added to -mm tree
Date: Mon, 30 Jul 2007 18:17:01 -0700
Message-ID: <200707310117.l6V1H1m3007959@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55800 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755146AbXGaBRO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 21:17:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au


The patch titled
     Eliminate warnings in ide-tape.c
has been added to the -mm tree.  Its filename is
     eliminate-warnings-in-ide-tapec.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Eliminate warnings in ide-tape.c
From: Stephen Rothwell <sfr@canb.auug.org.au>

drivers/ide/ide-tape.c: In function '__idetape_kmalloc_stage':
drivers/ide/ide-tape.c:2588: warning: large integer implicitly truncated to unsigned type
drivers/ide/ide-tape.c:2616: warning: large integer implicitly truncated to unsigned type

b_size in struct idetape_bh is an unsigned short.  We sometimes assign
PAGE_SIZE to it and PAGE_SIZE can be 64K or larger, so make it a u32.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/ide-tape.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ide/ide-tape.c~eliminate-warnings-in-ide-tapec drivers/ide/ide-tape.c
--- a/drivers/ide/ide-tape.c~eliminate-warnings-in-ide-tapec
+++ a/drivers/ide/ide-tape.c
@@ -640,7 +640,7 @@ typedef enum {
 } idetape_chrdev_direction_t;
 
 struct idetape_bh {
-	unsigned short b_size;
+	u32 b_size;
 	atomic_t b_count;
 	struct idetape_bh *b_reqnext;
 	char *b_data;
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
arch-i386-kernel-apmc-apm_init-warning-fix.patch
git-alsa.patch
eliminate-warnings-in-ide-tapec.patch
clean-up-duplicate-includes-in-drivers-block.patch

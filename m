From: akpm@linux-foundation.org
Subject: - eliminate-warnings-in-ide-tapec.patch removed from -mm tree
Date: Mon, 06 Aug 2007 00:43:57 -0700
Message-ID: <200708060743.l767hvqC015968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36663 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758583AbXHFHok (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 03:44:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Eliminate warnings in ide-tape.c
has been removed from the -mm tree.  Its filename was
     eliminate-warnings-in-ide-tapec.patch

This patch was dropped because it was sent to Bart, then dropped

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

git-alsa.patch
eliminate-warnings-in-ide-tapec.patch
clean-up-duplicate-includes-in-drivers-block.patch

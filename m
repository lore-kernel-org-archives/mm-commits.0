From: akpm@linux-foundation.org
Subject: - fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch removed from -mm tree
Date: Sun, 21 Oct 2007 16:47:51 -0700
Message-ID: <200710212347.l9LNlppB000679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40505 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753109AbXJUXzZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 19:55:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, edward@namesys.com, vs@namesys.com, mm-commits@vger.kernel.org


The patch titled
     fs/reiser4/ktxnmgrd.c: kmalloc + memset conversion to kzalloc
has been removed from the -mm tree.  Its filename was
     fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: fs/reiser4/ktxnmgrd.c: kmalloc + memset conversion to kzalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 fs/reiser4/ktxnmgrd.c | 5314 -> 5277 (-37 bytes)
 fs/reiser4/ktxnmgrd.o | 131624 -> 131496 (-128 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Edward Shishkin <edward@namesys.com>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/ktxnmgrd.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/reiser4/ktxnmgrd.c~fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc fs/reiser4/ktxnmgrd.c
--- a/fs/reiser4/ktxnmgrd.c~fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc
+++ a/fs/reiser4/ktxnmgrd.c
@@ -130,13 +130,12 @@ int reiser4_init_ktxnmgrd(struct super_b
 
 	assert("zam-1014", mgr->daemon == NULL);
 
-	ctx = kmalloc(sizeof(ktxnmgrd_context), reiser4_ctx_gfp_mask_get());
-	if (ctx == NULL)
+	ctx = kzalloc(sizeof(ktxnmgrd_context), reiser4_ctx_gfp_mask_get());
+	if (!ctx)
 		return RETERR(-ENOMEM);
 
 	assert("nikita-2442", ctx != NULL);
 
-	memset(ctx, 0, sizeof *ctx);
 	init_waitqueue_head(&ctx->wait);
 
 	/*kcond_init(&ctx->startup);*/
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
reiser4.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch

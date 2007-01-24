From: akpm@osdl.org
Subject: + buffer-memorder-fix.patch added to -mm tree
Date: Wed, 24 Jan 2007 01:03:15 -0800
Message-ID: <200701240903.l0O93F9e013391@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58635 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030264AbXAXJDV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 04:03:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     buffer: memorder fix
has been added to the -mm tree.  Its filename is
     buffer-memorder-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: buffer: memorder fix
From: Nick Piggin <npiggin@suse.de>

unlock_buffer(), like unlock_page(), must not clear the lock without
ensuring that the critical section is closed.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/buffer.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/buffer.c~buffer-memorder-fix fs/buffer.c
--- a/fs/buffer.c~buffer-memorder-fix
+++ a/fs/buffer.c
@@ -70,6 +70,7 @@ EXPORT_SYMBOL(__lock_buffer);
 
 void fastcall unlock_buffer(struct buffer_head *bh)
 {
+	smp_mb__before_clear_bit();
 	clear_buffer_locked(bh);
 	smp_mb__after_clear_bit();
 	wake_up_bit(&bh->b_state, BH_Lock);
_

Patches currently in -mm which might be from npiggin@suse.de are

git-block.patch
buffer-memorder-fix.patch
sched-avoid-div-in-rebalance_tick.patch

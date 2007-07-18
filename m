From: akpm@linux-foundation.org
Subject: + make-timerfd-return-a-u64-and-fix-the-__put_user.patch added to -mm tree
Date: Tue, 17 Jul 2007 17:05:39 -0700
Message-ID: <200707180005.l6I05doq014605@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48446 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751926AbXGRAFu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 20:05:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org, davi@haxent.com.br, mtk-manpages@gmx.net


The patch titled
     make timerfd return a u64 and fix the __put_user
has been added to the -mm tree.  Its filename is
     make-timerfd-return-a-u64-and-fix-the-__put_user.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make timerfd return a u64 and fix the __put_user
From: Davide Libenzi <davidel@xmailserver.org>

Davi fixed a missing cast in the __put_user(), that was making timerfd
return a single byte instead of the full value.

Talking with Michael about the timerfd man page, we think it'd be better to
use a u64 for the returned value, to align it with the eventfd
implementation.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Davi Arnaut <davi@haxent.com.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/timerfd.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/timerfd.c~make-timerfd-return-a-u64-and-fix-the-__put_user fs/timerfd.c
--- a/fs/timerfd.c~make-timerfd-return-a-u64-and-fix-the-__put_user
+++ a/fs/timerfd.c
@@ -95,7 +95,7 @@ static ssize_t timerfd_read(struct file 
 {
 	struct timerfd_ctx *ctx = file->private_data;
 	ssize_t res;
-	u32 ticks = 0;
+	u64 ticks = 0;
 	DECLARE_WAITQUEUE(wait, current);
 
 	if (count < sizeof(ticks))
@@ -130,7 +130,7 @@ static ssize_t timerfd_read(struct file 
 			 * callback to avoid DoS attacks specifying a very
 			 * short timer period.
 			 */
-			ticks = (u32)
+			ticks = (u64)
 				hrtimer_forward(&ctx->tmr,
 						hrtimer_cb_get_time(&ctx->tmr),
 						ctx->tintv);
@@ -140,7 +140,7 @@ static ssize_t timerfd_read(struct file 
 	}
 	spin_unlock_irq(&ctx->wqh.lock);
 	if (ticks)
-		res = put_user(ticks, buf) ? -EFAULT: sizeof(ticks);
+		res = put_user(ticks, (u64 __user *) buf) ? -EFAULT: sizeof(ticks);
 	return res;
 }
 
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
git-kvm.patch
make-timerfd-return-a-u64-and-fix-the-__put_user.patch

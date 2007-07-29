From: akpm@linux-foundation.org
Subject: - make-timerfd-return-a-u64-and-fix-the-__put_user.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:11:48 -0700
Message-ID: <200707290611.l6T6BmPe011007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39116 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757307AbXG2GMH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:12:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, davi@haxent.com.br, mtk-manpages@gmx.net, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     make timerfd return a u64 and fix the __put_user
has been removed from the -mm tree.  Its filename was
     make-timerfd-return-a-u64-and-fix-the-__put_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: make timerfd return a u64 and fix the __put_user
From: Davide Libenzi <davidel@xmailserver.org>

Davi fixed a missing cast in the __put_user(), that was making timerfd
return a single byte instead of the full value.

Talking with Michael about the timerfd man page, we think it'd be better to
use a u64 for the returned value, to align it with the eventfd
implementation.

This is an ABI change.  The timerfd code is new in 2.6.22 and if we merge this
into 2.6.23 then we should also merge it into 2.6.22.x.  That will leave a few
early 2.6.22 kernels out in the wild which might misbehave when a future
timerfd-enabled glibc is run on them.

mtk says: The difference would be that read() will only return 4 bytes, while
the application will expect 8.  If the application is checking the size of
returned value, as it should, then it will be able to detect the problem (it
could even be sophisticated enough to know that if this is a 4-byte return,
then it is running on an old 2.6.22 kernel).  If the application is not
checking the return from read(), then its 8-byte buffer will not be filled --
the contents of the last 4 bytes will be undefined, so the u64 value as a
whole will be junk.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Davi Arnaut <davi@haxent.com.br>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/timerfd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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
anon_inodes-shouldnt-be-user-visible.patch
do_sys_poll-simplify-playing-with-on-stack-data.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
do_poll-return-eintr-when-signalled.patch

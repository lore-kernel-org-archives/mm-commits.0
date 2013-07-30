From: akpm@linux-foundation.org
Subject: [to-be-updated] relay-fix-timer-madness-v2.patch removed from -mm tree
Date: Tue, 30 Jul 2013 15:44:02 -0700
Message-ID: <51f841b2.3lXPDuvYvEQrBkm7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3G3WoD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jul 2013 18:44:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, rostedt@goodmis.org, mingo@elte.hu, edumazet@google.com, axboe@kernel.dk, jovi.zhangwei@huawei.com

Subject: [to-be-updated] relay-fix-timer-madness-v2.patch removed from -mm tree
To: jovi.zhangwei@huawei.com,axboe@kernel.dk,edumazet@google.com,mingo@elte.hu,rostedt@goodmis.org,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 30 Jul 2013 15:44:02 -0700


The patch titled
     Subject: relay-fix-timer-madness-v2
has been removed from the -mm tree.  Its filename was
     relay-fix-timer-madness-v2.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: relay-fix-timer-madness-v2

Changed from v1:
mod timer interval changed from jiffies+1 to HZ/10, as Ingo suggested.

Signed-off-by: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/relay.c~relay-fix-timer-madness-v2 kernel/relay.c
--- a/kernel/relay.c~relay-fix-timer-madness-v2
+++ a/kernel/relay.c
@@ -342,7 +342,7 @@ static void wakeup_readers(unsigned long
 	/*
 	 * Stupid polling for now:
 	 */
-	mod_timer(&buf->timer, jiffies + 1);
+	mod_timer(&buf->timer, HZ / 10);
 }
 
 /**
@@ -360,7 +360,7 @@ static void __relay_reset(struct rchan_b
 		init_waitqueue_head(&buf->read_wait);
 		kref_init(&buf->kref);
 		setup_timer(&buf->timer, wakeup_readers, (unsigned long)buf);
-		mod_timer(&buf->timer, jiffies + 1);
+		mod_timer(&buf->timer, HZ / 10);
 	} else
 		del_timer_sync(&buf->timer);
 
_

Patches currently in -mm which might be from jovi.zhangwei@huawei.com are



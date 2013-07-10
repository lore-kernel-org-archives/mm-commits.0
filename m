From: akpm@linux-foundation.org
Subject: + relay-fix-timer-madness-v2.patch added to -mm tree
Date: Wed, 10 Jul 2013 15:23:03 -0700
Message-ID: <51dddec7.K3TbNwW5PuwqGLDb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55716 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab3GJWXE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Jul 2013 18:23:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, rostedt@goodmis.org, mingo@elte.hu, edumazet@google.com, axboe@kernel.dk, jovi.zhangwei@huawei.com

Subject: + relay-fix-timer-madness-v2.patch added to -mm tree
To: jovi.zhangwei@huawei.com,axboe@kernel.dk,edumazet@google.com,mingo@elte.hu,rostedt@goodmis.org,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Wed, 10 Jul 2013 15:23:03 -0700


The patch titled
     Subject: relay-fix-timer-madness-v2
has been added to the -mm tree.  Its filename is
     relay-fix-timer-madness-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/relay-fix-timer-madness-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/relay-fix-timer-madness-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
relay-fix-timer-madness.patch
relay-fix-timer-madness-v2.patch


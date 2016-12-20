From: akpm@linux-foundation.org
Subject: + timerqueue-use-rb_entry_safe.patch added to -mm tree
Date: Tue, 20 Dec 2016 14:07:34 -0800
Message-ID: <5859aba6.ejPqtcw6uRKVTBFe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36014 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753463AbcLTWQ0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Dec 2016 17:16:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@gmail.com, john.stultz@linaro.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/timerqueue.c: use rb_entry_safe
has been added to the -mm tree.  Its filename is
     timerqueue-use-rb_entry_safe.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/timerqueue-use-rb_entry_safe.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/timerqueue-use-rb_entry_safe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geliang Tang <geliangtang@gmail.com>
Subject: lib/timerqueue.c: use rb_entry_safe

Use rb_entry_safe() instead of open-coding it.

Link: http://lkml.kernel.org/r/0d5cf199ac43792df0b6f7e2145545c30fa1dbbe.1482222135.git.geliangtang@gmail.com
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/timerqueue.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN lib/timerqueue.c~timerqueue-use-rb_entry_safe lib/timerqueue.c
--- a/lib/timerqueue.c~timerqueue-use-rb_entry_safe
+++ a/lib/timerqueue.c
@@ -80,8 +80,7 @@ bool timerqueue_del(struct timerqueue_he
 	if (head->next == node) {
 		struct rb_node *rbn = rb_next(&node->node);
 
-		head->next = rbn ?
-			rb_entry(rbn, struct timerqueue_node, node) : NULL;
+		head->next = rb_entry_safe(rbn, struct timerqueue_node, node);
 	}
 	rb_erase(&node->node, &head->head);
 	RB_CLEAR_NODE(&node->node);
_

Patches currently in -mm which might be from geliangtang@gmail.com are

timerqueue-use-rb_entry_safe.patch


From: akpm@linux-foundation.org
Subject: [alternative-merged]
 epoll-use-proper-wake_up-variant-in-ep_poll_callback.patch removed from -mm tree
Date: Wed, 06 Dec 2017 16:03:47 -0800
Message-ID: <5a288563.8wZ7HRMco1WybC9h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44824 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751604AbdLGADt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2017 19:03:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, mingo@redhat.com, peterz@infradead.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: use proper wake_up variant in ep_poll_callback
has been removed from the -mm tree.  Its filename was
     epoll-use-proper-wake_up-variant-in-ep_poll_callback.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: epoll: use proper wake_up variant in ep_poll_callback

We do not hold ep->wq->lock, so we should not use wake_up_locked on it.

Link: http://lkml.kernel.org/r/20171130142037.19339-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/eventpoll.c~epoll-use-proper-wake_up-variant-in-ep_poll_callback fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-use-proper-wake_up-variant-in-ep_poll_callback
+++ a/fs/eventpoll.c
@@ -1190,7 +1190,7 @@ static int ep_poll_callback(wait_queue_e
 				break;
 			}
 		}
-		wake_up_locked(&ep->wq);
+		wake_up(&ep->wq);
 	}
 	if (waitqueue_active(&ep->poll_wait))
 		pwake++;
_

Patches currently in -mm which might be from hch@lst.de are

sched-wait-assert-the-wait_queue_head-lock-is-held-in-__wake_up_common.patch


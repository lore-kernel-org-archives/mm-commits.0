From: akpm@linux-foundation.org
Subject: +
 sched-wait-assert-the-wait_queue_head-lock-is-held-in-__wake_up_common.patch added to -mm tree
Date: Thu, 30 Nov 2017 12:53:03 -0800
Message-ID: <5a206faf.GIDYqGlsT/cM524k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54480 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750849AbdK3UxE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2017 15:53:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, mingo@redhat.com, peterz@infradead.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: sched/wait: assert the wait_queue_head lock is held in __wake_up_common
has been added to the -mm tree.  Its filename is
     sched-wait-assert-the-wait_queue_head-lock-is-held-in-__wake_up_common.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sched-wait-assert-the-wait_queue_head-lock-is-held-in-__wake_up_common.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sched-wait-assert-the-wait_queue_head-lock-is-held-in-__wake_up_common.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: sched/wait: assert the wait_queue_head lock is held in __wake_up_common

Patch series "waitqueue lockdep annotation".

This series adds a strategic lockdep_assert_held to __wake_up_common to
ensure callers really do hold the wait_queue_head lock when calling the
unlocked wake_up variants.  It turns out epoll did not do this for a
fairly common path (hit all the time by systemd during bootup), so the
second patch fixed this instance as well.

This patch (of 2):

Better ensure we actually hold the lock using lockdep than just commenting
on it.  Due to the various exported _locked interfaces it is far too easy
to get the locking wrong.

Link: http://lkml.kernel.org/r/20171130142037.19339-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/wait.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/sched/wait.c~sched-wait-assert-the-wait_queue_head-lock-is-held-in-__wake_up_common kernel/sched/wait.c
--- a/kernel/sched/wait.c~sched-wait-assert-the-wait_queue_head-lock-is-held-in-__wake_up_common
+++ a/kernel/sched/wait.c
@@ -76,6 +76,8 @@ static int __wake_up_common(struct wait_
 	wait_queue_entry_t *curr, *next;
 	int cnt = 0;
 
+	lockdep_assert_held(&wq_head->lock);
+
 	if (bookmark && (bookmark->flags & WQ_FLAG_BOOKMARK)) {
 		curr = list_next_entry(bookmark, entry);
 
_

Patches currently in -mm which might be from hch@lst.de are

sched-wait-assert-the-wait_queue_head-lock-is-held-in-__wake_up_common.patch
epoll-use-proper-wake_up-variant-in-ep_poll_callback.patch


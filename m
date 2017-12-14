From: akpm@linux-foundation.org
Subject: [obsolete]
 sched-wait-assert-the-wait_queue_head-lock-is-held-in-__wake_up_common.patch removed from -mm tree
Date: Wed, 13 Dec 2017 17:02:02 -0800
Message-ID: <5a31cd8a.pdk8BtBPVBEc5+e0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33146 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750749AbdLNBCD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Dec 2017 20:02:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, mingo@redhat.com, peterz@infradead.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: sched/wait: assert the wait_queue_head lock is held in __wake_up_common
has been removed from the -mm tree.  Its filename was
     sched-wait-assert-the-wait_queue_head-lock-is-held-in-__wake_up_common.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: sched/wait: assert the wait_queue_head lock is held in __wake_up_common

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



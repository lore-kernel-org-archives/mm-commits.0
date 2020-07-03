From: akpm@linux-foundation.org
Subject: +
 kthread-work-could-not-be-queued-when-worker-being-destroyed.patch added to
 -mm tree
Date: Fri, 03 Jul 2020 12:13:35 -0700
Message-ID: <20200703191335.UnW5xFL9b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726147AbgGCTNg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Jul 2020 15:13:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, pmladek@suse.com, qiang.zhang@windriver.com


The patch titled
     Subject: kthread: work could not be queued when worker being destroyed
has been added to the -mm tree.  Its filename is
     kthread-work-could-not-be-queued-when-worker-being-destroyed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kthread-work-could-not-be-queued-when-worker-being-destroyed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kthread-work-could-not-be-queued-when-worker-being-destroyed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Qiang <qiang.zhang@windriver.com>
Subject: kthread: work could not be queued when worker being destroyed

The "queuing_blocked" func should print warning message and returns true
when the worker being destroyed.

Link: http://lkml.kernel.org/r/20200702070156.5862-1-qiang.zhang@windriver.com
Signed-off-by: Zhang Qiang <qiang.zhang@windriver.com>
Suggested-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/kthread.c~kthread-work-could-not-be-queued-when-worker-being-destroyed
+++ a/kernel/kthread.c
@@ -814,6 +814,9 @@ static inline bool queuing_blocked(struc
 {
 	lockdep_assert_held(&worker->lock);
 
+	if (WARN_ON(!worker->task))
+		return true;
+
 	return !list_empty(&work->node) || work->canceling;
 }
 
_

Patches currently in -mm which might be from qiang.zhang@windriver.com are

kthread-work-could-not-be-queued-when-worker-being-destroyed.patch

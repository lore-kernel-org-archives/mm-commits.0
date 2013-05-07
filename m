From: akpm@linux-foundation.org
Subject: [merged] set_task_comm-kill-the-pointless-memset-wmb.patch removed from -mm tree
Date: Tue, 07 May 2013 10:49:44 -0700
Message-ID: <20130507174945.5F1EA5A4360@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:44704 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758406Ab3EGRtq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:49:46 -0400
Received: by mail-ve0-f202.google.com with SMTP id 15so85279vea.5
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:49:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, andi@firstfloor.org, johnstul@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: set_task_comm: kill the pointless memset() + wmb()
has been removed from the -mm tree.  Its filename was
     set_task_comm-kill-the-pointless-memset-wmb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: set_task_comm: kill the pointless memset() + wmb()

set_task_comm() does memset() + wmb() before strlcpy().  This buys nothing
and to add to the confusion, the comment is wrong.

- We do not need memset() to be "safe from non-terminating string
  reads", the final char is always zero and we never change it.

- wmb() is paired with nothing, it cannot prevent from printing
  the mixture of the old/new data unless the reader takes the lock.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN fs/exec.c~set_task_comm-kill-the-pointless-memset-wmb fs/exec.c
--- a/fs/exec.c~set_task_comm-kill-the-pointless-memset-wmb
+++ a/fs/exec.c
@@ -1027,17 +1027,7 @@ EXPORT_SYMBOL_GPL(get_task_comm);
 void set_task_comm(struct task_struct *tsk, char *buf)
 {
 	task_lock(tsk);
-
 	trace_task_rename(tsk, buf);

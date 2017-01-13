From: akpm@linux-foundation.org
Subject: + proc-add-a-schedule-point-in-proc_pid_readdir.patch added to
 -mm tree
Date: Fri, 13 Jan 2017 15:24:14 -0800
Message-ID: <5879619e.9TrT9b3vzIvKaLFO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49718 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751350AbdAMXYP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2017 18:24:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edumazet@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: add a schedule point in proc_pid_readdir()
has been added to the -mm tree.  Its filename is
     proc-add-a-schedule-point-in-proc_pid_readdir.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-add-a-schedule-point-in-proc_pid_readdir.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-add-a-schedule-point-in-proc_pid_readdir.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Dumazet <edumazet@google.com>
Subject: proc: add a schedule point in proc_pid_readdir()

We have seen proc_pid_readdir() invocations holding cpu for more than 50
ms.  Add a cond_resched() to be gentle with other tasks.

Link: http://lkml.kernel.org/r/1484238380.15816.42.camel@edumazet-glaptop3.roam.corp.google.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/proc/base.c~proc-add-a-schedule-point-in-proc_pid_readdir fs/proc/base.c
--- a/fs/proc/base.c~proc-add-a-schedule-point-in-proc_pid_readdir
+++ a/fs/proc/base.c
@@ -3179,6 +3179,7 @@ int proc_pid_readdir(struct file *file,
 	     iter.tgid += 1, iter = next_tgid(ns, iter)) {
 		char name[PROC_NUMBUF];
 		int len;
+		cond_resched();
 		if (!has_pid_permissions(ns, iter.task, 2))
 			continue;
 
_

Patches currently in -mm which might be from edumazet@google.com are

proc-add-a-schedule-point-in-proc_pid_readdir.patch


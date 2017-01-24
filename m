From: akpm@linux-foundation.org
Subject: [patch 09/26] proc: add a schedule point in proc_pid_readdir()
Date: Tue, 24 Jan 2017 15:18:07 -0800
Message-ID: <5887e0af.fql3epcRoEBh6DHK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41402 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750888AbdAXXSI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2017 18:18:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, edumazet@google.com

From: Eric Dumazet <edumazet@google.com>
Subject: proc: add a schedule point in proc_pid_readdir()

We have seen proc_pid_readdir() invocations holding cpu for more than 50
ms.  Add a cond_resched() to be gentle with other tasks.

[akpm@linux-foundation.org: coding style fix]
Link: http://lkml.kernel.org/r/1484238380.15816.42.camel@edumazet-glaptop3.roam.corp.google.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/proc/base.c~proc-add-a-schedule-point-in-proc_pid_readdir fs/proc/base.c
--- a/fs/proc/base.c~proc-add-a-schedule-point-in-proc_pid_readdir
+++ a/fs/proc/base.c
@@ -3179,6 +3179,8 @@ int proc_pid_readdir(struct file *file,
 	     iter.tgid += 1, iter = next_tgid(ns, iter)) {
 		char name[PROC_NUMBUF];
 		int len;
+
+		cond_resched();
 		if (!has_pid_permissions(ns, iter.task, 2))
 			continue;
 
_

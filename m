From: akpm@linux-foundation.org
Subject: [merged] proc-add-a-schedule-point-in-proc_pid_readdir.patch
 removed from -mm tree
Date: Wed, 25 Jan 2017 14:04:40 -0800
Message-ID: <588920f8.cqQVTkca/AAb8t6J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42014 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752260AbdAYWEp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2017 17:04:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edumazet@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: add a schedule point in proc_pid_readdir()
has been removed from the -mm tree.  Its filename was
     proc-add-a-schedule-point-in-proc_pid_readdir.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from edumazet@google.com are



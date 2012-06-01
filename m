From: akpm@linux-foundation.org
Subject: [merged] stack-usage-add-pid-to-warning-printk-in-check_stack_usage.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:33:46 -0700
Message-ID: <20120601193346.6844FA013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:44792 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932615Ab2FATdr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:33:47 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so245076ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:33:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tim.bird@am.sony.com, aarcange@redhat.com, fweisbec@gmail.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: stack usage: add pid to warning printk in check_stack_usage
has been removed from the -mm tree.  Its filename was
     stack-usage-add-pid-to-warning-printk-in-check_stack_usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Tim Bird <tim.bird@am.sony.com>
Subject: stack usage: add pid to warning printk in check_stack_usage

In embedded systems, sometimes the same program (busybox) is the cause of
multiple warnings.  Outputting the pid with the program name in the
warning printk helps distinguish which instances of a program are using
the stack most.

This is a small patch, but useful.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/exit.c~stack-usage-add-pid-to-warning-printk-in-check_stack_usage kernel/exit.c
--- a/kernel/exit.c~stack-usage-add-pid-to-warning-printk-in-check_stack_usage
+++ a/kernel/exit.c
@@ -884,9 +884,9 @@ static void check_stack_usage(void)
 
 	spin_lock(&low_water_lock);
 	if (free < lowest_to_date) {
-		printk(KERN_WARNING "%s used greatest stack depth: %lu bytes "
-				"left\n",
-				current->comm, free);
+		printk(KERN_WARNING "%s (%d) used greatest stack depth: "
+				"%lu bytes left\n",
+				current->comm, task_pid_nr(current), free);
 		lowest_to_date = free;
 	}
 	spin_unlock(&low_water_lock);
_

Patches currently in -mm which might be from tim.bird@am.sony.com are

origin.patch


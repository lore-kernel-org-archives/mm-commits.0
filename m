From: akpm@linux-foundation.org
Subject: + stack-usage-add-pid-to-warning-printk-in-check_stack_usage.patch added to -mm tree
Date: Thu, 12 Apr 2012 16:45:58 -0700
Message-ID: <20120412234558.C5FAAA02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:36339 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753197Ab2DLXqB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Apr 2012 19:46:01 -0400
Received: by laai8 with SMTP id i8so112271laa.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Apr 2012 16:45:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tim.bird@am.sony.com, aarcange@redhat.com, fweisbec@gmail.com, oleg@redhat.com


The patch titled
     Subject: stack usage: add pid to warning printk in check_stack_usage
has been added to the -mm tree.  Its filename is
     stack-usage-add-pid-to-warning-printk-in-check_stack_usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: stack usage: add pid to warning printk in check_stack_usage

Patches currently in -mm which might be from tim.bird@am.sony.com are

stack-usage-add-pid-to-warning-printk-in-check_stack_usage.patch


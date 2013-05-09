From: akpm@linux-foundation.org
Subject: + panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks.patch added to -mm tree
Date: Thu, 09 May 2013 13:59:57 -0700
Message-ID: <20130509205957.92FBC31C15D@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:59358 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab3EIU76 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 16:59:58 -0400
Received: by mail-qe0-f74.google.com with SMTP id 1so334892qec.5
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 13:59:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: athorlton@sgi.com, holt@sgi.com, markivx@codeaurora.org, rusty@rustcorp.com.au, sboyd@codeaurora.org, tj@kernel.org


The patch titled
     Subject: panic: add cpu/pid to warn_slowpath_common in WARNING printk()s
has been added to the -mm tree.  Its filename is
     panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Thorlton <athorlton@sgi.com>
Subject: panic: add cpu/pid to warn_slowpath_common in WARNING printk()s

Add the cpu/pid that called WARN() so that the stack traces can be matched
up with the WARNING messages.

Signed-off-by: Alex Thorlton <athorlton@sgi.com>
Reviewed-by: Robin Holt <holt@sgi.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Vikram Mulukutla <markivx@codeaurora.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/panic.c~panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks kernel/panic.c
--- a/kernel/panic.c~panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks
+++ a/kernel/panic.c
@@ -399,8 +399,9 @@ struct slowpath_args {
 static void warn_slowpath_common(const char *file, int line, void *caller,
 				 unsigned taint, struct slowpath_args *args)
 {
-	printk(KERN_WARNING "------------[ cut here ]------------\n");
-	printk(KERN_WARNING "WARNING: at %s:%d %pS()\n", file, line, caller);
+	pr_warn("------------[ cut here ]------------\n");
+	pr_warn("WARNING: CPU: %d PID: %d at %s:%d %pS()\n",  '
+		raw_smp_processor_id(), current->pid, file, line, caller);
 
 	if (args)
 		vprintk(args->fmt, args->args);
_

Patches currently in -mm which might be from athorlton@sgi.com are

origin.patch
dump_stack-serialize-the-output-from-dump_stack.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks.patch


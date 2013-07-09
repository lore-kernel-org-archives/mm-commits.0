From: akpm@linux-foundation.org
Subject: [merged]
 panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks.patch removed
 from -mm tree
Date: Tue, 09 Jul 2013 16:20:55 -0700
Message-ID: <51dc9ad7.S2tGpOYsB4xUfTug%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39011 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab3GIXU4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:20:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, sboyd@codeaurora.org, rusty@rustcorp.com.au, markivx@codeaurora.org, holt@sgi.com, athorlton@sgi.com

Subject: [merged] panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks.patch removed from -mm tree
To: athorlton@sgi.com,holt@sgi.com,markivx@codeaurora.org,rusty@rustcorp.com.au,sboyd@codeaurora.org,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:20:55 -0700


The patch titled
     Subject: panic: add cpu/pid to warn_slowpath_common in WARNING printk()s
has been removed from the -mm tree.  Its filename was
     panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Thorlton <athorlton@sgi.com>
Subject: panic: add cpu/pid to warn_slowpath_common in WARNING printk()s

Add the cpu/pid that called WARN() so that the stack traces can be matched
up with the WARNING messages.

[akpm@linux-foundation.org: remove stray quote]
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
+	pr_warn("WARNING: CPU: %d PID: %d at %s:%d %pS()\n",
+		raw_smp_processor_id(), current->pid, file, line, caller);
 
 	if (args)
 		vprintk(args->fmt, args->args);
_

Patches currently in -mm which might be from athorlton@sgi.com are

origin.patch


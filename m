Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE4225A2A1
	for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2025 00:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756168879; cv=none; b=OV60Tgc2glHBXbKgJ07j1ulTABxay9MgRjHZTfnwL9jhQv2TEb9OHC/oYMVM381WbmBNrl6SgUA3ZdJI7KFp6YnAw6zHcAhQvXNs6FnaAKEoY8+J/c15PGFV1ok8eOOAKsZoYZWV8JyRNUqASDipWJxqQt1TWz+LJij6BaHw3v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756168879; c=relaxed/simple;
	bh=CxDzDvbyGjdxuHJCfXc2LddEAddWH72S6hVH4oi+TME=;
	h=Date:To:From:Subject:Message-Id; b=FhQ07En26ms9IABD4zgOl0mWpLK24lQr94SD3iqa6kbD1pJIzSztIHBmciN6tXS+dP7gTvdpEvqgEUApqDh3fIOUYRd/f5l1oYpKIrsI4W2MqRQGpsKxIihtLqP0U4eZgC6QB4+LlKR37wDbOULeKQZ1r3pO4JMgxzDPSAXpCkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xncuUQ/k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xncuUQ/k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9ED1C4CEED;
	Tue, 26 Aug 2025 00:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756168879;
	bh=CxDzDvbyGjdxuHJCfXc2LddEAddWH72S6hVH4oi+TME=;
	h=Date:To:From:Subject:From;
	b=xncuUQ/k2z2GgbX2UM26LZNgCO3G5NOgVjYmROCHIrimRoJa0f3r8TWm6q1Xa7/dD
	 f+G7NfsY5y7Nf74ddFB7XDtrdW77ODZq75nlKzixr+zaYI4WwEVkeFoppJIMJ7zn/o
	 5FzsJs9fbdSwzzwJkwCjcsxKqOc+fBvjNAJkIW2Q=
Date: Mon, 25 Aug 2025 17:41:18 -0700
To: mm-commits@vger.kernel.org,safinaskar@zohomail.com,rostedt@goodmis.org,paulmck@kernel.org,lance.yang@linux.dev,john.ogness@linutronix.de,feng.tang@linux.alibaba.com,corbet@lwn.net,pmladek@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-clean-up-message-about-deprecated-panic_print-parameter.patch added to mm-nonmm-unstable branch
Message-Id: <20250826004118.E9ED1C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: clean up message about deprecated 'panic_print' parameter
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-clean-up-message-about-deprecated-panic_print-parameter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-clean-up-message-about-deprecated-panic_print-parameter.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: panic: clean up message about deprecated 'panic_print' parameter
Date: Mon, 25 Aug 2025 10:57:01 +0800

Remove duplication of the message about deprecated 'panic_print'
parameter.

Also make the wording more direct.  Make it clear that the new parameters
already exist and should be used instead.

Link: https://lkml.kernel.org/r/20250825025701.81921-5-feng.tang@linux.alibaba.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Feng Tang <feng.tang@linux.alibaba.com>
Cc: Askar Safin <safinaskar@zohomail.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/kernel/panic.c~panic-clean-up-message-about-deprecated-panic_print-parameter
+++ a/kernel/panic.c
@@ -77,6 +77,11 @@ ATOMIC_NOTIFIER_HEAD(panic_notifier_list
 
 EXPORT_SYMBOL(panic_notifier_list);
 
+static void panic_print_deprecated(void)
+{
+	pr_info_once("Kernel: The 'panic_print' parameter is now deprecated. Please use 'panic_sys_info' and 'panic_console_replay' instead.\n");
+}
+
 #ifdef CONFIG_SYSCTL
 
 /*
@@ -125,7 +130,7 @@ static int proc_taint(const struct ctl_t
 static int sysctl_panic_print_handler(const struct ctl_table *table, int write,
 			   void *buffer, size_t *lenp, loff_t *ppos)
 {
-	pr_info_once("Kernel: 'panic_print' sysctl interface will be obsoleted by both 'panic_sys_info' and 'panic_console_replay'\n");
+	panic_print_deprecated();
 	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
 }
 
@@ -944,13 +949,13 @@ core_param(panic_console_replay, panic_c
 
 static int panic_print_set(const char *val, const struct kernel_param *kp)
 {
-	pr_info_once("Kernel: 'panic_print' parameter will be obsoleted by both 'panic_sys_info' and 'panic_console_replay'\n");
+	panic_print_deprecated();
 	return  param_set_ulong(val, kp);
 }
 
 static int panic_print_get(char *val, const struct kernel_param *kp)
 {
-	pr_info_once("Kernel: 'panic_print' parameter will be obsoleted by both 'panic_sys_info' and 'panic_console_replay'\n");
+	panic_print_deprecated();
 	return  param_get_ulong(val, kp);
 }
 
_

Patches currently in -mm which might be from pmladek@suse.com are

panic-clean-up-message-about-deprecated-panic_print-parameter.patch


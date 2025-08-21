Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98361C4A10
	for <mm-commits@vger.kernel.org>; Thu, 21 Aug 2025 00:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755736518; cv=none; b=CRwnH43Wdyki+kEPTZvrR0ruoc68apzws1qcGs7DdrxJjnrF2W89ExMCASQ4vdmzORvJ21ovUf+bxODNehdER75HTkHtWZSxpH3vYUMj1ZHCE2xx+9ShCnpyltuzKE8bLi/lSLxJ/8mnpUA7i8Gew4WAGaREGT7+qv0zVc6S0yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755736518; c=relaxed/simple;
	bh=ToNerv5oKAmRaaMXAT3XcZBfkaOkXpDq97hoTL0DT1w=;
	h=Date:To:From:Subject:Message-Id; b=dn2c6FmA18EXjKO23AJbN+W8bJPmaLqbeE2Ux+nXzu6iutzaPnoRNLfFUadB0iObzsEg8ChIdWIcXxzpmvjXgq1wOdCAQWmQSLIWffwA3F0u36Cn5ExxU61k3EfCiq7MNEFhPGVGWelnwHxt4HlHkxf707P/YEO6ayAJFNjtmhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IEE+lGXP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IEE+lGXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F65BC4CEE7;
	Thu, 21 Aug 2025 00:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755736517;
	bh=ToNerv5oKAmRaaMXAT3XcZBfkaOkXpDq97hoTL0DT1w=;
	h=Date:To:From:Subject:From;
	b=IEE+lGXPQBKP4+jtyXfrQXuv4epYzcPJUAfDqMacGdInckNokrwlsBWuIW7AzIohW
	 AFJ2ZRHcr85CMYJEbcBariUxXfUhkssXcGwHwMtLnJvsCZdu1IyVWZP7KJMnTcH59s
	 H4p6rdi3SK2IGlJIqULhp8MpGo1v9pa4oo2VabQI=
Date: Wed, 20 Aug 2025 17:35:16 -0700
To: mm-commits@vger.kernel.org,safinaskar@zohomail.com,rostedt@goodmis.org,paulmck@kernel.org,lance.yang@linux.dev,john.ogness@linutronix.de,feng.tang@linux.alibaba.com,corbet@lwn.net,pmladek@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-add-note-that-panic_print-parameter-is-deprecated-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250821003517.1F65BC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: clean up message about deprecated 'panic_print' parameter
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-add-note-that-panic_print-parameter-is-deprecated-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-add-note-that-panic_print-parameter-is-deprecated-fix.patch

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
Date: Wed, 20 Aug 2025 11:40:32 +0200

Remove duplication of the message about deprecated 'panic_print'
parameter.

Also make the wording more direct. Make it clear that the new
parameters already exist and should be used instead.

Link: https://lkml.kernel.org/r/aKWYELPjbhC7R8NO@pathway.suse.cz
Signed-off-by: Petr Mladek <pmladek@suse.com>
Cc: Askar Safin <safinaskar@zohomail.com>
Cc: Feng Tang <feng.tang@linux.alibaba.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/kernel/panic.c~panic-add-note-that-panic_print-parameter-is-deprecated-fix
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

panic-add-note-that-panic_print-parameter-is-deprecated-fix.patch


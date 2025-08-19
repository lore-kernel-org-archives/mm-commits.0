Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C8035334E
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 22:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755641365; cv=none; b=sRC87Pd450C7IboTyNHkAbq8iHzaZO/yGfbQjSnK02XmzAdqdM0eVryXZ55x3oSNylq0j2qg/Wwrtx0+p53kPCJhPaHFEHaLkoE5CTLH6n/rALVAoctz1DSng1pQQXalCL9dfomMMrE/0TgFKPc42B/ynZ4dvycEw15ofixGYnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755641365; c=relaxed/simple;
	bh=jU0tl3N7Okxjyckm0FwHDy2jTiwyzn/4MFrBPLhHBpw=;
	h=Date:To:From:Subject:Message-Id; b=mxeb7J8HfxvQNg4Vgfli9DRIdof9xkTZf9R7lJsWnbuUeH64Ec7lmk6FpO0duaBcn7T4gjwca10SdHa6DVYm9H2uwW1yz+TUAzU318ofjUXjUACSUnDERKRG8SkyIw5PyYE+aZojFHXW5q3opAhBW2YYNl2my4o13VNwfyj6Cdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0ADBlTFK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0ADBlTFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AEDC4CEF1;
	Tue, 19 Aug 2025 22:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755641365;
	bh=jU0tl3N7Okxjyckm0FwHDy2jTiwyzn/4MFrBPLhHBpw=;
	h=Date:To:From:Subject:From;
	b=0ADBlTFKyXu+ypHliR2jQbhB2SzfCxrjirAaN8OzqqwZFM7uctgDsMPLQdb3j9L7e
	 cfE7z/yVquhJzIzSe5Y8rW1Cz7WCcMkRGJ8f6jAcmmz8uieueG/Y3VjFBpRLku+3ra
	 6DHY0uO9jD7iWze7DvMwgI8L6Dy7OCsACzzwUN88=
Date: Tue, 19 Aug 2025 15:09:24 -0700
To: mm-commits@vger.kernel.org,safinaskar@zohomail.com,rostedt@goodmis.org,paulmck@kernel.org,lance.yang@linux.dev,john.ogness@linutronix.de,feng.tang@linux.alibaba.com,corbet@lwn.net,pmladek@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-add-note-that-panic_print-parameter-is-deprecated-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250819220925.18AEDC4CEF1@smtp.kernel.org>
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
Date: Tue, 19 Aug 2025 11:51:37 +0200

Remove duplication of the message about the deprecated 'panic_print'
parameter.

Also make the wording more direct. Make it clear that the new
parameters already exist and should be used instead.

Link: https://lkml.kernel.org/r/aKRJKZHgcxyNF3y7@pathway.suse.cz
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Askar Safin <safinaskar@zohomail.com>
Cc: Feng Tang <feng.tang@linux.alibaba.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/kernel/panic.c~panic-add-note-that-panic_print-parameter-is-deprecated-fix
+++ a/kernel/panic.c
@@ -122,10 +122,15 @@ static int proc_taint(const struct ctl_t
 	return err;
 }
 
+static void panic_print_deprecated(void)
+{
+	pr_info_once("Kernel: The 'panic_print' parameter is now deprecated. Please use 'panic_sys_info' and 'panic_console_replay' instead.\n");
+}
+
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


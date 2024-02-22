Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB28913BAF9
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645217; cv=none; b=V5VYe7FsBJZ4tNG0jGggSl7gZF1BoKB7NcBS7BjSVb9SDrtgKXa8rLEZmo4NgdleYa4BH8MWCi/u8ExXnUu2RcqbywSSiSIto1rs9vh/UN3Sn7pXyqQsDE7ftSDEV9yisQmNvajxBPROWYkUGQOkONtGTK+jB0ngE0eT616MkRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645217; c=relaxed/simple;
	bh=vBhgb5GH6JUirY/KgJLCgBdLVj0tULIPr1jLZEOKkMo=;
	h=Date:To:From:Subject:Message-Id; b=OvNKln3owdrZE3367spuawSGsd8MGnEoJHTN/79PkMxMyhurhQEOwbPxlva2FJWscYAn4rL61TZkZuYvpGoJQaIiYVMYFwbMvevwpMZDH+aH0REXTaJsd3vrO12FIt29PHEjVXcryA6sJ4nhSXESRqek6s6E5xOf1Jco4tMtcRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q6z9FXHX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q6z9FXHX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6580DC433C7;
	Thu, 22 Feb 2024 23:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645217;
	bh=vBhgb5GH6JUirY/KgJLCgBdLVj0tULIPr1jLZEOKkMo=;
	h=Date:To:From:Subject:From;
	b=q6z9FXHX/zjycwvqZrxc3c6PYCS2AYIWZL5P7Oer96gt2Xf2O5Ue0685lskruuVGt
	 38kY14k0k/skH3Qwa5P9Ri2/Pwu9bml7zVWIz8kQwvabEFx8CMAjCEDZ2PYQnvgyxj
	 MOrBWJYN8mV7Eu9P/E5w04uaoezz7NNUQlTKDs7E=
Date: Thu, 22 Feb 2024 15:40:16 -0800
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,peterz@infradead.org,jpoimboe@kernel.org,gpiccoli@igalia.com,corbet@lwn.net,feng.tang@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] panic-add-option-to-dump-blocked-tasks-in-panic_print.patch removed from -mm tree
Message-Id: <20240222234017.6580DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: add option to dump blocked tasks in panic_print
has been removed from the -mm tree.  Its filename was
     panic-add-option-to-dump-blocked-tasks-in-panic_print.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Feng Tang <feng.tang@intel.com>
Subject: panic: add option to dump blocked tasks in panic_print
Date: Fri, 2 Feb 2024 21:20:42 +0800

For debugging kernel panics and other bugs, there is already an option of
panic_print to dump all tasks' call stacks.  On today's large servers
running many containers, there could be thousands of tasks or more, and
this will print out huge amount of call stacks, taking a lot of time (for
serial console which is main target user case of panic_print).

And in many cases, only those several tasks being blocked are key for the
panic, so add an option to only dump blocked tasks' call stacks.

[akpm@linux-foundation.org: clarify documentation a little]
Link: https://lkml.kernel.org/r/20240202132042.3609657-1-feng.tang@intel.com
Signed-off-by: Feng Tang <feng.tang@intel.com>
Tested-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    1 +
 Documentation/admin-guide/sysctl/kernel.rst     |    1 +
 kernel/panic.c                                  |    4 ++++
 3 files changed, 6 insertions(+)

--- a/Documentation/admin-guide/kernel-parameters.txt~panic-add-option-to-dump-blocked-tasks-in-panic_print
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -4182,6 +4182,7 @@
 			bit 4: print ftrace buffer
 			bit 5: print all printk messages in buffer
 			bit 6: print all CPUs backtrace (if available in the arch)
+			bit 7: print only tasks in uninterruptible (blocked) state
 			*Be aware* that this option may print a _lot_ of lines,
 			so there are risks of losing older messages in the log.
 			Use this option carefully, maybe worth to setup a
--- a/Documentation/admin-guide/sysctl/kernel.rst~panic-add-option-to-dump-blocked-tasks-in-panic_print
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -853,6 +853,7 @@ bit 3  print locks info if ``CONFIG_LOCK
 bit 4  print ftrace buffer
 bit 5  print all printk messages in buffer
 bit 6  print all CPUs backtrace (if available in the arch)
+bit 7  print only tasks in uninterruptible (blocked) state
 =====  ============================================
 
 So for example to print tasks and memory info on panic, user can::
--- a/kernel/panic.c~panic-add-option-to-dump-blocked-tasks-in-panic_print
+++ a/kernel/panic.c
@@ -73,6 +73,7 @@ EXPORT_SYMBOL_GPL(panic_timeout);
 #define PANIC_PRINT_FTRACE_INFO		0x00000010
 #define PANIC_PRINT_ALL_PRINTK_MSG	0x00000020
 #define PANIC_PRINT_ALL_CPU_BT		0x00000040
+#define PANIC_PRINT_BLOCKED_TASKS	0x00000080
 unsigned long panic_print;
 
 ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
@@ -227,6 +228,9 @@ static void panic_print_sys_info(bool co
 
 	if (panic_print & PANIC_PRINT_FTRACE_INFO)
 		ftrace_dump(DUMP_ALL);
+
+	if (panic_print & PANIC_PRINT_BLOCKED_TASKS)
+		show_state_filter(TASK_UNINTERRUPTIBLE);
 }
 
 void check_panic_on_warn(const char *origin)
_

Patches currently in -mm which might be from feng.tang@intel.com are



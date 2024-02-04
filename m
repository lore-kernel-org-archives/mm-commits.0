Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64688820
	for <mm-commits@vger.kernel.org>; Sun,  4 Feb 2024 07:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707031247; cv=none; b=X+HzEyXOI6NNX+6Vrex04XrJ1foyp6Jx8xyTi+pu6M4WC2E1kX2Qt9/7TkVuFuJ6MtIy2c+JLS1bXtGYzH9Y7cwAUAoeA/xadCfJ0qC+XlYgYApe0BH0Co86BtKhLAsd0mrImONQpCn/GdMRi1iM3eD5zHkN2F+1vbKOkoQfKv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707031247; c=relaxed/simple;
	bh=Y3WkwVlWu+NVT5FHwBXrMo5yKVvxJJi2XPmbn4AkDeY=;
	h=Date:To:From:Subject:Message-Id; b=R0uh7tdlOjvgOfiGS8joRpJogP8keVf/lCbieBTSDpE7zn8fq5PE+/UpJ/VANYJ2N/ctJzCuImB+6h/HLiJ9iQyGdXZ/iXLW99d+/ePdLtnTAYWLzPw+d4OKctZBa9JG3WoM6jk8/TD00/WrfEYdVacdrkq8PHUQ/T5SN3vKqOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kKwRJ8zu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kKwRJ8zu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BE6C433F1;
	Sun,  4 Feb 2024 07:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707031246;
	bh=Y3WkwVlWu+NVT5FHwBXrMo5yKVvxJJi2XPmbn4AkDeY=;
	h=Date:To:From:Subject:From;
	b=kKwRJ8zuc5QHdpu3sLR3gjK0iTikByTLvTNuJNsNZGcSZLB7qWG4Dv5U+8d2nZ+Qt
	 uAr0//AxB3UYEZfixvRPKqohDHy+5xPA7vQpgAGYoIP5xqK01zGNW8SlnUFm9fDuV4
	 DGJXQaKLL53Gkk5yM1dXxqTCLJqEh0b1f81kNUFY=
Date: Sat, 03 Feb 2024 23:20:46 -0800
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,peterz@infradead.org,jpoimboe@kernel.org,gpiccoli@igalia.com,corbet@lwn.net,feng.tang@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-add-option-to-dump-blocked-tasks-in-panic_print.patch added to mm-nonmm-unstable branch
Message-Id: <20240204072046.B0BE6C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: add option to dump blocked tasks in panic_print
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-add-option-to-dump-blocked-tasks-in-panic_print.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-add-option-to-dump-blocked-tasks-in-panic_print.patch

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

Link: https://lkml.kernel.org/r/20240202132042.3609657-1-feng.tang@intel.com
Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Guilherme G. Piccoli <gpiccoli@igalia.com>
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
+			bit 7: print tasks in uninterruptible (blocked) state
 			*Be aware* that this option may print a _lot_ of lines,
 			so there are risks of losing older messages in the log.
 			Use this option carefully, maybe worth to setup a
--- a/Documentation/admin-guide/sysctl/kernel.rst~panic-add-option-to-dump-blocked-tasks-in-panic_print
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -853,6 +853,7 @@ bit 3  print locks info if ``CONFIG_LOCK
 bit 4  print ftrace buffer
 bit 5  print all printk messages in buffer
 bit 6  print all CPUs backtrace (if available in the arch)
+bit 7  print tasks in uninterruptible (blocked) state
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

panic-add-option-to-dump-blocked-tasks-in-panic_print.patch


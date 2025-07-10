Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB67224B00
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 22:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752184845; cv=none; b=DbGgrnuBlMAYL8CEl3LU0qGofdEAfUbQpMLtHjx4zyCBd0b9c0lKDli77hK3KNZZ03vivvUEx6FLNge/LlT3NcsZZydGDm4Em8co0JDpb/zLJjKmeYPYJ1P6HHjHuqirSCApS6x7nBRhzjWCi+wLUJBvfjxwR3JnDy4MzV/TLrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752184845; c=relaxed/simple;
	bh=V8tfDjmrixmJLAu/dAxsXDtrLWbNCy+SIhmIlNl9etg=;
	h=Date:To:From:Subject:Message-Id; b=RmapjFxM/uzpkwgV9WYwoG+HlmANPSIwlbttwNMQ2KquKzGM180OA0RUczrZSIkpuVr86LRmOnfvF0WmyL7gz5DsM4cwdgaKoiTaaXaXzxekPac7l21ER7vLOPJxzC23tEcyj5RFype7INtQqalp/9vmGjtcKDzj/vFar1DEOto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fDcGKfqB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fDcGKfqB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C87C4CEE3;
	Thu, 10 Jul 2025 22:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752184844;
	bh=V8tfDjmrixmJLAu/dAxsXDtrLWbNCy+SIhmIlNl9etg=;
	h=Date:To:From:Subject:From;
	b=fDcGKfqBRPtS62UN2RcH0l4svmHjgJjiZWU3q5SI2YSmJpArcjR7L1N9vpWftVr59
	 t8AuRjgeyT0cRxp8hZ6dVyj9HbUJTMsxmw8ADSszZJOv2+G1W3QSNHdKltEROGDctf
	 yBRXI1p/2EDes9KtdC87Z6lQtocR1i8E7Trb95Pw=
Date: Thu, 10 Jul 2025 15:00:44 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,pmladek@suse.com,paulmck@kernel.org,nathan@kernel.org,lance.yang@linux.dev,john.ogness@linutronix.de,feng.tang@linux.alibaba.com,corbet@lwn.net,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-add-panic_sys_info-sysctl-to-take-human-readable-string-parameter-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250710220044.B2C87C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: fix compilation error (`make W=1`)
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-add-panic_sys_info-sysctl-to-take-human-readable-string-parameter-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-add-panic_sys_info-sysctl-to-take-human-readable-string-parameter-fix.patch

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
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: panic: fix compilation error (`make W=1`)
Date: Thu, 10 Jul 2025 12:48:16 +0300

Compiler is not happy about the recently added code:

lib/sys_info.c:52:19: error: variable 'sys_info_avail' is not needed and will not be emitted [-Werror,-Wunneeded-internal-declaration]
   52 | static const char sys_info_avail[] = "tasks,mem,timers,locks,ftrace,all_bt,blocked_tasks";
      |                   ^~~~~~~~~~~~~~

Fix it in the same way how, for example, lib/vsprintf.c does in the similar
cases, i.e. by using string literal directly as sizeof() parameter.

Link: https://lkml.kernel.org/r/20250710094816.771656-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Feng Tang <feng.tang@linux.alibaba.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sys_info.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/lib/sys_info.c~panic-add-panic_sys_info-sysctl-to-take-human-readable-string-parameter-fix
+++ a/lib/sys_info.c
@@ -49,13 +49,11 @@ unsigned long sys_info_parse_param(char
 
 #ifdef CONFIG_SYSCTL
 
-static const char sys_info_avail[] = "tasks,mem,timers,locks,ftrace,all_bt,blocked_tasks";
-
 int sysctl_sys_info_handler(const struct ctl_table *ro_table, int write,
 					  void *buffer, size_t *lenp,
 					  loff_t *ppos)
 {
-	char names[sizeof(sys_info_avail) + 1];
+	char names[sizeof("tasks,mem,timers,locks,ftrace,all_bt,blocked_tasks") + 1];
 	struct ctl_table table;
 	unsigned long *si_bits_global;
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

panic-add-panic_sys_info-sysctl-to-take-human-readable-string-parameter-fix.patch


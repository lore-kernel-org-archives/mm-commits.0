Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F671EF091
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676251; cv=none; b=hbaZliNkZROwRi6X03PtzCSvS+f1j/PoyGahIgFgZaTcUQwfxeYVOAvxaL8wYYzUCMiTk40ib1qV0S5xSExqlUtRVV3SSmVciULRsrbJ6gUd20/elyvIg+xMZfFA4LEwW9Pt4qn3nTV4xEsTL9nlp1ZdDcgTCg3k3BR3ep/K/Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676251; c=relaxed/simple;
	bh=gSOuP18bGgok+2w5p51Z6ZMruCagY3V0hbL2onPlIUk=;
	h=Date:To:From:Subject:Message-Id; b=ZnwFreVT4rtEdgEJK/tbYWasZp77caG/2IZ5bJZ7TP0iDrrBK7Z3EmvJFI2wWAqfNZ1V2Fp56iavhKHClzazm0UpLtAWSWoHwdXjc1Q2KNFSlbW4Ki57x1Ht6NyAxL63HH0djl1o3Dgne0h8JFmGRoW8ifR7A8uNne9eKGZOFS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CHXVjun+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CHXVjun+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CCF8C4CEF1;
	Thu, 20 Nov 2025 22:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676251;
	bh=gSOuP18bGgok+2w5p51Z6ZMruCagY3V0hbL2onPlIUk=;
	h=Date:To:From:Subject:From;
	b=CHXVjun+HcRQlNqZaHuIsAJsDu9gm5D7SnTEO+7zM9EKZGNQB3BkhABhAAEnALkyl
	 RO31EjXZ/SzO90hMppSpsHqHimeACWY829024S7/7SykB8uN0AyZiMWMdDb5fqExKF
	 l5oM0/6M1mXNp27nup9aNW/A8VUyuBLgjc6ILXbw=
Date: Thu, 20 Nov 2025 14:04:10 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,feng.tang@linux.alibaba.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] panic-sys_info-align-constant-definition-names-with-parameters.patch removed from -mm tree
Message-Id: <20251120220411.3CCF8C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: sys_info: align constant definition names with parameters
has been removed from the -mm tree.  Its filename was
     panic-sys_info-align-constant-definition-names-with-parameters.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: panic: sys_info: align constant definition names with parameters
Date: Thu, 30 Oct 2025 12:44:18 +0100

Align constant definition names with parameters to make it easier to map. 
It's also better to maintain and extend the names while keeping their
uniqueness.

Link: https://lkml.kernel.org/r/20251030132007.3742368-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Feng Tang <feng.tang@linux.alibaba.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sys_info.h |    2 +-
 kernel/panic.c           |    2 +-
 lib/sys_info.c           |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/sys_info.h~panic-sys_info-align-constant-definition-names-with-parameters
+++ a/include/linux/sys_info.h
@@ -14,7 +14,7 @@
 #define SYS_INFO_LOCKS			0x00000008
 #define SYS_INFO_FTRACE			0x00000010
 #define SYS_INFO_PANIC_CONSOLE_REPLAY	0x00000020
-#define SYS_INFO_ALL_CPU_BT		0x00000040
+#define SYS_INFO_ALL_BT			0x00000040
 #define SYS_INFO_BLOCKED_TASKS		0x00000080
 
 void sys_info(unsigned long si_mask);
--- a/kernel/panic.c~panic-sys_info-align-constant-definition-names-with-parameters
+++ a/kernel/panic.c
@@ -401,7 +401,7 @@ static void panic_trigger_all_cpu_backtr
  */
 static void panic_other_cpus_shutdown(bool crash_kexec)
 {
-	if (panic_print & SYS_INFO_ALL_CPU_BT)
+	if (panic_print & SYS_INFO_ALL_BT)
 		panic_trigger_all_cpu_backtrace();
 
 	/*
--- a/lib/sys_info.c~panic-sys_info-align-constant-definition-names-with-parameters
+++ a/lib/sys_info.c
@@ -23,7 +23,7 @@ static const struct sys_info_name  si_na
 	{ SYS_INFO_TIMERS,		"timers" },
 	{ SYS_INFO_LOCKS,		"locks" },
 	{ SYS_INFO_FTRACE,		"ftrace" },
-	{ SYS_INFO_ALL_CPU_BT,		"all_bt" },
+	{ SYS_INFO_ALL_BT,		"all_bt" },
 	{ SYS_INFO_BLOCKED_TASKS,	"blocked_tasks" },
 };
 
@@ -118,7 +118,7 @@ void sys_info(unsigned long si_mask)
 	if (si_mask & SYS_INFO_FTRACE)
 		ftrace_dump(DUMP_ALL);
 
-	if (si_mask & SYS_INFO_ALL_CPU_BT)
+	if (si_mask & SYS_INFO_ALL_BT)
 		trigger_all_cpu_backtrace();
 
 	if (si_mask & SYS_INFO_BLOCKED_TASKS)
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are



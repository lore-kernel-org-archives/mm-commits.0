Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CB82741A0
	for <mm-commits@vger.kernel.org>; Fri, 31 Oct 2025 03:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761880375; cv=none; b=lS3RY2mjgBycM855H4AMLVmj+/1vK6AodaygfyEh+HNk6Jaj5sKjwAhRg4E7wRXpEx1DZv8WSy1m6NHI3Lk02UOtDSPcQiGziFt50SMcvAnT+tRIjD62RRNJRJyrgHFhHl1njQYmmuJW5XORw2eFLJ8lwDMrAjFTrSjMn62/fCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761880375; c=relaxed/simple;
	bh=LC6B33aKtfaptb8K+LVaZrbzEOvgO5WXHBmf5V64qzE=;
	h=Date:To:From:Subject:Message-Id; b=aeacPM5il9P/5Vf1QGwmHUzD8JhzqKPIryA5XaA4YA3DUxwUDf7b19C36S9WISrGznY6iEJcxj3+tJD6YJ7y2HlVJuys7LrTjq3bTEQkwAlJdCeisMbrh1ZNKH8l3fAWQsl62ItEfa2me7RdJGyEJ6mk1k0hPYjrQRwG8VVmJFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w3FS9TcG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w3FS9TcG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F643C4CEF1;
	Fri, 31 Oct 2025 03:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761880375;
	bh=LC6B33aKtfaptb8K+LVaZrbzEOvgO5WXHBmf5V64qzE=;
	h=Date:To:From:Subject:From;
	b=w3FS9TcGHb6F+njT4sJl2wjhh8UxcItRthjjIYgi3T1S0qb4tFlXs62+Y3qGm+H+9
	 jF9DWlBCsAhFL1H9/GsXCu+dD254VpDsUL3sxOzZQcNrLLZolKuFChU/ftY7qTEaNS
	 1uIQrFRgU58euikN4CreMWoBuLDWIXn/5uzmJVFk=
Date: Thu, 30 Oct 2025 20:12:54 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,feng.tang@linux.alibaba.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-sys_info-replace-struct-sys_info_name-with-plain-array-of-strings.patch added to mm-nonmm-unstable branch
Message-Id: <20251031031255.0F643C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: sys_info:replace struct sys_info_name with plain array of strings
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-sys_info-replace-struct-sys_info_name-with-plain-array-of-strings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-sys_info-replace-struct-sys_info_name-with-plain-array-of-strings.patch

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
Subject: panic: sys_info:replace struct sys_info_name with plain array of strings
Date: Thu, 30 Oct 2025 12:44:19 +0100

There is no need to keep a custom structure just for the need of a plain
array of strings.  Replace struct sys_info_name with plain array of
strings.

With that done, simplify the code, in particular, naturally use
for_each_set_bit() when iterating over si_bits_global bitmap.

Link: https://lkml.kernel.org/r/20251030132007.3742368-4-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Feng Tang <feng.tang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sys_info.c |   44 ++++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

--- a/lib/sys_info.c~panic-sys_info-replace-struct-sys_info_name-with-plain-array-of-strings
+++ a/lib/sys_info.c
@@ -1,30 +1,29 @@
 // SPDX-License-Identifier: GPL-2.0-only
-#include <linux/sched/debug.h>
+#include <linux/bitops.h>
 #include <linux/console.h>
+#include <linux/log2.h>
 #include <linux/kernel.h>
 #include <linux/ftrace.h>
-#include <linux/sysctl.h>
 #include <linux/nmi.h>
+#include <linux/sched/debug.h>
+#include <linux/string.h>
+#include <linux/sysctl.h>
 
 #include <linux/sys_info.h>
 
-struct sys_info_name {
-	unsigned long bit;
-	const char *name;
-};
-
 /*
  * When 'si_names' gets updated,  please make sure the 'sys_info_avail'
  * below is updated accordingly.
  */
-static const struct sys_info_name  si_names[] = {
-	{ SYS_INFO_TASKS,		"tasks" },
-	{ SYS_INFO_MEM,			"mem" },
-	{ SYS_INFO_TIMERS,		"timers" },
-	{ SYS_INFO_LOCKS,		"locks" },
-	{ SYS_INFO_FTRACE,		"ftrace" },
-	{ SYS_INFO_ALL_BT,		"all_bt" },
-	{ SYS_INFO_BLOCKED_TASKS,	"blocked_tasks" },
+static const char * const si_names[] = {
+	[ilog2(SYS_INFO_TASKS)]			= "tasks",
+	[ilog2(SYS_INFO_MEM)]			= "mem",
+	[ilog2(SYS_INFO_TIMERS)]		= "timers",
+	[ilog2(SYS_INFO_LOCKS)]			= "locks",
+	[ilog2(SYS_INFO_FTRACE)]		= "ftrace",
+	[ilog2(SYS_INFO_PANIC_CONSOLE_REPLAY)]	= "",
+	[ilog2(SYS_INFO_ALL_BT)]		= "all_bt",
+	[ilog2(SYS_INFO_BLOCKED_TASKS)]		= "blocked_tasks",
 };
 
 /* Expecting string like "xxx_sys_info=tasks,mem,timers,locks,ftrace,..." */
@@ -36,12 +35,9 @@ unsigned long sys_info_parse_param(char
 
 	s = str;
 	while ((name = strsep(&s, ",")) && *name) {
-		for (i = 0; i < ARRAY_SIZE(si_names); i++) {
-			if (!strcmp(name, si_names[i].name)) {
-				si_bits |= si_names[i].bit;
-				break;
-			}
-		}
+		i = match_string(si_names, ARRAY_SIZE(si_names), name);
+		if (i >= 0)
+			__set_bit(i, &si_bits);
 	}
 
 	return si_bits;
@@ -85,10 +81,10 @@ int sysctl_sys_info_handler(const struct
 		si_bits = READ_ONCE(*si_bits_global);
 
 		names[0] = '\0';
-		for (i = 0; i < ARRAY_SIZE(si_names); i++) {
-			if (si_bits & si_names[i].bit) {
+		for_each_set_bit(i, &si_bits, ARRAY_SIZE(si_names)) {
+			if (*si_names[i]) {
 				len += scnprintf(names + len, sizeof(names) - len,
-					"%s%s", delim, si_names[i].name);
+						 "%s%s", delim, si_names[i]);
 				delim = ",";
 			}
 		}
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

panic-sys_info-capture-si_bits_global-before-iterating-over-it.patch
panic-sys_info-align-constant-definition-names-with-parameters.patch
panic-sys_info-replace-struct-sys_info_name-with-plain-array-of-strings.patch
panic-sys_info-rewrite-a-fix-for-a-compilation-error-make-w=1.patch
panic-sys_info-deduplicate-local-variable-table-assignments.patch
panic-sys_info-factor-out-read-and-write-handlers.patch


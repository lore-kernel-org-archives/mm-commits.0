Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FCD2FB96A
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676253; cv=none; b=QHgKglRL4mJlJG0ZGaNLuvAtZksv3GnftirE5iQ2+q6BbVgo+mNAh+Q4ut4Nht9SILyLlzmeTuqluJvs76k6sik0SWkldhEqQHiym/AMsCl9RnC9FG73rvALsyxrlL4tPR2drOac473nthJHuNyAoAiSLjlG+02+Ry6/4/8oxSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676253; c=relaxed/simple;
	bh=eQEWwmeoByN0sfw1xszroBImCo3GEetn5VpK7lbXEug=;
	h=Date:To:From:Subject:Message-Id; b=ioaNatjrji+3+/s9EGEpmJGHccDjYOIzHXD+DL0OMvCLlefAojKV7RgkcyL5vzxoT5hxEfdrgLwLkYWLFPTExmL3T1/Ehx/bWhnJuLTMBqds7H1f9RZm93EbCncEt3ygvy40GEfwV/kXFsZ82fnvqROaXssvyYCf9NIMA8HRw/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=opHRimPd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="opHRimPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD2CC4CEF1;
	Thu, 20 Nov 2025 22:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676252;
	bh=eQEWwmeoByN0sfw1xszroBImCo3GEetn5VpK7lbXEug=;
	h=Date:To:From:Subject:From;
	b=opHRimPdrGNN9BjonIAsBGTwcDXxTuh9+I/k9aTN/rwGPRXHTNb3/BuGiUSDQpHu3
	 D581Nolr0t+EJOAxLMbGzhP6bun6lyDUO3evTVyYysPDi4vvpM8X9IjsgGuZhJgUTa
	 hap5sQvUL1mKirSWXB4OeUmx909yQGDqtfkPWWCE=
Date: Thu, 20 Nov 2025 14:04:11 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,feng.tang@linux.alibaba.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] panic-sys_info-replace-struct-sys_info_name-with-plain-array-of-strings.patch removed from -mm tree
Message-Id: <20251120220412.3AD2CC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: sys_info:replace struct sys_info_name with plain array of strings
has been removed from the -mm tree.  Its filename was
     panic-sys_info-replace-struct-sys_info_name-with-plain-array-of-strings.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



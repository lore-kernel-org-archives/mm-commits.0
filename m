Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90EC2FC010
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676253; cv=none; b=UhAJjgLdKlcFNnaWJG5GoqeHwLFx1gKxVa+66zw/9kn93G+yqVZpj4bAtrHeG4hcStcV9/BlOOEKyZm1iOyO4K6epNzn1vDw0k+/bfwqS/zcLWSfszp/UMvL0HyaAto3smdf0J0EytUW1E529bsBq15rdVqXqu9Fkef/AyNQewA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676253; c=relaxed/simple;
	bh=YHtGBO4/f+Db+e21+j8PqNAi2GiTiKQbRRroYPzli5w=;
	h=Date:To:From:Subject:Message-Id; b=VOmcMnxYfJh/0WzmyIH1YaGSBwJBNVQu59dSX470y3FNag56cKNaJNUQkp1J6Ty+fFnTnnOVRf89+AqNVo1n4VmVSYnBJQykb5v9/b5Qo8QaioMyZK2Cab61oHFyzB3pZe5MsqpPY2crOhhvnx7+MrJG9AG67/fS96Oj0RMtyTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RnmPfxEa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RnmPfxEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B96C113D0;
	Thu, 20 Nov 2025 22:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676253;
	bh=YHtGBO4/f+Db+e21+j8PqNAi2GiTiKQbRRroYPzli5w=;
	h=Date:To:From:Subject:From;
	b=RnmPfxEaM4eMSNrPbpP7RaLa7luRMKlx9MxBLGsupzUbMVQ2lnQLuq7HTOQKdeQUs
	 2B+vD4TSwqaz2biFPDmsB5YrgBYPjR1f/tjjYZmAe8X2Tnh6UXV5wCov7E0YebPVqR
	 HmgalJjIvS9FawCjqAoaReq0OeoNQUKdNkbGy0QA=
Date: Thu, 20 Nov 2025 14:04:12 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,feng.tang@linux.alibaba.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] panic-sys_info-rewrite-a-fix-for-a-compilation-error-make-w=1.patch removed from -mm tree
Message-Id: <20251120220413.41B96C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: sys_info: rewrite a fix for a compilation error (`make W=1`)
has been removed from the -mm tree.  Its filename was
     panic-sys_info-rewrite-a-fix-for-a-compilation-error-make-w=1.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: panic: sys_info: rewrite a fix for a compilation error (`make W=1`)
Date: Thu, 30 Oct 2025 12:44:20 +0100

Compiler was not happy about dead variable in use:

lib/sys_info.c:52:19: error: variable 'sys_info_avail' is not needed and will not be emitted [-Werror,-Wunneeded-internal-declaration]
   52 | static const char sys_info_avail[] = "tasks,mem,timers,locks,ftrace,all_bt,blocked_tasks";
      |                   ^~~~~~~~~~~~~~

This was fixed by adding __maybe_unused attribute that just hides the
issue and didn't actually fix the root cause.  Rewrite the fix by moving
the local variable from stack to a heap.

As a side effect this drops unneeded "synchronisation" of duplicative info
and also makes code ready for the further refactoring.

Link: https://lkml.kernel.org/r/20251030132007.3742368-5-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Feng Tang <feng.tang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sys_info.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

--- a/lib/sys_info.c~panic-sys_info-rewrite-a-fix-for-a-compilation-error-make-w=1
+++ a/lib/sys_info.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
+#include <linux/array_size.h>
 #include <linux/bitops.h>
+#include <linux/cleanup.h>
 #include <linux/console.h>
 #include <linux/log2.h>
 #include <linux/kernel.h>
@@ -11,10 +13,6 @@
 
 #include <linux/sys_info.h>
 
-/*
- * When 'si_names' gets updated,  please make sure the 'sys_info_avail'
- * below is updated accordingly.
- */
 static const char * const si_names[] = {
 	[ilog2(SYS_INFO_TASKS)]			= "tasks",
 	[ilog2(SYS_INFO_MEM)]			= "mem",
@@ -45,25 +43,32 @@ unsigned long sys_info_parse_param(char
 
 #ifdef CONFIG_SYSCTL
 
-static const char sys_info_avail[] __maybe_unused = "tasks,mem,timers,locks,ftrace,all_bt,blocked_tasks";
-
 int sysctl_sys_info_handler(const struct ctl_table *ro_table, int write,
 					  void *buffer, size_t *lenp,
 					  loff_t *ppos)
 {
-	char names[sizeof(sys_info_avail)];
 	struct ctl_table table;
 	unsigned long *si_bits_global;
 	unsigned long si_bits;
+	unsigned int i;
+	size_t maxlen;
 
 	si_bits_global = ro_table->data;
 
+	maxlen = 0;
+	for (i = 0; i < ARRAY_SIZE(si_names); i++)
+		maxlen += strlen(si_names[i]) + 1;
+
+	char *names __free(kfree) = kzalloc(maxlen, GFP_KERNEL);
+	if (!names)
+		return -ENOMEM;
+
 	if (write) {
 		int ret;
 
 		table = *ro_table;
 		table.data = names;
-		table.maxlen = sizeof(names);
+		table.maxlen = maxlen;
 		ret = proc_dostring(&table, write, buffer, lenp, ppos);
 		if (ret)
 			return ret;
@@ -74,16 +79,15 @@ int sysctl_sys_info_handler(const struct
 		return 0;
 	} else {
 		/* for 'read' operation */
+		unsigned int len = 0;
 		char *delim = "";
-		int i, len = 0;
 
 		/* The access to the global value is not synchronized. */
 		si_bits = READ_ONCE(*si_bits_global);
 
-		names[0] = '\0';
 		for_each_set_bit(i, &si_bits, ARRAY_SIZE(si_names)) {
 			if (*si_names[i]) {
-				len += scnprintf(names + len, sizeof(names) - len,
+				len += scnprintf(names + len, maxlen - len,
 						 "%s%s", delim, si_names[i]);
 				delim = ",";
 			}
@@ -91,7 +95,7 @@ int sysctl_sys_info_handler(const struct
 
 		table = *ro_table;
 		table.data = names;
-		table.maxlen = sizeof(names);
+		table.maxlen = maxlen;
 		return proc_dostring(&table, write, buffer, lenp, ppos);
 	}
 }
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are



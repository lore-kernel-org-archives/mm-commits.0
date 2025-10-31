Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970A02D0C8B
	for <mm-commits@vger.kernel.org>; Fri, 31 Oct 2025 03:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761880378; cv=none; b=vGeCVUJv4nhDCt36L4jS/CXnQJCMpsUyTXjq1CuI1FY417IGgahHYQrl/c2yElijPHnvWxHBaN6dONiz8tVHi3n1u+3RDuySL3Xf2K4+leCbzBdDcps4yzX7F/DctFbE2dpkBlI0wPVIqqd1wQkEhl6BQOyIqNJMVlMEt2dWUl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761880378; c=relaxed/simple;
	bh=evuDytT/YPCBhyTmp7oTVXzxTUok3co1Je/FoMm6Dlk=;
	h=Date:To:From:Subject:Message-Id; b=TVV8BKPObRPRt+jG0rr9ubtwvkvXI+OZ6wchr/1bFqd5Oy+f248Gdx0l9KPp/jvEhy8qT58HsylSf7PkKvzAD4smm1SnFmpXJ+E7GHrwF+b37IZydTAINfR+/lvf3GCxDc5cuXBiKKnukeQEUDQgXKmE1ERXbY0Q2Ma8VdclHIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eiSgsWIN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eiSgsWIN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2158FC4CEF1;
	Fri, 31 Oct 2025 03:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761880377;
	bh=evuDytT/YPCBhyTmp7oTVXzxTUok3co1Je/FoMm6Dlk=;
	h=Date:To:From:Subject:From;
	b=eiSgsWINv8F+wtd43BTLpmBl/htFx+OjO+3xJyzt+PdlAqjHkuGNvnpYa2cN7WNGN
	 biaDzkGnIyxYaQJgVFto4ZHQd25zUI5EQLFinDbcykcYVdF7SHHAELCrSo5Ls99KJh
	 VVp2c/c3/ib/feg4gGuRPPkMH5r6jzif7nD2QSCc=
Date: Thu, 30 Oct 2025 20:12:56 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,feng.tang@linux.alibaba.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-sys_info-rewrite-a-fix-for-a-compilation-error-make-w=1.patch added to mm-nonmm-unstable branch
Message-Id: <20251031031257.2158FC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: sys_info: rewrite a fix for a compilation error (`make W=1`)
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-sys_info-rewrite-a-fix-for-a-compilation-error-make-w=1.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-sys_info-rewrite-a-fix-for-a-compilation-error-make-w=1.patch

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

panic-sys_info-capture-si_bits_global-before-iterating-over-it.patch
panic-sys_info-align-constant-definition-names-with-parameters.patch
panic-sys_info-replace-struct-sys_info_name-with-plain-array-of-strings.patch
panic-sys_info-rewrite-a-fix-for-a-compilation-error-make-w=1.patch
panic-sys_info-deduplicate-local-variable-table-assignments.patch
panic-sys_info-factor-out-read-and-write-handlers.patch


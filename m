Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB68274B51
	for <mm-commits@vger.kernel.org>; Fri, 31 Oct 2025 03:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761880373; cv=none; b=ZKKCwEuOF2S1HSbSeKPLg7fq764aTn1+8vs220pZ1YePT0o/lTNgE/8hLuLZLbd30U0CQZvOLD/ZddlzIC11/YJgiSuwLigKAesdtj92uSP3ayPZCWFCk3q6bn/kOnWx5ii4tV0gzYHwn9IFal0CFEs61TXBsnnUxFJKMxxIH24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761880373; c=relaxed/simple;
	bh=uE+2hNqKQpLZY2dhYL+MPKw7M7Nlbll5+5OgmbvSfqA=;
	h=Date:To:From:Subject:Message-Id; b=PE+UThzdB1d5eJ+VFNjm6vr9PbTIhJfcnZf9xOmsYBH6+RZgZacwPeqNk4pFv1J/Jr6nFUkDxLhs7tVWpDl4U/jqGqxXA9K0Mng/Vb3iTdOqLnUISwmwg3uowz7VZ2Gh40OJm/YslkPK/Snnxl31+CZr/rbDJD2HOr2EUZNnlwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KhbIucGM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KhbIucGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49EFCC4CEFD;
	Fri, 31 Oct 2025 03:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761880372;
	bh=uE+2hNqKQpLZY2dhYL+MPKw7M7Nlbll5+5OgmbvSfqA=;
	h=Date:To:From:Subject:From;
	b=KhbIucGMxTWB75wAVIaTuYZTiW7tuFUAZF7HPK6L2nGLQLc6Z3hCbcA1Ma4aHopdo
	 FfGq7rHYx6E+eR3LrY6LL1xawfm8qPwLfGPNOgB2INZ1plKo1IDPOwKJLTj73RoM/m
	 VGxJJgA10mMoU7qERQ5IkSTrFI2QgEgcpGRkM4x8=
Date: Thu, 30 Oct 2025 20:12:51 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,feng.tang@linux.alibaba.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-sys_info-align-constant-definition-names-with-parameters.patch added to mm-nonmm-unstable branch
Message-Id: <20251031031252.49EFCC4CEFD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: sys_info: align constant definition names with parameters
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-sys_info-align-constant-definition-names-with-parameters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-sys_info-align-constant-definition-names-with-parameters.patch

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

panic-sys_info-capture-si_bits_global-before-iterating-over-it.patch
panic-sys_info-align-constant-definition-names-with-parameters.patch
panic-sys_info-replace-struct-sys_info_name-with-plain-array-of-strings.patch
panic-sys_info-rewrite-a-fix-for-a-compilation-error-make-w=1.patch
panic-sys_info-deduplicate-local-variable-table-assignments.patch
panic-sys_info-factor-out-read-and-write-handlers.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5006274FC2
	for <mm-commits@vger.kernel.org>; Fri, 31 Oct 2025 03:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761880371; cv=none; b=U7AlujI9SKJdVlMMrhjYVxYpwQfTgjaBu3JKab0nRh8Ja/RRvMUMNp+Q1kcNWPorbZnLg7aq2po1gBGLEvc72Lg5iAA/O3Idg0WK2thguA46tuz0CAKoFvvqmmlTc8gA+QBXN2G31ws9iBmkPlYEgyZd6PyAFbbepOHA841/mSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761880371; c=relaxed/simple;
	bh=cF+zBZLT9rgg2WQb9YEgBrIOAPQHoVSlbuA1Yn34oUU=;
	h=Date:To:From:Subject:Message-Id; b=kbAZuUB5HfMGpiZgCC7qPUynl+DL5a2jiFisGMXmrTah9+6n0R+mjW2raRkn7YpO67zloxuCPnOUKyOzMJlCT4tWkVxIKt3IBKV875+mPygGUycptoibJAKW0JQ0qgA7jylH1VoAfZrTn+Yte7tTMLC4rMkTKQbJ2Ze1ueXo48s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yD0DfVB0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yD0DfVB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB0CC113D0;
	Fri, 31 Oct 2025 03:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761880370;
	bh=cF+zBZLT9rgg2WQb9YEgBrIOAPQHoVSlbuA1Yn34oUU=;
	h=Date:To:From:Subject:From;
	b=yD0DfVB0knBamjw6PR1C13t6vVMivnGZC6/HqU9FeugO2vxrCRMrHRnZ1/wd7femY
	 cqQDEgd3z/7QktyC5Khz4qDPh1GCcu6Mnit27zJnF9GpbVaWFO8kRqKv87/krtM3+2
	 4ZKubPXXGMB+G/JZTtXwges1qiakjeWAaHhan0FY=
Date: Thu, 30 Oct 2025 20:12:49 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,feng.tang@linux.alibaba.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-sys_info-capture-si_bits_global-before-iterating-over-it.patch added to mm-nonmm-unstable branch
Message-Id: <20251031031250.4EB0CC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: sys_info: capture si_bits_global before iterating over it
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-sys_info-capture-si_bits_global-before-iterating-over-it.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-sys_info-capture-si_bits_global-before-iterating-over-it.patch

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
Subject: panic: sys_info: capture si_bits_global before iterating over it
Date: Thu, 30 Oct 2025 12:44:17 +0100

Patch series "panic: sys_info: Refactor and fix a potential issue", v3.

While targeting the compilation issue due to dangling variable, I have
noticed more opportunities for refactoring that helps to avoid above
mentioned compilation issue in a cleaner way and also fixes a potential
problem with global variable access.


This patch (of 6):

The for-loop might re-read the content of the memory the si_bits_global
points to on each iteration.  Instead, just capture it for the sake of
consistency and use that instead.

Link: https://lkml.kernel.org/r/20251030132007.3742368-1-andriy.shevchenko@linux.intel.com
Link: https://lkml.kernel.org/r/20251030132007.3742368-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Feng Tang <feng.tang@linux.alibaba.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sys_info.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/lib/sys_info.c~panic-sys_info-capture-si_bits_global-before-iterating-over-it
+++ a/lib/sys_info.c
@@ -58,11 +58,11 @@ int sysctl_sys_info_handler(const struct
 	char names[sizeof(sys_info_avail)];
 	struct ctl_table table;
 	unsigned long *si_bits_global;
+	unsigned long si_bits;
 
 	si_bits_global = ro_table->data;
 
 	if (write) {
-		unsigned long si_bits;
 		int ret;
 
 		table = *ro_table;
@@ -81,9 +81,12 @@ int sysctl_sys_info_handler(const struct
 		char *delim = "";
 		int i, len = 0;
 
+		/* The access to the global value is not synchronized. */
+		si_bits = READ_ONCE(*si_bits_global);
+
 		names[0] = '\0';
 		for (i = 0; i < ARRAY_SIZE(si_names); i++) {
-			if (*si_bits_global & si_names[i].bit) {
+			if (si_bits & si_names[i].bit) {
 				len += scnprintf(names + len, sizeof(names) - len,
 					"%s%s", delim, si_names[i].name);
 				delim = ",";
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

panic-sys_info-capture-si_bits_global-before-iterating-over-it.patch
panic-sys_info-align-constant-definition-names-with-parameters.patch
panic-sys_info-replace-struct-sys_info_name-with-plain-array-of-strings.patch
panic-sys_info-rewrite-a-fix-for-a-compilation-error-make-w=1.patch
panic-sys_info-deduplicate-local-variable-table-assignments.patch
panic-sys_info-factor-out-read-and-write-handlers.patch


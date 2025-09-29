Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF78E46BF
	for <mm-commits@vger.kernel.org>; Mon, 29 Sep 2025 22:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759186215; cv=none; b=cMYDkI11+OUWrCF4CUcRvoacfib4V3q5HAdLPig1HK8QaEwSCi63ZUWt9ZKEL6INvNmNe7kWEQGTA0qvf4Mk3L+GAeN1eSCSKxvNWoCzN3YzLCFP+wxHlfvSvNWh+5MmHCGiDDJG6B4pj9XunEVHo7Yt8L6KqUf1ys2/oxQXAi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759186215; c=relaxed/simple;
	bh=3dm22E1qtOPltsdNOjhKREHTpzU6TlatAvLhiarawus=;
	h=Date:To:From:Subject:Message-Id; b=pqseUmEiy32L4NCJdn+izHvGF2IUWllv70r0S9WT3yVQaxJwLQDj17oQkWtWDmBU8VnQkyiGb87HroDpgyxkaNR6VC4ZE3G4fLslwdYnxnQvWbes7ggllpuX3WAl3mVvtSv21YeQz3MQ8aIoK2hy2reCuf9u15zAtAKe1zwgSN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LQglYgzT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LQglYgzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F32C4CEF4;
	Mon, 29 Sep 2025 22:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759186215;
	bh=3dm22E1qtOPltsdNOjhKREHTpzU6TlatAvLhiarawus=;
	h=Date:To:From:Subject:From;
	b=LQglYgzT+Ya3c8hBIWM+SVL0tU//E2Q/VU6SO+Tw2YPZf8v5RCL2qOyJ8FfdQ7pX/
	 WPjH9Ikoganku4C2vBZuyBJgpR32rmNpE9oyxpGx1sscUohexR6zXbWFh4go7QwbOM
	 JuQ0Cu4AAz8D+bQLL+dIK2vjv5IcINUCZS8zahFI=
Date: Mon, 29 Sep 2025 15:50:14 -0700
To: mm-commits@vger.kernel.org,zhouyuhang@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-fix-coding-style-issues-in-kconfig.patch added to mm-nonmm-unstable branch
Message-Id: <20250929225015.30F32C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples: fix coding style issues in Kconfig
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     samples-fix-coding-style-issues-in-kconfig.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-fix-coding-style-issues-in-kconfig.patch

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
From: Zhou Yuhang <zhouyuhang@kylinos.cn>
Subject: samples: fix coding style issues in Kconfig
Date: Mon, 29 Sep 2025 14:24:34 +0800

Fix some coding style issues in Kconfig: use one tab to indent lines under
a config definition, and use an additional two spaces to indent help text.

Link: https://lkml.kernel.org/r/20250929062434.4114607-1-zhouyuhang1010@163.com
Signed-off-by: Zhou Yuhang <zhouyuhang@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/Kconfig |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/samples/Kconfig~samples-fix-coding-style-issues-in-kconfig
+++ a/samples/Kconfig
@@ -23,11 +23,11 @@ config SAMPLE_TRACE_CUSTOM_EVENTS
 	  This builds the custom trace event example module.
 
 config SAMPLE_TRACE_PRINTK
-        tristate "Build trace_printk module - tests various trace_printk formats"
+	tristate "Build trace_printk module - tests various trace_printk formats"
 	depends on EVENT_TRACING && m
 	help
-	 This builds a module that calls trace_printk() and can be used to
-	 test various trace_printk() calls from a module.
+	  This builds a module that calls trace_printk() and can be used to
+	  test various trace_printk() calls from a module.
 
 config SAMPLE_FTRACE_DIRECT
 	tristate "Build register_ftrace_direct() example"
@@ -54,11 +54,11 @@ config SAMPLE_FTRACE_OPS
 	  measures the time taken to invoke one function a number of times.
 
 config SAMPLE_TRACE_ARRAY
-        tristate "Build sample module for kernel access to Ftrace instances"
+	tristate "Build sample module for kernel access to Ftrace instances"
 	depends on EVENT_TRACING && m
 	help
-	 This builds a module that demonstrates the use of various APIs to
-	 access Ftrace instances from within the kernel.
+	  This builds a module that demonstrates the use of various APIs to
+	  access Ftrace instances from within the kernel.
 
 config SAMPLE_KOBJECT
 	tristate "Build kobject examples"
@@ -290,11 +290,11 @@ config SAMPLE_CORESIGHT_SYSCFG
 	  configurations and easily load them into the system at runtime.
 
 config SAMPLE_KMEMLEAK
-        tristate "Simple test for the kernel memory leak detector"
-        depends on DEBUG_KMEMLEAK && m
-        help
-          Build a sample program which have explicitly leaks memory to test
-          kmemleak
+	tristate "Simple test for the kernel memory leak detector"
+	depends on DEBUG_KMEMLEAK && m
+	help
+	  Build a sample program which have explicitly leaks memory to test
+	  kmemleak.
 
 config SAMPLE_CGROUP
 	bool "Build cgroup sample code"
_

Patches currently in -mm which might be from zhouyuhang@kylinos.cn are

samples-fix-coding-style-issues-in-kconfig.patch


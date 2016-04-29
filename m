From: akpm@linux-foundation.org
Subject: [merged] kcov-dont-profile-branches-in-kcov.patch removed from
 -mm tree
Date: Fri, 29 Apr 2016 15:05:41 -0700
Message-ID: <5723dab5.ZVY/t4LtCCWr2VB8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbcD2WFm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2016 18:05:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, dvyukov@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: don't profile branches in kcov
has been removed from the -mm tree.  Its filename was
     kcov-dont-profile-branches-in-kcov.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: kcov: don't profile branches in kcov

Profiling 'if' statements in __sanitizer_cov_trace_pc() leads to
unbound recursion and crash:
	__sanitizer_cov_trace_pc() ->
		ftrace_likely_update ->
			__sanitizer_cov_trace_pc() ...

Define DISABLE_BRANCH_PROFILING to disable this tracer.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/kcov.c~kcov-dont-profile-branches-in-kcov kernel/kcov.c
--- a/kernel/kcov.c~kcov-dont-profile-branches-in-kcov
+++ a/kernel/kcov.c
@@ -1,5 +1,6 @@
 #define pr_fmt(fmt) "kcov: " fmt
 
+#define DISABLE_BRANCH_PROFILING
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <linux/file.h>
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are



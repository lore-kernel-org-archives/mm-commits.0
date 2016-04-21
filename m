From: akpm@linux-foundation.org
Subject: + kcov-dont-profile-branches-in-kcov.patch added to -mm tree
Date: Thu, 21 Apr 2016 15:07:28 -0700
Message-ID: <57194f20.nbyiWho9ToKoOiwf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58921 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbcDUWH3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2016 18:07:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, dvyukov@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: don't profile branches in kcov
has been added to the -mm tree.  Its filename is
     kcov-dont-profile-branches-in-kcov.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kcov-dont-profile-branches-in-kcov.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kcov-dont-profile-branches-in-kcov.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kcov-dont-profile-branches-in-kcov.patch


From: akpm@linux-foundation.org
Subject: + kcov-dont-trace-the-code-coverage-code.patch added to -mm tree
Date: Fri, 22 Apr 2016 14:00:10 -0700
Message-ID: <571a90da.qNAPx6wWEvCplaPN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbcDVVAL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2016 17:00:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: james.morse@arm.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: Don't trace the code coverage code
has been added to the -mm tree.  Its filename is
     kcov-dont-trace-the-code-coverage-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kcov-dont-trace-the-code-coverage-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kcov-dont-trace-the-code-coverage-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: James Morse <james.morse@arm.com>
Subject: kcov: Don't trace the code coverage code

Kcov causes the compiler to add a call to __sanitizer_cov_trace_pc() in
every basic block.  Ftrace patches in a call to _mcount() to each function
it has annotated.

Letting these mechanisms annotate each other is a bad thing.  Break the
loop by adding 'notrace' to __sanitizer_cov_trace_pc() so that ftrace
won't try to patch this code.

This patch lets arm64 with KCOV and STACK_TRACER boot.

Signed-off-by: James Morse <james.morse@arm.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kcov.c~kcov-dont-trace-the-code-coverage-code kernel/kcov.c
--- a/kernel/kcov.c~kcov-dont-trace-the-code-coverage-code
+++ a/kernel/kcov.c
@@ -43,7 +43,7 @@ struct kcov {
  * Entry point from instrumented code.
  * This is called once per basic-block/edge.
  */
-void __sanitizer_cov_trace_pc(void)
+void notrace __sanitizer_cov_trace_pc(void)
 {
 	struct task_struct *t;
 	enum kcov_mode mode;
_

Patches currently in -mm which might be from james.morse@arm.com are

kcov-dont-trace-the-code-coverage-code.patch


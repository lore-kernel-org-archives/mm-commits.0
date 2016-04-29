From: akpm@linux-foundation.org
Subject: [merged] kcov-dont-trace-the-code-coverage-code.patch removed
 from -mm tree
Date: Fri, 29 Apr 2016 15:05:39 -0700
Message-ID: <5723dab3.UK+IxTK0iyymy7T4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45443 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbcD2WFk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2016 18:05:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: james.morse@arm.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: don't trace the code coverage code
has been removed from the -mm tree.  Its filename was
     kcov-dont-trace-the-code-coverage-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: James Morse <james.morse@arm.com>
Subject: kcov: don't trace the code coverage code

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



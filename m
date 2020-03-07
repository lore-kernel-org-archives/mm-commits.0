From: akpm@linux-foundation.org
Subject: [merged]
 arch-kconfig-update-have_reliable_stacktrace-description.patch removed from
 -mm tree
Date: Fri, 06 Mar 2020 20:01:30 -0800
Message-ID: <20200307040130.ygwklYNDd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgCGEBb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 6 Mar 2020 23:01:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jpoimboe@redhat.com, mbenes@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/Kconfig: update HAVE_RELIABLE_STACKTRACE description
has been removed from the -mm tree.  Its filename was
     arch-kconfig-update-have_reliable_stacktrace-description.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miroslav Benes <mbenes@suse.cz>
Subject: arch/Kconfig: update HAVE_RELIABLE_STACKTRACE description

save_stack_trace_tsk_reliable() is not the only function providing the
reliable stack traces anymore.  Architecture might define ARCH_STACKWALK
which provides a newer stack walking interface and has
arch_stack_walk_reliable() function.  Update the description accordingly.

Link: http://lkml.kernel.org/r/20200120154042.9934-1-mbenes@suse.cz
Signed-off-by: Miroslav Benes <mbenes@suse.cz>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/Kconfig~arch-kconfig-update-have_reliable_stacktrace-description
+++ a/arch/Kconfig
@@ -738,8 +738,9 @@ config HAVE_STACK_VALIDATION
 config HAVE_RELIABLE_STACKTRACE
 	bool
 	help
-	  Architecture has a save_stack_trace_tsk_reliable() function which
-	  only returns a stack trace if it can guarantee the trace is reliable.
+	  Architecture has either save_stack_trace_tsk_reliable() or
+	  arch_stack_walk_reliable() function which only returns a stack trace
+	  if it can guarantee the trace is reliable.
 
 config HAVE_ARCH_HASH
 	bool
_

Patches currently in -mm which might be from mbenes@suse.cz are

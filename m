From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 arch-kconfig-update-have_reliable_stacktrace-description.patch added to -mm
 tree
Date: Mon, 24 Feb 2020 16:26:30 -0800
Message-ID: <20200225002630.IesRpCkVz%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728087AbgBYA0b (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Feb 2020 19:26:31 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jpoimboe@redhat.com, mbenes@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/Kconfig: update HAVE_RELIABLE_STACKTRACE description
has been added to the -mm tree.  Its filename is
     arch-kconfig-update-have_reliable_stacktrace-description.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-kconfig-update-have_reliable_stacktrace-description.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-kconfig-update-have_reliable_stacktrace-description.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

arch-kconfig-update-have_reliable_stacktrace-description.patch

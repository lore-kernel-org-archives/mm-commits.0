From: akpm@linux-foundation.org
Subject: +
 ubsan-entirely-disable-alignment-checks-under-ubsan_trap.patch added to -mm
 tree
Date: Fri, 29 May 2020 13:16:15 -0700
Message-ID: <20200529201615.tUza8IAeg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726878AbgE2UQR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 29 May 2020 16:16:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, jpoimboe@redhat.com, keescook@chromium.org, lenaptr@google.com, mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: ubsan: entirely disable alignment checks under UBSAN_TRAP
has been added to the -mm tree.  Its filename is
     ubsan-entirely-disable-alignment-checks-under-ubsan_trap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ubsan-entirely-disable-alignment-checks-under-ubsan_trap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ubsan-entirely-disable-alignment-checks-under-ubsan_trap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: ubsan: entirely disable alignment checks under UBSAN_TRAP

Commit 8d58f222e85f ("ubsan: disable UBSAN_ALIGNMENT under COMPILE_TEST")
tried to fix the pathological results of UBSAN_ALIGNMENT with UBSAN_TRAP
(which objtool would rightly scream about), but it made an assumption
about how COMPILE_TEST gets set (it is not set for randconfig).  As a
result, we need a bigger hammer here: just don't allow the alignment
checks with the trap mode.

Link: http://lkml.kernel.org/r/202005291236.000FCB6@keescook
Link: https://lore.kernel.org/lkml/742521db-1e8c-0d7a-1ed4-a908894fb497@infradead.org/
Fixes: 8d58f222e85f ("ubsan: disable UBSAN_ALIGNMENT under COMPILE_TEST")
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Elena Petrova <lenaptr@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.ubsan |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/Kconfig.ubsan~ubsan-entirely-disable-alignment-checks-under-ubsan_trap
+++ a/lib/Kconfig.ubsan
@@ -63,7 +63,7 @@ config UBSAN_SANITIZE_ALL
 config UBSAN_ALIGNMENT
 	bool "Enable checks for pointers alignment"
 	default !HAVE_EFFICIENT_UNALIGNED_ACCESS
-	depends on !X86 || !COMPILE_TEST
+	depends on !UBSAN_TRAP
 	help
 	  This option enables the check of unaligned memory accesses.
 	  Enabling this option on architectures that support unaligned
_

Patches currently in -mm which might be from keescook@chromium.org are

ubsan-entirely-disable-alignment-checks-under-ubsan_trap.patch
exec-change-uselib2-is_sreg-failure-to-eacces.patch
exec-relocate-s_isreg-check.patch
exec-relocate-path_noexec-check.patch
fs-include-fmode_exec-when-converting-flags-to-f_mode.patch

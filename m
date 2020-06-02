From: akpm@linux-foundation.org
Subject: [merged]
 ubsan-entirely-disable-alignment-checks-under-ubsan_trap.patch removed from
 -mm tree
Date: Tue, 02 Jun 2020 14:43:19 -0700
Message-ID: <20200602214319.RJ9dySLGL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgFBVnU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:43:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, jpoimboe@redhat.com, keescook@chromium.org, lenaptr@google.com, mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: ubsan: entirely disable alignment checks under UBSAN_TRAP
has been removed from the -mm tree.  Its filename was
     ubsan-entirely-disable-alignment-checks-under-ubsan_trap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

exec-change-uselib2-is_sreg-failure-to-eacces.patch
exec-relocate-s_isreg-check.patch
exec-relocate-path_noexec-check.patch
fs-include-fmode_exec-when-converting-flags-to-f_mode.patch

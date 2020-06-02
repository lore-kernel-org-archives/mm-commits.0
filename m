From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 126/128] ubsan: entirely disable alignment checks
 under UBSAN_TRAP
Date: Mon, 01 Jun 2020 21:52:46 -0700
Message-ID: <20200602045246.pe2oJNbY9%akpm@linux-foundation.org>
References: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbgFBEwr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:52:47 -0400
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dvyukov@google.com, jpoimboe@redhat.com, keescook@chromium.org, lenaptr@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, rdunlap@infradead.org, torvalds@linux-foundation.org

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

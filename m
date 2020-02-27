From: akpm@linux-foundation.org
Subject: + ubsan-check-panic_on_warn.patch added to -mm tree
Date: Thu, 27 Feb 2020 15:30:38 -0800
Message-ID: <20200227233038.VN1M9WsAh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729838AbgB0Xaj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 27 Feb 2020 18:30:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, ard.biesheuvel@linaro.org, arnd@arndb.de, aryabinin@virtuozzo.com, dan.carpenter@oracle.com, dvyukov@google.com, glider@google.com, gustavo@embeddedor.com, keescook@chromium.org, lenaptr@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan: check panic_on_warn
has been added to the -mm tree.  Its filename is
     ubsan-check-panic_on_warn.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ubsan-check-panic_on_warn.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ubsan-check-panic_on_warn.patch

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
Subject: ubsan: check panic_on_warn

Syzkaller expects kernel warnings to panic when the panic_on_warn sysctl
is set.  More work is needed here to have UBSan reuse the WARN
infrastructure, but for now, just check the flag manually.

Link: https://lore.kernel.org/lkml/CACT4Y+bsLJ-wFx_TaXqax3JByUOWB3uk787LsyMVcfW6JzzGvg@mail.gmail.com
Link: http://lkml.kernel.org/r/20200227193516.32566-5-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Elena Petrova <lenaptr@google.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ubsan.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/lib/ubsan.c~ubsan-check-panic_on_warn
+++ a/lib/ubsan.c
@@ -156,6 +156,17 @@ static void ubsan_epilogue(void)
 		"========================================\n");
 
 	current->in_ubsan--;
+
+	if (panic_on_warn) {
+		/*
+		 * This thread may hit another WARN() in the panic path.
+		 * Resetting this prevents additional WARN() from panicking the
+		 * system on this thread.  Other threads are blocked by the
+		 * panic_mutex in panic().
+		 */
+		panic_on_warn = 0;
+		panic("panic_on_warn set ...\n");
+	}
 }
 
 static void handle_overflow(struct overflow_data *data, void *lhs,
_

Patches currently in -mm which might be from keescook@chromium.org are

shmem-distribute-switch-variables-for-initialization.patch
lib-test_stackinitc-xfail-switch-variable-init-tests.patch
ubsan-add-trap-instrumentation-option.patch
ubsan-split-bounds-checker-from-other-options.patch
lkdtm-bugs-add-arithmetic-overflow-and-array-bounds-checks.patch
ubsan-check-panic_on_warn.patch
kasan-unset-panic_on_warn-before-calling-panic.patch
ubsan-include-bug-type-in-report-header.patch

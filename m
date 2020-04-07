From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 162/166] kasan: unset panic_on_warn before calling
 panic()
Date: Mon, 06 Apr 2020 20:12:42 -0700
Message-ID: <20200407031242.brxg9O47-%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgDGDMn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:12:43 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreyknvl@google.com, ard.biesheuvel@linaro.org, arnd@arndb.de, aryabinin@virtuozzo.com, dan.carpenter@oracle.com, dvyukov@google.com, glider@google.com, gustavo@embeddedor.com, keescook@chromium.org, lenaptr@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Kees Cook <keescook@chromium.org>
Subject: kasan: unset panic_on_warn before calling panic()

As done in the full WARN() handler, panic_on_warn needs to be cleared
before calling panic() to avoid recursive panics.

Link: http://lkml.kernel.org/r/20200227193516.32566-6-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Elena Petrova <lenaptr@google.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/kasan/report.c~kasan-unset-panic_on_warn-before-calling-panic
+++ a/mm/kasan/report.c
@@ -92,8 +92,16 @@ static void end_report(unsigned long *fl
 	pr_err("==================================================================\n");
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 	spin_unlock_irqrestore(&report_lock, *flags);
-	if (panic_on_warn)
+	if (panic_on_warn) {
+		/*
+		 * This thread may hit another WARN() in the panic path.
+		 * Resetting this prevents additional WARN() from panicking the
+		 * system on this thread.  Other threads are blocked by the
+		 * panic_mutex in panic().
+		 */
+		panic_on_warn = 0;
 		panic("panic_on_warn set ...\n");
+	}
 	kasan_enable_current();
 }
 
_

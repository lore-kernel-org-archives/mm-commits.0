From: akpm@linux-foundation.org
Subject: + kasan-add-__asan_report_loadn-storen_noabort-callbacks.patch
 added to -mm tree
Date: Mon, 22 Jan 2018 13:05:00 -0800
Message-ID: <5a6651fc.3oaBgMG+C0PS34NO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53778 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751126AbeAVVFB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Jan 2018 16:05:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, ndesaulniers@google.com, yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: add __asan_report_loadN/storeN_noabort callbacks
has been added to the -mm tree.  Its filename is
     kasan-add-__asan_report_loadn-storen_noabort-callbacks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-add-__asan_report_loadn-storen_noabort-callbacks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-add-__asan_report_loadn-storen_noabort-callbacks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: add __asan_report_loadN/storeN_noabort callbacks

Instead of __asan_report_load_n_noabort and __asan_report_store_n_noabort
callbacks Clang emits differently named __asan_report_loadN_noabort and
__asan_report_storeN_noabort (similar to __asan_loadN/storeN_noabort,
whose names both GCC and Clang agree on).

Add callback implementation for __asan_report_loadN/storeN_noabort.

Link: http://lkml.kernel.org/r/891fbd1fe77f46701fb1958e77bdd89651c12643.1516383788.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN mm/kasan/report.c~kasan-add-__asan_report_loadn-storen_noabort-callbacks mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-add-__asan_report_loadn-storen_noabort-callbacks
+++ a/mm/kasan/report.c
@@ -449,3 +449,15 @@ void __asan_report_store_n_noabort(unsig
 	kasan_report(addr, size, true, _RET_IP_);
 }
 EXPORT_SYMBOL(__asan_report_store_n_noabort);
+
+void __asan_report_loadN_noabort(unsigned long addr, size_t size)
+{
+	kasan_report(addr, size, false, _RET_IP_);
+}
+EXPORT_SYMBOL(__asan_report_loadN_noabort);
+
+void __asan_report_storeN_noabort(unsigned long addr, size_t size)
+{
+	kasan_report(addr, size, true, _RET_IP_);
+}
+EXPORT_SYMBOL(__asan_report_storeN_noabort);
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-dont-emit-builtin-calls-when-sanitization-is-off.patch
kasan-fix-prototype-author-email-address.patch
kasan-clean-up-kasan_shadow_scale_shift-usage.patch
kasan-add-__asan_report_loadn-storen_noabort-callbacks.patch


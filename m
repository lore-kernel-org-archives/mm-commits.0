From: akpm@linux-foundation.org
Subject: [withdrawn]
 kasan-add-__asan_report_loadn-storen_noabort-callbacks.patch removed from
 -mm tree
Date: Tue, 23 Jan 2018 14:17:23 -0800
Message-ID: <5a67b473.Ej3v92CrpgeQd86r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41910 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932217AbeAWWRY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 23 Jan 2018 17:17:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, ndesaulniers@google.com, yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: add __asan_report_loadN/storeN_noabort callbacks
has been removed from the -mm tree.  Its filename was
     kasan-add-__asan_report_loadn-storen_noabort-callbacks.patch

This patch was dropped because it was withdrawn

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


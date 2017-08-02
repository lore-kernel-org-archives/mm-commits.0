From: akpm@linux-foundation.org
Subject: [patch 05/16] kasan: avoid -Wmaybe-uninitialized warning
Date: Wed, 02 Aug 2017 13:31:58 -0700
Message-ID: <598236be.Fr07nQjWXjaVgbq8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45964 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752975AbdHBUb7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 16:31:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, arnd@arndb.de, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com

From: Arnd Bergmann <arnd@arndb.de>
Subject: kasan: avoid -Wmaybe-uninitialized warning

gcc-7 produces this warning:

mm/kasan/report.c: In function 'kasan_report':
mm/kasan/report.c:351:3: error: 'info.first_bad_addr' may be used uninitialized in this function [-Werror=maybe-uninitialized]
   print_shadow_for_address(info->first_bad_addr);
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mm/kasan/report.c:360:27: note: 'info.first_bad_addr' was declared here

The code seems fine as we only print info.first_bad_addr when there is a shadow,
and we always initialize it in that case, but this is relatively hard
for gcc to figure out after the latest rework. Adding an intialization
to the most likely value together with the other struct members
shuts up that warning.

Fixes: b235b9808664 ("kasan: unify report headers")
Link: https://patchwork.kernel.org/patch/9641417/
Link: http://lkml.kernel.org/r/20170725152739.4176967-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Suggested-by: Alexander Potapenko <glider@google.com>
Suggested-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/kasan/report.c~kasan-avoid-wmaybe-uninitialized-warning-v3 mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-avoid-wmaybe-uninitialized-warning-v3
+++ a/mm/kasan/report.c
@@ -401,6 +401,7 @@ void kasan_report(unsigned long addr, si
 	disable_trace_on_warning();
 
 	info.access_addr = (void *)addr;
+	info.first_bad_addr = (void *)addr;
 	info.access_size = size;
 	info.is_write = is_write;
 	info.ip = ip;
_

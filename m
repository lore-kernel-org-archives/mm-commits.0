From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-fix-kasan-unit-tests-for-tag-based-kasan-v4.patch
 added to -mm tree
Date: Wed, 08 Jul 2020 15:25:36 -0700
Message-ID: <20200708222536.iABdDq_Fh%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgGHWZh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Jul 2020 18:25:37 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, matthias.bgg@gmail.com, mm-commits@vger.kernel.org, walter-zh.wu@mediatek.com


The patch titled
     Subject: kasan-fix-kasan-unit-tests-for-tag-based-kasan-v4
has been added to the -mm tree.  Its filename is
     kasan-fix-kasan-unit-tests-for-tag-based-kasan-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-fix-kasan-unit-tests-for-tag-based-kasan-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-fix-kasan-unit-tests-for-tag-based-kasan-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Walter Wu <walter-zh.wu@mediatek.com>
Subject: kasan-fix-kasan-unit-tests-for-tag-based-kasan-v4

use KASAN_SHADOW_SCALE_SIZE instead of 13

Link: http://lkml.kernel.org/r/20200708132524.11688-1-walter-zh.wu@mediatek.com
Signed-off-by: Walter Wu <walter-zh.wu@mediatek.com>
Suggested-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/lib/test_kasan.c~kasan-fix-kasan-unit-tests-for-tag-based-kasan-v4
+++ a/lib/test_kasan.c
@@ -23,7 +23,9 @@
 
 #include <asm/page.h>
 
-#define OOB_TAG_OFF (IS_ENABLED(CONFIG_KASAN_GENERIC) ? 0 : 13)
+#include "../mm/kasan/kasan.h"
+
+#define OOB_TAG_OFF (IS_ENABLED(CONFIG_KASAN_GENERIC) ? 0 : KASAN_SHADOW_SCALE_SIZE)
 
 /*
  * We assign some test results to these globals to make sure the tests
_

Patches currently in -mm which might be from walter-zh.wu@mediatek.com are

kasan-fix-kasan-unit-tests-for-tag-based-kasan.patch
kasan-fix-kasan-unit-tests-for-tag-based-kasan-v4.patch
rcu-kasan-record-and-print-call_rcu-call-stack.patch
kasan-record-and-print-the-free-track.patch
kasan-add-tests-for-call_rcu-stack-recording.patch
kasan-update-documentation-for-generic-kasan.patch

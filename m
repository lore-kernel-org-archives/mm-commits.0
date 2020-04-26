From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 kasan-stop-tests-being-eliminated-as-dead-code-with-fortify_source-v4.patch
 added to -mm tree
Date: Sat, 25 Apr 2020 17:41:25 -0700
Message-ID: <20200426004125.1bhIymrmK%akpm@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbgDZAl0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 25 Apr 2020 20:41:26 -0400
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, danielmicay@gmail.com, davidgow@google.com, dja@axtens.net, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-stop-tests-being-eliminated-as-dead-code-with-fortify_source-v4
has been added to the -mm tree.  Its filename is
     kasan-stop-tests-being-eliminated-as-dead-code-with-fortify_source-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-stop-tests-being-eliminated-as-dead-code-with-fortify_source-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-stop-tests-being-eliminated-as-dead-code-with-fortify_source-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Axtens <dja@axtens.net>
Subject: kasan-stop-tests-being-eliminated-as-dead-code-with-fortify_source-v4

drop patch 3

Link: http://lkml.kernel.org/r/20200424145521.8203-2-dja@axtens.net
Fixes: 0c96350a2d2f ("lib/test_kasan.c: add tests for several string/memory API functions")
Signed-off-by: Daniel Axtens <dja@axtens.net>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Tested-by: David Gow <davidgow@google.com>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/test_kasan.c~kasan-stop-tests-being-eliminated-as-dead-code-with-fortify_source-v4
+++ a/lib/test_kasan.c
@@ -645,6 +645,7 @@ static noinline void __init kasan_memcmp
 	if (!ptr)
 		return;
 
+	memset(arr, 0, sizeof(arr));
 	kasan_int_result = memcmp(ptr, arr, size + 1);
 	kfree(ptr);
 }
_

Patches currently in -mm which might be from dja@axtens.net are

kasan-stop-tests-being-eliminated-as-dead-code-with-fortify_source.patch
kasan-stop-tests-being-eliminated-as-dead-code-with-fortify_source-v4.patch
stringh-fix-incompatibility-between-fortify_source-and-kasan.patch

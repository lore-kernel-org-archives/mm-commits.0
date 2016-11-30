From: akpm@linux-foundation.org
Subject: [folded-merged] kasan-support-use-after-scope-detection-v3.patch
 removed from -mm tree
Date: Wed, 30 Nov 2016 15:48:44 -0800
Message-ID: <583f655c.ccgmyu9eK6cAd9wI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43372 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752031AbcK3Xy7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2016 18:54:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, aryabinin@virtuozzo.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-support-use-after-scope-detection-v3
has been removed from the -mm tree.  Its filename was
     kasan-support-use-after-scope-detection-v3.patch

This patch was dropped because it was folded into kasan-support-use-after-scope-detection.patch

------------------------------------------------------
From: Dmitry Vyukov <dvyukov@google.com>
Subject: kasan-support-use-after-scope-detection-v3

 - added comment to test_kasan.c re noinline
 - fixed a typo in comment: s/go into of scope/go into scope/
 - added cc stable

Link: http://lkml.kernel.org/r/1479998292-144502-1-git-send-email-dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |    5 +++++
 mm/kasan/kasan.c |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff -puN lib/test_kasan.c~kasan-support-use-after-scope-detection-v3 lib/test_kasan.c
--- a/lib/test_kasan.c~kasan-support-use-after-scope-detection-v3
+++ a/lib/test_kasan.c
@@ -20,6 +20,11 @@
 #include <linux/uaccess.h>
 #include <linux/module.h>
 
+/*
+ * Note: test functions are marked noinline so that their names appear in
+ * reports.
+ */
+
 static noinline void __init kmalloc_oob_right(void)
 {
 	char *ptr;
diff -puN mm/kasan/kasan.c~kasan-support-use-after-scope-detection-v3 mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~kasan-support-use-after-scope-detection-v3
+++ a/mm/kasan/kasan.c
@@ -776,7 +776,7 @@ void __asan_poison_stack_memory(const vo
 }
 EXPORT_SYMBOL(__asan_poison_stack_memory);
 
-/* Emitted by compiler to unpoison large objects when they go into of scope. */
+/* Emitted by compiler to unpoison large objects when they go into scope. */
 void __asan_unpoison_stack_memory(const void *addr, size_t size)
 {
 	kasan_unpoison_shadow(addr, size);
_

Patches currently in -mm which might be from dvyukov@google.com are

kasan-update-kasan_global-for-gcc-7.patch
kasan-support-use-after-scope-detection.patch
kasan-support-panic_on_warn.patch
kasan-eliminate-long-stalls-during-quarantine-reduction.patch


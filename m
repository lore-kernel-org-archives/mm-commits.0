From: akpm@linux-foundation.org
Subject: +
 kasan-remove-redundant-initialization-of-variable-real_size.patch added to
 -mm tree
Date: Tue, 06 Feb 2018 12:52:32 -0800
Message-ID: <5a7a1590.3lLZU1EWZyEIVG/z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51004 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753994AbeBFUwd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 15:52:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, akpm@linux-foundation.org, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: remove redundant initialization of variable 'real_size'
has been added to the -mm tree.  Its filename is
     kasan-remove-redundant-initialization-of-variable-real_size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-remove-redundant-initialization-of-variable-real_size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-remove-redundant-initialization-of-variable-real_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: kasan: remove redundant initialization of variable 'real_size'

Variable real_size is initialized with a value that is never read, it is
re-assigned a new value later on, hence the initialization is redundant
and can be removed.

Cleans up clang warning:
lib/test_kasan.c:422:21: warning: Value stored to 'real_size' during
its initialization is never read

Link: http://lkml.kernel.org/r/20180206144950.32457-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/test_kasan.c~kasan-remove-redundant-initialization-of-variable-real_size lib/test_kasan.c
--- a/lib/test_kasan.c~kasan-remove-redundant-initialization-of-variable-real_size
+++ a/lib/test_kasan.c
@@ -419,7 +419,7 @@ static noinline void __init kasan_stack_
 static noinline void __init ksize_unpoisons_memory(void)
 {
 	char *ptr;
-	size_t size = 123, real_size = size;
+	size_t size = 123, real_size;
 
 	pr_info("ksize() unpoisons the whole allocated chunk\n");
 	ptr = kmalloc(size, GFP_KERNEL);
_

Patches currently in -mm which might be from colin.king@canonical.com are

kasan-remove-redundant-initialization-of-variable-real_size.patch


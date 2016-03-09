From: akpm@linux-foundation.org
Subject: +
 kasan-test-fix-warn-if-the-uaf-could-not-be-detected-in-kmalloc_uaf2.patch
 added to -mm tree
Date: Wed, 09 Mar 2016 12:23:37 -0800
Message-ID: <56e08649.K+8iNFA+U8pEGmWk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934156AbcCIUXj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2016 15:23:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glider@google.com, adech.fo@gmail.com, aryabinin@virtuozzo.com, cl@linux.com, dvyukov@google.com, iamjoonsoo.kim@lge.com, kcc@google.com, penberg@kernel.org, rientjes@google.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: test fix: warn if the UAF could not be detected in kmalloc_uaf2
has been added to the -mm tree.  Its filename is
     kasan-test-fix-warn-if-the-uaf-could-not-be-detected-in-kmalloc_uaf2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-test-fix-warn-if-the-uaf-could-not-be-detected-in-kmalloc_uaf2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-test-fix-warn-if-the-uaf-could-not-be-detected-in-kmalloc_uaf2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: kasan: test fix: warn if the UAF could not be detected in kmalloc_uaf2

Signed-off-by: Alexander Potapenko <glider@google.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrey Konovalov <adech.fo@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Konstantin Serebryany <kcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN lib/test_kasan.c~kasan-test-fix-warn-if-the-uaf-could-not-be-detected-in-kmalloc_uaf2 lib/test_kasan.c
--- a/lib/test_kasan.c~kasan-test-fix-warn-if-the-uaf-could-not-be-detected-in-kmalloc_uaf2
+++ a/lib/test_kasan.c
@@ -294,6 +294,8 @@ static noinline void __init kmalloc_uaf2
 	}
 
 	ptr1[40] = 'x';
+	if (ptr1 == ptr2)
+		pr_err("Could not detect use-after-free: ptr1 == ptr2\n");
 	kfree(ptr2);
 }
 
_

Patches currently in -mm which might be from glider@google.com are

kasan-modify-kmalloc_large_oob_right-add-kmalloc_pagealloc_oob_right.patch
mm-kasan-slab-support.patch
mm-kasan-added-gfp-flags-to-kasan-api.patch
arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections.patch
mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab.patch
kasan-test-fix-warn-if-the-uaf-could-not-be-detected-in-kmalloc_uaf2.patch
mm-kasan-initial-memory-quarantine-implementation.patch


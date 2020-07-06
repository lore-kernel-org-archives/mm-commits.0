From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-fix-kasan-unit-tests-for-tag-based-kasan.patch
 added to -mm tree
Date: Mon, 06 Jul 2020 15:46:35 -0700
Message-ID: <20200706224635.hqBvyf8F4%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726280AbgGFWqg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Jul 2020 18:46:36 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, matthias.bgg@gmail.com, mm-commits@vger.kernel.org, walter-zh.wu@mediatek.com


The patch titled
     Subject: lib/test_kasan.c
has been added to the -mm tree.  Its filename is
     kasan-fix-kasan-unit-tests-for-tag-based-kasan.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-fix-kasan-unit-tests-for-tag-based-kasan.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-fix-kasan-unit-tests-for-tag-based-kasan.patch

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
Subject: lib/test_kasan.c
: fix KASAN unit tests for tag-based KASAN

We use tag-based KASAN, then KASAN unit tests don't detect out-of-bounds
memory access. They need to be fixed.

With tag-based KASAN, the state of each 16 aligned bytes of memory is
encoded in one shadow byte and the shadow value is tag of pointer, so
we need to read next shadow byte, the shadow value is not equal to tag
value of pointer, so that tag-based KASAN will detect out-of-bounds
memory access.

Link: http://lkml.kernel.org/r/20200706115039.16750-1-walter-zh.wu@mediatek.com
Signed-off-by: Walter Wu <walter-zh.wu@mediatek.com>
Suggested-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   47 ++++++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 17 deletions(-)

--- a/lib/test_kasan.c~kasan-fix-kasan-unit-tests-for-tag-based-kasan
+++ a/lib/test_kasan.c
@@ -23,6 +23,8 @@
 
 #include <asm/page.h>
 
+#define OOB_TAG_OFF (IS_ENABLED(CONFIG_KASAN_GENERIC) ? 0 : 13)
+
 /*
  * We assign some test results to these globals to make sure the tests
  * are not eliminated as dead code.
@@ -48,7 +50,8 @@ static noinline void __init kmalloc_oob_
 		return;
 	}
 
-	ptr[size] = 'x';
+	ptr[size + OOB_TAG_OFF] = 'x';
+
 	kfree(ptr);
 }
 
@@ -100,7 +103,8 @@ static noinline void __init kmalloc_page
 		return;
 	}
 
-	ptr[size] = 0;
+	ptr[size + OOB_TAG_OFF] = 0;
+
 	kfree(ptr);
 }
 
@@ -170,7 +174,8 @@ static noinline void __init kmalloc_oob_
 		return;
 	}
 
-	ptr2[size2] = 'x';
+	ptr2[size2 + OOB_TAG_OFF] = 'x';
+
 	kfree(ptr2);
 }
 
@@ -188,7 +193,9 @@ static noinline void __init kmalloc_oob_
 		kfree(ptr1);
 		return;
 	}
-	ptr2[size2] = 'x';
+
+	ptr2[size2 + OOB_TAG_OFF] = 'x';
+
 	kfree(ptr2);
 }
 
@@ -224,7 +231,8 @@ static noinline void __init kmalloc_oob_
 		return;
 	}
 
-	memset(ptr+7, 0, 2);
+	memset(ptr + 7 + OOB_TAG_OFF, 0, 2);
+
 	kfree(ptr);
 }
 
@@ -240,7 +248,8 @@ static noinline void __init kmalloc_oob_
 		return;
 	}
 
-	memset(ptr+5, 0, 4);
+	memset(ptr + 5 + OOB_TAG_OFF, 0, 4);
+
 	kfree(ptr);
 }
 
@@ -257,7 +266,8 @@ static noinline void __init kmalloc_oob_
 		return;
 	}
 
-	memset(ptr+1, 0, 8);
+	memset(ptr + 1 + OOB_TAG_OFF, 0, 8);
+
 	kfree(ptr);
 }
 
@@ -273,7 +283,8 @@ static noinline void __init kmalloc_oob_
 		return;
 	}
 
-	memset(ptr+1, 0, 16);
+	memset(ptr + 1 + OOB_TAG_OFF, 0, 16);
+
 	kfree(ptr);
 }
 
@@ -289,7 +300,8 @@ static noinline void __init kmalloc_oob_
 		return;
 	}
 
-	memset(ptr, 0, size+5);
+	memset(ptr, 0, size + 5 + OOB_TAG_OFF);
+
 	kfree(ptr);
 }
 
@@ -423,7 +435,8 @@ static noinline void __init kmem_cache_o
 		return;
 	}
 
-	*p = p[size];
+	*p = p[size + OOB_TAG_OFF];
+
 	kmem_cache_free(cache, p);
 	kmem_cache_destroy(cache);
 }
@@ -520,25 +533,25 @@ static noinline void __init copy_user_te
 	}
 
 	pr_info("out-of-bounds in copy_from_user()\n");
-	unused = copy_from_user(kmem, usermem, size + 1);
+	unused = copy_from_user(kmem, usermem, size + 1 + OOB_TAG_OFF);
 
 	pr_info("out-of-bounds in copy_to_user()\n");
-	unused = copy_to_user(usermem, kmem, size + 1);
+	unused = copy_to_user(usermem, kmem, size + 1 + OOB_TAG_OFF);
 
 	pr_info("out-of-bounds in __copy_from_user()\n");
-	unused = __copy_from_user(kmem, usermem, size + 1);
+	unused = __copy_from_user(kmem, usermem, size + 1 + OOB_TAG_OFF);
 
 	pr_info("out-of-bounds in __copy_to_user()\n");
-	unused = __copy_to_user(usermem, kmem, size + 1);
+	unused = __copy_to_user(usermem, kmem, size + 1 + OOB_TAG_OFF);
 
 	pr_info("out-of-bounds in __copy_from_user_inatomic()\n");
-	unused = __copy_from_user_inatomic(kmem, usermem, size + 1);
+	unused = __copy_from_user_inatomic(kmem, usermem, size + 1 + OOB_TAG_OFF);
 
 	pr_info("out-of-bounds in __copy_to_user_inatomic()\n");
-	unused = __copy_to_user_inatomic(usermem, kmem, size + 1);
+	unused = __copy_to_user_inatomic(usermem, kmem, size + 1 + OOB_TAG_OFF);
 
 	pr_info("out-of-bounds in strncpy_from_user()\n");
-	unused = strncpy_from_user(kmem, usermem, size + 1);
+	unused = strncpy_from_user(kmem, usermem, size + 1 + OOB_TAG_OFF);
 
 	vm_munmap((unsigned long)usermem, PAGE_SIZE);
 	kfree(kmem);
_

Patches currently in -mm which might be from walter-zh.wu@mediatek.com are

kasan-fix-kasan-unit-tests-for-tag-based-kasan.patch
rcu-kasan-record-and-print-call_rcu-call-stack.patch
kasan-record-and-print-the-free-track.patch
kasan-add-tests-for-call_rcu-stack-recording.patch
kasan-update-documentation-for-generic-kasan.patch

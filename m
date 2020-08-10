Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57BACC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:39:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 333B92065D
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027165;
	bh=B/2R+wf0ehrAGThtpkZCtkDpLLRZXvJzPRLKIkm9ESg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=rAiwwvrqRzzkdD6G/Q7XGMnT/mJy57rUKott8Fsmmk8ASGne0qXm7U0aOC+srKiC/
	 YHT8ksz5k3SmiNIvMzV61NgYZlAs8Cw+x4mxqzZcge6xE6t3R/q89y/JlBGC09nsUN
	 URooY+YykC15/Dm6kK/ch8dq2mScQ6VKFtaI5no0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgHJCjY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:39:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCjY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:39:24 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98C98206C3;
        Mon, 10 Aug 2020 02:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027163;
        bh=B/2R+wf0ehrAGThtpkZCtkDpLLRZXvJzPRLKIkm9ESg=;
        h=Date:From:To:Subject:From;
        b=sRT11Yr1UjmaS5bDo4nZv1m0bLofE0ezke1KPzz8NIze7MNtrDySeWvpDiv3U9UmE
         G6qalTZ5fHCB4hOtWwayU4m9486+xwzqEgADs6xOG8mNdloyHoPR8KEebc2JA/2Er/
         00Kc4VoUYLvOWpRvTKK0gBeTdiLavyxxMt+tSnkk=
Date:   Sun, 09 Aug 2020 19:39:23 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com,
        glider@google.com, matthias.bgg@gmail.com,
        mm-commits@vger.kernel.org, walter-zh.wu@mediatek.com
Subject:  [merged]
 kasan-fix-kasan-unit-tests-for-tag-based-kasan.patch removed from -mm tree
Message-ID: <20200810023923.VeCcdO_jA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_kasan.c: fix KASAN unit tests for tag-based KASAN
has been removed from the -mm tree.  Its filename was
     kasan-fix-kasan-unit-tests-for-tag-based-kasan.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Walter Wu <walter-zh.wu@mediatek.com>
Subject: lib/test_kasan.c: fix KASAN unit tests for tag-based KASAN

We use tag-based KASAN, then KASAN unit tests don't detect out-of-bounds
memory access. They need to be fixed.

With tag-based KASAN, the state of each 16 aligned bytes of memory is
encoded in one shadow byte and the shadow value is tag of pointer, so
we need to read next shadow byte, the shadow value is not equal to tag
value of pointer, so that tag-based KASAN will detect out-of-bounds
memory access.

[walter-zh.wu@mediatek.com: use KASAN_SHADOW_SCALE_SIZE instead of 13]
  Link: http://lkml.kernel.org/r/20200708132524.11688-1-walter-zh.wu@mediatek.com
Link: http://lkml.kernel.org/r/20200706115039.16750-1-walter-zh.wu@mediatek.com
Signed-off-by: Walter Wu <walter-zh.wu@mediatek.com>
Suggested-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   49 +++++++++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 17 deletions(-)

--- a/lib/test_kasan.c~kasan-fix-kasan-unit-tests-for-tag-based-kasan
+++ a/lib/test_kasan.c
@@ -23,6 +23,10 @@
 
 #include <asm/page.h>
 
+#include "../mm/kasan/kasan.h"
+
+#define OOB_TAG_OFF (IS_ENABLED(CONFIG_KASAN_GENERIC) ? 0 : KASAN_SHADOW_SCALE_SIZE)
+
 /*
  * We assign some test results to these globals to make sure the tests
  * are not eliminated as dead code.
@@ -48,7 +52,8 @@ static noinline void __init kmalloc_oob_
 		return;
 	}
 
-	ptr[size] = 'x';
+	ptr[size + OOB_TAG_OFF] = 'x';
+
 	kfree(ptr);
 }
 
@@ -100,7 +105,8 @@ static noinline void __init kmalloc_page
 		return;
 	}
 
-	ptr[size] = 0;
+	ptr[size + OOB_TAG_OFF] = 0;
+
 	kfree(ptr);
 }
 
@@ -170,7 +176,8 @@ static noinline void __init kmalloc_oob_
 		return;
 	}
 
-	ptr2[size2] = 'x';
+	ptr2[size2 + OOB_TAG_OFF] = 'x';
+
 	kfree(ptr2);
 }
 
@@ -188,7 +195,9 @@ static noinline void __init kmalloc_oob_
 		kfree(ptr1);
 		return;
 	}
-	ptr2[size2] = 'x';
+
+	ptr2[size2 + OOB_TAG_OFF] = 'x';
+
 	kfree(ptr2);
 }
 
@@ -224,7 +233,8 @@ static noinline void __init kmalloc_oob_
 		return;
 	}
 
-	memset(ptr+7, 0, 2);
+	memset(ptr + 7 + OOB_TAG_OFF, 0, 2);
+
 	kfree(ptr);
 }
 
@@ -240,7 +250,8 @@ static noinline void __init kmalloc_oob_
 		return;
 	}
 
-	memset(ptr+5, 0, 4);
+	memset(ptr + 5 + OOB_TAG_OFF, 0, 4);
+
 	kfree(ptr);
 }
 
@@ -257,7 +268,8 @@ static noinline void __init kmalloc_oob_
 		return;
 	}
 
-	memset(ptr+1, 0, 8);
+	memset(ptr + 1 + OOB_TAG_OFF, 0, 8);
+
 	kfree(ptr);
 }
 
@@ -273,7 +285,8 @@ static noinline void __init kmalloc_oob_
 		return;
 	}
 
-	memset(ptr+1, 0, 16);
+	memset(ptr + 1 + OOB_TAG_OFF, 0, 16);
+
 	kfree(ptr);
 }
 
@@ -289,7 +302,8 @@ static noinline void __init kmalloc_oob_
 		return;
 	}
 
-	memset(ptr, 0, size+5);
+	memset(ptr, 0, size + 5 + OOB_TAG_OFF);
+
 	kfree(ptr);
 }
 
@@ -423,7 +437,8 @@ static noinline void __init kmem_cache_o
 		return;
 	}
 
-	*p = p[size];
+	*p = p[size + OOB_TAG_OFF];
+
 	kmem_cache_free(cache, p);
 	kmem_cache_destroy(cache);
 }
@@ -520,25 +535,25 @@ static noinline void __init copy_user_te
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



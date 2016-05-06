From: akpm@linux-foundation.org
Subject: + kasan-tests-add-tests-for-user-memory-access-functions.patch
 added to -mm tree
Date: Fri, 06 May 2016 15:48:29 -0700
Message-ID: <572d1f3d.TmMpycljHJjV4Zv0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55228 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759212AbcEFWsa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 May 2016 18:48:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan/tests: add tests for user memory access functions
has been added to the -mm tree.  Its filename is
     kasan-tests-add-tests-for-user-memory-access-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-tests-add-tests-for-user-memory-access-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-tests-add-tests-for-user-memory-access-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: kasan/tests: add tests for user memory access functions

Add some tests for the newly-added user memory access API.

Link: http://lkml.kernel.org/r/1462538722-1574-1-git-send-email-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   49 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff -puN lib/test_kasan.c~kasan-tests-add-tests-for-user-memory-access-functions lib/test_kasan.c
--- a/lib/test_kasan.c~kasan-tests-add-tests-for-user-memory-access-functions
+++ a/lib/test_kasan.c
@@ -12,9 +12,12 @@
 #define pr_fmt(fmt) "kasan test: %s " fmt, __func__
 
 #include <linux/kernel.h>
+#include <linux/mman.h>
+#include <linux/mm.h>
 #include <linux/printk.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/uaccess.h>
 #include <linux/module.h>
 
 static noinline void __init kmalloc_oob_right(void)
@@ -389,6 +392,51 @@ static noinline void __init ksize_unpois
 	kfree(ptr);
 }
 
+static noinline void __init copy_user_test(void)
+{
+	char *kmem;
+	char __user *usermem;
+	size_t size = 10;
+	int unused;
+
+	kmem = kmalloc(size, GFP_KERNEL);
+	if (!kmem)
+		return;
+
+	usermem = (char __user *)vm_mmap(NULL, 0, PAGE_SIZE,
+			    PROT_READ | PROT_WRITE | PROT_EXEC,
+			    MAP_ANONYMOUS | MAP_PRIVATE, 0);
+	if (IS_ERR(usermem)) {
+		pr_err("Failed to allocate user memory\n");
+		kfree(kmem);
+		return;
+	}
+
+	pr_info("out-of-bounds in copy_from_user()\n");
+	unused = copy_from_user(kmem, usermem, size + 1);
+
+	pr_info("out-of-bounds in copy_to_user()\n");
+	unused = copy_to_user(usermem, kmem, size + 1);
+
+	pr_info("out-of-bounds in __copy_from_user()\n");
+	unused = __copy_from_user(kmem, usermem, size + 1);
+
+	pr_info("out-of-bounds in __copy_to_user()\n");
+	unused = __copy_to_user(usermem, kmem, size + 1);
+
+	pr_info("out-of-bounds in __copy_from_user_inatomic()\n");
+	unused = __copy_from_user_inatomic(kmem, usermem, size + 1);
+
+	pr_info("out-of-bounds in __copy_to_user_inatomic()\n");
+	unused = __copy_to_user_inatomic(usermem, kmem, size + 1);
+
+	pr_info("out-of-bounds in strncpy_from_user()\n");
+	unused = strncpy_from_user(kmem, usermem, size + 1);
+
+	vm_munmap((unsigned long)usermem, PAGE_SIZE);
+	kfree(kmem);
+}
+
 static int __init kmalloc_tests_init(void)
 {
 	kmalloc_oob_right();
@@ -416,6 +464,7 @@ static int __init kmalloc_tests_init(voi
 	kasan_quarantine_cache();
 #endif
 	ksize_unpoisons_memory();
+	copy_user_test();
 	return -EAGAIN;
 }
 
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

mm-kasan-print-name-of-mem-caller-in-report.patch
mm-kasan-add-api-to-check-memory-regions.patch
x86-kasan-instrument-user-memory-access-api.patch
kasan-tests-add-tests-for-user-memory-access-functions.patch


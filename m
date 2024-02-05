Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E32B48793
	for <mm-commits@vger.kernel.org>; Mon,  5 Feb 2024 23:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707175139; cv=none; b=DhnC59zycC3rElss49XI8du6fsuURtUVWkDgq0tPpLacD57OiQSDQ9nqLRLOCCbgsFxsGf7T0B+pfvcB7MfS0HI0WzhseRQaE7wockTx5YLiUtnLWMnbvh/gCaMle5IusrS2xNIkDtQSbYDLFX4gUbBT8Hba8Md1kddkyuclLN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707175139; c=relaxed/simple;
	bh=cq4WTpkAiooox0OHufZ+HAmuuqVw424NJl1nzwSEWtU=;
	h=Date:To:From:Subject:Message-Id; b=WrUCpV5VL5LTQ2i0UCGNsVkgnZgXLk3Wuakw1mm1GlibeBse+4Bh02KBxCqYkYtA7mckuigZkAXYNEVu8dxkMm1srubckTpTjVqBBMzc0ENUrJj/LGAOZRXIeyxUqLnhhUiEmYwkX+ZHGMb+UBzzJiqM5T03jFN9yRXVj3umHvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZuDLBWCD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZuDLBWCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1003C433F1;
	Mon,  5 Feb 2024 23:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707175138;
	bh=cq4WTpkAiooox0OHufZ+HAmuuqVw424NJl1nzwSEWtU=;
	h=Date:To:From:Subject:From;
	b=ZuDLBWCDRC2sZ71X1bFu1Jq5qme2h2bwWsXJ/Rvy+Y2og/to0/RVnogfWsBIcVk8Q
	 vglhKMd57wCFo639pzOBAyRgpxcCL0ruJQHWxhsLgVFxu2k8zwZTgN1DUJ/R7GwNm3
	 7GguTBxGNGlmW8Hgv4tGIT456QfMb8XGvASu/IlY=
Date: Mon, 05 Feb 2024 15:18:58 -0800
To: mm-commits@vger.kernel.org,elver@google.com,corbet@lwn.net,andreyknvl@gmail.com,yangtiezhu@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-docs-update-descriptions-about-test-file-and-module.patch added to mm-unstable branch
Message-Id: <20240205231858.C1003C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: docs: update descriptions about test file and module
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-docs-update-descriptions-about-test-file-and-module.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-docs-update-descriptions-about-test-file-and-module.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: kasan: docs: update descriptions about test file and module
Date: Mon, 5 Feb 2024 14:09:21 +0800

After commit f7e01ab828fd ("kasan: move tests to mm/kasan/"), the test
file is renamed to mm/kasan/kasan_test.c and the test module is renamed to
kasan_test.ko, so update the descriptions in the document.

While at it, update the line number and testcase number when the tests
kmalloc_large_oob_right and kmalloc_double_kzfree failed to sync with the
current code in mm/kasan/kasan_test.c.

Link: https://lkml.kernel.org/r/20240205060925.15594-2-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Acked-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst                    |   20 +++++-----
 Documentation/translations/zh_CN/dev-tools/kasan.rst |   20 +++++-----
 Documentation/translations/zh_TW/dev-tools/kasan.rst |   20 +++++-----
 3 files changed, 30 insertions(+), 30 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-docs-update-descriptions-about-test-file-and-module
+++ a/Documentation/dev-tools/kasan.rst
@@ -169,7 +169,7 @@ Error reports
 A typical KASAN report looks like this::
 
     ==================================================================
-    BUG: KASAN: slab-out-of-bounds in kmalloc_oob_right+0xa8/0xbc [test_kasan]
+    BUG: KASAN: slab-out-of-bounds in kmalloc_oob_right+0xa8/0xbc [kasan_test]
     Write of size 1 at addr ffff8801f44ec37b by task insmod/2760
 
     CPU: 1 PID: 2760 Comm: insmod Not tainted 4.19.0-rc3+ #698
@@ -179,8 +179,8 @@ A typical KASAN report looks like this::
      print_address_description+0x73/0x280
      kasan_report+0x144/0x187
      __asan_report_store1_noabort+0x17/0x20
-     kmalloc_oob_right+0xa8/0xbc [test_kasan]
-     kmalloc_tests_init+0x16/0x700 [test_kasan]
+     kmalloc_oob_right+0xa8/0xbc [kasan_test]
+     kmalloc_tests_init+0x16/0x700 [kasan_test]
      do_one_initcall+0xa5/0x3ae
      do_init_module+0x1b6/0x547
      load_module+0x75df/0x8070
@@ -200,8 +200,8 @@ A typical KASAN report looks like this::
      save_stack+0x43/0xd0
      kasan_kmalloc+0xa7/0xd0
      kmem_cache_alloc_trace+0xe1/0x1b0
-     kmalloc_oob_right+0x56/0xbc [test_kasan]
-     kmalloc_tests_init+0x16/0x700 [test_kasan]
+     kmalloc_oob_right+0x56/0xbc [kasan_test]
+     kmalloc_tests_init+0x16/0x700 [kasan_test]
      do_one_initcall+0xa5/0x3ae
      do_init_module+0x1b6/0x547
      load_module+0x75df/0x8070
@@ -510,15 +510,15 @@ When a test passes::
 
 When a test fails due to a failed ``kmalloc``::
 
-        # kmalloc_large_oob_right: ASSERTION FAILED at lib/test_kasan.c:163
+        # kmalloc_large_oob_right: ASSERTION FAILED at mm/kasan/kasan_test.c:245
         Expected ptr is not null, but is
-        not ok 4 - kmalloc_large_oob_right
+        not ok 5 - kmalloc_large_oob_right
 
 When a test fails due to a missing KASAN report::
 
-        # kmalloc_double_kzfree: EXPECTATION FAILED at lib/test_kasan.c:974
+        # kmalloc_double_kzfree: EXPECTATION FAILED at mm/kasan/kasan_test.c:709
         KASAN failure expected in "kfree_sensitive(ptr)", but none occurred
-        not ok 44 - kmalloc_double_kzfree
+        not ok 28 - kmalloc_double_kzfree
 
 
 At the end the cumulative status of all KASAN tests is printed. On success::
@@ -534,7 +534,7 @@ There are a few ways to run KUnit-compat
 1. Loadable module
 
    With ``CONFIG_KUNIT`` enabled, KASAN-KUnit tests can be built as a loadable
-   module and run by loading ``test_kasan.ko`` with ``insmod`` or ``modprobe``.
+   module and run by loading ``kasan_test.ko`` with ``insmod`` or ``modprobe``.
 
 2. Built-In
 
--- a/Documentation/translations/zh_CN/dev-tools/kasan.rst~kasan-docs-update-descriptions-about-test-file-and-module
+++ a/Documentation/translations/zh_CN/dev-tools/kasan.rst
@@ -137,7 +137,7 @@ 错误报告
 典型的KASAN报告如下所示::
 
     ==================================================================
-    BUG: KASAN: slab-out-of-bounds in kmalloc_oob_right+0xa8/0xbc [test_kasan]
+    BUG: KASAN: slab-out-of-bounds in kmalloc_oob_right+0xa8/0xbc [kasan_test]
     Write of size 1 at addr ffff8801f44ec37b by task insmod/2760
 
     CPU: 1 PID: 2760 Comm: insmod Not tainted 4.19.0-rc3+ #698
@@ -147,8 +147,8 @@ 典型的KASAN报告如下所示::
      print_address_description+0x73/0x280
      kasan_report+0x144/0x187
      __asan_report_store1_noabort+0x17/0x20
-     kmalloc_oob_right+0xa8/0xbc [test_kasan]
-     kmalloc_tests_init+0x16/0x700 [test_kasan]
+     kmalloc_oob_right+0xa8/0xbc [kasan_test]
+     kmalloc_tests_init+0x16/0x700 [kasan_test]
      do_one_initcall+0xa5/0x3ae
      do_init_module+0x1b6/0x547
      load_module+0x75df/0x8070
@@ -168,8 +168,8 @@ 典型的KASAN报告如下所示::
      save_stack+0x43/0xd0
      kasan_kmalloc+0xa7/0xd0
      kmem_cache_alloc_trace+0xe1/0x1b0
-     kmalloc_oob_right+0x56/0xbc [test_kasan]
-     kmalloc_tests_init+0x16/0x700 [test_kasan]
+     kmalloc_oob_right+0x56/0xbc [kasan_test]
+     kmalloc_tests_init+0x16/0x700 [kasan_test]
      do_one_initcall+0xa5/0x3ae
      do_init_module+0x1b6/0x547
      load_module+0x75df/0x8070
@@ -421,15 +421,15 @@ 当测试通过::
 
 当由于 ``kmalloc`` 失败而导致测试失败时::
 
-        # kmalloc_large_oob_right: ASSERTION FAILED at lib/test_kasan.c:163
+        # kmalloc_large_oob_right: ASSERTION FAILED at mm/kasan/kasan_test.c:245
         Expected ptr is not null, but is
-        not ok 4 - kmalloc_large_oob_right
+        not ok 5 - kmalloc_large_oob_right
 
 当由于缺少KASAN报告而导致测试失败时::
 
-        # kmalloc_double_kzfree: EXPECTATION FAILED at lib/test_kasan.c:974
+        # kmalloc_double_kzfree: EXPECTATION FAILED at mm/kasan/kasan_test.c:709
         KASAN failure expected in "kfree_sensitive(ptr)", but none occurred
-        not ok 44 - kmalloc_double_kzfree
+        not ok 28 - kmalloc_double_kzfree
 
 
 最后打印所有KASAN测试的累积状态。成功::
@@ -445,7 +445,7 @@ 有几种方法可以运行与KUnit兼�
 1. 可加载模块
 
    启用 ``CONFIG_KUNIT`` 后，KASAN-KUnit测试可以构建为可加载模块，并通过使用
-   ``insmod`` 或 ``modprobe`` 加载 ``test_kasan.ko`` 来运行。
+   ``insmod`` 或 ``modprobe`` 加载 ``kasan_test.ko`` 来运行。
 
 2. 内置
 
--- a/Documentation/translations/zh_TW/dev-tools/kasan.rst~kasan-docs-update-descriptions-about-test-file-and-module
+++ a/Documentation/translations/zh_TW/dev-tools/kasan.rst
@@ -137,7 +137,7 @@ 錯誤報告
 典型的KASAN報告如下所示::
 
     ==================================================================
-    BUG: KASAN: slab-out-of-bounds in kmalloc_oob_right+0xa8/0xbc [test_kasan]
+    BUG: KASAN: slab-out-of-bounds in kmalloc_oob_right+0xa8/0xbc [kasan_test]
     Write of size 1 at addr ffff8801f44ec37b by task insmod/2760
 
     CPU: 1 PID: 2760 Comm: insmod Not tainted 4.19.0-rc3+ #698
@@ -147,8 +147,8 @@ 典型的KASAN報告如下所示::
      print_address_description+0x73/0x280
      kasan_report+0x144/0x187
      __asan_report_store1_noabort+0x17/0x20
-     kmalloc_oob_right+0xa8/0xbc [test_kasan]
-     kmalloc_tests_init+0x16/0x700 [test_kasan]
+     kmalloc_oob_right+0xa8/0xbc [kasan_test]
+     kmalloc_tests_init+0x16/0x700 [kasan_test]
      do_one_initcall+0xa5/0x3ae
      do_init_module+0x1b6/0x547
      load_module+0x75df/0x8070
@@ -168,8 +168,8 @@ 典型的KASAN報告如下所示::
      save_stack+0x43/0xd0
      kasan_kmalloc+0xa7/0xd0
      kmem_cache_alloc_trace+0xe1/0x1b0
-     kmalloc_oob_right+0x56/0xbc [test_kasan]
-     kmalloc_tests_init+0x16/0x700 [test_kasan]
+     kmalloc_oob_right+0x56/0xbc [kasan_test]
+     kmalloc_tests_init+0x16/0x700 [kasan_test]
      do_one_initcall+0xa5/0x3ae
      do_init_module+0x1b6/0x547
      load_module+0x75df/0x8070
@@ -421,15 +421,15 @@ 當測試通過::
 
 當由於 ``kmalloc`` 失敗而導致測試失敗時::
 
-        # kmalloc_large_oob_right: ASSERTION FAILED at lib/test_kasan.c:163
+        # kmalloc_large_oob_right: ASSERTION FAILED at mm/kasan/kasan_test.c:245
         Expected ptr is not null, but is
-        not ok 4 - kmalloc_large_oob_right
+        not ok 5 - kmalloc_large_oob_right
 
 當由於缺少KASAN報告而導致測試失敗時::
 
-        # kmalloc_double_kzfree: EXPECTATION FAILED at lib/test_kasan.c:974
+        # kmalloc_double_kzfree: EXPECTATION FAILED at mm/kasan/kasan_test.c:709
         KASAN failure expected in "kfree_sensitive(ptr)", but none occurred
-        not ok 44 - kmalloc_double_kzfree
+        not ok 28 - kmalloc_double_kzfree
 
 
 最後打印所有KASAN測試的累積狀態。成功::
@@ -445,7 +445,7 @@ 有幾種方法可以運行與KUnit兼�
 1. 可加載模塊
 
    啓用 ``CONFIG_KUNIT`` 後，KASAN-KUnit測試可以構建爲可加載模塊，並通過使用
-   ``insmod`` 或 ``modprobe`` 加載 ``test_kasan.ko`` 來運行。
+   ``insmod`` 或 ``modprobe`` 加載 ``kasan_test.ko`` 來運行。
 
 2. 內置
 
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are

kasan-docs-update-descriptions-about-test-file-and-module.patch
kasan-rename-test_kasan_module_init-to-kasan_test_module_init.patch


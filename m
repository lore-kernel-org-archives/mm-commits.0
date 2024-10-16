Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC19C1D434E
	for <mm-commits@vger.kernel.org>; Wed, 16 Oct 2024 22:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729117310; cv=none; b=UUjoIP0fyPF9ua1uooWmddlSeEcawPUHbOwZWHLMjDCUrBTzIuteZwAIiWam0GQlZhDGugS0ZWNTpg1MfRAcoxxAV0YK8QgEIVuopCTjseAFBMlidX/pyi49Z16lDBBBemyrpaM4sLiZfXSgGJAovGOwbbhHGPJMUUGN0XXtTYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729117310; c=relaxed/simple;
	bh=UtncgAtOWzueuiX4n6BajLFSJj2jrMCT7o3fgqsgWi0=;
	h=Date:To:From:Subject:Message-Id; b=lbz+6mrwcYBZEQ7pG+NvLethOH3VG/ncs2pjtWGGYX6KXfNSdetN165MlXN8uSR79aYYpvqHsOo0PyS8waZ/5Jz8tkl4+Lqxos3+YacTFQf3nif/JL+6p4h/NRkfXBfiDWI3H/C9S2s334vF3uleYixRyi6SZ08wH9tTBtsm4ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yDhIUu6O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yDhIUu6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0A0C4CEC5;
	Wed, 16 Oct 2024 22:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729117310;
	bh=UtncgAtOWzueuiX4n6BajLFSJj2jrMCT7o3fgqsgWi0=;
	h=Date:To:From:Subject:From;
	b=yDhIUu6OywUkhUGVAAqw6wmGjnc/DjofGNzs8JIJorApyuCZo7WwllAFc8hG2pvOQ
	 EwgQ9GTnSyppnKd/lnSPX4E637gec+8IuKREVOaOJdAfAflw8yHT1N45KqyYY7T7/f
	 72a7cE9QFs2lZdRKsbhIwXmwETl3T8laFOwNZCGk=
Date: Wed, 16 Oct 2024 15:21:49 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,siyanteng@loongson.cn,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,corbet@lwn.net,andreyknvl@gmail.com,alexs@kernel.org,2023002089@link.tyut.edu.cn,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-delete-config_kasan_module_test.patch added to mm-unstable branch
Message-Id: <20241016222150.8D0A0C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: delete CONFIG_KASAN_MODULE_TEST
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-delete-config_kasan_module_test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-delete-config_kasan_module_test.patch

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
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Subject: kasan: delete CONFIG_KASAN_MODULE_TEST
Date: Wed, 16 Oct 2024 18:18:02 +0500

Since we've migrated all tests to the KUnit framework, we can delete
CONFIG_KASAN_MODULE_TEST and mentioning of it in the documentation as
well.

I've used the online translator to modify the non-English documentation.

Link: https://lkml.kernel.org/r/20241016131802.3115788-4-snovitoll@gmail.com
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst                    |   23 +++-------
 Documentation/translations/zh_CN/dev-tools/kasan.rst |   20 +++-----
 Documentation/translations/zh_TW/dev-tools/kasan.rst |   21 +++------
 lib/Kconfig.kasan                                    |    7 ---
 mm/kasan/kasan.h                                     |    2 
 mm/kasan/report.c                                    |    2 
 6 files changed, 28 insertions(+), 47 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-delete-config_kasan_module_test
+++ a/Documentation/dev-tools/kasan.rst
@@ -511,19 +511,14 @@ Tests
 ~~~~~
 
 There are KASAN tests that allow verifying that KASAN works and can detect
-certain types of memory corruptions. The tests consist of two parts:
+certain types of memory corruptions.
 
-1. Tests that are integrated with the KUnit Test Framework. Enabled with
-``CONFIG_KASAN_KUNIT_TEST``. These tests can be run and partially verified
+All KASAN tests are integrated with the KUnit Test Framework and can be enabled
+via ``CONFIG_KASAN_KUNIT_TEST``. The tests can be run and partially verified
 automatically in a few different ways; see the instructions below.
 
-2. Tests that are currently incompatible with KUnit. Enabled with
-``CONFIG_KASAN_MODULE_TEST`` and can only be run as a module. These tests can
-only be verified manually by loading the kernel module and inspecting the
-kernel log for KASAN reports.
-
-Each KUnit-compatible KASAN test prints one of multiple KASAN reports if an
-error is detected. Then the test prints its number and status.
+Each KASAN test prints one of multiple KASAN reports if an error is detected.
+Then the test prints its number and status.
 
 When a test passes::
 
@@ -550,16 +545,16 @@ Or, if one of the tests failed::
 
         not ok 1 - kasan
 
-There are a few ways to run KUnit-compatible KASAN tests.
+There are a few ways to run the KASAN tests.
 
 1. Loadable module
 
-   With ``CONFIG_KUNIT`` enabled, KASAN-KUnit tests can be built as a loadable
-   module and run by loading ``kasan_test.ko`` with ``insmod`` or ``modprobe``.
+   With ``CONFIG_KUNIT`` enabled, the tests can be built as a loadable module
+   and run by loading ``kasan_test.ko`` with ``insmod`` or ``modprobe``.
 
 2. Built-In
 
-   With ``CONFIG_KUNIT`` built-in, KASAN-KUnit tests can be built-in as well.
+   With ``CONFIG_KUNIT`` built-in, the tests can be built-in as well.
    In this case, the tests will run at boot as a late-init call.
 
 3. Using kunit_tool
--- a/Documentation/translations/zh_CN/dev-tools/kasan.rst~kasan-delete-config_kasan_module_test
+++ a/Documentation/translations/zh_CN/dev-tools/kasan.rst
@@ -422,16 +422,12 @@ 测试
 ~~~~
 
 有一些KASAN测试可以验证KASAN是否正常工作并可以检测某些类型的内存损坏。
-测试由两部分组成:
 
-1. 与KUnit测试框架集成的测试。使用 ``CONFIG_KASAN_KUNIT_TEST`` 启用。
-这些测试可以通过几种不同的方式自动运行和部分验证；请参阅下面的说明。
+所有 KASAN 测试都与 KUnit 测试框架集成，可通过 ``CONFIG_KASAN_KUNIT_TEST`` 启用。
+测试可以通过几种不同的方式自动运行和部分验证；请参阅以下说明。
 
-2. 与KUnit不兼容的测试。使用 ``CONFIG_KASAN_MODULE_TEST`` 启用并且只能作为模块
-运行。这些测试只能通过加载内核模块并检查内核日志以获取KASAN报告来手动验证。
-
-如果检测到错误，每个KUnit兼容的KASAN测试都会打印多个KASAN报告之一，然后测试打印
-其编号和状态。
+如果检测到错误，每个 KASAN 测试都会打印多份 KASAN 报告中的一份。
+然后测试会打印其编号和状态。
 
 当测试通过::
 
@@ -458,16 +454,16 @@ 或者，如果其中一项测试失败:
 
         not ok 1 - kasan
 
-有几种方法可以运行与KUnit兼容的KASAN测试。
+有几种方法可以运行 KASAN 测试。
 
 1. 可加载模块
 
-   启用 ``CONFIG_KUNIT`` 后，KASAN-KUnit测试可以构建为可加载模块，并通过使用
-   ``insmod`` 或 ``modprobe`` 加载 ``kasan_test.ko`` 来运行。
+   启用 ``CONFIG_KUNIT`` 后，可以将测试构建为可加载模块
+   并通过使用 ``insmod`` 或 ``modprobe`` 加载 ``kasan_test.ko`` 来运行。
 
 2. 内置
 
-   通过内置 ``CONFIG_KUNIT`` ，也可以内置KASAN-KUnit测试。在这种情况下，
+   通过内置 ``CONFIG_KUNIT``，测试也可以内置。
    测试将在启动时作为后期初始化调用运行。
 
 3. 使用kunit_tool
--- a/Documentation/translations/zh_TW/dev-tools/kasan.rst~kasan-delete-config_kasan_module_test
+++ a/Documentation/translations/zh_TW/dev-tools/kasan.rst
@@ -404,16 +404,13 @@ 測試
 ~~~~
 
 有一些KASAN測試可以驗證KASAN是否正常工作並可以檢測某些類型的內存損壞。
-測試由兩部分組成:
 
-1. 與KUnit測試框架集成的測試。使用 ``CONFIG_KASAN_KUNIT_TEST`` 啓用。
-這些測試可以通過幾種不同的方式自動運行和部分驗證；請參閱下面的說明。
+所有 KASAN 測試均與 KUnit 測試框架集成，並且可以啟用
+透過 ``CONFIG_KASAN_KUNIT_TEST``。可以運行測試並進行部分驗證
+ 以幾種不同的方式自動進行；請參閱下面的說明。
 
-2. 與KUnit不兼容的測試。使用 ``CONFIG_KASAN_MODULE_TEST`` 啓用並且只能作爲模塊
-運行。這些測試只能通過加載內核模塊並檢查內核日誌以獲取KASAN報告來手動驗證。
-
-如果檢測到錯誤，每個KUnit兼容的KASAN測試都會打印多個KASAN報告之一，然後測試打印
-其編號和狀態。
+如果偵測到錯誤，每個 KASAN 測試都會列印多個 KASAN 報告之一。
+然後測試列印其編號和狀態。
 
 當測試通過::
 
@@ -440,16 +437,16 @@ 或者，如果其中一項測試失敗:
 
         not ok 1 - kasan
 
-有幾種方法可以運行與KUnit兼容的KASAN測試。
+有幾種方法可以執行 KASAN 測試。
 
 1. 可加載模塊
 
-   啓用 ``CONFIG_KUNIT`` 後，KASAN-KUnit測試可以構建爲可加載模塊，並通過使用
-   ``insmod`` 或 ``modprobe`` 加載 ``kasan_test.ko`` 來運行。
+   啟用 ``CONFIG_KUNIT`` 後，測試可以建置為可載入模組
+   並且透過使用 ``insmod`` 或 ``modprobe`` 來載入 ``kasan_test.ko`` 來運作。
 
 2. 內置
 
-   通過內置 ``CONFIG_KUNIT`` ，也可以內置KASAN-KUnit測試。在這種情況下，
+   透過內建 ``CONFIG_KUNIT``，測試也可以內建。
    測試將在啓動時作爲後期初始化調用運行。
 
 3. 使用kunit_tool
--- a/lib/Kconfig.kasan~kasan-delete-config_kasan_module_test
+++ a/lib/Kconfig.kasan
@@ -195,13 +195,6 @@ config KASAN_KUNIT_TEST
 	  For more information on KUnit and unit tests in general, please refer
 	  to the KUnit documentation in Documentation/dev-tools/kunit/.
 
-config KASAN_MODULE_TEST
-	tristate "KUnit-incompatible tests of KASAN bug detection capabilities"
-	depends on m && KASAN && !KASAN_HW_TAGS
-	help
-	  A part of the KASAN test suite that is not integrated with KUnit.
-	  Incompatible with Hardware Tag-Based KASAN.
-
 config KASAN_EXTRA_INFO
 	bool "Record and report more information"
 	depends on KASAN
--- a/mm/kasan/kasan.h~kasan-delete-config_kasan_module_test
+++ a/mm/kasan/kasan.h
@@ -568,7 +568,7 @@ static inline void kasan_kunit_test_suit
 
 #endif /* CONFIG_KASAN_KUNIT_TEST */
 
-#if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST) || IS_ENABLED(CONFIG_KASAN_MODULE_TEST)
+#if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
 
 bool kasan_save_enable_multi_shot(void);
 void kasan_restore_multi_shot(bool enabled);
--- a/mm/kasan/report.c~kasan-delete-config_kasan_module_test
+++ a/mm/kasan/report.c
@@ -132,7 +132,7 @@ static bool report_enabled(void)
 	return !test_and_set_bit(KASAN_BIT_REPORTED, &kasan_flags);
 }
 
-#if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST) || IS_ENABLED(CONFIG_KASAN_MODULE_TEST)
+#if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
 
 bool kasan_save_enable_multi_shot(void)
 {
_

Patches currently in -mm which might be from snovitoll@gmail.com are

x86-traps-move-kmsan-check-after-instrumentation_begin.patch
mm-kasan-kmsan-copy_from-to_kernel_nofault.patch
kasan-move-checks-to-do_strncpy_from_user.patch
kasan-migrate-copy_user_test-to-kunit.patch
kasan-delete-config_kasan_module_test.patch


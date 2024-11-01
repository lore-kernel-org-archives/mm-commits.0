Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F2D1D0F50
	for <mm-commits@vger.kernel.org>; Fri,  1 Nov 2024 19:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730490492; cv=none; b=CNcw8AweNpMkbK/c03Y+tsFlTE5r5xtmuJhObTa5VxOh92uo9bl2G32KHxXbfKiG5K2U+VTH9DEVNC1ikjmrA7U3foRPLmssQN8UiI/59jT7gFPfSlnroq/5ERUg8DTzEPp3dIIl6a/kU7V1Fvx8p5lIi46CrwTCD5+Ne+HGuek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730490492; c=relaxed/simple;
	bh=F3fo7Ou+B2Jj/TYJaKGjyEl4SCFzmAH+ZZI3TqNKGbU=;
	h=Date:To:From:Subject:Message-Id; b=FF5+nH4epGHIBlY0290dG6tlEOhjBRGesmz7gl/4se/sIHGnUx6jmAJGsNrX+cbmGVgeUT1T9732hpK0dDxZT7dtXT9rSfmiG8wtAh2btca6IfUUbTuc89gm/n0ckoinG0e72qXlra+nyx6l58JOV5iqwbwKk9YrSJBUv7IgTEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OSBmbj1U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OSBmbj1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39B7C4CECD;
	Fri,  1 Nov 2024 19:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730490492;
	bh=F3fo7Ou+B2Jj/TYJaKGjyEl4SCFzmAH+ZZI3TqNKGbU=;
	h=Date:To:From:Subject:From;
	b=OSBmbj1U9IFifF+/79AEzk+rU/s5mqVxJ5J7A3s+we7dvRb/Ik+qGaOR3bX2hUo/4
	 gDqLlrOfEM36/JopSj2ElcCAJmiAuGiZ1DNxBK7+tttrEYAGqQyjqeKQNTdCWaYFGy
	 lsgQCJ4jzrUiaELYEKhjk2DDBvgB/jU/Vod3c8mY=
Date: Fri, 01 Nov 2024 12:48:11 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-use-export_symbol_if_kunit-to-export-symbols.patch added to mm-unstable branch
Message-Id: <20241101194811.F39B7C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: use EXPORT_SYMBOL_IF_KUNIT to export symbols
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-use-export_symbol_if_kunit-to-export-symbols.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-use-export_symbol_if_kunit-to-export-symbols.patch

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
Subject: kasan: use EXPORT_SYMBOL_IF_KUNIT to export symbols
Date: Fri, 1 Nov 2024 23:40:10 +0500

Patch series "kasan: few improvements on kunit tests".

This patch series addresses the issue [1] with KASAN symbols used in the
Kunit test, but exported as EXPORT_SYMBOL_GPL.

Also a small tweak of marking kasan_atomics() as KUNIT_CASE_SLOW to avoid
kunit report that the test should be marked as slow.


This patch (of 2):

Replace EXPORT_SYMBOL_GPL with EXPORT_SYMBOL_IF_KUNIT to mark the symbols
as visible only if CONFIG_KUNIT is enabled.

KASAN Kunit test should import the namespace EXPORTED_FOR_KUNIT_TESTING to
use these marked symbols.

Link: https://lkml.kernel.org/r/20241101184011.3369247-1-snovitoll@gmail.com
Link: https://lkml.kernel.org/r/20241101184011.3369247-2-snovitoll@gmail.com
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Reported-by: Andrey Konovalov <andreyknvl@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218315
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/hw_tags.c      |    7 ++++---
 mm/kasan/kasan_test_c.c |    2 ++
 mm/kasan/report.c       |   17 +++++++++--------
 3 files changed, 15 insertions(+), 11 deletions(-)

--- a/mm/kasan/hw_tags.c~kasan-use-export_symbol_if_kunit-to-export-symbols
+++ a/mm/kasan/hw_tags.c
@@ -8,6 +8,7 @@
 
 #define pr_fmt(fmt) "kasan: " fmt
 
+#include <kunit/visibility.h>
 #include <linux/init.h>
 #include <linux/kasan.h>
 #include <linux/kernel.h>
@@ -394,12 +395,12 @@ void kasan_enable_hw_tags(void)
 
 #if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
 
-EXPORT_SYMBOL_GPL(kasan_enable_hw_tags);
+EXPORT_SYMBOL_IF_KUNIT(kasan_enable_hw_tags);
 
-void kasan_force_async_fault(void)
+VISIBLE_IF_KUNIT void kasan_force_async_fault(void)
 {
 	hw_force_async_tag_fault();
 }
-EXPORT_SYMBOL_GPL(kasan_force_async_fault);
+EXPORT_SYMBOL_IF_KUNIT(kasan_force_async_fault);
 
 #endif
--- a/mm/kasan/kasan_test_c.c~kasan-use-export_symbol_if_kunit-to-export-symbols
+++ a/mm/kasan/kasan_test_c.c
@@ -33,6 +33,8 @@
 
 #define OOB_TAG_OFF (IS_ENABLED(CONFIG_KASAN_GENERIC) ? 0 : KASAN_GRANULE_SIZE)
 
+MODULE_IMPORT_NS(EXPORTED_FOR_KUNIT_TESTING);
+
 static bool multishot;
 
 /* Fields set based on lines observed in the console. */
--- a/mm/kasan/report.c~kasan-use-export_symbol_if_kunit-to-export-symbols
+++ a/mm/kasan/report.c
@@ -10,6 +10,7 @@
  */
 
 #include <kunit/test.h>
+#include <kunit/visibility.h>
 #include <linux/bitops.h>
 #include <linux/ftrace.h>
 #include <linux/init.h>
@@ -134,18 +135,18 @@ static bool report_enabled(void)
 
 #if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
 
-bool kasan_save_enable_multi_shot(void)
+VISIBLE_IF_KUNIT bool kasan_save_enable_multi_shot(void)
 {
 	return test_and_set_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags);
 }
-EXPORT_SYMBOL_GPL(kasan_save_enable_multi_shot);
+EXPORT_SYMBOL_IF_KUNIT(kasan_save_enable_multi_shot);
 
-void kasan_restore_multi_shot(bool enabled)
+VISIBLE_IF_KUNIT void kasan_restore_multi_shot(bool enabled)
 {
 	if (!enabled)
 		clear_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags);
 }
-EXPORT_SYMBOL_GPL(kasan_restore_multi_shot);
+EXPORT_SYMBOL_IF_KUNIT(kasan_restore_multi_shot);
 
 #endif
 
@@ -157,17 +158,17 @@ EXPORT_SYMBOL_GPL(kasan_restore_multi_sh
  */
 static bool kasan_kunit_executing;
 
-void kasan_kunit_test_suite_start(void)
+VISIBLE_IF_KUNIT void kasan_kunit_test_suite_start(void)
 {
 	WRITE_ONCE(kasan_kunit_executing, true);
 }
-EXPORT_SYMBOL_GPL(kasan_kunit_test_suite_start);
+EXPORT_SYMBOL_IF_KUNIT(kasan_kunit_test_suite_start);
 
-void kasan_kunit_test_suite_end(void)
+VISIBLE_IF_KUNIT void kasan_kunit_test_suite_end(void)
 {
 	WRITE_ONCE(kasan_kunit_executing, false);
 }
-EXPORT_SYMBOL_GPL(kasan_kunit_test_suite_end);
+EXPORT_SYMBOL_IF_KUNIT(kasan_kunit_test_suite_end);
 
 static bool kasan_kunit_test_suite_executing(void)
 {
_

Patches currently in -mm which might be from snovitoll@gmail.com are

mm-kasan-kmsan-copy_from-to_kernel_nofault.patch
kasan-move-checks-to-do_strncpy_from_user.patch
kasan-migrate-copy_user_test-to-kunit.patch
kasan-delete-config_kasan_module_test.patch
kasan-delete-config_kasan_module_test-fix.patch
kasan-use-export_symbol_if_kunit-to-export-symbols.patch
kasan-change-kasan_atomics-kunit-test-as-kunit_case_slow.patch


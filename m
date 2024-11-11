Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D3F13E02E
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 08:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731313733; cv=none; b=aRa6VWEUYRKVX94EPDHOabaf/znWCtXS2FmryIfYAx3Gl0/i13ZKmrwCQNs8z+c/XQaXLOEuCBDBWYnygJUkNTKeFnkAiHKYiQThtm3B0BKSyb5qNNH08OqVuCweqOmTCidJ+m/kfH+U1MazDjtLoNrWl4FzivtT8KU4uTtT73A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731313733; c=relaxed/simple;
	bh=d9Si9PnN2b/X7pEfoomSwnz9+r52Ux8+kD0WnSmpXRI=;
	h=Date:To:From:Subject:Message-Id; b=M7Zu1SakV10lLqy31JJEq46lBzOGeDUIhCdu8XCDMIkuazXudEI2566wWsqIwRkxb5EeA6QZeRSX9/AUek0DwMUjYzKvwFOs+NILckCku/tEBpkxQd7xtBYEBmew3yvQ9Wt30ht7wl7tWjmwo8eORQc6ZjheaqyWqa3/ekislwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VBfMW9rH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VBfMW9rH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E807C4CED0;
	Mon, 11 Nov 2024 08:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731313733;
	bh=d9Si9PnN2b/X7pEfoomSwnz9+r52Ux8+kD0WnSmpXRI=;
	h=Date:To:From:Subject:From;
	b=VBfMW9rHNGpVZ9CKFfaVEHEkMYzcIqT3iUL46TJzrlq/I7xGS78MKrgvsztjIoi3e
	 w4KU/VkVEI7fRqz20WuXsyRvrhb+c5DJrx5YAXgLN03bT9Up/zS2eN3VWn9uIJjrFj
	 C8SExjmR2PzrZNNxfvFH35MjYVTcdLpNU0VwyPdY=
Date: Mon, 11 Nov 2024 00:28:52 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-use-export_symbol_if_kunit-to-export-symbols.patch removed from -mm tree
Message-Id: <20241111082853.0E807C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: use EXPORT_SYMBOL_IF_KUNIT to export symbols
has been removed from the -mm tree.  Its filename was
     kasan-use-export_symbol_if_kunit-to-export-symbols.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
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



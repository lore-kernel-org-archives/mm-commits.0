From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-move-kasan_report-into-reportc.patch added to -mm
 tree
Date: Tue, 12 May 2020 14:04:00 -0700
Message-ID: <20200512210400.yt48F6AWy%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728220AbgELVEC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 12 May 2020 17:04:02 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, leon@kernel.org, leonro@mellanox.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: move kasan_report() into report.c
has been added to the -mm tree.  Its filename is
     kasan-move-kasan_report-into-reportc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-move-kasan_report-into-reportc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-move-kasan_report-into-reportc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: move kasan_report() into report.c

The kasan_report() functions belongs to report.c, as it's a common
functions that does error reporting.

Link: http://lkml.kernel.org/r/78a81fde6eeda9db72a7fd55fbc33173a515e4b1.1589297433.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reported-by: Leon Romanovsky <leon@kernel.org>
Tested-by: Leon Romanovsky <leon@kernel.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |   19 -------------------
 mm/kasan/report.c |   22 ++++++++++++++++++++--
 2 files changed, 20 insertions(+), 21 deletions(-)

--- a/mm/kasan/common.c~kasan-move-kasan_report-into-reportc
+++ a/mm/kasan/common.c
@@ -33,7 +33,6 @@
 #include <linux/types.h>
 #include <linux/vmalloc.h>
 #include <linux/bug.h>
-#include <linux/uaccess.h>
 
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
@@ -613,24 +612,6 @@ void kasan_free_shadow(const struct vm_s
 }
 #endif
 
-extern void __kasan_report(unsigned long addr, size_t size, bool is_write, unsigned long ip);
-extern bool report_enabled(void);
-
-bool kasan_report(unsigned long addr, size_t size, bool is_write, unsigned long ip)
-{
-	unsigned long flags = user_access_save();
-	bool ret = false;
-
-	if (likely(report_enabled())) {
-		__kasan_report(addr, size, is_write, ip);
-		ret = true;
-	}
-
-	user_access_restore(flags);
-
-	return ret;
-}
-
 #ifdef CONFIG_MEMORY_HOTPLUG
 static bool shadow_mapped(unsigned long addr)
 {
--- a/mm/kasan/report.c~kasan-move-kasan_report-into-reportc
+++ a/mm/kasan/report.c
@@ -29,6 +29,7 @@
 #include <linux/kasan.h>
 #include <linux/module.h>
 #include <linux/sched/task_stack.h>
+#include <linux/uaccess.h>
 
 #include <asm/sections.h>
 
@@ -454,7 +455,7 @@ static void print_shadow_for_address(con
 	}
 }
 
-bool report_enabled(void)
+static bool report_enabled(void)
 {
 	if (current->kasan_depth)
 		return false;
@@ -479,7 +480,8 @@ void kasan_report_invalid_free(void *obj
 	end_report(&flags);
 }
 
-void __kasan_report(unsigned long addr, size_t size, bool is_write, unsigned long ip)
+static void __kasan_report(unsigned long addr, size_t size, bool is_write,
+				unsigned long ip)
 {
 	struct kasan_access_info info;
 	void *tagged_addr;
@@ -518,6 +520,22 @@ void __kasan_report(unsigned long addr,
 	end_report(&flags);
 }
 
+bool kasan_report(unsigned long addr, size_t size, bool is_write,
+			unsigned long ip)
+{
+	unsigned long flags = user_access_save();
+	bool ret = false;
+
+	if (likely(report_enabled())) {
+		__kasan_report(addr, size, is_write, ip);
+		ret = true;
+	}
+
+	user_access_restore(flags);
+
+	return ret;
+}
+
 #ifdef CONFIG_KASAN_INLINE
 /*
  * With CONFIG_KASAN_INLINE, accesses to bogus pointers (outside the high
_

Patches currently in -mm which might be from andreyknvl@google.com are

kcov-cleanup-debug-messages.patch
kcov-fix-potential-use-after-free-in-kcov_remote_start.patch
kcov-move-t-kcov-assignments-into-kcov_start-stop.patch
kcov-move-t-kcov_sequence-assignment.patch
kcov-use-t-kcov_mode-as-enabled-indicator.patch
kcov-collect-coverage-from-interrupts.patch
usb-core-kcov-collect-coverage-from-usb-complete-callback.patch
kasan-consistently-disable-debugging-features.patch
kasan-add-missing-functions-declarations-to-kasanh.patch
kasan-move-kasan_report-into-reportc.patch

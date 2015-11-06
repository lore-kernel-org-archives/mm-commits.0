From: akpm@linux-foundation.org
Subject: [merged] kasan-update-log-messages.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:17:41 -0800
Message-ID: <563d0ae5.jR9lTJ8QjzXlRLt3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49117 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162900AbbKFURm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:17:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, dvyukov@google.com, glider@google.com, kcc@google.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: update log messages
has been removed from the -mm tree.  Its filename was
     kasan-update-log-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: update log messages

We decided to use KASAN as the short name of the tool and
KernelAddressSanitizer as the full one.  Update log messages according to
that.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Konstantin Serebryany <kcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/kasan_init_64.c |    2 +-
 mm/kasan/kasan.c            |    2 +-
 mm/kasan/report.c           |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/x86/mm/kasan_init_64.c~kasan-update-log-messages arch/x86/mm/kasan_init_64.c
--- a/arch/x86/mm/kasan_init_64.c~kasan-update-log-messages
+++ a/arch/x86/mm/kasan_init_64.c
@@ -126,5 +126,5 @@ void __init kasan_init(void)
 	__flush_tlb_all();
 	init_task.kasan_depth = 0;
 
-	pr_info("Kernel address sanitizer initialized\n");
+	pr_info("KernelAddressSanitizer initialized\n");
 }
diff -puN mm/kasan/kasan.c~kasan-update-log-messages mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~kasan-update-log-messages
+++ a/mm/kasan/kasan.c
@@ -518,7 +518,7 @@ static int kasan_mem_notifier(struct not
 
 static int __init kasan_memhotplug_init(void)
 {
-	pr_err("WARNING: KASan doesn't support memory hot-add\n");
+	pr_err("WARNING: KASAN doesn't support memory hot-add\n");
 	pr_err("Memory hot-add will be disabled\n");
 
 	hotplug_memory_notifier(kasan_mem_notifier, 0);
diff -puN mm/kasan/report.c~kasan-update-log-messages mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-update-log-messages
+++ a/mm/kasan/report.c
@@ -91,7 +91,7 @@ static void print_error_description(stru
 		break;
 	}
 
-	pr_err("BUG: KASan: %s in %pS at addr %p\n",
+	pr_err("BUG: KASAN: %s in %pS at addr %p\n",
 		bug_type, (void *)info->ip,
 		info->access_addr);
 	pr_err("%s of size %zu by task %s/%d\n",
@@ -224,7 +224,7 @@ static void kasan_report_error(struct ka
 			bug_type = "user-memory-access";
 		else
 			bug_type = "wild-memory-access";
-		pr_err("BUG: KASan: %s on address %p\n",
+		pr_err("BUG: KASAN: %s on address %p\n",
 			bug_type, info->access_addr);
 		pr_err("%s of size %zu by task %s/%d\n",
 			info->is_write ? "Write" : "Read",
_

Patches currently in -mm which might be from andreyknvl@google.com are



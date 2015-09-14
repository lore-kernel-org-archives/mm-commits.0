From: akpm@linux-foundation.org
Subject: + kasan-update-log-messages.patch tentatively added to -mm tree
Date: Mon, 14 Sep 2015 14:46:24 -0700
Message-ID: <55f74030.0UiYz0MTGpY6uY2W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49340 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbbINVqZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 17:46:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, dvyukov@google.com, glider@google.com, kcc@google.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: update log messages
has been added to the -mm tree.  Its filename is
     kasan-update-log-messages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-update-log-messages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-update-log-messages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -535,7 +535,7 @@ static int kasan_mem_notifier(struct not
 
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

kasan-update-reported-bug-types-for-not-user-nor-kernel-memory-accesses.patch
kasan-update-reported-bug-types-for-kernel-memory-accesses.patch
kasan-accurately-determine-the-type-of-the-bad-access.patch
kasan-update-log-messages.patch
kasan-various-fixes-in-documentation.patch
kasan-move-kasan_sanitize-in-arch-x86-boot-makefile.patch
kasan-update-reference-to-kasan-prototype-repo.patch


From: akpm@linux-foundation.org
Subject: [patch 095/102] kasan: unify report headers
Date: Wed, 03 May 2017 14:56:28 -0700
Message-ID: <20170503215628.yHQoDXRAt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52760 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751821AbdECV52 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:57:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: unify report headers

Unify KASAN report header format for different kinds of bad memory
accesses. Makes the code simpler.

Link: http://lkml.kernel.org/r/20170302134851.101218-3-andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN mm/kasan/report.c~kasan-unify-report-headers mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-unify-report-headers
+++ a/mm/kasan/report.c
@@ -121,16 +121,22 @@ const char *get_wild_bug_type(struct kas
 	return bug_type;
 }
 
+static const char *get_bug_type(struct kasan_access_info *info)
+{
+	if (addr_has_shadow(info))
+		return get_shadow_bug_type(info);
+	return get_wild_bug_type(info);
+}
+
 static void print_error_description(struct kasan_access_info *info)
 {
-	const char *bug_type = get_shadow_bug_type(info);
+	const char *bug_type = get_bug_type(info);
 
 	pr_err("BUG: KASAN: %s in %pS at addr %p\n",
-		bug_type, (void *)info->ip,
-		info->access_addr);
+		bug_type, (void *)info->ip, info->access_addr);
 	pr_err("%s of size %zu by task %s/%d\n",
-		info->is_write ? "Write" : "Read",
-		info->access_size, current->comm, task_pid_nr(current));
+		info->is_write ? "Write" : "Read", info->access_size,
+		current->comm, task_pid_nr(current));
 }
 
 static inline bool kernel_or_module_addr(const void *addr)
@@ -297,17 +303,11 @@ static void kasan_report_error(struct ka
 
 	kasan_start_report(&flags);
 
+	print_error_description(info);
+
 	if (!addr_has_shadow(info)) {
-		const char *bug_type = get_wild_bug_type(info);
-		pr_err("BUG: KASAN: %s on address %p\n",
-			bug_type, info->access_addr);
-		pr_err("%s of size %zu by task %s/%d\n",
-			info->is_write ? "Write" : "Read",
-			info->access_size, current->comm,
-			task_pid_nr(current));
 		dump_stack();
 	} else {
-		print_error_description(info);
 		print_address_description(info);
 		print_shadow_for_address(info->first_bad_addr);
 	}
_

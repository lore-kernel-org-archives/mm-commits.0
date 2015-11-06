From: akpm@linux-foundation.org
Subject: [merged]
 kasan-update-reported-bug-types-for-not-user-nor-kernel-memory-accesses.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:17:35 -0800
Message-ID: <563d0adf.TjvoueIGCXbm9eVw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162902AbbKFURg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:17:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, dvyukov@google.com, glider@google.com, kcc@google.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: update reported bug types for not user nor kernel memory accesses
has been removed from the -mm tree.  Its filename was
     kasan-update-reported-bug-types-for-not-user-nor-kernel-memory-accesses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: update reported bug types for not user nor kernel memory accesses

Each access with address lower than
kasan_shadow_to_mem(KASAN_SHADOW_START) is reported as user-memory-access.
This is not always true, the accessed address might not be in user space.
Fix this by reporting such accesses as null-ptr-derefs or
wild-memory-accesses.

There's another reason for this change.  For userspace ASan we have a
bunch of systems that analyze error types for the purpose of
classification and deduplication.  Sooner of later we will write them to
KASAN as well.  Then clearly and explicitly stated error types will bring
value.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Konstantin Serebryany <kcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.c  |    8 -------
 mm/kasan/kasan.h  |    3 --
 mm/kasan/report.c |   50 ++++++++++++++++++++------------------------
 3 files changed, 24 insertions(+), 37 deletions(-)

diff -puN mm/kasan/kasan.c~kasan-update-reported-bug-types-for-not-user-nor-kernel-memory-accesses mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~kasan-update-reported-bug-types-for-not-user-nor-kernel-memory-accesses
+++ a/mm/kasan/kasan.c
@@ -235,18 +235,12 @@ static __always_inline bool memory_is_po
 static __always_inline void check_memory_region(unsigned long addr,
 						size_t size, bool write)
 {
-	struct kasan_access_info info;
-
 	if (unlikely(size == 0))
 		return;
 
 	if (unlikely((void *)addr <
 		kasan_shadow_to_mem((void *)KASAN_SHADOW_START))) {
-		info.access_addr = (void *)addr;
-		info.access_size = size;
-		info.is_write = write;
-		info.ip = _RET_IP_;
-		kasan_report_user_access(&info);
+		kasan_report(addr, size, write, _RET_IP_);
 		return;
 	}
 
diff -puN mm/kasan/kasan.h~kasan-update-reported-bug-types-for-not-user-nor-kernel-memory-accesses mm/kasan/kasan.h
--- a/mm/kasan/kasan.h~kasan-update-reported-bug-types-for-not-user-nor-kernel-memory-accesses
+++ a/mm/kasan/kasan.h
@@ -54,9 +54,6 @@ struct kasan_global {
 #endif
 };
 
-void kasan_report_error(struct kasan_access_info *info);
-void kasan_report_user_access(struct kasan_access_info *info);
-
 static inline const void *kasan_shadow_to_mem(const void *shadow_addr)
 {
 	return (void *)(((unsigned long)shadow_addr - KASAN_SHADOW_OFFSET)
diff -puN mm/kasan/report.c~kasan-update-reported-bug-types-for-not-user-nor-kernel-memory-accesses mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-update-reported-bug-types-for-not-user-nor-kernel-memory-accesses
+++ a/mm/kasan/report.c
@@ -189,9 +189,10 @@ static void print_shadow_for_address(con
 
 static DEFINE_SPINLOCK(report_lock);
 
-void kasan_report_error(struct kasan_access_info *info)
+static void kasan_report_error(struct kasan_access_info *info)
 {
 	unsigned long flags;
+	const char *bug_type;
 
 	/*
 	 * Make sure we don't end up in loop.
@@ -200,32 +201,26 @@ void kasan_report_error(struct kasan_acc
 	spin_lock_irqsave(&report_lock, flags);
 	pr_err("================================="
 		"=================================\n");
-	print_error_description(info);
-	print_address_description(info);
-	print_shadow_for_address(info->first_bad_addr);
-	pr_err("================================="
-		"=================================\n");
-	spin_unlock_irqrestore(&report_lock, flags);
-	kasan_enable_current();
-}
-
-void kasan_report_user_access(struct kasan_access_info *info)
-{
-	unsigned long flags;
-
-	/*
-	 * Make sure we don't end up in loop.
-	 */
-	kasan_disable_current();
-	spin_lock_irqsave(&report_lock, flags);
-	pr_err("================================="
-		"=================================\n");
-	pr_err("BUG: KASan: user-memory-access on address %p\n",
-		info->access_addr);
-	pr_err("%s of size %zu by task %s/%d\n",
-		info->is_write ? "Write" : "Read",
-		info->access_size, current->comm, task_pid_nr(current));
-	dump_stack();
+	if (info->access_addr <
+			kasan_shadow_to_mem((void *)KASAN_SHADOW_START)) {
+		if ((unsigned long)info->access_addr < PAGE_SIZE)
+			bug_type = "null-ptr-deref";
+		else if ((unsigned long)info->access_addr < TASK_SIZE)
+			bug_type = "user-memory-access";
+		else
+			bug_type = "wild-memory-access";
+		pr_err("BUG: KASan: %s on address %p\n",
+			bug_type, info->access_addr);
+		pr_err("%s of size %zu by task %s/%d\n",
+			info->is_write ? "Write" : "Read",
+			info->access_size, current->comm,
+			task_pid_nr(current));
+		dump_stack();
+	} else {
+		print_error_description(info);
+		print_address_description(info);
+		print_shadow_for_address(info->first_bad_addr);
+	}
 	pr_err("================================="
 		"=================================\n");
 	spin_unlock_irqrestore(&report_lock, flags);
@@ -244,6 +239,7 @@ void kasan_report(unsigned long addr, si
 	info.access_size = size;
 	info.is_write = is_write;
 	info.ip = ip;
+
 	kasan_report_error(&info);
 }
 
_

Patches currently in -mm which might be from andreyknvl@google.com are



From: akpm@linux-foundation.org
Subject: + kasan-improve-double-free-reports.patch added to -mm tree
Date: Mon, 01 Aug 2016 13:16:18 -0700
Message-ID: <579fae12.m389Hd+Pwe0mc+ur%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41296 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbcHAUlt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2016 16:41:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: improve double-free reports
has been added to the -mm tree.  Its filename is
     kasan-improve-double-free-reports.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-improve-double-free-reports.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-improve-double-free-reports.patch

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
Subject: kasan: improve double-free reports

Currently we just dump stack in case of double free bug.
Let's dump all info about the object that we have.

Link: http://lkml.kernel.org/r/1470062715-14077-6-git-send-email-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.c  |    3 --
 mm/kasan/kasan.h  |    2 +
 mm/kasan/report.c |   54 ++++++++++++++++++++++++++++++--------------
 3 files changed, 41 insertions(+), 18 deletions(-)

diff -puN mm/kasan/kasan.c~kasan-improve-double-free-reports mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~kasan-improve-double-free-reports
+++ a/mm/kasan/kasan.c
@@ -543,8 +543,7 @@ bool kasan_slab_free(struct kmem_cache *
 
 	shadow_byte = READ_ONCE(*(s8 *)kasan_mem_to_shadow(object));
 	if (shadow_byte < 0 || shadow_byte >= KASAN_SHADOW_SCALE_SIZE) {
-		pr_err("Double free");
-		dump_stack();
+		kasan_report_double_free(cache, object, shadow_byte);
 		return true;
 	}
 
diff -puN mm/kasan/kasan.h~kasan-improve-double-free-reports mm/kasan/kasan.h
--- a/mm/kasan/kasan.h~kasan-improve-double-free-reports
+++ a/mm/kasan/kasan.h
@@ -99,6 +99,8 @@ static inline bool kasan_report_enabled(
 
 void kasan_report(unsigned long addr, size_t size,
 		bool is_write, unsigned long ip);
+void kasan_report_double_free(struct kmem_cache *cache, void *object,
+			s8 shadow);
 
 #if defined(CONFIG_SLAB) || defined(CONFIG_SLUB)
 void quarantine_put(struct kasan_free_meta *info, struct kmem_cache *cache);
diff -puN mm/kasan/report.c~kasan-improve-double-free-reports mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-improve-double-free-reports
+++ a/mm/kasan/report.c
@@ -116,6 +116,26 @@ static inline bool init_task_stack_addr(
 			sizeof(init_thread_union.stack));
 }
 
+static DEFINE_SPINLOCK(report_lock);
+
+static void kasan_start_report(unsigned long *flags)
+{
+	/*
+	 * Make sure we don't end up in loop.
+	 */
+	kasan_disable_current();
+	spin_lock_irqsave(&report_lock, *flags);
+	pr_err("==================================================================\n");
+}
+
+static void kasan_end_report(unsigned long *flags)
+{
+	pr_err("==================================================================\n");
+	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
+	spin_unlock_irqrestore(&report_lock, *flags);
+	kasan_enable_current();
+}
+
 static void print_track(struct kasan_track *track)
 {
 	pr_err("PID = %u\n", track->pid);
@@ -129,8 +149,7 @@ static void print_track(struct kasan_tra
 	}
 }
 
-static void kasan_object_err(struct kmem_cache *cache, struct page *page,
-				void *object, char *unused_reason)
+static void kasan_object_err(struct kmem_cache *cache, void *object)
 {
 	struct kasan_alloc_meta *alloc_info = get_alloc_info(cache, object);
 
@@ -147,6 +166,18 @@ static void kasan_object_err(struct kmem
 	print_track(&alloc_info->free_track);
 }
 
+void kasan_report_double_free(struct kmem_cache *cache, void *object,
+			s8 shadow)
+{
+	unsigned long flags;
+
+	kasan_start_report(&flags);
+	pr_err("BUG: Double free or corrupt pointer\n");
+	pr_err("Unexpected shadow byte: 0x%hhX\n", shadow);
+	kasan_object_err(cache, object);
+	kasan_end_report(&flags);
+}
+
 static void print_address_description(struct kasan_access_info *info)
 {
 	const void *addr = info->access_addr;
@@ -160,8 +191,7 @@ static void print_address_description(st
 			struct kmem_cache *cache = page->slab_cache;
 			object = nearest_obj(cache, page,
 						(void *)info->access_addr);
-			kasan_object_err(cache, page, object,
-					"kasan: bad access detected");
+			kasan_object_err(cache, object);
 			return;
 		}
 		dump_page(page, "kasan: bad access detected");
@@ -226,19 +256,13 @@ static void print_shadow_for_address(con
 	}
 }
 
-static DEFINE_SPINLOCK(report_lock);
-
 static void kasan_report_error(struct kasan_access_info *info)
 {
 	unsigned long flags;
 	const char *bug_type;
 
-	/*
-	 * Make sure we don't end up in loop.
-	 */
-	kasan_disable_current();
-	spin_lock_irqsave(&report_lock, flags);
-	pr_err("==================================================================\n");
+	kasan_start_report(&flags);
+
 	if (info->access_addr <
 			kasan_shadow_to_mem((void *)KASAN_SHADOW_START)) {
 		if ((unsigned long)info->access_addr < PAGE_SIZE)
@@ -259,10 +283,8 @@ static void kasan_report_error(struct ka
 		print_address_description(info);
 		print_shadow_for_address(info->first_bad_addr);
 	}
-	pr_err("==================================================================\n");
-	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
-	spin_unlock_irqrestore(&report_lock, flags);
-	kasan_enable_current();
+
+	kasan_end_report(&flags);
 }
 
 void kasan_report(unsigned long addr, size_t size,
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

mm-kasan-fix-corruptions-and-false-positive-reports.patch
mm-kasan-dont-reduce-quarantine-in-atomic-contexts.patch
mm-kasan-slub-dont-disable-interrupts-when-object-leaves-quarantine.patch
mm-kasan-get-rid-of-alloc_size-in-struct-kasan_alloc_meta.patch
mm-kasan-get-rid-of-state-in-struct-kasan_alloc_meta.patch
kasan-improve-double-free-reports.patch


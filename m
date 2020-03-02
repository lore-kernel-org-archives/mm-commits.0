From: akpm@linux-foundation.org
Subject: +
 kasan-detect-negative-size-in-memory-operation-function.patch added to -mm
 tree
Date: Mon, 02 Mar 2020 14:37:36 -0800
Message-ID: <20200302223736.0UD63UouS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbgCBWhi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 2 Mar 2020 17:37:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, lkp@intel.com, mm-commits@vger.kernel.org, walter-zh.wu@mediatek.com


The patch titled
     Subject: kasan: detect negative size in memory operation function
has been added to the -mm tree.  Its filename is
     kasan-detect-negative-size-in-memory-operation-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-detect-negative-size-in-memory-operation-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-detect-negative-size-in-memory-operation-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Walter Wu <walter-zh.wu@mediatek.com>
Subject: kasan: detect negative size in memory operation function

Patch series "fix the missing underflow in memory operation function", v4.

The patchset helps to produce a KASAN report when size is negative in
memory operation functions.  It is helpful for programmer to solve an
undefined behavior issue.  Patch 1 based on Dmitry's review and
suggestion, patch 2 is a test in order to verify the patch 1.  

[1]https://bugzilla.kernel.org/show_bug.cgi?id=199341 
[2]https://lore.kernel.org/linux-arm-kernel/20190927034338.15813-1-walter-zh.wu@mediatek.com/ 


This patch (of 2):

KASAN missed detecting size is a negative number in memset(), memcpy(),
and memmove(), it will cause out-of-bounds bug.  So needs to be detected
by KASAN.

If size is a negative number, then it has a reason to be defined as
out-of-bounds bug type.  Casting negative numbers to size_t would indeed
turn up as a large size_t and its value will be larger than ULONG_MAX/2,
so that this can qualify as out-of-bounds.

KASAN report is shown below:

 BUG: KASAN: out-of-bounds in kmalloc_memmove_invalid_size+0x70/0xa0
 Read of size 18446744073709551608 at addr ffffff8069660904 by task cat/72

 CPU: 2 PID: 72 Comm: cat Not tainted 5.4.0-rc1-next-20191004ajb-00001-gdb8af2f372b2-dirty #1
 Hardware name: linux,dummy-virt (DT)
 Call trace:
  dump_backtrace+0x0/0x288
  show_stack+0x14/0x20
  dump_stack+0x10c/0x164
  print_address_description.isra.9+0x68/0x378
  __kasan_report+0x164/0x1a0
  kasan_report+0xc/0x18
  check_memory_region+0x174/0x1d0
  memmove+0x34/0x88
  kmalloc_memmove_invalid_size+0x70/0xa0

[1] https://bugzilla.kernel.org/show_bug.cgi?id=199341

Link: http://lkml.kernel.org/r/20191112065302.7015-1-walter-zh.wu@mediatek.com
Signed-off-by: Walter Wu <walter-zh.wu@mediatek.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Suggested-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h     |    2 +-
 mm/kasan/common.c         |   25 ++++++++++++++++++-------
 mm/kasan/generic.c        |    9 +++++----
 mm/kasan/generic_report.c |   11 +++++++++++
 mm/kasan/kasan.h          |    2 +-
 mm/kasan/report.c         |    5 +----
 mm/kasan/tags.c           |    9 +++++----
 mm/kasan/tags_report.c    |   11 +++++++++++
 8 files changed, 53 insertions(+), 21 deletions(-)

--- a/include/linux/kasan.h~kasan-detect-negative-size-in-memory-operation-function
+++ a/include/linux/kasan.h
@@ -190,7 +190,7 @@ void kasan_init_tags(void);
 
 void *kasan_reset_tag(const void *addr);
 
-void kasan_report(unsigned long addr, size_t size,
+bool kasan_report(unsigned long addr, size_t size,
 		bool is_write, unsigned long ip);
 
 #else /* CONFIG_KASAN_SW_TAGS */
--- a/mm/kasan/common.c~kasan-detect-negative-size-in-memory-operation-function
+++ a/mm/kasan/common.c
@@ -105,7 +105,8 @@ EXPORT_SYMBOL(__kasan_check_write);
 #undef memset
 void *memset(void *addr, int c, size_t len)
 {
-	check_memory_region((unsigned long)addr, len, true, _RET_IP_);
+	if (!check_memory_region((unsigned long)addr, len, true, _RET_IP_))
+		return NULL;
 
 	return __memset(addr, c, len);
 }
@@ -114,8 +115,9 @@ void *memset(void *addr, int c, size_t l
 #undef memmove
 void *memmove(void *dest, const void *src, size_t len)
 {
-	check_memory_region((unsigned long)src, len, false, _RET_IP_);
-	check_memory_region((unsigned long)dest, len, true, _RET_IP_);
+	if (!check_memory_region((unsigned long)src, len, false, _RET_IP_) ||
+	    !check_memory_region((unsigned long)dest, len, true, _RET_IP_))
+		return NULL;
 
 	return __memmove(dest, src, len);
 }
@@ -124,8 +126,9 @@ void *memmove(void *dest, const void *sr
 #undef memcpy
 void *memcpy(void *dest, const void *src, size_t len)
 {
-	check_memory_region((unsigned long)src, len, false, _RET_IP_);
-	check_memory_region((unsigned long)dest, len, true, _RET_IP_);
+	if (!check_memory_region((unsigned long)src, len, false, _RET_IP_) ||
+	    !check_memory_region((unsigned long)dest, len, true, _RET_IP_))
+		return NULL;
 
 	return __memcpy(dest, src, len);
 }
@@ -634,12 +637,20 @@ void kasan_free_shadow(const struct vm_s
 #endif
 
 extern void __kasan_report(unsigned long addr, size_t size, bool is_write, unsigned long ip);
+extern bool report_enabled(void);
 
-void kasan_report(unsigned long addr, size_t size, bool is_write, unsigned long ip)
+bool kasan_report(unsigned long addr, size_t size, bool is_write, unsigned long ip)
 {
-	unsigned long flags = user_access_save();
+	unsigned long flags;
+
+	if (likely(!report_enabled()))
+		return false;
+
+	flags = user_access_save();
 	__kasan_report(addr, size, is_write, ip);
 	user_access_restore(flags);
+
+	return true;
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
--- a/mm/kasan/generic.c~kasan-detect-negative-size-in-memory-operation-function
+++ a/mm/kasan/generic.c
@@ -173,17 +173,18 @@ static __always_inline bool check_memory
 	if (unlikely(size == 0))
 		return true;
 
+	if (unlikely(addr + size < addr))
+		return !kasan_report(addr, size, write, ret_ip);
+
 	if (unlikely((void *)addr <
 		kasan_shadow_to_mem((void *)KASAN_SHADOW_START))) {
-		kasan_report(addr, size, write, ret_ip);
-		return false;
+		return !kasan_report(addr, size, write, ret_ip);
 	}
 
 	if (likely(!memory_is_poisoned(addr, size)))
 		return true;
 
-	kasan_report(addr, size, write, ret_ip);
-	return false;
+	return !kasan_report(addr, size, write, ret_ip);
 }
 
 bool check_memory_region(unsigned long addr, size_t size, bool write,
--- a/mm/kasan/generic_report.c~kasan-detect-negative-size-in-memory-operation-function
+++ a/mm/kasan/generic_report.c
@@ -110,6 +110,17 @@ static const char *get_wild_bug_type(str
 
 const char *get_bug_type(struct kasan_access_info *info)
 {
+	/*
+	 * If access_size is a negative number, then it has reason to be
+	 * defined as out-of-bounds bug type.
+	 *
+	 * Casting negative numbers to size_t would indeed turn up as
+	 * a large size_t and its value will be larger than ULONG_MAX/2,
+	 * so that this can qualify as out-of-bounds.
+	 */
+	if (info->access_addr + info->access_size < info->access_addr)
+		return "out-of-bounds";
+
 	if (addr_has_shadow(info->access_addr))
 		return get_shadow_bug_type(info);
 	return get_wild_bug_type(info);
--- a/mm/kasan/kasan.h~kasan-detect-negative-size-in-memory-operation-function
+++ a/mm/kasan/kasan.h
@@ -153,7 +153,7 @@ bool check_memory_region(unsigned long a
 void *find_first_bad_addr(void *addr, size_t size);
 const char *get_bug_type(struct kasan_access_info *info);
 
-void kasan_report(unsigned long addr, size_t size,
+bool kasan_report(unsigned long addr, size_t size,
 		bool is_write, unsigned long ip);
 void kasan_report_invalid_free(void *object, unsigned long ip);
 
--- a/mm/kasan/report.c~kasan-detect-negative-size-in-memory-operation-function
+++ a/mm/kasan/report.c
@@ -446,7 +446,7 @@ static void print_shadow_for_address(con
 	}
 }
 
-static bool report_enabled(void)
+bool report_enabled(void)
 {
 	if (current->kasan_depth)
 		return false;
@@ -478,9 +478,6 @@ void __kasan_report(unsigned long addr,
 	void *untagged_addr;
 	unsigned long flags;
 
-	if (likely(!report_enabled()))
-		return;
-
 	disable_trace_on_warning();
 
 	tagged_addr = (void *)addr;
--- a/mm/kasan/tags.c~kasan-detect-negative-size-in-memory-operation-function
+++ a/mm/kasan/tags.c
@@ -86,6 +86,9 @@ bool check_memory_region(unsigned long a
 	if (unlikely(size == 0))
 		return true;
 
+	if (unlikely(addr + size < addr))
+		return !kasan_report(addr, size, write, ret_ip);
+
 	tag = get_tag((const void *)addr);
 
 	/*
@@ -111,15 +114,13 @@ bool check_memory_region(unsigned long a
 	untagged_addr = reset_tag((const void *)addr);
 	if (unlikely(untagged_addr <
 			kasan_shadow_to_mem((void *)KASAN_SHADOW_START))) {
-		kasan_report(addr, size, write, ret_ip);
-		return false;
+		return !kasan_report(addr, size, write, ret_ip);
 	}
 	shadow_first = kasan_mem_to_shadow(untagged_addr);
 	shadow_last = kasan_mem_to_shadow(untagged_addr + size - 1);
 	for (shadow = shadow_first; shadow <= shadow_last; shadow++) {
 		if (*shadow != tag) {
-			kasan_report(addr, size, write, ret_ip);
-			return false;
+			return !kasan_report(addr, size, write, ret_ip);
 		}
 	}
 
--- a/mm/kasan/tags_report.c~kasan-detect-negative-size-in-memory-operation-function
+++ a/mm/kasan/tags_report.c
@@ -36,6 +36,17 @@
 
 const char *get_bug_type(struct kasan_access_info *info)
 {
+	/*
+	 * If access_size is a negative number, then it has reason to be
+	 * defined as out-of-bounds bug type.
+	 *
+	 * Casting negative numbers to size_t would indeed turn up as
+	 * a large size_t and its value will be larger than ULONG_MAX/2,
+	 * so that this can qualify as out-of-bounds.
+	 */
+	if (info->access_addr + info->access_size < info->access_addr)
+		return "out-of-bounds";
+
 #ifdef CONFIG_KASAN_SW_TAGS_IDENTIFY
 	struct kasan_alloc_meta *alloc_meta;
 	struct kmem_cache *cache;
_

Patches currently in -mm which might be from walter-zh.wu@mediatek.com are

kasan-detect-negative-size-in-memory-operation-function.patch
kasan-add-test-for-invalid-size-in-memmove.patch

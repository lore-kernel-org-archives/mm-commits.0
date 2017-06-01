From: akpm@linux-foundation.org
Subject: + mm-kasan-add-support-for-memory-hotplug.patch added to -mm tree
Date: Thu, 01 Jun 2017 14:52:05 -0700
Message-ID: <59308c85.nrgOrdBOfLoRF+mi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60296 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751078AbdFAVwG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2017 17:52:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, catalin.marinas@arm.com, dvyukov@google.com, glider@google.com, hpa@zytor.com, mark.rutland@arm.com, mingo@elte.hu, mingo@redhat.com, tglx@linutronix.de, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kasan: add support for memory hotplug
has been added to the -mm tree.  Its filename is
     mm-kasan-add-support-for-memory-hotplug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kasan-add-support-for-memory-hotplug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kasan-add-support-for-memory-hotplug.patch

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
Subject: mm/kasan: add support for memory hotplug

KASAN doesn't happen work with memory hotplug because hotplugged memory
doesn't have any shadow memory.  So any access to hotplugged memory would
cause a crash on shadow check.

Use memory hotplug notifier to allocate and map shadow memory when the
hotplugged memory is going online and free shadow after the memory
offlined.

Link: http://lkml.kernel.org/r/20170601162338.23540-4-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig       |    1 -
 mm/kasan/kasan.c |   40 +++++++++++++++++++++++++++++++++++-----
 2 files changed, 35 insertions(+), 6 deletions(-)

diff -puN mm/Kconfig~mm-kasan-add-support-for-memory-hotplug mm/Kconfig
--- a/mm/Kconfig~mm-kasan-add-support-for-memory-hotplug
+++ a/mm/Kconfig
@@ -161,7 +161,6 @@ config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
 	depends on SPARSEMEM || X86_64_ACPI_NUMA
 	depends on ARCH_ENABLE_MEMORY_HOTPLUG
-	depends on COMPILE_TEST || !KASAN
 
 config MEMORY_HOTPLUG_SPARSE
 	def_bool y
diff -puN mm/kasan/kasan.c~mm-kasan-add-support-for-memory-hotplug mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~mm-kasan-add-support-for-memory-hotplug
+++ a/mm/kasan/kasan.c
@@ -737,17 +737,47 @@ void __asan_unpoison_stack_memory(const
 EXPORT_SYMBOL(__asan_unpoison_stack_memory);
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-static int kasan_mem_notifier(struct notifier_block *nb,
+static int __meminit kasan_mem_notifier(struct notifier_block *nb,
 			unsigned long action, void *data)
 {
-	return (action == MEM_GOING_ONLINE) ? NOTIFY_BAD : NOTIFY_OK;
+	struct memory_notify *mem_data = data;
+	unsigned long nr_shadow_pages, start_kaddr, shadow_start;
+	unsigned long shadow_end, shadow_size;
+
+	nr_shadow_pages = mem_data->nr_pages >> KASAN_SHADOW_SCALE_SHIFT;
+	start_kaddr = (unsigned long)pfn_to_kaddr(mem_data->start_pfn);
+	shadow_start = (unsigned long)kasan_mem_to_shadow((void *)start_kaddr);
+	shadow_size = nr_shadow_pages << PAGE_SHIFT;
+	shadow_end = shadow_start + shadow_size;
+
+	if (WARN_ON(mem_data->nr_pages % KASAN_SHADOW_SCALE_SIZE) ||
+		WARN_ON(start_kaddr % (KASAN_SHADOW_SCALE_SIZE << PAGE_SHIFT)))
+		return NOTIFY_BAD;
+
+	switch (action) {
+	case MEM_GOING_ONLINE: {
+		void *ret;
+
+		ret = __vmalloc_node_range(shadow_size, PAGE_SIZE, shadow_start,
+					shadow_end, GFP_KERNEL,
+					PAGE_KERNEL, VM_NO_GUARD,
+					pfn_to_nid(mem_data->start_pfn),
+					__builtin_return_address(0));
+		if (!ret)
+			return NOTIFY_BAD;
+
+		kmemleak_ignore(ret);
+		return NOTIFY_OK;
+	}
+	case MEM_OFFLINE:
+		vfree((void *)shadow_start);
+	}
+
+	return NOTIFY_OK;
 }
 
 static int __init kasan_memhotplug_init(void)
 {
-	pr_info("WARNING: KASAN doesn't support memory hot-add\n");
-	pr_info("Memory hot-add will be disabled\n");

From: akpm@linux-foundation.org
Subject: + mm-kasan-dont-vfree-nonexistent-vm_area.patch added to -mm tree
Date: Thu, 01 Feb 2018 14:32:28 -0800
Message-ID: <5a73957c.c6hNjjd2xQ/8P/hX%akpm__47569.5635578178$1517524246$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54248 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751526AbeBAWc3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 17:32:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, pmenzel+linux-kasan-dev@molgen.mpg.de, stable@vger.kernel.org, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kasan: don't vfree() nonexistent vm_area
has been added to the -mm tree.  Its filename is
     mm-kasan-dont-vfree-nonexistent-vm_area.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kasan-dont-vfree-nonexistent-vm_area.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kasan-dont-vfree-nonexistent-vm_area.patch

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
Subject: mm/kasan: don't vfree() nonexistent vm_area

KASAN uses different routines to map shadow for hot added memory and
memory obtained in boot process.  Attempt to offline memory onlined by
normal boot process leads to this:

    Trying to vfree() nonexistent vm area (000000005d3b34b9)
    WARNING: CPU: 2 PID: 13215 at mm/vmalloc.c:1525 __vunmap+0x147/0x190

    Call Trace:
     kasan_mem_notifier+0xad/0xb9
     notifier_call_chain+0x166/0x260
     __blocking_notifier_call_chain+0xdb/0x140
     __offline_pages+0x96a/0xb10
     memory_subsys_offline+0x76/0xc0
     device_offline+0xb8/0x120
     store_mem_state+0xfa/0x120
     kernfs_fop_write+0x1d5/0x320
     __vfs_write+0xd4/0x530
     vfs_write+0x105/0x340
     SyS_write+0xb0/0x140

Obviously we can't call vfree() to free memory that wasn't allocated via
vmalloc().  Use find_vm_area() to see if we can call vfree().

Unfortunately it's a bit tricky to properly unmap and free shadow
allocated during boot, so we'll have to keep it.  If memory will come
online again that shadow will be reused.

Link: http://lkml.kernel.org/r/20180201163349.8700-1-aryabinin@virtuozzo.com
Fixes: fa69b5989bb0 ("mm/kasan: add support for memory hotplug")
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Reported-by: Paul Menzel <pmenzel+linux-kasan-dev@molgen.mpg.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.c |   57 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 2 deletions(-)

diff -puN mm/kasan/kasan.c~mm-kasan-dont-vfree-nonexistent-vm_area mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~mm-kasan-dont-vfree-nonexistent-vm_area
+++ a/mm/kasan/kasan.c
@@ -791,6 +791,41 @@ DEFINE_ASAN_SET_SHADOW(f5);
 DEFINE_ASAN_SET_SHADOW(f8);
 
 #ifdef CONFIG_MEMORY_HOTPLUG
+static bool shadow_mapped(unsigned long addr)
+{
+	pgd_t *pgd = pgd_offset_k(addr);
+	p4d_t *p4d;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	if (pgd_none(*pgd))
+		return false;
+	p4d = p4d_offset(pgd, addr);
+	if (p4d_none(*p4d))
+		return false;
+	pud = pud_offset(p4d, addr);
+	if (pud_none(*pud))
+		return false;
+
+	/*
+	 * We can't use pud_large() or pud_huge(), the first one
+	 * is arch-specific, the last one depend on HUGETLB_PAGE.
+	 * So let's abuse pud_bad(), if bud is bad it's has to
+	 * because it's huge.
+	 */
+	if (pud_bad(*pud))
+		return true;
+	pmd = pmd_offset(pud, addr);
+	if (pmd_none(*pmd))
+		return false;
+
+	if (pmd_bad(*pmd))
+		return true;
+	pte = pte_offset_kernel(pmd, addr);
+	return !pte_none(*pte);
+}
+
 static int __meminit kasan_mem_notifier(struct notifier_block *nb,
 			unsigned long action, void *data)
 {
@@ -812,6 +847,14 @@ static int __meminit kasan_mem_notifier(
 	case MEM_GOING_ONLINE: {
 		void *ret;
 
+		/*
+		 * If shadow is mapped already than it must have been mapped
+		 * during the boot. This could happen if we onlining previously
+		 * offlined memory.
+		 */
+		if (shadow_mapped(shadow_start))
+			return NOTIFY_OK;
+
 		ret = __vmalloc_node_range(shadow_size, PAGE_SIZE, shadow_start,
 					shadow_end, GFP_KERNEL,
 					PAGE_KERNEL, VM_NO_GUARD,
@@ -823,8 +866,18 @@ static int __meminit kasan_mem_notifier(
 		kmemleak_ignore(ret);
 		return NOTIFY_OK;
 	}
-	case MEM_OFFLINE:
-		vfree((void *)shadow_start);
+	case MEM_OFFLINE: {
+		struct vm_struct *vm;
+
+		/*
+		 * Only hot-added memory have vm_area. Freeing shadow
+		 * mapped during boot would be tricky, so we'll just
+		 * have to keep it.
+		 */
+		vm = find_vm_area((void *)shadow_start);
+		if (vm)
+			vfree((void *)shadow_start);
+	}
 	}
 
 	return NOTIFY_OK;
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

kasan-makefile-support-llvm-style-asan-parameters.patch
mm-kasan-dont-vfree-nonexistent-vm_area.patch
lib-ubsan-add-type-mismatch-handler-for-new-gcc-clang.patch
lib-ubsan-remove-returns-nonnull-attribute-checks.patch
lib-ubsan-remove-returns-nonnull-attribute-checks-fix.patch


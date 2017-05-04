From: akpm@linux-foundation.org
Subject: [merged]
 kasan-introduce-helper-functions-for-determining-bug-type.patch removed
 from -mm tree
Date: Thu, 04 May 2017 12:13:55 -0700
Message-ID: <20170504191355.EqXfk5KdM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52060 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752487AbdEDTN5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:13:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: introduce helper functions for determining bug type
has been removed from the -mm tree.  Its filename was
     kasan-introduce-helper-functions-for-determining-bug-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: introduce helper functions for determining bug type

Patch series "kasan: improve error reports", v2.

This patchset improves KASAN reports by making them easier to read
and a little more detailed.
Also improves mm/kasan/report.c readability.

Effectively changes a use-after-free report to:

==================================================================
BUG: KASAN: use-after-free in kmalloc_uaf+0xaa/0xb6 [test_kasan]
Write of size 1 at addr ffff88006aa59da8 by task insmod/3951

CPU: 1 PID: 3951 Comm: insmod Tainted: G    B           4.10.0+ #84
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Call Trace:
 dump_stack+0x292/0x398
 print_address_description+0x73/0x280
 kasan_report.part.2+0x207/0x2f0
 __asan_report_store1_noabort+0x2c/0x30
 kmalloc_uaf+0xaa/0xb6 [test_kasan]
 kmalloc_tests_init+0x4f/0xa48 [test_kasan]
 do_one_initcall+0xf3/0x390
 do_init_module+0x215/0x5d0
 load_module+0x54de/0x82b0
 SYSC_init_module+0x3be/0x430
 SyS_init_module+0x9/0x10
 entry_SYSCALL_64_fastpath+0x1f/0xc2
RIP: 0033:0x7f22cfd0b9da
RSP: 002b:00007ffe69118a78 EFLAGS: 00000206 ORIG_RAX: 00000000000000af
RAX: ffffffffffffffda RBX: 0000555671242090 RCX: 00007f22cfd0b9da
RDX: 00007f22cffcaf88 RSI: 000000000004df7e RDI: 00007f22d0399000
RBP: 00007f22cffcaf88 R08: 0000000000000003 R09: 0000000000000000
R10: 00007f22cfd07d0a R11: 0000000000000206 R12: 0000555671243190
R13: 000000000001fe81 R14: 0000000000000000 R15: 0000000000000004

Allocated by task 3951:
 save_stack_trace+0x16/0x20
 save_stack+0x43/0xd0
 kasan_kmalloc+0xad/0xe0
 kmem_cache_alloc_trace+0x82/0x270
 kmalloc_uaf+0x56/0xb6 [test_kasan]
 kmalloc_tests_init+0x4f/0xa48 [test_kasan]
 do_one_initcall+0xf3/0x390
 do_init_module+0x215/0x5d0
 load_module+0x54de/0x82b0
 SYSC_init_module+0x3be/0x430
 SyS_init_module+0x9/0x10
 entry_SYSCALL_64_fastpath+0x1f/0xc2

Freed by task 3951:
 save_stack_trace+0x16/0x20
 save_stack+0x43/0xd0
 kasan_slab_free+0x72/0xc0
 kfree+0xe8/0x2b0
 kmalloc_uaf+0x85/0xb6 [test_kasan]
 kmalloc_tests_init+0x4f/0xa48 [test_kasan]
 do_one_initcall+0xf3/0x390
 do_init_module+0x215/0x5d0
 load_module+0x54de/0x82b0
 SYSC_init_module+0x3be/0x430
 SyS_init_module+0x9/0x10
 entry_SYSCALL_64_fastpath+0x1f/0xc

The buggy address belongs to the object at ffff88006aa59da0
 which belongs to the cache kmalloc-16 of size 16
The buggy address is located 8 bytes inside of
 16-byte region [ffff88006aa59da0, ffff88006aa59db0)
The buggy address belongs to the page:
page:ffffea0001aa9640 count:1 mapcount:0 mapping:          (null) index:0x0
flags: 0x100000000000100(slab)
raw: 0100000000000100 0000000000000000 0000000000000000 0000000180800080
raw: ffffea0001abe380 0000000700000007 ffff88006c401b40 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88006aa59c80: 00 00 fc fc 00 00 fc fc 00 00 fc fc 00 00 fc fc
 ffff88006aa59d00: 00 00 fc fc 00 00 fc fc 00 00 fc fc 00 00 fc fc
>ffff88006aa59d80: fb fb fc fc fb fb fc fc fb fb fc fc fb fb fc fc
                                  ^
 ffff88006aa59e00: fb fb fc fc fb fb fc fc fb fb fc fc fb fb fc fc
 ffff88006aa59e80: fb fb fc fc 00 00 fc fc 00 00 fc fc 00 00 fc fc
==================================================================

from:

==================================================================
BUG: KASAN: use-after-free in kmalloc_uaf+0xaa/0xb6 [test_kasan] at addr ffff88006c4dcb28
Write of size 1 by task insmod/3984
CPU: 1 PID: 3984 Comm: insmod Tainted: G    B           4.10.0+ #83
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Call Trace:
 dump_stack+0x292/0x398
 kasan_object_err+0x1c/0x70
 kasan_report.part.1+0x20e/0x4e0
 __asan_report_store1_noabort+0x2c/0x30
 kmalloc_uaf+0xaa/0xb6 [test_kasan]
 kmalloc_tests_init+0x4f/0xa48 [test_kasan]
 do_one_initcall+0xf3/0x390
 do_init_module+0x215/0x5d0
 load_module+0x54de/0x82b0
 SYSC_init_module+0x3be/0x430
 SyS_init_module+0x9/0x10
 entry_SYSCALL_64_fastpath+0x1f/0xc2
RIP: 0033:0x7feca0f779da
RSP: 002b:00007ffdfeae5218 EFLAGS: 00000206 ORIG_RAX: 00000000000000af
RAX: ffffffffffffffda RBX: 000055a064c13090 RCX: 00007feca0f779da
RDX: 00007feca1236f88 RSI: 000000000004df7e RDI: 00007feca1605000
RBP: 00007feca1236f88 R08: 0000000000000003 R09: 0000000000000000
R10: 00007feca0f73d0a R11: 0000000000000206 R12: 000055a064c14190
R13: 000000000001fe81 R14: 0000000000000000 R15: 0000000000000004
Object at ffff88006c4dcb20, in cache kmalloc-16 size: 16
Allocated:
PID = 3984
 save_stack_trace+0x16/0x20
 save_stack+0x43/0xd0
 kasan_kmalloc+0xad/0xe0
 kmem_cache_alloc_trace+0x82/0x270
 kmalloc_uaf+0x56/0xb6 [test_kasan]
 kmalloc_tests_init+0x4f/0xa48 [test_kasan]
 do_one_initcall+0xf3/0x390
 do_init_module+0x215/0x5d0
 load_module+0x54de/0x82b0
 SYSC_init_module+0x3be/0x430
 SyS_init_module+0x9/0x10
 entry_SYSCALL_64_fastpath+0x1f/0xc2
Freed:
PID = 3984
 save_stack_trace+0x16/0x20
 save_stack+0x43/0xd0
 kasan_slab_free+0x73/0xc0
 kfree+0xe8/0x2b0
 kmalloc_uaf+0x85/0xb6 [test_kasan]
 kmalloc_tests_init+0x4f/0xa48 [test_kasan]
 do_one_initcall+0xf3/0x390
 do_init_module+0x215/0x5d0
 load_module+0x54de/0x82b0
 SYSC_init_module+0x3be/0x430
 SyS_init_module+0x9/0x10
 entry_SYSCALL_64_fastpath+0x1f/0xc2
Memory state around the buggy address:
 ffff88006c4dca00: fb fb fc fc fb fb fc fc fb fb fc fc fb fb fc fc
 ffff88006c4dca80: fb fb fc fc fb fb fc fc fb fb fc fc fb fb fc fc
>ffff88006c4dcb00: fb fb fc fc fb fb fc fc fb fb fc fc fb fb fc fc
                                  ^
 ffff88006c4dcb80: fb fb fc fc 00 00 fc fc fb fb fc fc fb fb fc fc
 ffff88006c4dcc00: fb fb fc fc fb fb fc fc fb fb fc fc fb fb fc fc
==================================================================



This patch (of 9):

Introduce get_shadow_bug_type() function, which determines bug type based
on the shadow value for a particular kernel address.  Introduce
get_wild_bug_type() function, which determines bug type for addresses
which don't have a corresponding shadow value.

Link: http://lkml.kernel.org/r/20170302134851.101218-2-andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   40 ++++++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff -puN mm/kasan/report.c~kasan-introduce-helper-functions-for-determining-bug-type mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-introduce-helper-functions-for-determining-bug-type
+++ a/mm/kasan/report.c
@@ -51,7 +51,13 @@ static const void *find_first_bad_addr(c
 	return first_bad_addr;
 }
 
-static void print_error_description(struct kasan_access_info *info)
+static bool addr_has_shadow(struct kasan_access_info *info)
+{
+	return (info->access_addr >=
+		kasan_shadow_to_mem((void *)KASAN_SHADOW_START));
+}
+
+static const char *get_shadow_bug_type(struct kasan_access_info *info)
 {
 	const char *bug_type = "unknown-crash";
 	u8 *shadow_addr;
@@ -98,6 +104,27 @@ static void print_error_description(stru
 		break;
 	}
 
+	return bug_type;
+}
+
+const char *get_wild_bug_type(struct kasan_access_info *info)
+{
+	const char *bug_type = "unknown-crash";
+
+	if ((unsigned long)info->access_addr < PAGE_SIZE)
+		bug_type = "null-ptr-deref";
+	else if ((unsigned long)info->access_addr < TASK_SIZE)
+		bug_type = "user-memory-access";
+	else
+		bug_type = "wild-memory-access";
+
+	return bug_type;
+}
+
+static void print_error_description(struct kasan_access_info *info)
+{
+	const char *bug_type = get_shadow_bug_type(info);
+
 	pr_err("BUG: KASAN: %s in %pS at addr %p\n",
 		bug_type, (void *)info->ip,
 		info->access_addr);
@@ -267,18 +294,11 @@ static void print_shadow_for_address(con
 static void kasan_report_error(struct kasan_access_info *info)
 {
 	unsigned long flags;
-	const char *bug_type;
 
 	kasan_start_report(&flags);
 
-	if (info->access_addr <
-			kasan_shadow_to_mem((void *)KASAN_SHADOW_START)) {
-		if ((unsigned long)info->access_addr < PAGE_SIZE)
-			bug_type = "null-ptr-deref";
-		else if ((unsigned long)info->access_addr < TASK_SIZE)
-			bug_type = "user-memory-access";
-		else
-			bug_type = "wild-memory-access";
+	if (!addr_has_shadow(info)) {
+		const char *bug_type = get_wild_bug_type(info);
 		pr_err("BUG: KASAN: %s on address %p\n",
 			bug_type, info->access_addr);
 		pr_err("%s of size %zu by task %s/%d\n",
_

Patches currently in -mm which might be from andreyknvl@google.com are



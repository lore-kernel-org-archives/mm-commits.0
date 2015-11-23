From: akpm@linux-foundation.org
Subject: [merged]
 kasan-fix-kmemleak-false-positive-in-kasan_module_alloc.patch removed from
 -mm tree
Date: Mon, 23 Nov 2015 12:15:15 -0800
Message-ID: <565373d3.VnOlRuLb25a/yBk+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53613 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbbKWUPQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 15:15:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, catalin.marinas@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix kmemleak false-positive in kasan_module_alloc()
has been removed from the -mm tree.  Its filename was
     kasan-fix-kmemleak-false-positive-in-kasan_module_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: kasan: fix kmemleak false-positive in kasan_module_alloc()

Kmemleak reports the following leak:
	unreferenced object 0xfffffbfff41ea000 (size 20480):
	comm "modprobe", pid 65199, jiffies 4298875551 (age 542.568s)
	hex dump (first 32 bytes):
	  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
	  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
	backtrace:
	  [<ffffffff82354f5e>] kmemleak_alloc+0x4e/0xc0
	  [<ffffffff8152e718>] __vmalloc_node_range+0x4b8/0x740
	  [<ffffffff81574072>] kasan_module_alloc+0x72/0xc0
	  [<ffffffff810efe68>] module_alloc+0x78/0xb0
	  [<ffffffff812f6a24>] module_alloc_update_bounds+0x14/0x70
	  [<ffffffff812f8184>] layout_and_allocate+0x16f4/0x3c90
	  [<ffffffff812faa1f>] load_module+0x2ff/0x6690
	  [<ffffffff813010b6>] SyS_finit_module+0x136/0x170
	  [<ffffffff8239bbc9>] system_call_fastpath+0x16/0x1b
	  [<ffffffffffffffff>] 0xffffffffffffffff

kasan_module_alloc() allocates shadow memory for module and frees it on
module unloading.  It doesn't store the pointer to allocated shadow memory
because it could be calculated from the shadowed address, i.e. 
kasan_mem_to_shadow(addr).

Since kmemleak cannot find pointer to allocated shadow, it thinks that
memory leaked.

Use kmemleak_ignore() to tell kmemleak that this is not a leak and shadow
memory doesn't contain any pointers.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/kasan/kasan.c~kasan-fix-kmemleak-false-positive-in-kasan_module_alloc mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~kasan-fix-kmemleak-false-positive-in-kasan_module_alloc
+++ a/mm/kasan/kasan.c
@@ -19,6 +19,7 @@
 #include <linux/export.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/kmemleak.h>
 #include <linux/memblock.h>
 #include <linux/memory.h>
 #include <linux/mm.h>
@@ -444,6 +445,7 @@ int kasan_module_alloc(void *addr, size_
 
 	if (ret) {
 		find_vm_area(addr)->flags |= VM_KASAN;
+		kmemleak_ignore(ret);
 		return 0;
 	}
 
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are



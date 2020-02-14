From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-annotate-various-data-races-obj-ptr.patch
 added to -mm tree
Date: Thu, 13 Feb 2020 19:06:46 -0800
Message-ID: <20200214030646.yglVwNFVo%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727604AbgBNDGr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 Feb 2020 22:06:47 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, catalin.marinas@arm.com, elver@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kmemleak: annotate various data races obj->ptr
has been added to the -mm tree.  Its filename is
     mm-kmemleak-annotate-various-data-races-obj-ptr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kmemleak-annotate-various-data-races-obj-ptr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kmemleak-annotate-various-data-races-obj-ptr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: mm/kmemleak: annotate various data races obj->ptr

The value of object->pointer could be accessed concurrently as noticed
by KCSAN,

 write to 0xffffb0ea683a7d50 of 4 bytes by task 23575 on cpu 12:
  do_raw_spin_lock+0x114/0x200
  debug_spin_lock_after at kernel/locking/spinlock_debug.c:91
  (inlined by) do_raw_spin_lock at kernel/locking/spinlock_debug.c:115
  _raw_spin_lock+0x40/0x50
  __handle_mm_fault+0xa9e/0xd00
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

 read to 0xffffb0ea683a7d50 of 4 bytes by task 839 on cpu 60:
  crc32_le_base+0x67/0x350
  crc32_le_base+0x67/0x350:
  crc32_body at lib/crc32.c:106
  (inlined by) crc32_le_generic at lib/crc32.c:179
  (inlined by) crc32_le at lib/crc32.c:197
  kmemleak_scan+0x528/0xd90
  update_checksum at mm/kmemleak.c:1172
  (inlined by) kmemleak_scan at mm/kmemleak.c:1497
  kmemleak_scan_thread+0xcc/0xfa
  kthread+0x1e0/0x200
  ret_from_fork+0x27/0x50

 write to 0xffff939bf07b95b8 of 4 bytes by interrupt on cpu 119:
  __free_object+0x884/0xcb0
  __free_object at lib/debugobjects.c:359
  __debug_check_no_obj_freed+0x19d/0x370
  debug_check_no_obj_freed+0x41/0x4b
  slab_free_freelist_hook+0xfb/0x1c0
  kmem_cache_free+0x10c/0x3a0
  free_object_rcu+0x1ca/0x260
  rcu_core+0x677/0xcc0
  rcu_core_si+0x17/0x20
  __do_softirq+0xd9/0x57c
  run_ksoftirqd+0x29/0x50
  smpboot_thread_fn+0x222/0x3f0
  kthread+0x1e0/0x200
  ret_from_fork+0x27/0x50

 read to 0xffff939bf07b95b8 of 8 bytes by task 838 on cpu 109:
  scan_block+0x69/0x190
  scan_block at mm/kmemleak.c:1250
  kmemleak_scan+0x249/0xd90
  scan_large_block at mm/kmemleak.c:1309
  (inlined by) kmemleak_scan at mm/kmemleak.c:1434
  kmemleak_scan_thread+0xcc/0xfa
  kthread+0x1e0/0x200
  ret_from_fork+0x27/0x50

crc32() will dereference object->pointer.  If a shattered value was
returned due to a data race, it will be corrected in the next scan. 
scan_block() will dereference a range of addresses (e.g., percpu sections)
to search for valid pointers.  Even if a data race heppens, it will cause
no issue because the code here does not care about the exact value of a
non-pointer.  Thus, mark them as intentional data races using the
data_race() macro.

Link: http://lkml.kernel.org/r/1581615390-9720-1-git-send-email-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-annotate-various-data-races-obj-ptr
+++ a/mm/kmemleak.c
@@ -1169,7 +1169,12 @@ static bool update_checksum(struct kmeml
 	u32 old_csum = object->checksum;
 
 	kasan_disable_current();
-	object->checksum = crc32(0, (void *)object->pointer, object->size);
+	/*
+	 * crc32() will dereference object->pointer. If an unstable value was
+	 * returned due to a data race, it will be corrected in the next scan.
+	 */
+	object->checksum = data_race(crc32(0, (void *)object->pointer,
+					   object->size));
 	kasan_enable_current();
 
 	return object->checksum != old_csum;
@@ -1243,7 +1248,7 @@ static void scan_block(void *_start, voi
 			break;
 
 		kasan_disable_current();
-		pointer = *ptr;
+		pointer = data_race(*ptr);
 		kasan_enable_current();
 
 		untagged_ptr = (unsigned long)kasan_reset_tag((void *)pointer);
_

Patches currently in -mm which might be from cai@lca.pw are

mm-kmemleak-annotate-various-data-races-obj-ptr.patch
mm-kmemleak-annotate-a-data-race-in-checksum.patch
mm-swapfile-fix-and-annotate-various-data-races.patch
mm-page_counter-fix-various-data-races-at-memsw.patch
mm-memcontrol-fix-a-data-race-in-scan-count.patch
mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
mm-mempool-fix-a-data-race-in-mempool_free.patch
mm-util-annotate-an-data-race-at-vm_committed_as.patch
mm-rmap-annotate-a-data-race-at-tlb_flush_batched.patch
mm-frontswap-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races.patch
mm-swap_state-mark-various-intentional-data-races.patch

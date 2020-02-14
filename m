From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated]
 mm-kmemleak-annotate-a-data-race-in-checksum.patch removed from -mm tree
Date: Thu, 13 Feb 2020 19:06:52 -0800
Message-ID: <20200214030652.iHbK1xAdw%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727604AbgBNDGy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 Feb 2020 22:06:54 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, catalin.marinas@arm.com, elver@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kmemleak.c: annotate a data race in checksum
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-annotate-a-data-race-in-checksum.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: mm/kmemleak.c: annotate a data race in checksum

The value of object->pointer could be accessed concurrently as noticed by
KCSAN,

 BUG: KCSAN: data-race in crc32_le_base / do_raw_spin_lock

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

 Reported by Kernel Concurrency Sanitizer on:
 CPU: 60 PID: 839 Comm: kmemleak Tainted: G        W    L 5.5.0-next-20200210+ #3
 Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 07/10/2019

crc32() will dereference object->pointer.  If a shattered value was
returned due to a data race, it will be corrected in the next scan.  Thus,
annotate it as an intentional data race using the data_race() macro.

Link: http://lkml.kernel.org/r/1581438245-24391-1-git-send-email-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/kmemleak.c~mm-kmemleak-annotate-a-data-race-in-checksum
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
_

Patches currently in -mm which might be from cai@lca.pw are

mm-kmemleak-annotate-various-data-races-obj-ptr.patch
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

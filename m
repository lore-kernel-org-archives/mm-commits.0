From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-silence-kcsan-splats-in-checksum.patch
 added to -mm tree
Date: Tue, 17 Mar 2020 19:59:52 -0700
Message-ID: <20200318025952.zBzj0hHEk%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726229AbgCRC7y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 17 Mar 2020 22:59:54 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, catalin.marinas@arm.com, elver@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kmemleak: silence KCSAN splats in checksum
has been added to the -mm tree.  Its filename is
     mm-kmemleak-silence-kcsan-splats-in-checksum.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kmemleak-silence-kcsan-splats-in-checksum.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kmemleak-silence-kcsan-splats-in-checksum.patch

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
Subject: mm/kmemleak: silence KCSAN splats in checksum

Even if KCSAN is disabled for kmemleak, update_checksum() could still call
crc32() (which is outside of kmemleak.c) to dereference object->pointer. 
Thus, the value of object->pointer could be accessed concurrently as
noticed by KCSAN,

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

If a shattered value was returned due to a data race, it will be corrected
in the next scan.  Thus, let KCSAN ignore all reads in the region to
silence KCSAN in case the write side is non-atomic.

Link: http://lkml.kernel.org/r/20200317182754.2180-1-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Suggested-by: Marco Elver <elver@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/kmemleak.c~mm-kmemleak-silence-kcsan-splats-in-checksum
+++ a/mm/kmemleak.c
@@ -1169,8 +1169,10 @@ static bool update_checksum(struct kmeml
 	u32 old_csum = object->checksum;
 
 	kasan_disable_current();
+	kcsan_disable_current();
 	object->checksum = crc32(0, (void *)object->pointer, object->size);
 	kasan_enable_current();
+	kcsan_enable_current();
 
 	return object->checksum != old_csum;
 }
_

Patches currently in -mm which might be from cai@lca.pw are

page-flags-fix-a-crash-at-setpageerrorthp_swap.patch
mm-kmemleak-silence-kcsan-splats-in-checksum.patch
mm-disable-kcsan-for-kmemleak.patch
mm-swapfile-fix-data-races-in-try_to_unuse.patch
kasan-detect-negative-size-in-memory-operation-function-fix.patch
mm-vmscan-fix-data-races-at-kswapd_classzone_idx.patch
percpu_counter-fix-a-data-race-at-vm_committed_as.patch
mm-frontswap-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races-v2.patch
mm-swap_state-mark-various-intentional-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races-v2.patch
mm-page_counter-fix-various-data-races-at-memsw.patch
mm-memcontrol-fix-a-data-race-in-scan-count.patch
mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
mm-mempool-fix-a-data-race-in-mempool_free.patch
mm-util-annotate-an-data-race-at-vm_committed_as.patch
mm-rmap-annotate-a-data-race-at-tlb_flush_batched.patch
mm-annotate-a-data-race-in-page_zonenum.patch
mm-swap-annotate-data-races-for-lru_rotate_pvecs.patch

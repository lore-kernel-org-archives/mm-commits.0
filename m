From: akpm@linux-foundation.org
Subject: + mm-annotate-a-data-race-in-page_zonenum.patch added to
 -mm tree
Date: Wed, 19 Feb 2020 14:51:22 -0800
Message-ID: <20200219225122.OU6sc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727883AbgBSWvX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Feb 2020 17:51:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paulmck@kernel.org, jhubbard@nvidia.com, jack@suse.cz, ira.weiny@intel.com, elver@google.com, david@redhat.com, dan.j.williams@intel.com, cai@lca.pw


The patch titled
     Subject: mm: annotate a data race in page_zonenum()
has been added to the -mm tree.  Its filename is
     mm-annotate-a-data-race-in-page_zonenum.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-annotate-a-data-race-in-page_zonenum.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-annotate-a-data-race-in-page_zonenum.patch

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
Subject: mm: annotate a data race in page_zonenum()

 BUG: KCSAN: data-race in page_cpupid_xchg_last / put_page

 write (marked) to 0xfffffc0d48ec1a00 of 8 bytes by task 91442 on cpu 3:
  page_cpupid_xchg_last+0x51/0x80
  page_cpupid_xchg_last at mm/mmzone.c:109 (discriminator 11)
  wp_page_reuse+0x3e/0xc0
  wp_page_reuse at mm/memory.c:2453
  do_wp_page+0x472/0x7b0
  do_wp_page at mm/memory.c:2798
  __handle_mm_fault+0xcb0/0xd00
  handle_pte_fault at mm/memory.c:4049
  (inlined by) __handle_mm_fault at mm/memory.c:4163
  handle_mm_fault+0xfc/0x2f0
  handle_mm_fault at mm/memory.c:4200
  do_page_fault+0x263/0x6f9
  do_user_addr_fault at arch/x86/mm/fault.c:1465
  (inlined by) do_page_fault at arch/x86/mm/fault.c:1539
  page_fault+0x34/0x40

 read to 0xfffffc0d48ec1a00 of 8 bytes by task 94817 on cpu 69:
  put_page+0x15a/0x1f0
  page_zonenum at include/linux/mm.h:923
  (inlined by) is_zone_device_page at include/linux/mm.h:929
  (inlined by) page_is_devmap_managed at include/linux/mm.h:948
  (inlined by) put_page at include/linux/mm.h:1023
  wp_page_copy+0x571/0x930
  wp_page_copy at mm/memory.c:2615
  do_wp_page+0x107/0x7b0
  __handle_mm_fault+0xcb0/0xd00
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

 Reported by Kernel Concurrency Sanitizer on:
 CPU: 69 PID: 94817 Comm: systemd-udevd Tainted: G        W  O L 5.5.0-next-20200204+ #6
 Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 07/10/2019

A page never changes its zone number. The zone number happens to be
stored in the same word as other bits which are modified, but the zone
number bits will never be modified by any other write, so it can accept
a reload of the zone bits after an intervening write and it don't need
to use READ_ONCE(). Thus, annotate this data race using
ASSERT_EXCLUSIVE_BITS() to also assert that there are no concurrent
writes to it.

Link: http://lkml.kernel.org/r/1581619089-14472-1-git-send-email-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Suggested-by: Marco Elver <elver@google.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/mm.h~mm-annotate-a-data-race-in-page_zonenum
+++ a/include/linux/mm.h
@@ -938,6 +938,7 @@ vm_fault_t finish_mkwrite_fault(struct v
 
 static inline enum zone_type page_zonenum(const struct page *page)
 {
+	ASSERT_EXCLUSIVE_BITS(page->flags, ZONES_MASK << ZONES_PGSHIFT);
 	return (page->flags >> ZONES_PGSHIFT) & ZONES_MASK;
 }
 
_

Patches currently in -mm which might be from cai@lca.pw are

hugetlb_cgroup-add-interface-for-charge-uncharge-hugetlb-reservations-fix.patch
mm-frontswap-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races-v2.patch
mm-swap_state-mark-various-intentional-data-races.patch
mm-kmemleak-annotate-various-data-races-obj-ptr.patch
mm-swapfile-fix-and-annotate-various-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races-v2.patch
mm-page_counter-fix-various-data-races-at-memsw.patch
mm-memcontrol-fix-a-data-race-in-scan-count.patch
mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
mm-mempool-fix-a-data-race-in-mempool_free.patch
mm-util-annotate-an-data-race-at-vm_committed_as.patch
mm-rmap-annotate-a-data-race-at-tlb_flush_batched.patch
fork-annotate-a-data-race-in-vm_area_dup.patch
mm-annotate-a-data-race-in-page_zonenum.patch

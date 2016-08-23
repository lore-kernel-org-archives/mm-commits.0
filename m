From: akpm@linux-foundation.org
Subject: + memremap-fix-null-pointer-bug-in-get_zone_device_page.patch
 added to -mm tree
Date: Tue, 23 Aug 2016 13:41:36 -0700
Message-ID: <57bcb500.Kvzcs4ybdUH/vTTs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51367 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753140AbcHWUl7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 23 Aug 2016 16:41:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hpe.com, ard.biesheuvel@linaro.org, brian.starkey@arm.com, dan.j.williams@intel.com, m.abhilash-kumar@hpe.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memremap: fix NULL pointer BUG in get_zone_device_page()
has been added to the -mm tree.  Its filename is
     memremap-fix-null-pointer-bug-in-get_zone_device_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memremap-fix-null-pointer-bug-in-get_zone_device_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memremap-fix-null-pointer-bug-in-get_zone_device_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Toshi Kani <toshi.kani@hpe.com>
Subject: memremap: fix NULL pointer BUG in get_zone_device_page()

The following BUG was observed while starting up KVM with nvdimm
device as memory-backend-file to /dev/dax.

 BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
 IP: [<ffffffff811ac851>] get_zone_device_page+0x11/0x30
 Call Trace:
   follow_devmap_pmd+0x298/0x2c0
   follow_page_mask+0x275/0x530
   __get_user_pages+0xe3/0x750
   __gfn_to_pfn_memslot+0x1b2/0x450 [kvm]
   ? hrtimer_try_to_cancel+0x2c/0x120
   ? kvm_read_l1_tsc+0x55/0x60 [kvm]
   try_async_pf+0x66/0x230 [kvm]
   ? kvm_host_page_size+0x90/0xa0 [kvm]
   tdp_page_fault+0x130/0x280 [kvm]
   kvm_mmu_page_fault+0x5f/0xf0 [kvm]
   handle_ept_violation+0x94/0x180 [kvm_intel]
   vmx_handle_exit+0x1d3/0x1440 [kvm_intel]
   ? atomic_switch_perf_msrs+0x6f/0xa0 [kvm_intel]
   ? vmx_vcpu_run+0x2d1/0x490 [kvm_intel]
   kvm_arch_vcpu_ioctl_run+0x81d/0x16a0 [kvm]
   ? wake_up_q+0x44/0x80
   kvm_vcpu_ioctl+0x33c/0x620 [kvm]
   ? __vfs_write+0x37/0x160
   do_vfs_ioctl+0xa2/0x5d0
   SyS_ioctl+0x79/0x90
   entry_SYSCALL_64_fastpath+0x1a/0xa4

devm_memremap_pages() calls for_each_device_pfn() to walk through
all pfns in page_map.  pfn_first(), however, returns a wrong pfn
that leaves page->pgmap uninitialized.

Since arch_add_memory() has set up direct mappings to the NVDIMM
range with altmap, pfn_first() should not modify the start pfn.
Change pfn_first() to simply return pfn of res->start.

Link: http://lkml.kernel.org/r/1471977800-12688-1-git-send-email-toshi.kani@hpe.com
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Reported-by: Abhilash Kumar Mulumudi <m.abhilash-kumar@hpe.com>
Tested-by: Abhilash Kumar Mulumudi <m.abhilash-kumar@hpe.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Brian Starkey <brian.starkey@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/memremap.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN kernel/memremap.c~memremap-fix-null-pointer-bug-in-get_zone_device_page kernel/memremap.c
--- a/kernel/memremap.c~memremap-fix-null-pointer-bug-in-get_zone_device_page
+++ a/kernel/memremap.c
@@ -210,15 +210,9 @@ static void pgmap_radix_release(struct r
 
 static unsigned long pfn_first(struct page_map *page_map)
 {
-	struct dev_pagemap *pgmap = &page_map->pgmap;
 	const struct resource *res = &page_map->res;
-	struct vmem_altmap *altmap = pgmap->altmap;
-	unsigned long pfn;
 
-	pfn = res->start >> PAGE_SHIFT;
-	if (altmap)
-		pfn += vmem_altmap_offset(altmap);
-	return pfn;
+	return res->start >> PAGE_SHIFT;
 }
 
 static unsigned long pfn_end(struct page_map *page_map)
_

Patches currently in -mm which might be from toshi.kani@hpe.com are

memremap-fix-null-pointer-bug-in-get_zone_device_page.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AC5FC47082
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 20:41:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82B27611AD
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 20:41:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbhFGUnX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 16:43:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230438AbhFGUnW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 16:43:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6D2C61139;
        Mon,  7 Jun 2021 20:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623098474;
        bh=8O18WAQn7EVEOMhrjlUQ+SwcnkRUbL4q1Fg9+Yu/NDg=;
        h=Date:From:To:Subject:From;
        b=SsZT0228iewwBhKd0yA22hYXv4Fl1eFS3kZyYOp+d8PWgzAA0YzctqbGZLKRKMmF2
         ot3RPLLuOuqplr82/+6NPlODuuJRi8x2N8EwcL6AhCPyLxPEuUSfYMEgiIFoQLUa6M
         msMOm9s8Z+jSZd0URnio6LwwhT/b7eBLJOinfqVo=
Date:   Mon, 07 Jun 2021 13:41:14 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, david@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        quic_qiancai@quicinc.com, rppt@kernel.org
Subject:  [merged]
 =?US-ASCII?Q?drivers-base-memory-fix-trying-offlining-memory-blocks-wi?=
 =?US-ASCII?Q?th-memory-holes-on-aarch64.patch?= removed from -mm tree
Message-ID: <20210607204114.xqd7usH-m%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/base/memory: fix trying offlining memory blocks with memory holes on aarch64
has been removed from the -mm tree.  Its filename was
     drivers-base-memory-fix-trying-offlining-memory-blocks-with-memory-holes-on-aarch64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: drivers/base/memory: fix trying offlining memory blocks with memory holes on aarch64

offline_pages() properly checks for memory holes and bails out.  However,
we do a page_zone(pfn_to_page(start_pfn)) before calling offline_pages()
when offlining a memory block.  We should not unconditionally call
page_zone(pfn_to_page(start_pfn)) on aarch64 in offlining code, otherwise
we can trigger a BUG when hitting a memory hole:

[  162.327720][ T1694] kernel BUG at include/linux/mm.h:1383!
[  162.333695][ T1694] Internal error: Oops - BUG: 0 [#1] SMP
[  162.339181][ T1694] Modules linked in: loop processor efivarfs ip_tables x_tables ext4 mbcache jbd2 dm_mod igb nvme i2c_algo_bit mlx5_core i2c_core nvme_core firmware_class
[  162.354604][ T1694] CPU: 13 PID: 1694 Comm: ranbug Not tainted 5.12.0-next-20210524+ #4
[  162.362601][ T1694] Hardware name: MiTAC RAPTOR EV-883832-X3-0001/RAPTOR, BIOS 1.6 06/28/2020
[  162.371116][ T1694] pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=--)
[  162.377811][ T1694] pc : memory_subsys_offline+0x1f8/0x250
[  162.383295][ T1694] lr : memory_subsys_offline+0x1f8/0x250
[  162.388773][ T1694] sp : ffff80002458f8e0
[  162.392773][ T1694] x29: ffff80002458f8e0 x28: ffff800010914d30 x27: 0000000000000000
[  162.400602][ T1694] x26: 0000000000002000 x25: 1fffe00002550401 x24: ffff000012a82008
[  162.408431][ T1694] x23: fffffc0000000000 x22: 0000000000008000 x21: 0000000000000001
[  162.416259][ T1694] x20: ffffffffffffffff x19: ffff000012a82018 x18: ffff0008527b6a70
[  162.424086][ T1694] x17: 0000000000000000 x16: 0000000000000007 x15: 00000000000000c8
[  162.431914][ T1694] x14: 0000000000000000 x13: ffff800011c6eea4 x12: ffff60136ceb8574
[  162.439742][ T1694] x11: 1fffe0136ceb8573 x10: ffff60136ceb8573 x9 : dfff800000000000
[  162.447570][ T1694] x8 : ffff009b675c2b9b x7 : 0000000000000001 x6 : ffff009b675c2b98
[  162.455398][ T1694] x5 : 00009fec93147a8d x4 : ffff009b675c2b98 x3 : 1fffe0010a4f6c09
[  162.463226][ T1694] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000034
[  162.471054][ T1694] Call trace:
[  162.474186][ T1694]  memory_subsys_offline+0x1f8/0x250
[  162.479318][ T1694]  device_offline+0x154/0x1d8
[  162.483844][ T1694]  online_store+0xa4/0x118
[  162.488107][ T1694]  dev_attr_store+0x44/0x78
[  162.492457][ T1694]  sysfs_kf_write+0xe8/0x138
[  162.496896][ T1694]  kernfs_fop_write_iter+0x26c/0x3d0
[  162.502028][ T1694]  new_sync_write+0x2bc/0x4f8
[  162.506552][ T1694]  vfs_write+0x718/0xc88
[  162.510643][ T1694]  ksys_write+0xf8/0x1e0
[  162.514732][ T1694]  __arm64_sys_write+0x74/0xa8
[  162.519342][ T1694]  invoke_syscall.constprop.0+0x78/0x1e8
[  162.524824][ T1694]  do_el0_svc+0xe4/0x298
[  162.528914][ T1694]  el0_svc+0x20/0x30
[  162.532658][ T1694]  el0_sync_handler+0xb0/0xb8
[  162.537181][ T1694]  el0_sync+0x178/0x180
[  162.541187][ T1694] Code: f00033e1 91318021 91090021 97e38d8b (d4210000)
[  162.547968][ T1694] ---[ end trace 2a1964462a219f20 ]---
[  162.553273][ T1694] Kernel panic - not syncing: Oops - BUG: Fatal exception
[  162.560250][ T1694] SMP: stopping secondary CPUs
[  162.564871][ T1694] Kernel Offset: disabled
[  162.569045][ T1694] CPU features: 0x00000251,20000846
[  162.574089][ T1694] Memory Limit: none
[  162.577849][ T1694] ---[ end Kernel panic - not syncing: Oops - BUG: Fatal exception ]---

If nr_vmemmap_pages is set, we know that we are dealing with hotplugged
memory that doesn't have any holes.  So call
page_zone(pfn_to_page(start_pfn)) only when really necessary -- when
nr_vmemmap_pages is set and we actually adjust the present pages.

Link: https://lkml.kernel.org/r/20210526075226.5572-1-david@redhat.com
Fixes: a08a2ae34613 ("mm,memory_hotplug: allocate memmap from the added memory range")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Qian Cai (QUIC) <quic_qiancai@quicinc.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/base/memory.c~drivers-base-memory-fix-trying-offlining-memory-blocks-with-memory-holes-on-aarch64
+++ a/drivers/base/memory.c
@@ -218,14 +218,14 @@ static int memory_block_offline(struct m
 	struct zone *zone;
 	int ret;
 
-	zone = page_zone(pfn_to_page(start_pfn));
-
 	/*
 	 * Unaccount before offlining, such that unpopulated zone and kthreads
 	 * can properly be torn down in offline_pages().
 	 */
-	if (nr_vmemmap_pages)
+	if (nr_vmemmap_pages) {
+		zone = page_zone(pfn_to_page(start_pfn));
 		adjust_present_page_count(zone, -nr_vmemmap_pages);
+	}
 
 	ret = offline_pages(start_pfn + nr_vmemmap_pages,
 			    nr_pages - nr_vmemmap_pages);
_

Patches currently in -mm which might be from david@redhat.com are

perf-map_executable-does-not-indicate-vm_mayexec.patch
binfmt-remove-in-tree-usage-of-map_executable.patch
mm-ignore-map_executable-in-ksys_mmap_pgoff.patch
fs-proc-kcore-drop-kcore_remap-and-kcore_other.patch
fs-proc-kcore-pfn_is_ram-check-only-applies-to-kcore_ram.patch
fs-proc-kcore-dont-read-offline-sections-logically-offline-pages-and-hwpoisoned-pages.patch
mm-introduce-page_offline_beginendfreezethaw-to-synchronize-setting-pageoffline.patch
virtio-mem-use-page_offline_startend-when-setting-pageoffline.patch
fs-proc-kcore-use-page_offline_freezethaw.patch
mm-make-variable-names-for-populate_vma_page_range-consistent.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables.patch
maintainers-add-tools-testing-selftests-vm-to-memory-management.patch
selftests-vm-add-protection_keys_32-protection_keys_64-to-gitignore.patch
selftests-vm-add-test-for-madv_populate_readwrite.patch
memory-hotplugrst-complete-admin-guide-overhaul.patch

